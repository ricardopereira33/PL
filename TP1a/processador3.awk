#!/usr/bin/gawk -f

BEGIN{ 
	FS = ":"
	head = "<h1 align=\"center\"> Autores Musicais </h1>\n<hr>\n";
	head2 = "<h3> %s </h3> <p> %s </p>\n";
  	enc = "<html> <head> <meta charset='UTF-8'/> <style>table, th, td {border: 1px solid black; border-collapse: collapse;} th, td {padding: 5px;} th {text-align: left;}</style> </head> <body>";
  	entrada = "<li><a> %s </a></li>\n";
  	linha = "<p> %s </p>";
  	end = "</body> </html>";
    table_start = "<table style=\"width:30%\"><tr> <th>Cantor</th><th>Número de Músicas</th> </tr>";
    table_start2 = "<table style=\"width:50%\"><tr> <th>Autor</th><th>Número de Músicas</th><th>Títulos</th> </tr>";
    table_entry= "<tr> <td> %s </td><td> %d </td> </tr>";
    table_entry2= "<tr> <td> %s </td><td> %d </td><td> %s </td> </tr>";
    table_end = "</table>";
	PROCINFO["sorted_in"]= "@ind_str_asc";
	title = "null";
	referencia = "<li><a href=\"%s\"> %s </a></li>\n\n";
	system("mkdir -p output/exercicio3/");
    local = "output/exercicio3/index.html";
}

/^singer/{
	split($2,res,/[;,'(?)']/)
	for(i in res){
		singer = fixSpaceAndChar(res[i]);
		if(singer!="")
			singers[singer]++;
	}
}

/^author/{
	split($2,r,/[;,'(?)']/)
	for(i in r){
		author = fixSpaceAndChar(r[i]);
		if(author!=""){
			authors[author]++;
			if(authorTitle[author]!=null) 
				authorTitle[author] = authorTitle[author]", " fixSpaceAndChar(title);
			else authorTitle[author] = fixSpaceAndChar(title);
		}
	}
}

/^title/{
	split($2,tit,/['(?)']/);
	title = tit[1];
}

END{
	print enc > local;
	print head > local;

	creatHTML("listaCantores");

	creatHTML("listaAutores");

	print end > local;
}

function fixSpaceAndChar(str){
	fix = 0;
	while(fix != 1){
		if(index(str,"*") == 1)
			sub("*","",str);
		else if(index(str,"=") == 1)
				sub("=","",str);
		else if(index(str," ") == 1)
				sub(" ","",str);
		else if(substr(str,length(str),1)==" ")
				str = substr(str,1,length(str)-1);
		else if(index(str,"\t") == 1 || substr(str,length(str),1)=="\t")
				sub("\t","",str);
		else fix = 1;
	}
	return str;
}

function creatHTML(str){
	print enc > "output/exercicio3/"str".html";
	print head > "output/exercicio3/"str".html";

	titulo="null";
	if(str=="listaCantores")
		titulo = "Lista de Cantores";
	else titulo = "Lista de Autores";
		
	printf(head2,titulo,"") > "output/exercicio3/"str".html";

	if(str=="listaCantores"){
		print table_start > "output/exercicio3/"str".html";
		for(i in singers){
			printf(table_entry,i,singers[i]) > "output/exercicio3/"str".html";	
		}
	}
	else{
		print table_start2 > "output/exercicio3/"str".html";
		for(i in authors){
			printf(table_entry2,i,authors[i],authorTitle[i]) > "output/exercicio3/"str".html";	
		}
	}
	print table_end > "output/exercicio3/"str".html";
	
	if(str=="listaCantores")
		printf(linha,"Número total de Cantores: "length(singers)) > "output/exercicio3/"str".html";
	else printf(linha,"Número total de Autores: "length(authors)) > "output/exercicio3/"str".html";

	print end > "output/exercicio3/"str".html";

	printf(referencia,str".html",titulo) > local;
}