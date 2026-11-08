\ GEMINI

\ --- Loop Structures using Relative Offsets ---

: BEGIN ( -- dest )
  HERE                     \ Save the loop back-destination address
; IMMEDIATE

: WHILE ( dest -- orig dest )
  POSTPONE ?BRANCH 
  HERE 0 ,                 \ Reserve cell for offset, push its address (orig)
  SWAP                     \ Keep 'dest' on top to be used by REPEAT
; IMMEDIATE

: REPEAT ( orig dest -- )
  POSTPONE BRANCH 
  HERE - ,                 \ 1. Resolve back-jump: Target (dest) minus current HERE
  
  \ 2. Resolve forward-jump from WHILE:
  \ Compute distance from WHILE's offset cell to the address right after REPEAT
  HERE OVER -              \ ( orig offset )
  SWAP !                   \ Store the relative offset back into the WHILE hole
; IMMEDIATE

\ --- Conditional Structures & Jumps ---

: AHEAD ( -- orig )
  POSTPONE BRANCH 
  HERE 0 ,                 \ Reserve cell for forward offset, push its address
; IMMEDIATE

: IF ( -- orig )
  POSTPONE ?BRANCH 
  HERE 0 ,                 \ Reserve cell for conditional offset, push its address
; IMMEDIATE

: THEN ( orig -- )
  \ Compute distance from the reserved hole (orig) to the current HERE
  HERE OVER -              \ ( orig offset )
  SWAP !                   \ Write relative offset into the reserved cell
; IMMEDIATE

: ELSE ( orig1 -- orig2 )
  POSTPONE BRANCH 
  HERE 0 ,                 \ Reserve cell for skipping ELSE block (orig2)
  
  \ Resolve the IF/AHEAD that led here (orig1)
  HERE 3 PICK -           \ Compute offset from orig1 to start of ELSE block
  2 PICK !                 \ Write it into orig1 slot
  
  NIP                      \ Clean up orig1 from stack, leaving orig2 for THEN
; IMMEDIATE

