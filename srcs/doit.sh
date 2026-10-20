
make clean && make

grep 'def_word "' aeforth2.S | tee word.lst | sort > word.srt

wc word.lst

