\ PC Bidmead has the KMTronic relay box on COM?
\ this file local and manual for each rig 
0 constant COM_PEG

: scan-lightboxes
\ report connected relay devices - manual for each setup
 	CR ." COM"   tab ." Light box                    " tab ." Handle"
 	CR COM_PEG . tab ." Pegasus Astro USB light box  " tab ." COM_PEG"
;
