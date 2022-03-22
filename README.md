# Project structure
Most tex files can be compiled on their own. Subfiles use the Latex-subfiles package. use `make clean` to remove everything but PDF files and `make distclean` to clean up the directory and remove everything but the tex files themselves.

*bachelor_thesis.tex* is the main tex file.

All chapter subfiles can be separately rendered, bibliography and such will be appended in such case. If you render chapter files, make sure there exists a soft link to the `bibliography.bib` file in the `content/` directory for Latex to use.

When creating a new subfile, make sure to include this block at the end:
```latex
% Render bibliograhy and acronyms if rendered standalone
\isstandalone
\bibliographystyle{IEEEtran}
\bibliography{bibliography}
\subfile{abbreviations.tex}
\fi
```
This will append the bibliography and abbreviations list at the end of the chapter document if rendered as a standalone PDF file. `\issatndalone` is a self defined switch and not part of the `subfiles` package! See the main file for the defines. If not appended, Latex will warn about undefined abbreviations and literature references. Make sure to run `bibtex chapter_name.aux` after a `make distclean` when compiling!


# TODO
* Write abstract german
* Write abstract english
* Write introduction
* write results
* rewrite future work
* rewrite conlusions
* check storyline 
* write appendix (all graphs)
* write appendix (how to set up)
* first pass by supervisor
* grammar check 
* add ri5cy pipeline block diagram
* add cover
* finish attributions
* change average to mean