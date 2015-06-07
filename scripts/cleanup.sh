#!/bin/bash

LANG=C sed 's/\/BaseFont \/Helvetica/\/BaseFont \/Palatino-Roman/' <$1 >pdftks/tmp.pdf
mv pdftks/tmp.pdf $1

