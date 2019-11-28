#!/bin/bash

for f in `git ls-files | grep '\.go$'`; do
        sed 's/ontio\/ontology\//DNAProject\/DNA\//g' $f > $f.new
        mv $f.new $f
        echo $f
done
