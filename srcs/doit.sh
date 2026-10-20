
make clean && make

grep 'def_word "' *.S | tee word.lst | sort > word.srt

wc word.lst

