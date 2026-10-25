
#---------------------------------------------------------------------- 

: # 
	BASE @ M/MOD ROT 9 OVER < IF 7 + THEN 30 + HOLD ;

: #> 
	DROP DROP HLD @ PAD OVER - ;

: <#	
	PAD HLD ! ;

: #S
	BEGIN # OVER OVER OR 0= UNTIL ;

: (.")
	R> COUNT OVER OVER + EVEN >R TYPE ;

: (;CODE)
	R> LATEST PFA CFA ! ;

: ;CODE
	?CSP COMPILE (;CODE) [COMPILE] [
	ASSEMBLER ; IMMEDIATE

: (NUMBER)
	BEGIN 1+ DUP >R C@ BASE @ DIGIT
	WHILE SWAP BASE @ U* DROP ROT BASE @ U* D+ DPL @ 1+
	IF 1 DPL +1 ENDIF R>
	REPEAT R>;

#---------------------------------------------------------------------- 

FIND ?DUP 
IF                                     ( xt +-1 )
   STATE @ 
   IF                                     ( xt +-1 )
     0> IF EXECUTE ELSE COMPILE, THEN   ( ??? )
   ELSE                                            ( xt +-1 )
     DROP EXECUTE                                ( ??? )
   THEN
ELSE                                              ( c-addr )
   ( whatever you do for an undefined word )
THEN
... 

VARIABLE HANDLER 0 HANDLER ! \ last exception handler

def_word "catch" hash_CATCH

: CATCH ( xt -- exception# | 0 \ return addr on stack
   SP@ >R             ( xt )       \ save data stack pointer
   HANDLER @ >R       ( xt )       \ and previous handler
   RP@ HANDLER !      ( xt )       \ set current handler
   EXECUTE            ( )          \ execute returns if no THROW
   R> HANDLER !       ( )          \ restore previous handler
   R> DROP            ( )          \ discard saved stack ptr
    0                 ( 0 )        \ normal completion
;

: THROW ( ??? exception# -- ??? exception# )
    ?DUP IF          ( exc# )     \ 0 THROW is no-op
      HANDLER @ RP!   ( exc# )     \ restore prev return stack
      R> HANDLER !    ( exc# )     \ restore prev handler
      R> SWAP >R      ( saved-sp ) \ exc# on return stack
      SP! DROP R>     ( exc# )     \ restore stack
      \ Return to the caller of CATCH because return
      \ stack is restored to the state that existed
       \ when CATCH began execution
    THEN
;


#---------------------------------------------------------------------- 

# : 2NIP 2SWAP 2DROP ;
# : 2TUCK 2SWAP 2OVER ;

