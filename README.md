# ForthPegasusAstro
Control of the Pegasus Astro Flatmaster in Forth

On Morbius the serial allocation is:

```text
COM3  MGBox
COM4  KMTronic relay box
COM5  Pegasus Astro FlatMaster
```

Attach and inspect without changing illumination:

```forth
NEED ForthPegasusAstro
5 -> Pegasus.COM
add-lightbox
lightbox.version type
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
