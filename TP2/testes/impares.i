Int n,i,count,lido,num[10];
F contador{
	n=10;
	i=0;
	count=0;
	iLoop(i<n){
		iRead(lido);
		?((lido%2)!=0){
			num[count]=lido;
			count = count + 1;
		}
		i = i+1;
	}
}
START 
	exe contador;
	i=0;
	iWrite("Os numeros impares sao: ");
	iLoop(i<count){
		iWrite(num[i]);
		iWrite(" ");
		i = i+1;
	}
END