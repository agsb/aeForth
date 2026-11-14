## The dictionary

The compilation is not the most important piece of Forth but 
is essential to extend dictionary of Forth.

Forth systems could use a dictionary with only a single vocabulary
or a list of vocabularies.

Each vocabulary is composed by a linked list with header payloads. 

The header includes Link, Hash, Name, Code

### Backward direction

    lower memory 
    A[0x0](hdr)<--B[A](hdr)<--C[B](hdr)<--D[C](hdr)
    
    A, B, C, D, E are memory address, latest = D, 
    latest points to last definition in vocabulary.

    To include a newer definition, 
    create a definition at address E with [0x0](hdr), E[0x0](hdr)
    do latest = D, E[0x0] = latest, latest = E,

### Forward direction 

    lower memory
    A[B](hdr)-->B[C](hdr)-->C[D](hdr)-->D[0x0](hdr) 

    A, B, C, D, E are memory address, head = A, tail = D,
    head is fixed, tail points to last definition in vocabulary.

    To include a newer definition, 
    create a definition at address E with [0x0](hdr), E[0x0](hdr)
    do tail = D, D[0x0] = E, tail = E,

## Vocabulary list

Using backward list:

    A vocabulary keep one address (latest) by entry;

    To know the index of a definition, start at latest and transverse 
    the list iuntil found, then start counting and continue until end.

Using forward list:

    A vocabulary keep two address (head, tail) by entry.

    TO know the index of a definition, start at head and transverse 
    the list, counting entries until found it. The count is the index;

Why the index is important or necessary ?



**In nautical terms, fore and aft, from the front to the back of a ship**
