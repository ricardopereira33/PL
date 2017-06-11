Int i,num[3];
F ler{
	iWrite("Introduza uma sequencia de numeros: ");
	i=0;
	iLoop(i<3){
		iRead(num[i]);
		i = i+1;
	}
}
START 
	exe ler;
	iWrite("Array por ordem inversa: ");
	i = i-1;
	iLoop(i>>0){
		iWrite(num[i]);
		iWrite(" ");
		i=i-1;
	}
END