#!/bin/awk -f

BEGIN {
	# binary to hex table
	B["0000"]="0"
	B["0001"]="1"
	B["0010"]="2"
	B["0011"]="3"
	B["0100"]="4"
	B["0101"]="5"
	B["0110"]="6"
	B["0111"]="7"
	B["1000"]="8"
	B["1001"]="9"
	B["1010"]="A"
	B["1011"]="B"
	B["1100"]="C"
	B["1101"]="D"
	B["1110"]="E"
	B["1111"]="F"
	
	# state
	CODEPOINT=""
	STRING=""
}

{ $0 = toupper($0) }

/^;/ { next }

/^$/ { next }

# new codepoint found
/^[0-9A-Z]+:$/ {
	# dump prev
	if (CODEPOINT) {
		gsub(/  /, "0", STRING)
		gsub(/██/, "1", STRING)
		bin=""
		for (i = 1; i <= length(STRING); i+=4) {
			bin = bin B[substr(STRING, i, 4)]
		}
		print CODEPOINT bin
	}
	CODEPOINT=$0
	STRING=""
}

# convert string to num
/^[█ ]+$/ {
	STRING = STRING $0
}

END {
	if (CODEPOINT) {
		gsub(/  /, "0", STRING)
		gsub(/██/, "1", STRING)
		bin=""
		for (i = 1; i <= length(STRING); i+=4) {
			bin = bin B[substr(STRING, i, 4)]
		}
		print CODEPOINT bin
	}
}
