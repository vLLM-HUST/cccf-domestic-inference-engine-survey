PDF_OUT=build/main.pdf
ifeq ($(OS),Windows_NT)
ifneq ($(strip $(shell where latexmk 2>NUL)),)
LATEXMK:=latexmk
endif
ifneq ($(strip $(shell where tectonic 2>NUL)),)
TECTONIC:=tectonic
endif
else
ifneq ($(strip $(shell command -v latexmk 2>/dev/null)),)
LATEXMK:=latexmk
endif
ifneq ($(strip $(shell command -v tectonic 2>/dev/null)),)
TECTONIC:=tectonic
endif
endif
TEX_CLEAN_FILES=$(PDF_OUT) build/main.aux build/main.bbl build/main.bcf build/main.blg build/main.fdb_latexmk build/main.fls build/main.log build/main.out build/main.run.xml build/main.synctex.gz build/main.toc build/main.xdv

.PHONY: pdf clean repair-perms

pdf:
ifdef LATEXMK
	$(LATEXMK) -xelatex -outdir=build main.tex
else ifdef TECTONIC
	mkdir -p .cache/tectonic && TECTONIC_CACHE_DIR=.cache/tectonic $(TECTONIC) --outdir build main.tex
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

repair-perms:
	bash scripts/repair_permissions.sh
