#!/bin/bash

# Use zenity to select an .ipynb file
FILE=$(zenity --file-selection --title="Select an .ipynb file")

# Check if a file was selected
if [ -z "$FILE" ]; then
  echo "No file selected. Exiting."
  exit 1
fi

# Check if the selected file is an .ipynb file
if [[ ! "$FILE" == *.ipynb ]]; then
  echo "Selected file is not an .ipynb file. Exiting."
  exit 1
fi

# Convert the selected .ipynb file to markdown using jupyter nbconvert
jupyter nbconvert --to markdown "$FILE"
