#!/usr/bin/gawk -f

BEGIN{ 
	FS = ":"
	PROCINFO["sorted_in"]= "@ind_str_asc";
}

/^singer/{
	split($2,res,"[;,]")
	for(i in res){
		str = fixSpace(res[i]);
		singers[str]++;
	}
}

/^author/{
	split($2,r,/\s?[;,]/)
	for(i in r){
		gsub(" ","",r[i]);
		authors[r[i]]++;
	}
}

END{
	for(i in singers){
		print "-" i "- " singers[i];
	}

	print "Total: " length(singers);
}

function fixSpace(str){
	while(index(str," ") == 1){
		sub(" ","",str)
	}
	while(substr(str,length(str),1)==" "){
		str = substr(str,1,length(str)-1);
	}
	return str;
}