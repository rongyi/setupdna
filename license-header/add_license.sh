#!/bin/bash

for f in `git ls-files | grep '\.go$'`; do
        cat header_file $f > $f.new
        mv $f.new $f
        echo $f
done
