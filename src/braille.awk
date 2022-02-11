BEGIN {
	# hex to binary table
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
	
	
	for (i = 0; i <= 255; i++) {
	
		# int to hex
		hex = sprintf("%02X", i)
		tmp=""
		
		# convert to binary
		for (a = 1; a <= 2; a++) {
			c = substr(hex, a, 1)
			tmp = tmp B[c]
		}
		
		# reverse binary string
		bin=""
		for (a = 1; a <= 8; a++) {
			c = substr(tmp, a, 1)
			bin = c bin
		}
		
		# "draw" binary forms
		split(bin, A, "")
		bin = \
			A[1] A[4] \
			A[1] A[4] \
			A[2] A[5] \
			A[2] A[5] \
			A[3] A[6] \
			A[3] A[6] \
			A[7] A[8] \
			A[7] A[8] \
		
		# convert to hex format
		font=""
		for (a = 1; a <= 16; a+=2) {
			c = substr(bin, a, 2)
			if (c == "00")
				font = font "0000"
			else if (c == "01")
				font = font "0f0f"
			else if (c == "10")
				font = font "f0f0"
			else if (c == "11")
				font = font "ffff"
		}
		
		printf("28%s:%s\n", hex, font)
	}
}
