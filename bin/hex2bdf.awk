#!/bin/awk -f

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
	printf("FONTBOUNDINGBOX 16 16 0 -2\n")
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


# dump each character
{
	
	split($0, C, ":")
	codepoint = C[1]
	hexcode = C[2]
	
	# base 10 codepoint
	CMD = sprintf("echo 'ibase=16;obase=A;%s' | bc\n", codepoint) 
	CMD | getline dec; close(CMD)
	
	width = length(hexcode) / 64 * 8
	
	glyph=""
	l = width/2
	for (i = 1; i <= length(hexcode); i+=l)
		glyph = glyph "\n" substr(hexcode, i, l)
		
	S=S sprintf("STARTCHAR U+%s\n", codepoint)
	S=S sprintf("ENCODING %d\n", dec)
	S=S sprintf("SWIDTH %d 0\n", (1000*width)/16)
	S=S sprintf("DWIDTH %d 0\n", width*2)
	S=S sprintf("BBX 8 16 0 0\n")
	S=S sprintf("BITMAP %s\n", glyph)
	S=S sprintf("ENDCHAR\n")
	
	count++
}

END {
	
	printf("CHARS %s\n", count)
	print S "ENDFONT"
}
