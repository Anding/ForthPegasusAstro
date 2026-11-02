\ Offline error paths: serial writes and readiness are mocked.
include "%idir%\..\ForthBase\libraries\libraries.f"
NEED ForthBase
NEED simple-tester
NEED serial
0 value test.lightbox-writes
0 value test.lightbox-command
: write-gio ( caddr u sid -- ior )
\ Record a single brightness command without serial I/O.
    drop drop c@ -> test.lightbox-command
    test.lightbox-writes 1+ -> test.lightbox-writes -37 ;
: key?-gio drop 0 ;
: ms drop ;
include "%idir%\PegasusAstro.f"

Tstart
T{ 123 add-lightbox }T 123 ==
T{ 123 -1 ->lightbox.intensity 101 ->lightbox.intensity }T 123 ==
T{ 123 Pegasus.buffer lightbox-ask nip }T 123 0 ==
T{ 123 lightbox.version nip }T 123 0 ==
0 -> test.lightbox-writes
T{ 123 configure-lightbox test.lightbox-writes test.lightbox-command }T 123 1 'L' ==
Tend
