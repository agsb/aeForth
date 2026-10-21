#---------------------------------------------------------------------- 

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

