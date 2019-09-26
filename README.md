# hls-creator

This script is based off of: https://gist.github.com/mrbar42/ae111731906f958b396f30906004b3fa.

It adds AES-128 encryption and keeps the output framerate locket at 24 fps and puts I-frames every 96 frames with a segment size of 4 seconds.

## Usage

`bash ./hls-creator.sh input output keyURI`

The script will generate the video segments with a playlist for each quality level and a master playlist file and a keyfile .

You will have to provide this keyfile for the video player on the given `key URI`.

#### Example

`./hls-creator my-movie.mov movie https://example.com/keys`.

After the script is done upload the video segments and playlist files to your webserver: 
 
`scp movie/ user@example.com:/var/www/html/videos/` 

for the video segments and:

`scp movie.key user@example.com:/var/www/html/keys/` 

for the key file.

Now point your video player of choice to the master playlist file:

`https://example.com/videos/movie/playlist.m3u8`.