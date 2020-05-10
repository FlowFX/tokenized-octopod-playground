#!/bin/sh

echo "octopod build"
octopod build

echo "do stuff"

cd _site

rm feed.xml

rm episodes/*
rm episodes1.mp3.rss

mkdir feed

input="tokens.txt"
while read -r TOKEN
do
  cp episodes.mp3.rss "feed/$TOKEN.rss"
done < "$input"

rm episodes.mp3.rss
rm tokens.txt

cp ht.access.allowfromall feed/.htaccess
cp ht.access.allowfromall img/.htaccess
rm ht.access.allowfromall

cd ..

echo "octopod deploy"
octopod deploy
