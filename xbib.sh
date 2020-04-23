#!/bin/sh
# Depencies: sed
# Usage: modify variable "bibres", cd into working directory of master-tex-file and run script with master-tex-file as first argument.

# modify this variable to set global .bib-file
bibres="PATH/TO/.bib"

# delete comments, in case a bibliography has been commented out and extract the filename of the local .bib-file
xbibres=$(sed '/%.*/d' "$1" | sed -n 's/^.*\\\(addbibresource\|bibliography\){\(\([^}]\+\)\(\.bib\)\|\([^}]\+\)\)}.*/\3\5.bib/p')

# only one local .bib-file should be specified, exit if there are more or less than 1
if [ "$(echo "$xbibres" | wc -w)" != 1 ]; then
    echo "Only one local bib-resource should be specified in your .tex-file. Number of specified resources: $(echo "$xbibres" | wc -w)."
    echo
    echo "$xbibres"
    echo
    echo "Aborting."
    exit 1
else
    # create empty file / truncate existing .bib file
    echo -n "" > "$xbibres"
    echo "Created local bib-resource: ""$xbibres"""
fi

# clear keylist
echo -n "" > xcitkeys.txt

# extract keys of specified file
echo
echo "Citation keys found in $1:"
for e in $(sed '/%.*/d'  "$1" | sed -n 's/^.*\\\(cite\|footcite\|autocite\|nocite\|fullcite\|citeauthor\)\(\[.*\]\)\?{\([^}]\+\)}.*$/\3/p' | sort | uniq)
do
    echo "$e"
    echo "$e" >> xcitkeys.txt
done

# extract keys of further input files
for i in $(sed '/%.*/d'  "$1" | sed -n 's/^.*input{\([^}]\+\)}.*$/\1/p' | sort | uniq | sed -n 's/\(\(.\+\)\(\.tex\)\|\(.\+\)\)$/\2\4.tex/p')
do
    echo
    echo "Citation keys found in ""$i"":"
    for e in $(sed '/%.*/d'  "$i" | sed -n 's/^.*\\\(cite\|footcite\|autocite\|nocite\|fullcite\|citeauthor\)\(\[.*\]\)\?{\([^}]\+\)}.*$/\3/p' | sort | uniq)
    do
	echo "$e"
	echo "$e" >> xcitkeys.txt
    done
done

# extract entry of each unique key
for k in $(sort xcitkeys.txt | uniq)
do
    sed -n '/^@[a-zA-Z]\+{'"$k"'/,/} *$/p' "$bibres" >> "$xbibres"
    echo >> "$xbibres"
done


# get crossrefs
echo
echo "Crossreferences found:"
for c in $(sed -n 's/^ *crossref *= *{\([^}]\+\)}.*/\1/p' "$xbibres" | sort | uniq)
do
    echo "$c"
    sed -n '/^@[a-zA-Z]\+{'"$c"'/,/} *$/p' "$bibres" >> "$xbibres"
    echo >> "$xbibres"
done
