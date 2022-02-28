#!/bin/awk -f

BEGIN {
	# hex2binary table
	B["0"]="0000"
	B["1"]="0001"
	B["2"]="0010"
	B["3"]="0011"
	B["4"]="0100"
	B["5"]="0101"
	B["6"]="0110"
	B["7"]="0111"
	B["8"]="1000"
	B["9"]="1001"
	B["A"]="1010"
	B["B"]="1011"
	B["C"]="1100"
	B["D"]="1101"
	B["E"]="1110"
	B["F"]="1111"
}

{ $0 = toupper($0) }

/^;/ { next }

/^[0-9A-Z]+:/ {
	# split codepoint and hex
	split($0, C, ":")
	
	# get character width
	width=length(C[2])/16
	
	# build binary string
	bin = ""
	# iter over widths of hex
	for (a = 1; a <= length(C[2]); a+=width) {
		S = substr(C[2], a, width)
		# convert hex to binary
		for (b = 1; b <= width; b++) {
			c   = substr(S, b, 1)
			bin = bin B[c]
		}
		bin = bin "\n"
	}
	
	# format binary
	gsub(/0/, "··", bin)
	gsub(/1/, "██", bin)
	
	# write glyph
	printf("%s:\n\n%s\n", C[1], bin)
}
