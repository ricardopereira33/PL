V=lyr2abc
$V: $V.fl
	flex $V.fl
	cc lex.yy.c -o ex

test: $V
	cat musica/* | ./lyr2abc
	-abcm2ps -n out.abc
	ps2pdf Out.ps
