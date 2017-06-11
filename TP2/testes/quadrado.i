Int la, lb, lc, ld;

START
	iWrite("Insira 4 numeros: ");
	iRead(la);
	iRead(lb);
	iRead(lc);
	iRead(ld);
	?((la == lb) & (lb == lc) & (lc == ld)){
		iWrite("Os lados introduzidos formam um quadrado.");
	}!?{
		iWrite("Os lados introduzidos nao formam um quadrado.");
	}
END