#!/bin/bash

file=`realpath -m "$1"`
ext=`echo "$1" | sed 's,^.*/,,' | sed 's,[^.]*\.\(.*\),\1,'`

case "$ext" in
    hs) haskell=1
    ;;
esac

mk-path-to "$file"
if [[ "$?" == "1" ]]; then
    exit 1
fi

if ([ ! -f "$file" ] && [ $haskell ]); then
    mod=`mk-hs-module "$file"`
    echo -e "\nmodule $mod where\n\n" > "$file"
fi

vim "$file"

