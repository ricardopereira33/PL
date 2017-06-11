Int n,i,prod,lido;

START 
	n=5;
	i=0;
	prod = 1;
	iLoop(i<n){
		iRead(lido);
		prod = prod * lido;
		i = i+1;
	}
	iWrite("O produtorio e: ");
	iWrite(prod);
END