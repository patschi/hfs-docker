#!/usr/bin/env bash

# !! THIS SCRIPT IS ONLY NEEDED IF YOU WANT TO BUILD THE 
# !! LATEST HFS STABLE CONTAINER YOURSELF.
# Quick script to manually build the latest HFS stable container yourself.
# Otherwise, the pre-built container images are available here:
# https://github.com/users/patschi/packages/container/package/hfs-docker

cd "$(dirname "$0")"

echo "> Getting last 20 releases..."
RELEASES=$(curl --silent https://api.github.com/repos/rejetto/hfs/releases?per_page=20)

echo "> Get last stable release..."
LASTSTABLE=$(echo "$RELEASES" | jq -cr '[.[] | select(.prerelease == false)] | select(.draft == false)] | first | {name: .name, download: (.assets[] | select(.name | match("hfs-linux.*zip")).browser_download_url)}')

echo "> Get name and download URL..."
NAME=$(echo "$LASTSTABLE" | jq -cr '.tag_name')
DOWNLOAD=$(echo "$LASTSTABLE" | jq -cr '.download')
echo "Download URL for hfs-$NAME is: $DOWNLOAD"

echo "> Building hfs-$NAME..."
CMD="docker build --build-arg DOWNLOAD_URL=$DOWNLOAD -t hfs-docker -f Dockerfile ."

echo "Building..."
echo "# $CMD"
$CMD
ret=$?

if [ $ret -eq 0 ]; then
    echo "> Build successful."
else
    echo "> Build failed."
fi
echo "> Done."
exit $ret
