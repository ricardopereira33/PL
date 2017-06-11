Int n,i,min,lido;

START 
	iWrite("Introduza um numero: ");
	iRead(n);
	i=0;
	min=0;
	iLoop(i<n){
		iRead(lido);
		?((lido<min) | (i==0)){
			min = lido;
		}
		i = i+1;
	}
	iWrite("O minimo e: ");
	iWrite(min);
END