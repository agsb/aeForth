
make clean && make

grep 'def_word "' *.S | tee word.lst | sort > word.srt

wc word.lst | tee word.wc

ccc=`date +%s`

mkdir $ccc

cp *sec *dmp defines.S $ccc

cd $ccc && sh ../stats.sh test.dmp

cat cnts

cd ..

mv $ccc ../.tst


