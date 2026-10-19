# CAB Lab preprint template
MAIN  ?= main
FILES := $(MAIN).tex $(MAIN).bbl cablab.cls sec figures assets

.PHONY: pdf watch arxiv clean distclean preview

pdf:            ## build $(MAIN).pdf
	latexmk -pdf -interaction=nonstopmode $(MAIN).tex

watch:          ## rebuild on save
	latexmk -pdf -pvc -interaction=nonstopmode $(MAIN).tex

arxiv: pdf      ## bundle sources + .bbl for arXiv upload
	rm -rf arxiv && mkdir arxiv
	cp -r $(FILES) arxiv/
	find arxiv -name '*.aux' -delete
	tar -czf arxiv.tar.gz -C arxiv .
	@echo "Wrote arxiv.tar.gz -- upload it as-is (arXiv compiles with pdflatex)."

preview: pdf    ## regenerate docs/example.pdf and the README preview images
	cp $(MAIN).pdf docs/example.pdf
	pdftoppm -r 110 -f 1 -l 2 -png $(MAIN).pdf docs/preview

clean:
	latexmk -c $(MAIN).tex
	rm -rf arxiv

distclean: clean
	latexmk -C $(MAIN).tex
	rm -f arxiv.tar.gz
