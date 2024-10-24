\ Use the serial port (COM) functionality of VFX Forth to communicate with a Pegasus Astro USB light box
NEED serial
NEED CommandStrings

\ COM port number, to revise on the local machine
	7 value Pegasus.COM 

\ prepare an instance of a VFX Forth generic I/O driver
	serdev: Pegasus.sid
		
\ prepare a read and write buffers
	256 buffer: Pegasus.buffer
	 16 buffer: Pegasus.command

: add-lightbox ( --)
\ open the serial port
	Pegasus.com 9600 sid_Pegasus ( com_port baud) open-serial
;

: remove-lightbox
\ close the serial port
	Pegasus.sid close-serial
;
 
: lightbox-tell ( caddr u --)
\ send a command 
	Pegasus.sid ( addr n sid) write-gio ( ior) ABORT" Failed to write Pegasus COM port"
;

: lightbox-ask ( -- n)
\ read from the lightbox.  non-blocking with brief hardware timeout
	10 BEGIN								\ timeout counter
		Pegasus.sed key?-gio
	0= WHILE
		1- dup 0= ( ior) ABORT" Pegasus COM port has not responded after 1000 ms"
		100 ms
	REPEAT
	drop
	Pegasus.buffer 256 Pegasus.sid ( addr n sid) readex-gio ( n ior) ABORT" Failed read from Pegasus COM port"
;

: lightbox-on ( --)
 	<< 'E' | ':' | '1' | 0x0d | >>
	lightbox-tell

;
: lightbox-off ( --)
 	<< 'E' | ':' | '0' | 0x0d | >>
	lightbox-tell
;

: ->lighbox.intensity ( n --)	
\ n is the intensity percentage 0 <= n <= 100
	100 - ( dark%) 235 * 100 / 20 + ( darkness in range 20-255)
	<< 'L' | ':' | (.) ..| 0x0d | >>
	lightbox-tell
;

: lightbox.version ( -- caddr u)
\ report the firmware version number
	<< 'V' | 0x0d | >>
	lightbox-tell
	200 ms
	lightbox-ask
	lightbox-buffer 2 + swap 2 -
;