Int i,j,lido,num[3],order[3],max,maxID;
F maximo{
	j=0;
	max = 0;
	iLoop(j<3){
		?(num[j]>max){
			maxID = j;
			max = num[j];
		}
		j = j+1;
	}
	order[i] = max; 
	num[maxID] = 0;
}
START 
	iWrite("Introduza uma sequencia de numeros: ");
	j=0;
	iLoop(j<3){
		iRead(lido);
		num[j]=lido;
		j = j+1;
	}
	i=0;
	iLoop(i<3){
		exe maximo;
		i=i+1;
	}
	i=0;
	iWrite("Array por ordem decrescente: ");
	iLoop(i<3){
		iWrite(order[i]);
		iWrite(" ");
		i = i+1;
	}
END