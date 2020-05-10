#!/bin/sh

# Octopod (i.e. jekyll) builds a static site in the _site directory.
echo "## Building a website"
octopod build
cd _site

# We don't want to publish the feed on iTunes or anywhere else. So I'm opting to
# not paginate it. This is crudely done by setting the page size in the
# configuration file to 1000 and to delete any feed pages below.
echo "\n## Creating token-based RSS feeds"

# The tokens.txt has to contain 1 token per line. It should be as simple as:
#
# flowfx.SECRETTOKEN
# zeitschlag.AMORESECRETTOKEN
#
# The individual RSS feeds will then be accessible at:
#
# https://podcasturlthing.org/feed/flowfx.SECRETTOKEN.rss
mkdir feed
input="tokens.txt"

while read -r TOKEN
do
  cp episodes.mp3.rss "feed/$TOKEN.rss"
done < "$input"

cp episodes/.htaccess feed/.htaccess
rm episodes*.mp3.rss
rm tokens.txt

# episodes/ANOTHERSECRETSTRING should be softlink to another directory that is
# not publicly accessible from the web. This allows us to change the apparent
# location of the media files from time to time by
#
# 1. changing the "download_url" in `_config.yml` 2. renaming this softlink
# directly on the server
#
# We can easily do this e.g. when someone leaves the company and should not have
# access to the files anymore, which they would have because they may still have
# a copy of the RSS feed, and this `ANOTHERSECRETSTRING` is included in it.

cd ..

# Deploy website via Rsync while excluding from `rsync-exclude`
octopod deploy
