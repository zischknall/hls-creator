#!/usr/bin/env bash
# ffmpeg -y -re -i bunny.mp4 -keyint_min 96 -x264opts "keyint=96:min-keyint=96:no-scenecut" -g 96 -r:v 24 -s 320x180 -b:v 256k -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.0 -c:a aac -ac 1 -ar 48000 -b:a 96k -hls_time 4 -hls_playlist_type vod -hls_segment_filename bunny/180p%03d.ts bunny/180p.m3u8
set -e

# Usage create-vod-hls.sh SOURCE_FILE [OUTPUT_NAME]
[[ ! "${1}" ]] && echo "Usage: create-vod-hls.sh SOURCE_FILE [OUTPUT_NAME]" && exit 1

# comment/add lines here to control which renditions would be created
renditions=(
# resolution  bitrate  audio-rate
  "426x240    400k    128k"
#  "640x360    800k     128k"
#  "842x480    1400k    128k"
#  "1280x720   2800k    128k"
#  "1920x1080  5000k    192k"
)

#########################################################################

source="${1}"
target="${2}"
keyURI="${3}"
if [[ ! "${target}" ]]; then
  target="${source##*/}" # leave only last component of path
  target="${target%.*}"  # strip extension
fi
mkdir -p ${target}

# key generation
echo 'Generating encryption key'
openssl rand 16 > ${target}.key
keyIV=$(openssl rand -hex 16)
keyinfo="${keyURI}/${target}.key
${target}.key
$keyIV"
echo -e "${keyinfo}" > ${target}.keyinfo

# static parameters
static_params="-keyint_min 96 -x264opts keyint=96:min-keyint=96:no-scenecut -g 96 -r:v 24 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.0 -c:a aac -ac 1 -ar 48000 -b:a 96k -hls_time 4 -hls_playlist_type vod -hls_key_info_file ${target}.keyinfo"

# misc params
misc_params="-hide_banner -y"

master_playlist="#EXTM3U
#EXT-X-VERSION:3
"
for rendition in "${renditions[@]}"; do
  # drop extraneous spaces
  rendition="${rendition/[[:space:]]+/ }"

  # rendition fields
  resolution="$(echo ${rendition} | cut -d ' ' -f 1)"
  bitrate="$(echo ${rendition} | cut -d ' ' -f 2)"
  audiorate="$(echo ${rendition} | cut -d ' ' -f 3)"

  # calculated field
  height="$(echo ${resolution} | cut -d 'x' -f 2)"
  name="${height}p"
  bandwidth=$(echo ${bitrate} | cut -d 'k' -f 1)
  bandwidth=$((${bandwidth}*1000))
  
  cmd=" ${static_params} -s ${resolution} -b:v ${bitrate} -b:a ${audiorate}" 
  cmd+=" -hls_segment_filename ${target}/${name}_%03d.ts ${target}/${name}.m3u8"
  
  # add rendition entry in the master playlist
  master_playlist+="#EXT-X-STREAM-INF:BANDWIDTH=${bandwidth},RESOLUTION=${resolution}\n${name}.m3u8\n"

  echo -e "Converting "
  ffmpeg ${misc_params} -i ${source} ${cmd}

done

# create master playlist file
echo -e "${master_playlist}" > ${target}/playlist.m3u8

echo "Done - encoded HLS is at ${target}/"
