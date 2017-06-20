#!/bin/bash
cd "${0%/*}"
file="emails/$(date +%Y%m%d%H%M%S)-product-hunt-email.html"
cat product-hunt-template.html > $file
echo "preparing file: $file"
echo "number of products? "
read products
echo "category? (number please) "
read category
for i in $(seq 1 $products); do
	echo "Product $i name? "
	read name
	echo "Product $i image URL? "
	read url
	pid=$(echo $url | sed 's/^.*products\/\([0-9]*\)\/.*$/\1/')
	echo "Product $i description text? "
	read description
	prodblock=$(cat product-hunt-product-template.html | sed 's~IMGURL~'"$url"'~g' | sed 's~PRODID~'"$pid"'~g' | sed 's~CATEGORYID~'"$category"'~g' | sed 's~DESCRIPTION~'"$description"'~' | sed 's~NAME~'"$name"'~')
	if [[ $i -eq 1 ]]; then
		prodblock=$(echo $prodblock | sed 's~padding-top: 0px~padding-top: 30px~g')
	fi
	if [[ $i -eq $products ]]; then
		prodblock=$(echo $prodblock | sed 's~padding-top: 0px~padding-top: 0px; padding-bottom: 30px;~g')
		echo $(cat $file | sed 's~XPROD~'"$prodblock"'~') > $file
	else
	echo $(cat $file | sed 's~XPROD~'"$prodblock"' XPROD~') > $file
	fi
done
cat $file | pbcopy
open $file
cd -
