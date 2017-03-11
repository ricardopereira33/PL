#!/usr/bin/gawk -f

BEGIN {
	FS = "[<>]";
	head = "<h1 align=\"center\"> Extracto ViaVerde </h1>\n<hr><h2> Cliente </h2>\n";
	head2 = "<h3> %s </h3> <p> %s </p>\n";
  	enc = "<html> <head> <meta charset='UTF-8'/> <style>table, th, td {border: 1px solid black; border-collapse: collapse;} th, td {padding: 5px;} th {text-align: left;}</style> </head> <body>";
  	entrada = "<li><a> %s </a></li>\n";
  	linha = "<p> %s </p>";
  	end = "</body> </html>";
  	elemento = "null";
    table_start = "<table style=\"width:30%\"><tr> <th>Dia</th><th>Número de Entradas</th> </tr>";
    table_entry= "<tr> <td> %s </td><td> %d </td> </tr>";
    table_end = "</table>";
}

/^<NOME|^<MORADA|^<LOCALIDADE|^<CODIGO_POSTAL|^<MATRICULA|^<MES/{
	if($2=="MES_EMISSAO")
		dadosCliente["MES"] = $3;
	else dadosCliente[$2] = $3;
}

/^<DATA_ENTRADA/{
	if($3!="null"){
		split($3,a,"-");
		dias[a[1]"-"a[2]]++;
		mes = a[2];
	}
	else{
		mes = "null";
	}
}

/^<DATA_SAIDA/ && mes=="null"{
	split($3,a,"-");
	mes = a[2];
}

/^<SAIDA/{
	locais[$3]++;
}

/^<IMPORTANCIA/{
	elemento = $3;
	sub(/,/,".",elemento)
	valor[mes] += elemento;
}

/^<TIPO>[Pp]arque/{
	parques[$3] += elemento;
}

END{
	print enc > "index.html";
	print head > "index.html";

	PROCINFO["sorted_in"]= "@ind_str_desc";
	for(i in dadosCliente){
		printf(head2,i,dadosCliente[i]) > "index.html";	
	}
	print "\n<hr>\n" > "index.html";

	PROCINFO["sorted_in"]= "@ind_str_asc";

	printf(head2,"Número de Entradas do Mês","") > "index.html";
	print table_start > "index.html";
  	for (i in dias) 
  		printf (table_entry,converteMonth(i),dias[i]) > "index.html";
  	print table_end > "index.html";

  	printf(head2,"Lista de Locais de Saída","") > "index.html";
  	for(i in locais)
  		printf (entrada,i) > "index.html";

  	printf(head2,"Total Gasto","") > "index.html";
  	total = 0;
  	for(i in valor){
  		total += valor[i];
  		printf(linha,"Mês "i ": " valor[i] " €") > "index.html";
  	}
  	print "Valor Total : " total " €" > "index.html";

  	printf(head2,"Total Gasto em Parques","") > "index.html";
  	for(i in parques)
  		printf(linha,"Valor Total: " parques[i] " €") > "index.html";

  	print end > "index.html";
}

function converteMonth(str){
	split(str,res,"-");

	switch(res[2]){
		case "01": return res[1] " de Janeiro";
			break;
		case "02": return res[1] " de Feveiro";
			break;
		case "03": return res[1] " de Março";
			break;
		case "04": return res[1] " de Abril";
			break;
		case "05": return res[1] " de Maio";
			break;
		case "06": return res[1] " de Junho";
			break;
		case "07": return res[1] " de Julho";
			break;
		case "08": return res[1] " de Agosto";
			break;
		case "09": return res[1] " de Setembro";
			break;
		case "10": return res[1] " de Outubro";
			break;
		case "11": return res[1] " de Novembro";
			break;
		case "12": return res[1] " de Dezembro";
			break;
	}
}