#!/bin/sh

lines="$(sed ':a N $!ba s/\n*$//' $1 | wc -l)"

cols=0
while read -r line; do
	if [ "${#line}" -gt "${cols}" ]; then
		cols="${#line}"
	fi
done < "$1"

width=$((cols*8+16))
height=$((lines*16+16))

convert \
	-size "${width}x${height}" \
	xc:"#373737" \
	-fill "#e5e5e5" \
	-font "out/phantasm.bdf" \
	-pointsize 16 \
	-annotate "+8+24" \
	"@${1}" "${2}"
