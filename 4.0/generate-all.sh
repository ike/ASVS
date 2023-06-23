#!/bin/bash 

ALLOWED_LANGS='ar de en es fr pt ru zh-cn'

echo $@

if [[ -n $@ ]]; then
  LANGS=$@
else
  LANGS=${ALLOWED_LANGS}
fi

for lang in ${LANGS}; do
  if [[ " $ALLOWED_LANGS " =~ " $lang " ]]; then

    vers="4.0.3"
    verslong="./docs_$lang/OWASP Application Security Verification Standard $vers-$lang"

    python3 tools/export.py --format json --language $lang > "$verslong.json"
    python3 tools/export.py --format json --language $lang --verify-only true

    python3 tools/export.py --format json_flat --language $lang > "$verslong.flat.json"
    python3 tools/export.py --format json_flat --language $lang --verify-only true

    python3 tools/export.py --format xml --language $lang > "$verslong.xml"
    python3 tools/export.py --format xml --language $lang --verify-only true

    python3 tools/export.py --format csv --language $lang > "$verslong.csv"
    python3 tools/export.py --format csv --language $lang --verify-only true

    git_hash=$(git rev-parse --short "$GITHUB_SHA")
    echo $git_hash
    if [[ -n "$git_hash" ]]; then
      diff=$(git diff $GITHUB_SHA "$verslong.json" "$verslong.flat.json" "$verslong.xml" "$verslong.csv")
      echo $diff
      if [[ -n "$diff" ]]; then
        ./generate_document.sh $lang $vers
      fi
    else
      ./generate_document.sh $lang $vers
    fi
  fi
done
