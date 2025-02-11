listen() {
  while true; do
    nc -lk '12345' | while IFS= read -r line; do
      echo "$line"
      beep_sound
    done
  done
}

send() {
  echo "$1" | nc 10.0.0.75 12345
}

beep_sound() {
  if command -v beep &> /dev/null; then
    beep
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    afplay /System/Library/Sounds/Ping.aiff
  elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/bell.oga
  elif command -v aplay &> /dev/null; then
    aplay /usr/share/sounds/alsa/Front_Center.wav
  else
    echo -e "\a"
  fi
}
