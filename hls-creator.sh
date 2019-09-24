#!/bin/bash

file=$1
IFS='.' read -ra fileNameArr <<< $file
baseName=${fileNameArr[0]}
keyBaseURI=$2
if [ -z $keyBaseURI -o -z ${fileNameArr[1]} ]
then
    echo 'Usage: hls-creator.sh [input file] [key URI]'
    exit 1
fi

mkdir -p $PWD/output/$baseName

echo 'Generating encryption key'
openssl rand 16 > $PWD/output/$baseName.key
keyIV=$(openssl rand -hex 16)
cat > $PWD/output/$baseName.keyinfo <<EOF
$keyBaseURI/$baseName.key
$baseName.key
$keyIV
EOF
echo 'Please upload '$baseName'.key to '$keyBaseURI' and press ENTER'
read -n 1 -s

echo 'Transcoding the input file'
ffmpeg -hide_banner -y -i $2 \
    -vf scale=w=426:h=240:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 500k -maxrate 500k -bufsize 300k -b:a 128k -hls_segment_filename $PWD/output/$baseName/240p_%03d.ts $PWD/output/$baseName/240p.m3u8 \
    -vf scale=w=640:h=360:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 1000k -maxrate 1000k -bufsize 600k -b:a 128k -hls_segment_filename $PWD/output/$baseName/360p_%03d.ts $PWD/output/$baseName/360p.m3u8 \
    -vf scale=w=842:h=480:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 1500k -maxrate 1500k -bufsize 1000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/480p_%03d.ts $PWD/output/$baseName/480p.m3u8 \
    -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 2500k -maxrate 2500k -bufsize 1500k -b:a 128k -hls_segment_filename $PWD/output/$baseName/720pL_%03d.ts $PWD/output/$baseName/720pL.m3u8 \
    -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 3500k -maxrate 3500k -bufsize 2000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/720pH_%03d.ts $PWD/output/$baseName/720pH.m3u8 \
    -vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 4500k -maxrate 4500k -bufsize 2250k -b:a 128k -hls_segment_filename $PWD/output/$baseName/1080pL_%03d.ts $PWD/output/$baseName/1080pL.m3u8 \
    -vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -hls_key_info_file $PWD/output/$baseName.keyinfo -b:v 6000k -maxrate 6000k -bufsize 3000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/1080pH_%03d.ts $PWD/output/$baseName/1080pH.m3u8

echo 'Creating master playlist file'
cat > $PWD/output/$baseName.m3u8 <<EOF
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=500000,RESOLUTION=426x240
$baseName/240p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1000000,RESOLUTION=640x360
$baseName/360p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1500000,RESOLUTION=842x480
$baseName/480p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2500000,RESOLUTION=1280x720
$baseName/720pL.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=3500000,RESOLUTION=1280x720
$baseName/720pH.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=4500000,RESOLUTION=1920x1080
$baseName/1080pL.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=6000000,RESOLUTION=1920x1080
$baseName/1080pH.m3u8
EOF