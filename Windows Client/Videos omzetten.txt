# Video omzetten naar MP3
$pad = "L:" 
$videos = (Get-ChildItem $pad -Recurse | where { $_.Name -like "*.m4v" }).FullName 
Foreach ($video In $videos) 
{ 
  $video_mp3 = $video -Replace ".m4v", ".mp3" 
  ffmpeg -n -i $video -vn "$video_mp3" 
} 
