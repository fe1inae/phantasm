.POSIX:
.PHONY: all install uninstall clean

# VARIABLES
# =========

NAME    = phantasm
VERSION = 0.0.1

UNIFONT = 14.0.01

PREFIX  = /usr
FONTDIR = /share/fonts/misc

# TOOLS
# =====

AWK     = gawk -P -Wposix
GUNZIP  = unpigz
FFORGE  = fontforge

# FILES
# =====

SRC = src/braille src/alphabet

FILES = out/$(NAME).bdf out/$(NAME).pcf out/$(NAME).otb out/$(NAME).ttf

PREVIEW = img/ascii.png img/block.png img/box.png img/braille.png


# RULES
# =====

HEX = $(SRC:=.hex) dep/unifont.hex

all: $(FILES) $(PREVIEW)

# amalgamate hex files
out/$(NAME).hex: $(HEX)
	@mkdir -p out -p out
	@# sort -s isnt posix, but it greatly simplifies things and is pretty 
	@# common, busybox, coreutils, and openbsd support it at least.5
	@# ill write some alternative for this whole block soon™ tbh
	sed 's/\(.*\):\(.*\)/\2\t\1/' $(HEX) \
	| sort -s -k 2 \
	| uniq -f 1 \
	| sed 's/\(.*\)\t\(.*\)/\2:\1/' > $(@)

# retrieve unifont
dep/unifont.hex:
	@mkdir -p dep
	curl -s "http://unifoundry.com/pub/unifont/unifont-$(UNIFONT)/font-builds/unifont_sample-$(UNIFONT).hex.gz" -o - | unpigz - > $(@)

# image preview
img/ascii.png: out/phantasm.bdf

# un/install font files
install: all
	@mkdir -p "$(PREFIX)$(FONTDIR)"
	for f in $(FILES); do install -Dm644 "$$f" "$(PREFIX)$(FONTDIR)"; done
uninstall:; for f in $(FILES); do rm -f "$(PREFIX)$(FONTDIR)/$${f#out/}"; done

# SUFFIXES
# ========

.SUFFIXES: .awk .txt .hex .pcf .ttf .otb .bdf .hex .png

.awk.hex:; $(AWK) -f $(<) > $(@)
.txt.hex:; $(AWK) -f bin/checktxt $(<) && $(AWK) -f bin/txt2hex.awk $(<) > $(@)
.hex.bdf:; $(AWK) -f bin/hex2bdf.awk -v "VER=$(VERSION)" $(<) > $(@)
.bdf.pcf:; bdftopcf $(<) > $(@)
.pcf.otb:; $(FFORGE) -lang ff -c 'Open("$(<)"); Generate("$(*).", "otb")'
.pcf.ttf:; $(FFORGE) -lang ff -c 'Open("$(<)"); Generate("$(*).", "ttf")'
.txt.png:; sh bin/preview.sh ${<} ${@}

# MISC
# ====

clean:
	rm -rf out dep $(HEX) $(HEX)
