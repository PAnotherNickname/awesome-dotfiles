#!/bin/sh

storeBrightness="export STORED_BRIGHTNESS=$(light -G)"
restoreBrightness="if [ $(echo $STORED_BRIGHTNESS) = '0.00' ]; then brightnessctl set 5%; else brightnessctl --restore; fi"
run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run killall xidlehook
run fcitx5 -d
run  rclone --no-console  --vfs-cache-mode  writes mount "onedrivePupkinpupsm":  ~/rclone/onedrivePupkinpupsm
run nm-applet
run  blueman-applet
run keepassxc --keyfile /home/pups/rclone/onedrivePupkinpupsm.local/PCTools/Keepassxc/key.keyx   /home/pups/rclone/onedrivePupkinpupsm.local/PCTools/Keepassxc/Пароли.kdbx
run claws-mail
run systemctl --user start plasma-polkit-agent.service
run xset s off
run xset s off -dpms
run /home/pups/.cargo/bin/xidlehook --not-when-audio --timer 300 "$storeBrightness; brightnessctl --save; brightnessctl set 0%" "$restoreBrightness" --timer 600 "i3lock-fancy -gpf Comic-Sans-MS -- scrot -z" "$restoreBrightness" --timer 900 "systemctl suspend" "$restoreBrightness" --socket "/tmp/xidlehook.sock"
