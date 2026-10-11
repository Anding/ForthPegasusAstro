# ForthPegasusAstro
Control of the Pegasus Astro Flatmaster in Forth

On Morbius the serial allocation is:

```text
COM3  MGBox
COM4  KMTronic relay box
COM5  Reserved for the currently disconnected Pegasus Astro FlatMaster
```

The driver-level vocabulary remains available for direct engineering use.
Attach and inspect without changing illumination:

```forth
NEED ForthPegasusAstro
5 -> Pegasus.COM
add-lightbox
check-lightbox
```

Control is explicit:

```forth
10 ->lightbox.intensity
lightbox-on
lightbox-off
remove-lightbox
```

Intensity is expressed as an illumination percentage from 0 through 100.
For an operation which must leave the panel off even when it throws:

```forth
: acquire-flats lightbox-flats ;
10 ->lightbox.intensity
' acquire-flats with-lightbox
```

`with-lightbox` guarantees an off command after success or a Forth exception.

AstroImagingInForth supplies the higher-level lifecycle. Its observatory
environment sets `Pegasus.COM`, `lightbox.default.intensity`, and
`lightbox-device`; `connect`, `check`, `configure`, and `disconnect` then
manage the FlatMaster alongside the other enabled equipment.
