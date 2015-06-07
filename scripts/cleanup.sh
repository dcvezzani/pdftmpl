#!/bin/bash

LANG=C sed 's/\/BaseFont \/Helvetica/\/BaseFont \/Palatino-Roman/' <$1 >pdftks/tmp.pdf
LANG=C sed 's/\/N 11 0 R//' <pdftks/tmp.pdf >pdftks/tmp2.pdf
mv pdftks/tmp2.pdf $1

#/AP \n<<\n/N 11 0 R\n>>
