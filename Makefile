PDF_OUT=build/main.pdf
LATEXMK:=$(shell command -v latexmk 2>/dev/null)
TECTONIC:=$(shell command -v tectonic 2>/dev/null)
TEX_CLEAN_FILES=$(PDF_OUT) build/main.aux build/main.bbl build/main.bcf build/main.blg build/main.fdb_latexmk build/main.fls build/main.log build/main.out build/main.run.xml build/main.synctex.gz build/main.toc build/main.xdv

.PHONY: pdf clean

pdf:
ifdef LATEXMK
	$(LATEXMK) -xelatex -outdir=build main.tex
else ifdef TECTONIC
	$(TECTONIC) --outdir build main.tex
else
	@echo "No supported LaTeX builder found. Install latexmk or tectonic." >&2
	@exit 127
endif

clean:
ifdef LATEXMK
	$(LATEXMK) -C -outdir=build main.tex
else
	rm -f $(TEX_CLEAN_FILES)
endif
