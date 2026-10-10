\ PC Morbius serial allocation:
\ COM3 MGBox, COM4 KMTronic relay box, COM5 Pegasus Astro FlatMaster.
5 constant COM_PEG

: scan-lightboxes
\ report connected relay devices - manual for each setup
 	CR ." COM"   tab ." Light box                    " tab ." Handle"
 	CR COM_PEG . tab ." Pegasus Astro USB light box  " tab ." COM_PEG"
;
