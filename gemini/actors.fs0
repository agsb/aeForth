
\ To implement the Actor Model over our cooperative multitasker, we need to provide each task with its own private message queue (a mailbox). In the Actor Model, actors do not share state; instead, they communicate exclusively by sending immutable messages to one another's mailboxes.
\ Because standard Forth naturally passes parameters via a shared data stack, we will formalize an "Actor Message" as a packet of data copied safely into an Actor’s private memory buffer using an asynchronous FIFO queue.

\ Forth Actor Model Implementation

\ This code sits directly on top of the cooperative multitasker framework, expanding the Task Control Block (TCB) to include a message mailbox.

\ Gemin, 03/11/2026
\ forth

\ ==============================================================================
\ ACTOR MODEL IMPLEMENTATION FOR COOPERATIVE FORTH TASKS
\ ==============================================================================

DECIMAL

\ ------------------------------------------------------------------------------
\ 1. Mailbox Queue Configuration & TCB Expansion
\ ------------------------------------------------------------------------------
4 CONSTANT MSG-MAX \ Max number of pending messages per actor
1 CELLS CONSTANT /MSG \ Each message contains 1 data cell (e.g., value, pointer, or XT)

\ Define Mailbox offsets within an Actor's expanded TCB structure
\ Offset 0 to 5 are reserved by the core multitasker layout
6 CELLS CONSTANT MBX-HEAD \ Read pointer index inside the queue array
7 CELLS CONSTANT MBX-TAIL \ Write pointer index inside the queue array
8 CELLS CONSTANT MBX-COUNT \ Total number of currently unread messages
9 CELLS CONSTANT MBX-BUFFER \ Start address of the actual message storage array

\ Total size of an Actor TCB including mailbox control fields and message slots
/TCB MSG-MAX CELLS + 3 CELLS + CONSTANT /ACTOR

\ ------------------------------------------------------------------------------
\ 2. Actor Construction Word
\ ------------------------------------------------------------------------------
\ Usage: 32 32 ACTOR MY-ACTOR
: ACTOR ( d-size r-size "name" -- )
    CREATE
        HERE >R \ Keep track of Actor TCB start address
        /ACTOR ALLOT \ Allocate complete Actor TCB space
        SWAP CELLS ALLOT \ Allocate space for Data Stack
        HERE R@ 4 CELLS + ! \ Store top of data stack into SP0
        CELLS ALLOT \ Allocate space for Return Stack
        HERE R> 5 CELLS + ! \ Store top of return stack into RP0
;

\ ------------------------------------------------------------------------------
\ 3. Message Passing Core Logic (Send & Receive)
\ ------------------------------------------------------------------------------

\ Non-blocking send: Push a message cell into a target actor's mailbox
: SEND ( msg target-actor -- success? )
    DUP >R MBX-COUNT @ MSG-MAX >= IF 
        \ Mailbox is full! Reject the message to avoid data corruption
        DROP RDROP FALSE
    ELSE
        \ Calculate message destination slot via circular buffer math
        R@ MBX-BUFFER R@ MBX-TAIL @ CELLS + !
        
        \ Advance the Tail pointer circularly
        R@ MBX-TAIL @ 1+ MSG-MAX MOD R@ MBX-TAIL !
        
        \ Increment active message count
        1 R@ MBX-COUNT +!
        
        \ Wake the target actor up in case it was waiting/sleeping
        R> WAKE TRUE
    THEN
;

\ Blocking receive: Halt execution until a message arrives in the mailbox
: RECEIVE ( -- msg )
    BEGIN
        STATUS @ MBX-COUNT @ 0=
    WHILE
        \ No messages available. Voluntarily yield and loop when awoken
        PAUSE
    REPEAT
    
    \ Pull message out of the current actor's Head slot
    STATUS @ MBX-BUFFER STATUS @ MBX-HEAD @ CELLS + @
    
    \ Advance the Head pointer circularly
    STATUS @ MBX-HEAD @ 1+ MSG-MAX MOD STATUS @ MBX-HEAD !
    
    \ Decrement active message count
    -1 STATUS @ MBX-COUNT +!
;

\ ==============================================================================
\ 4. Concrete Demonstration: Producer / Consumer Actors
\ ==============================================================================

32 32 ACTOR PRODUCER \ Allocates Producer task
32 32 ACTOR CONSUMER \ Allocates Consumer task

VARIABLE LAST-RECEIVED \ Global tracking variable for terminal inspection

\ Consumer Engine: Loops indefinitely waiting for incoming payloads
: RUN-CONSUMER ( -- )
    BEGIN
        RECEIVE \ Halts and yields automatically until message arrives
        LAST-RECEIVED ! \ Store payload safely into memory
        PAUSE \ Keep round-robin friendly
    AGAIN
;

\ Producer Engine: Generates an incrementing numeric signal and sends it
: RUN-PRODUCER ( -- )
    0 BEGIN
        1+ \ Increment loop payload integer
        DUP CONSUMER SEND IF
            \ Message successfully delivered to Consumer's mailbox
        ELSE
            \ Consumer queue was full, wait a cycle before trying again
        THEN
        PAUSE \ Allow other system tasks to process
    AGAIN
;

\ Boot and interconnect actor states
: START-ACTOR-DEMO ( -- )
    0 LAST-RECEIVED !
    
    PRODUCER CONSTRUCT
    CONSUMER CONSTRUCT
    
    ['] RUN-PRODUCER PRODUCER START-TASK
    ['] RUN-CONSUMER CONSUMER START-TASK
;

\ Terminal inspection dashboard
: SHOW-ACTOR-DEMO ( -- )
    CR ." Monitoring Actor Mailboxes (Press any key to exit)..." CR
    BEGIN
        KEY? NOT
    WHILE
        ." Consumer Latest Received Packet: " LAST-RECEIVED @ . CR
        1000 0 DO LOOP \ Visual spacing delay
        PAUSE
    REPEAT
    KEY DROP
;

\ Use code with caution.

\ Architectural Breakdown


\ API Command Parameter Stack Behavioral Effect
\ ACTOR ( d-size r-size "name" -- ) Defines a custom execution block possessing dedicated data/return stacks paired with a localized asynchronous memory ring buffer.
\ SEND ( msg target-actor -- success? ) Drops a data cell straight into the recipient's thread safe tracking index. It returns FALSE if overflowing, eliminating priority inversion or lock contentions.
\ RECEIVE ( -- msg ) Forces the calling thread into a localized PAUSE processing cycle until an active SEND execution increments MBX-COUNT back past zero.


\ Designing Complex Workflows

\ In a production Actor system, messages are rarely raw integers. To send more structured payloads, you can combine this model with Forth's strengths:
\ • Dynamic XT Processing: Instead of passing raw data values, pass the Execution Token (xt) of a specific function as the message. The receiving actor's core loop changes to RECEIVE EXECUTE, turning it into a dynamic event loop that changes behavior based on incoming message commands.
\ • Heap Buffer Pointers: For large data objects (like strings or arrays), allocate a small block of memory from a heap, populate it, and pass the starting address pointer as the message cell. The receiver processes the memory block and frees it when finished.
\ If you want to scale this pattern up, let me know:
\ • Do you want to process string payloads or structured data instead of simple numbers?
\ • Do you need an anonymous routing directory (like looking up actors by name or ID)?
\ • Are you dealing with a multi-core or bare-metal environment where true atomic synchronization instructions are required?

