#!/bin/awk -f


BEGIN {
	MAXHEIGHT=16
	
	NEW=0
	HEIGHT=0
	
	err=0
}


/^;/ { next }
/^$/ { next }

# new codepoint found
/^[0-9A-Z]+:$/ {
	HEIGHT=0
	NEW=1
}

/^[█·]+$/ {
	# unicode awareness is, unreliable
	gsub(/█/, "1")
	gsub(/·/, "0")
	
	if (NEW == 1) {
		WIDTH=length($0)
		HEIGHT+=1
		NEW=0
	} else {
		HEIGHT+=1
	}
	
	if (HEIGHT > MAXHEIGHT) {
		printf("line %d: character height > %d\n", NR, MAXHEIGHT)
		err=1
	}
	
	if (length($0) != WIDTH) {
		printf("line %d: character width uneven\n", NR)
		err=1
	}
	
}

END { if (err == 1) exit 1 }
