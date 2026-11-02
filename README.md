# ForthPegasusAstro

`configure-lightbox` applies desired `lightbox.default.intensity` (10%)
without turning illumination on. It is policy, not a hardware-state cache.
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
For a normally returning operation which should leave the panel off:

```forth
: acquire-flats lightbox-flats ;
10 ->lightbox.intensity
' acquire-flats with-lightbox
```

`with-lightbox` sends an off command after the operation returns normally.
It does not catch Forth exceptions. If switching on fails, it reports the
error and skips the operation.

Ordinary configuration, range, timeout and serial write failures report and
return normally. A timed-out query returns its buffer with length zero.
`PegasusAstro_errors_test.f` checks these paths using serial mocks only and
never accesses hardware.

AstroImagingInForth supplies the higher-level lifecycle. Its observatory
environment sets `Pegasus.COM`, `lightbox.default.intensity`, and
`lightbox-device`; `connect`, `check`, `configure`, and `disconnect` then
manage the FlatMaster alongside the other enabled equipment.
