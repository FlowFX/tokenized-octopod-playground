#!/bin/sh

# Octopod (i.e. jekyll) builds a static site in the _site directory.
echo "## Building a website"
octopod build
cd _site

# We don't want to publish the feed on iTunes or anywhere else. So I'm opting to
# not paginate it. This is crudely done by setting the page size in the
# configuration file to 1000 and to delete any feed pages below.
echo "\n## Creating token-based RSS feeds"
rm episodes1.mp3.rss

mkdir feed

# The tokens.txt has to contain 1 token per line. It should be as simple as:
#
# flowfx.SECRETTOKEN
# zeitschlag.AMORESECRETTOKEN
#
# The individual RSS feeds will then be accessible at:
#
# https://podcasturlthing.org/feed/flowfx.SECRETTOKEN.rss
input="tokens.txt"
while read -r TOKEN
do
  cp episodes.mp3.rss "feed/$TOKEN.rss"
done < "$input"

rm episodes.mp3.rss
rm tokens.txt

# The episodes htaccess is ignored by the deploy command and has to be added
# manually on the server. This is to prevent rsync from deleting the softlink
# that points from the publicly-accessible episodes directory to where the mp3s
# are actually located in the file system.
cp ht.access.allowfromall episodes/.htaccess
cp ht.access.allowfromall feed/.htaccess
cp ht.access.allowfromall img/.htaccess
rm ht.access.allowfromall

cd ..

# Deploy website via Rsync
octopod deploy
