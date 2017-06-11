Int i,j,dimensaoi,dimensaoj,matriz[2][2], matrizz[2][2], matrizresultante[2][2];

F input{
	i = 0;
	dimensaoi = 2;
	dimensaoj = 2;
	iLoop(i<dimensaoi){
		j = 0;
		iLoop(j<dimensaoj){
			iRead(matriz[i][j]);
			j = j+1;
		}
		i = i+1;
	}
	i = 0;
	iLoop(i<dimensaoi){
		j = 0;
		iLoop(j<dimensaoj){
			iRead(matrizz[i][j]);
			j = j+1;
		}
		i = i+1;
	}
}
START
	iWrite("Introduza uma sequencia de numeros para as duas matrizes (2x2): ");
	exe input;
	i = 0;

	iWrite(" A matriz resultante é: \n");
	iLoop(i<dimensaoi){
		iWrite("[ ");
		j = 0;
		iLoop(j<dimensaoj){
			matrizresultante[i][j] = (matriz[i][j]) + (matrizz[i][j]);
			iWrite(matrizresultante[i][j]);
			?(j!=(dimensaoj-1)){
				iWrite(" , ");
			}
			j = j+1;
		}
		iWrite(" ]\n");
		i = i+1;
	}

END