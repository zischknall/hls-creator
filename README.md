# hls-creator

This script uses `ffmpeg` to create multiple AES-128 encrypted hls playlists for different resolutions and bitrates out of one original file.


## Usage

`bash ./hls-creator.sh [input file] [key URI]`

The script will output all video segments and playlist files to `./output/[base filename]/`.

It will also generate a master playlist file and a keyfile in the `./output` directory.

You will have to provide this keyfile for the video player on the given `key URI`.

#### Example

`./hls-creator my-movie.mov https://example.com/keys`.

After that the script will stop and ask you to upload the generated keyfile to the specified keyURI: 

`scp ./output/my-movie.key user@example.com:/var/www/html/keys/`.

After the script is done upload the video segments and playlist files to your webserver: 
 
`scp ./output/my-movie/ user@example.com:/var/www/html/videos/` 

for the video segments and:

`scp ./output/my-movie.m3u8 user@example.com:/var/www/html/videos/` 

for the master playlist file.

Now point your video player of choice to the master playlist file:

`https://example.com/videos/my-movie.m3u8`.


## Settings

Currently the script outputs streams in these qualities:

- 240p ( 500 Kbps)
- 360p (1000 Kbps)
- 480p (1500 Kbps)
- 720p (2500 Kbps)
- 720p (3500 Kbps)
- 1080p (4500 Kbps)
- 1080p (6000 Kbps)

If you want to change these, you will as of now have to modify the script itself.