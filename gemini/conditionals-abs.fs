
\ GEMINI

\ --- Estruturas de Loop (BEGIN WHILE REPEAT) ---

: BEGIN ( -- dest )
  HERE 
; IMMEDIATE

: WHILE ( dest -- orig dest )
  POSTPONE ?BRANCH 
  HERE 0 ,           \ Reserva espaço para o endereço de salto se falso
  SWAP 
; IMMEDIATE

: REPEAT ( orig dest -- )
  POSTPONE BRANCH 
  ,                  \ Compila o salto de volta para o BEGIN (dest)
  HERE SWAP !        \ Resolve o salto do WHILE (orig) para apontar para cá
; IMMEDIATE


\ --- Estruturas Condicionais e Saltos (AHEAD IF ELSE THEN) ---

: AHEAD ( -- orig )
  POSTPONE BRANCH 
  HERE 0 ,           \ Reserva espaço para o endereço do salto incondicional
; IMMEDIATE

: IF ( -- orig )
  POSTPONE ?BRANCH 
  HERE 0 ,           \ Reserva espaço para o endereço do salto se falso
; IMMEDIATE

: THEN ( orig -- )
  HERE SWAP !        \ Resolve o endereço reservado pelo IF/AHEAD para apontar para cá
; IMMEDIATE

: ELSE ( orig1 -- orig2 )
  POSTPONE BRANCH 
  HERE 0 ,           \ Reserva espaço para saltar o bloco ELSE
  SWAP 
  HERE SWAP !        \ Resolve o IF anterior (orig1) para apontar para o início do ELSE
; IMMEDIATE

