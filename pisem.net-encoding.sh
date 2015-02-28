#!/bin/bash
#
#

FROM="_site"
TO="_site_win"

if [ -d "$FROM" ]; then
    # prepare hierarhy
    if [ -d "$TO" ]; then
        rm -r $TO
    fi
    mkdir $TO
    cp -r $FROM/* $TO
    find $TO -name "*.*" -type f -exec rm '{}' \;

    # process
    for ext in "*.html" "*.js" "*.css"; do
        FILES=`find $FROM -type f -name "$ext" | xargs file | grep UTF-8 | cut -d ":" -f 1` # take html in utf 8 encoding
        if [ -n "$FILES" ]; then
            for file in $FILES; do
                echo "change encoding $file > $TO/${file#*/}"
                iconv -f utf-8 -t windows-1251 "$file" > "$TO/${file#*/}"
            done
        fi
    done
fi

#
