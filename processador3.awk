#!/usr/bin/gawk -f

BEGIN{ 
	FS = ":"
	PROCINFO["sorted_in"]= "@ind_str_asc";
}

$1 == "singer"{
	split($2,res,/\s?[;,]/)
	for(i in res){
		gsub(" ","",res[i]);
		singers[res[i]]++;
	}
}

$1 == "author"{
	split($2,r,/\s?[;,]/)
	for(i in r){
		gsub(" ","",r[i]);
		authors[r[i]]++;
	}
}

END{
	for(s in singers) 
		printf("%s -> %d.\n",s,singers[s]);
	
	printf("Total de cantores: %d.\n",length(singers));
	print "____________________________________________";
	
	
}
