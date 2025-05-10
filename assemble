#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <source.asm>"
  echo "Usage: $0 <source.s>"
fi

full_filename=$1
if [[ "$full_filename" != *.asm && "$full_filename" != *.s ]]; then
  echo "Invalid file type."
  exit ;
fi

filename=${full_filename%%.*}

as "$full_filename" -o "$filename.o" || { echo "Assembling failed"; exit 1; }
ld "$filename.o" -o "$filename" || { echo "Linking failed"; exit 1; }

./"$filename"

rm "$filename" "$filename".o