\ Use the serial port (COM) functionality of VFX Forth to communicate with a Pegasus Astro USB light box
include %idir%\..\ForthBase\libraries\libraries.f

NEED serial
NEED CommandStrings

\ COM port number, to revise on the local machine
	5 value Pegasus.COM 

\ prepare an instance of a VFX Forth generic I/O driver
	serdev: Pegasus.sid
		
\ prepare a read and write buffers
	256 buffer: Pegasus.buffer
	 16 buffer: Pegasus.command

: add-lightbox ( --)
\ open the serial port
	Pegasus.com 9600 Pegasus.sid ( com_port baud) open-serial
;

: remove-lightbox
\ close the serial port
	Pegasus.sid close-serial
;
 
: lightbox-tell ( caddr u --)
\ send a command 
	Pegasus.sid ( addr n sid) write-gio ( ior) ABORT" Failed to write Pegasus COM port"
;

: lightbox-ask ( addr -- addr n)		\ factor this to serial.f
\ read from the lightbox.  non-blocking with brief hardware timeout
	dup
	10 BEGIN								\ timeout counter
		Pegasus.sid key?-gio
	0= WHILE
		1- dup 0= ( ior) ABORT" Pegasus COM port has not responded after 1000 ms"
		100 ms
	REPEAT
	drop
	
	BEGIN									\ read while characters are available
		Pegasus.sid key?-gio
	WHILE
		Pegasus.sid ( addr addr' sid) key-gio ( addr addr c)
		over c!
		1+
		1 ms								\ appropriate for 9600 baud
	REPEAT
		over - ( addr n)
;

: lightbox-on ( --)
 	Pegasus.command << 'E' | ':' | '1' | 0x0a | >>
	lightbox-tell

;
: lightbox-off ( --)
 	Pegasus.command << 'E' | ':' | '0' | 0x0a | >>
	lightbox-tell
;

: ->lightbox.intensity ( n --)	
\ n is the intensity percentage 0 <= n <= 100
	100 swap - ( dark%) 235 * 100 / 20 + ( darkness in range 20-255)
	Pegasus.command << 'L' | ':' | (.) ..| 0x0a | >>
	lightbox-tell
;

: lightbox.version ( -- caddr u)
\ report the firmware version number
	Pegasus.command << 'V' | 0x0a | >>
	lightbox-tell
	200 ms
	Pegasus.buffer lightbox-ask
;