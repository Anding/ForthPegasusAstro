\ Use the serial port (COM) functionality of VFX Forth to communicate with a Pegasus Astro USB light box
\ Maintenance: keep serial protocol words device-level; observatory lifecycle
\ and illumination policy belong to AstroImagingInForth.
include %idir%\..\ForthBase\libraries\libraries.f

NEED serial
NEED CommandStrings
NEED ForthVT100
NEED windows

0 value pegasus.error.code       \ Native write error, or -1 for an observed reply timeout.
0 value pegasus.error.timestamp  \ UTC Unix epoch seconds.

: Pegasus.error! ( code -- )
\ Retain the latest nonzero transport failure without clearing on success.
    ?dup if
        -> pegasus.error.code utc-epoch-seconds -> pegasus.error.timestamp
    then
;

\ COM port number supplied by the observing environment
	0 value Pegasus.COM
10 value lightbox.default.intensity \ Desired percentage; configure never turns on illumination.

\ prepare an instance of a VFX Forth generic I/O driver
	serdev: Pegasus.sid
		
\ prepare a read and write buffers
	256 buffer: Pegasus.buffer
	 16 buffer: Pegasus.command

: add-lightbox ( -- )
\ open the serial port
	Pegasus.COM 0= if cr ." Pegasus FlatMaster COM port is not configured" cr exit then
	Pegasus.com 9600 Pegasus.sid ( com_port baud) open-serial
;

: remove-lightbox ( -- )
\ close the serial port
	Pegasus.sid close-serial
;
 
: lightbox-tell ( caddr u -- )
\ send a command 
	Pegasus.sid write-gio dup Pegasus.error! .throw
;

: lightbox-ask { addr | cursor -- addr n }
\ read from the lightbox.  non-blocking with brief hardware timeout
	10 0 do
		Pegasus.sid key?-gio if leave then
		100 ms
	loop
	Pegasus.sid key?-gio 0= if
        -1 Pegasus.error!
		cr ." Pegasus COM port has not responded after 1000 ms" cr addr 0 exit
	then
	addr -> cursor
	begin Pegasus.sid key?-gio while
		Pegasus.sid key-gio cursor c! cursor 1+ -> cursor
		1 ms
	repeat
	addr cursor addr -
;

: lightbox-drain ( -- )
\ Discard only bytes already waiting; unlike lightbox-ask, never wait.
	BEGIN
		Pegasus.sid key?-gio
	WHILE
		Pegasus.sid key-gio drop
	REPEAT
;

: lightbox-on ( -- )
 	Pegasus.command << 'E' | ':' | '1' | 0x0a | >>
	lightbox-tell
;
: lightbox-off ( -- )
 	Pegasus.command << 'E' | ':' | '0' | 0x0a | >>
	lightbox-tell
;

: with-lightbox { xt -- }
\ Run one normally returning operation with illumination, then switch off.
	Pegasus.command << 'E' | ':' | '1' | 0x0a | >>
	Pegasus.sid write-gio ?dup if dup Pegasus.error! .throw exit then
	xt execute
	lightbox-off
;

: ->lightbox.intensity ( n -- )
\ n is the intensity percentage 0 <= n <= 100
	dup 0 101 within 0= if
		drop cr ." Lightbox intensity must be 0 through 100" cr exit
	then
	100 swap - ( dark%) 235 * 100 / 20 + ( darkness in range 20-255)
	Pegasus.command << 'L' | ':' | (.) ..| 0x0a | >>
	lightbox-tell
;

: lightbox.version ( -- caddr u )
\ report the firmware version number
	lightbox-drain
	Pegasus.command << 'V' | 0x0a | >>
	Pegasus.sid write-gio ?dup if
		dup Pegasus.error! .throw Pegasus.buffer 0 exit
	then
	200 ms
	Pegasus.buffer lightbox-ask
;

: check-lightbox ( -- )
\ report the connected light box state available without changing illumination
	s" FlatMaster" panel{
	s" Firmware" lightbox.version .field
	}panel
;

: configure-lightbox ( -- )
\ Apply desired brightness without switching the panel on.
    lightbox.default.intensity ->lightbox.intensity
;