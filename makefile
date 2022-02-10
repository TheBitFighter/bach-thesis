JOB ?= bachelor_paper
# trailing / is important below
OUTDIR := ./
CONTENTDIR := content/
STYLEDIR := style/

TEX_MAIN ?= $(JOB)
TEX := pdflatex -shell-escape -output-directory $(OUTDIR) -jobname $(JOB)
BIB := bibtex
IDX := makeindex
VIEW := "xdg-open"
CWD := $(shell pwd)
TEX_OUT := $(OUTDIR)$(JOB).pdf

all: view

fast:
	$(TEX) $(TEX_MAIN).tex
	"$(VIEW)" "$(CWD)/$(TEX_OUT)"

view: $(TEX_OUT)
	"$(VIEW)" "$(CWD)/$(TEX_OUT)"

clean:
	@rm -f -v $(OUTDIR)*.aux $(OUTDIR)*.bcf $(OUTDIR)*.bbl $(OUTDIR)*-blx.bib $(OUTDIR)*.run.xml $(OUTDIR)*.idx $(OUTDIR)*.ilg $(OUTDIR)*.lot $(OUTDIR)*.lof $(OUTDIR)*.lol $(OUTDIR)*.blg $(OUTDIR)*.alg $(OUTDIR)*.ind $(OUTDIR)*.toc $(OUTDIR)*.acl $(OUTDIR)*.acn $(OUTDIR)*.acr $(OUTDIR)*.out $(OUTDIR)*.log $(OUTDIR)*.gls $(OUTDIR)*.glo $(OUTDIR)*.glg $(OUTDIR)*.ist $(OUTDIR)*.brf $(OUTDIR)*.ver $(OUTDIR)*.hst $(OUTDIR)*.glsdefs $(OUTDIR)*.bib.bak $(OUTDIR)*.synctex.gz $(OUTDIR)*.fls $(OUTDIR)*.fdb_latexmk
	@rm -f -v $(CONTENTDIR)*.aux $(CONTENTDIR)*.bcf $(CONTENTDIR)*.bbl $(CONTENTDIR)*-blx.bib $(CONTENTDIR)*.run.xml $(CONTENTDIR)*.idx $(CONTENTDIR)*.ilg $(CONTENTDIR)*.lot $(CONTENTDIR)*.lof $(CONTENTDIR)*.lol $(CONTENTDIR)*.blg $(CONTENTDIR)*.alg $(CONTENTDIR)*.ind $(CONTENTDIR)*.toc $(CONTENTDIR)*.acl $(CONTETDIR)*.acn $(CONTENTDIR)*.acr $(CONTENTDIR)*.out $(CONTENTDIR)*.log $(CONTENTDIR)*.gls $(CONTENTDIR)*.glo $(CONTENTDIR)*.glg $(CONTENTDIR)*.ist $(CONTENTDIR)*.brf $(CONTENTDIR)*.ver $(CONTENTDIR)*.hst $(CONTENTDIR)*.glsdefs $(CONTENTDIR)*.bib.bak $(CONTENTDIR)*.synctex.gz $(CONTENTDIR)*.fls $(CONTENTDIR)*.fdb_latexmk
	@rm -f -v $(STYLEDIR)*.aux $(STYLEDIR)*.bcf $(STYLEDIR)*.bbl $(STYLEDIR)*-blx.bib $(STYLEDIR)*.run.xml $(STYLEDIR)*.idx $(STYLEDIR)*.ilg $(STYLEDIR)*.lot $(STYLEDIR)*.lof $(STYLEDIR)*.lol $(STYLEDIR)*.blg $(STYLEDIR)*.alg $(STYLEDIR)*.ind $(STYLEDIR)*.toc $(STYLEDIR)*.acl $(STYLEDIR)*.acn $(STYLEDIR)*.acr $(STYLEDIR)*.out $(STYLEDIR)*.log $(STYLEDIR)*.gls $(STYLEDIR)*.glo $(STYLEDIR)*.glg $(STYLEDIR)*.ist $(STYLEDIR)*.brf $(STYLEDIR)*.ver $(STYLEDIR)*.hst $(STYLEDIR)*.glsdefs $(STYLEDIR)*.bib.bak $(STYLEDIR)*.synctex.gz $(STYLEDIR)*.fls $(STYLEDIR)*.fdb_latexmk

distclean: clean
	@rm -f -v $(JOB).pdf
	@rm -f -v $(CONTENTDIR)*.pdf
	@rm -f -v $(STYLEDIR)cover_page.pdf
	@rm -f -v $(STYLEDIR)declaration.pdf
	@rm -f -v abbreviations.pdf

$(JOB).pdf: *.tex $(wildcard content/*.tex) $(wildcard *.bib)
	$(TEX) $(TEX_MAIN)
	if grep "\\citation" $(OUTDIR)*.aux ; then \
		$(BIB) $(OUTDIR)$(JOB); \
	fi
	$(TEX) $(TEX_MAIN)
	$(TEX) $(TEX_MAIN)

.PHONY = clean view all fast
