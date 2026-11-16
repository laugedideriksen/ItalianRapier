#!/usr/bin/env bash

for file in $(find ../ -name "*.typ" -not -name "glossary*" -not -name "lib.typ" -not -name "preface.typ" -not -name "*_content.typ"); do
    echo $file
    filename=${file##*/}
    echo ${file%%.typ}.pdf
done
