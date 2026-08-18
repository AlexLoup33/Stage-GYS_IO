# Makefile for the Inria technical report
#
#   make          build the PDF (only if something changed)
#   make final    build a clean version, no TODO markers or annotations
#   make force    rebuild from scratch
#   make watch    rebuild continuously on every save
#   make view     build and open the PDF
#   make clean    remove intermediate files
#   make distclean  remove intermediate files and the PDF

MAIN      := squelette-rr
LATEXMK   := latexmk
LATEXMKFLAGS := -pdf -interaction=nonstopmode -file-line-error -halt-on-error -synctex=1
VIEWER    := xdg-open

# Dependency tracking is delegated to latexmk: it hashes every file the
# document actually pulls in (sources, figures, .sty, .bib) and reruns
# pdflatex/bibtex as many times as needed to settle references and the ToC.
# So the pdf rule always runs latexmk, and latexmk decides whether there is
# anything to do -- that stays correct after 'make clean', and when new
# figures or \input files appear.

.PHONY: all pdf final force watch view clean distclean help

all: pdf

pdf:
	$(LATEXMK) $(LATEXMKFLAGS) $(MAIN).tex

# Clean version for circulation: \finalversion makes review.sty switch every
# \todoitem and annotation off. Written to $(MAIN)-final.pdf, with its own aux
# files, so it never clobbers the draft build.
final:
	$(LATEXMK) $(LATEXMKFLAGS) -jobname=$(MAIN)-final \
	    -pdflatex="pdflatex %O '\def\finalversion{}\input{%S}'" $(MAIN).tex

# Ignore timestamps and rebuild everything.
force:
	$(LATEXMK) $(LATEXMKFLAGS) -gg $(MAIN).tex

# Watch the sources and recompile on each change (Ctrl-C to stop).
watch:
	$(LATEXMK) $(LATEXMKFLAGS) -pvc -view=none $(MAIN).tex

view: pdf
	$(VIEWER) $(MAIN).pdf >/dev/null 2>&1 &

clean:
	$(LATEXMK) -c $(MAIN).tex
	$(LATEXMK) -c -jobname=$(MAIN)-final $(MAIN).tex
	rm -f $(MAIN).bbl $(MAIN).synctex.gz $(MAIN)-final.synctex.gz

distclean:
	$(LATEXMK) -C $(MAIN).tex
	$(LATEXMK) -C -jobname=$(MAIN)-final $(MAIN).tex
	rm -f $(MAIN).bbl $(MAIN).synctex.gz $(MAIN)-final.synctex.gz *-eps-converted-to.pdf

help:
	@echo "targets: all (default), pdf, final, force, watch, view, clean, distclean"
