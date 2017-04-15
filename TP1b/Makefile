V1=processador4
V2=processador
$(V1): $(V1).fl
	flex $(V1).fl
	cc -g lex.yy.c -o $(V1) `pkg-config --cflags --libs glib-2.0`

$V2: $V2.fl
	flex $V2.fl
	cc lex.yy.c -o $V2 `pkg-config --cflags --libs glib-2.0`
