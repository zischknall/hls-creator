#!/bin/bash

file=$1
IFS='.' read -ra fileNameArr <<< $file

if [ -z ${fileNameArr[1]} ]
then
    echo 'Incorrect filename'
    exit 1
fi
baseName=${fileNameArr[0]}

mkdir -p $PWD/hls-output/$basename

ffmpeg -hide_banner -y -i $2 \
    -vf scale=w=426:h=240:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod  -b:v 500k -maxrate 500k -bufsize 300k -b:a 128k -hls_segment_filename $PWD/output/$baseName/240p_%03d.ts $PWD/output/$baseName/240p.m3u8 \
    -vf scale=w=640:h=360:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod  -b:v 1000k -maxrate 1000k -bufsize 600k -b:a 128k -hls_segment_filename $PWD/output/$baseName/360p_%03d.ts $PWD/output/$baseName/360p.m3u8 \
    -vf scale=w=842:h=480:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -b:v 1500k -maxrate 1500k -bufsize 1000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/480p_%03d.ts $PWD/output/$baseName/480p.m3u8 \
    -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -b:v 2500k -maxrate 2500k -bufsize 1500k -b:a 128k -hls_segment_filename $PWD/output/$baseName/720pL_%03d.ts $PWD/output/$baseName/720pL.m3u8 \
    -vf scale=w=1280:h=720:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -b:v 3500k -maxrate 3500k -bufsize 2000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/720pH_%03d.ts $PWD/output/$baseName/720pH.m3u8 \
    -vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -b:v 4500k -maxrate 4500k -bufsize 2250k -b:a 128k -hls_segment_filename $PWD/output/$baseName/1080pL_%03d.ts $PWD/output/$baseName/1080pL.m3u8 \
    -vf scale=w=1920:h=1080:force_original_aspect_ratio=decrease -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -r 144 -g 144 -keyint_min 24 -hls_time 6 -hls_playlist_type vod -b:v 6000k -maxrate 6000k -bufsize 3000k -b:a 128k -hls_segment_filename $PWD/output/$baseName/1080pH_%03d.ts $PWD/output/$baseName/1080pH.m3u8