#!/bin/sh

echo "octopod build"
octopod build

echo "do stuff"

cd _site

rm feed.xml

rm episodes/*
rm episodes1.mp3.rss

mkdir feed
mv episodes.mp3.rss feed/

cd feed
cp episodes.mp3.rss florian.posdziech.SECRETTOKEN.rss
cp episodes.mp3.rss daniela.matheis.SECRETTOKEN.rss
cp episodes.mp3.rss vineet.SECRETTOKEN.rss

cp ht.access.allowfromall feed/.htaccess
cp ht.access.allowfromall img/.htaccess
rm ht.access.allowfromall

cd ../..

echo "octopod deploy"
octopod deploy
