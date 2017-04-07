V=processador
$V: $V.fl
	flex $V.fl
	cc lex.yy.c -o $V `pkg-config --cflags --libs glib-2.0`

