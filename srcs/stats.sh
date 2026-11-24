#/bin/bash

# decompose assembler dumps into groups of intructions
# agsb@ 2025

cp $1 dmp

grep -E '[0123456789abcdef]{4,8}:' dmp | \
grep -vi -E '\.word' > lins

grep -E ':.[1234567890abcdef]{4,4} ' dmp | \
grep -vi -E '\.word' > 16opc

grep -E ':.[1234567890abcdef]{8,8} ' dmp | \
grep -vi -E '\.word' > 32opc

grep -E 'beq|bne|blt|ble|bgt|bge' dmp > decisions

grep -E 'xt_' dmp  | grep -v '00000000' > hooks

grep -E '<.*>:' dmp | grep -v '<.t_' > hoops

grep -E 'hash_' dmp > hashs

grep -E '_GLOBAL_|auipc' dmp > globals

grep -E 'lui|aui' dmp > lauis

grep -E '	mv' dmp > movs

grep -E '	ja' dmp > jals

for r in s0 s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 \
	 a0 a1 a2 a3 a4 a5 a6 a7 \
	 t0 t1 t2 t3 t4 t5 t6 ;
do
        grep -E ",${r}|${r},|\(${r}\)" dmp > ${r}.ss
	grep -P '\t.... ' ${r}.ss > ${r}.s16
	grep -v -P '\t.... ' ${r}.ss > ${r}.s32

        # | \
        # grep -v -E ":\s*$r|$r:" > ${r}.ss
done

# some stats

`wc 16opc 32opc > wcs`

{
    read -r var1 _
    read -r var2 _
    read -r var3 _
} < "wcs"

awk " BEGIN {
	printf \" 16op=%6d 32op=%6d ops=%6d ; \", \
	$var1, $var2, $var3 ; \
	printf \" 16op%=%6.4f 32op%=%6.4f 16/32=%6.4f ; \n\", \
	$var1/$var3 * 100, $var2/$var3 * 100, $var1/$var2 * 100 ; }" \
	> cnts

