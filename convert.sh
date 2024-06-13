#!/bin/bash
shopt -s globstar

# kramdown converter - md to asciidoc
rm -rf ./kramdown_md_to_asciidoc && \
mkdir -p ./kramdown_md_to_asciidoc && \
mkdir -p ./kramdown_md_to_asciidoc/i18n/zh/docusaurus-plugin-content-docs && \
cp -r ./docs ./shared-files ./kramdown_md_to_asciidoc && \
cp -r ./i18n/zh/docusaurus-plugin-content-docs/current ./kramdown_md_to_asciidoc/i18n/zh/docusaurus-plugin-content-docs

find ./kramdown_md_to_asciidoc -type f \( -name "*.md" -o -name "*.mdx" \) -exec sh -c 'echo Processing Head tag in file $1 & head_tag.sh "$1" "antora"' _ {} \;
find ./kramdown_md_to_asciidoc -type f -name "*.md" -exec sh -c 'echo Replacing Collapsible blocks in file $1 & collapsible_block.sh "$1" ' _ {} \;
find ./kramdown_md_to_asciidoc -type f -name "*.md" -exec sh -c 'echo Replacing Admonitions in file $1 & admon.sh "$1" ' _ {} \;
find ./kramdown_md_to_asciidoc -type f -name "*.md" -exec sh -c 'echo Processing file $1 & kramdoc -o "${1%.md}.adoc" "$1"' _ {} \;
find ./kramdown_md_to_asciidoc -type f -name "*.adoc" -exec sh -c 'echo Replacing cross reference links in file "$1" && sed -i "s|\\(link:[^ ]*\\)\\.md|\\1.adoc|g" "$1"' _ {} \;

rm ./kramdown_md_to_asciidoc/**/*.md
