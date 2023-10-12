:: Requires VLC Media Player
@echo off
set "app=%ProgramFiles%\VideoLAN\VLC\vlc.exe"
set "media=%~dp0.\res\toddlaugh.mp4"
"%app%" "%media%" --fullscreen --play-and-exit --playlist-autostart
