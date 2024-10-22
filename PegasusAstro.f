\ Use the serial port (COM) functionality of VFX Forth to communicate with a Pegasus Astro USB light box
NEED serial
NEED CommandStrings

\ COM port number, to revise on the local machine
	7 value Pegasus.COM 

\ prepare an instance of a VFX Forth generic I/O driver
	serdev: Pegasus.sid

: add-lightbox ( --)
	Pegasus.com 9600 sid_Pegasus ( com_port baud) open-serial
;

: remove-lightbox
	Pegasus.sid close-serial
;

 create Pegasus.command
 16 allot
 \ protocol string
 
: lightbox-on ( --)
 	<< 'E' | ':' | '1' | 0x0d | >>
	( addr 4) Pegasus.sid ( addr n sid) write-gio ( ior) ABORT" Failed to write Pegasus COM port"
;

: lightbox-off ( --)
 	<< 'E' | ':' | '0' | 0x0d | >>
	( addr 4) Pegasus.sid ( addr n sid) write-gio ( ior) ABORT" Failed to write Pegasus COM port"
;

: ->lighbox.intensity ( n --)	
\ n is the intensity percentage 0 <= n <= 100
	100 - ( dark%) 235 * 100 / 20 + ( darkness in range 20-255)
	<< 'L' | ':' | (.) ..| 0x0d | >>
	( addr u) Pegasus.sid ( addr n sid) write-gio ( ior) ABORT" Failed to write Pegasus COM port"
;
