\ Offline error paths: serial writes and readiness are mocked.
include "%idir%\..\ForthBase\libraries\libraries.f"
NEED ForthBase
NEED simple-tester
NEED serial
: write-gio 3drop -37 ;
: key?-gio drop 0 ;
: ms drop ;
include "%idir%\PegasusAstro.f"

Tstart
T{ 123 add-lightbox }T 123 ==
T{ 123 -1 ->lightbox.intensity 101 ->lightbox.intensity }T 123 ==
T{ 123 Pegasus.buffer lightbox-ask nip }T 123 0 ==
T{ 123 lightbox.version nip }T 123 0 ==
Tend
