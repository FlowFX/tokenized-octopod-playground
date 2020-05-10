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

# Because the episode files are simply named SLUGXXX.mp3, their location is
# easily guessable once you know the location of one of them. For this reason,
# we can put the audio files into a subfolder and regularly change the name of
# the subfolder. Everyone who has access to the RSS feed can access all the
# files as long as this subfolder is not renamed. Renaming it does not break
# current subscriptions, because we change the `download_url` in the
# configuration file at the same time.
mkdir episodes/TOTALLYUNIQUESTRING
mv episodes/*.mp3 episodes/TOTALLYUNIQUESTRING/

cd ..

# Deploy website via Rsync while excluding from `rsync-exclude`
octopod deploy
