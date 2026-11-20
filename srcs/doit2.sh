
make clean && make

grep 'def_word "' *.S | tee word.lst | sort > word.srt

wc word.lst | tee word.wc

ccc=`echo $EPOCHSECONDS`

mkdir $ccc

cp *sec *dmp defines.S $ccc

