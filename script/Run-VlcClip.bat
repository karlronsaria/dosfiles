:: Requires VLC Media Player
@echo off
set "app=%ProgramFiles%\VideoLAN\VLC\vlc.exe"
set "media=%~dp0..\res\%~1.mp4"
set "args=--fullscreen"
set "args=%args% --play-and-exit"
set "args=%args% --playlist-autostart"
set "args=%args% --no-loop --no-repeat"
set "args=%args% --no-media-library"
set "args=%args% --no-playlist-tree"
set "args=%args% --mouse-hide-timeout=0"
"%app%" "%media%" %args%
