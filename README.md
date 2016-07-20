# Gentoo Setup Guide

This guide explains how I set up Gentoo Linux on my system.

# Building

Install the sphinx and related dependencies with pip:
```
pip install sphinx
pip install sphinx_bootstrap_theme
pip install rst2pdf
```
The rst2pdf plugin did not work properly with Python 3, so use Python 2.

For latex building, make sure latex is installed, including `pdflatex`.

Then, run:
```
make all
```

The built files will be:
* HTML: `_build/html/index.html`
* Single page HTML: `_build/singlehtml/index.html`
* PDF made with rst2pdf: `_build/pdf/GentooSetupGuide.pdf`
* PDF made with latex: `_build/latex/GentooSetupGuide.pdf`
* EPUB: `_build/epub3/GentooSetupGuide.epub`
* Plain text: `_build/text`

The HTML version looks the best.
