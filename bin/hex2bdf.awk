#!/bin/awk -f

function hex2dec(hex) {
	# build lookup table
	T["0"] = 0;  T["1"] = 1;  T["2"] = 2;  T["3"] = 3;  T["4"] = 4;
	T["5"] = 5;  T["6"] = 6;  T["7"] = 7;  T["8"] = 8;  T["9"] = 9; 
	T["A"] = 10; T["B"] = 11; T["C"] = 12; T["D"] = 13; T["E"] = 14; 
	T["F"] = 15

	# convert each char to int and sum with offset
	sum=0
	for (i = length(hex); i >= 1; i--)
		sum += T[substr(hex, i, 1)] * 16^(length(hex)-i)
	return sum
}


BEGIN {
	NAME    = "phantasm"
	if (! VER) VER = 0
	
	caphgt = 11
	xhgt   = 7
	asc    = 13
	desc   = 3
	undpos = 1
	
	S=""
	count=0
	
	printf("STARTFONT 2.1\n")
	printf("FONT -%s-%s-Medium-R-Normal-16-16-160-75-75-c-80-iso10646-1\n", NAME, NAME)
	printf("SIZE 16 75 75\n")
	printf("FONTBOUNDINGBOX 16 16 0 0\n")
	printf("STARTPROPERTIES 24\n")
	printf("COPYRIGHT \"CC0 <felinae@ulthar.cat>\"\n")
	printf("FONT_VERSION \"%s\"\n", VER)
	printf("FONT_TYPE \"Bitmap\"\n")
	printf("FOUNDRY \"%s\"\n", NAME)
	printf("FAMILY_NAME \"%s\"\n", NAME)
	printf("WEIGHT_NAME \"Medium\"\n")
	printf("SLANT \"R\"\n")
	printf("SETWIDTH_NAME \"Normal\"\n")
	printf("ADD_STYLE_NAME \"16\"\n")
	printf("PIXEL_SIZE 16\n")
	printf("POINT_SIZE 16\n")
	printf("RESOLUTION_X 75\n")
	printf("RESOLUTION_Y 75\n")
	printf("SPACING \"C\"\n")
	printf("AVERAGE_WIDTH 80\n")
	printf("CHARSET_REGISTRY \"ISO10646\"\n")
	printf("CHARSET_ENCODING \"1\"\n")
	printf("UNDERLINE_POSITION %s\n", undpos)
	printf("UNDERLINE_THICKNESS 1\n")
	printf("CAP_HEIGHT %s\n", caphgt)
	printf("X_HEIGHT %s\n", xhgt)
	printf("FONT_ASCENT 16\n")
	printf("FONT_DESCENT 0\n")
	printf("DEFAULT_CHAR 63\n")
	printf("ENDPROPERTIES\n")
}

# add to array and inc count
{
	L[count] = $0
	count++
}

# print all
END {
	printf("CHARS %s\n", count)
	for (n in L) {
		split(L[n], C, ":")
		codepoint = C[1]
		hexcode   = C[2]
		
		width = length(hexcode) / 64 * 8
		
		glyph=""
		l = width/2
		for (i = 1; i <= length(hexcode); i+=l)
			glyph = glyph "\n" substr(hexcode, i, l)
			
		printf("STARTCHAR U+%s\n", codepoint)
		printf("ENCODING %d\n", hex2dec(codepoint))
		printf("SWIDTH %d 0\n", (1000*width)/16)
		printf("DWIDTH %d 0\n", width*2)
		printf("BBX %d 16 0 0\n", width*2)
		printf("BITMAP %s\n", glyph)
		printf("ENDCHAR\n")
	}
	print "ENDFONT"
}
