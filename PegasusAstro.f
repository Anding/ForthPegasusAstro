\ Use the serial port (COM) functionality of VFX Forth to communicate with a Pegasus Astro USB light box
\ requires VFX32serial.f

\ prepare an instance of a VFX Forth generic I/O driver
 serdev: sid_Pegasus

: add-lightbox ( com_port --)
	9600 sid_Pegasus ( com_port baud) open-serial
;

: remove-lightbox
	sid_Pegasus close-serial
;

 create Pegasus_protocol_version
 'V' c, 13 c,

 create Pegasus_protocol_enable
 'E' c, ':' c, '1' c, 13 c,

 create Pegasus_protocol_disable
 'E' c, ':' c, '0' c, 13 c,
	
 create Pegasus_protocol_brightness
 'L' c, ':' c,'0' c, '0' c, '0' c, 13 c,
