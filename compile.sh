#!/bin/bash

# Define directories
OUTPUT_DIR="output"

# Create directories if they do not exist
mkdir -p "$OUTPUT_DIR"

# Define compilation function
function tex-pdf {
    printf "INFO - Step 1/4 (pdflatex) - First compilation \n"
    pdflatex -output-directory=$OUTPUT_DIR -halt-on-error -interaction=nonstopmode $1 > $OUTPUT_DIR/$1.txt
    grep '^!.*' --color=never $OUTPUT_DIR/$1.txt

    printf "INFO - Step 2/4 (bibtex) - Compile references \n"
    bibtex $OUTPUT_DIR/$1.aux > $OUTPUT_DIR/$1.txt
    grep '^!.*' --color=never $OUTPUT_DIR/$1.txt

    printf "INFO - Step 3/4 (pdflatex) - Second compilation \n"
    pdflatex -halt-on-error -interaction=nonstopmode -output-directory="$OUTPUT_DIR" $1 > $OUTPUT_DIR/$1.txt
    grep '^!.*' --color=never $OUTPUT_DIR/$1.txt

    printf "INFO - Step 4/4 (pdflatex) - Final compilation \n"
    pdflatex -halt-on-error -interaction=nonstopmode -output-directory="$OUTPUT_DIR" $1 > $OUTPUT_DIR/$1.txt
    grep '^!.*' --color=never $OUTPUT_DIR/$1.txt

    rm -f $OUTPUT_DIR/$1.txt $OUTPUT_DIR/$1.aux $OUTPUT_DIR/$1.bbl $OUTPUT_DIR/$1.blg $OUTPUT_DIR/$1.log $OUTPUT_DIR/$1.out
    rm -f $OUTPUT_DIR/$1.bcf $OUTPUT_DIR/$1.loe $OUTPUT_DIR/$1.run.xml 
}
export -f tex-pdf

# Compile
tex-pdf main

# Open Okular
pgrep -x okular > /dev/null || okular $OUTPUT_DIR/main.pdf &

# Pause and wait for user input
echo "INFO - Compilation completed. Output in '$OUTPUT_DIR' directory."
read -n 1 -p "INFO - Press [Enter] to re-compile or any key to quit: " key

# Clear the terminal screen
clear
if [[ $key == "" ]]; then
	bash compile.sh
else
	echo "INFO - Finished compiling..."
fi