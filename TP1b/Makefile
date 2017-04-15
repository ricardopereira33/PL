V1=processador
V2=processador2
V4=processador4
$(V1): $(V1).fl
	flex $(V1).fl
	cc lex.yy.c -o $(V1) `pkg-config --cflags --libs glib-2.0`

$(V2): $(V2).fl
	flex $(V2).fl
	cc lex.yy.c -o $(V2) `pkg-config --cflags --libs glib-2.0`

$(V4): $(V4).fl
	flex $(V4).fl
	cc lex.yy.c -o $(V4) `pkg-config --cflags --libs glib-2.0`




