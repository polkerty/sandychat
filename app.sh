listen() {
  while true; do
    nc -lk '12345' | while IFS= read -r line; do
      beep_id=$(echo "$line" | cut -d '|' -f 1)
      message=$(echo "$line" | cut -d '|' -f 2-)
      echo "$message"
      beep_sound "$beep_id"
    done
  done
}

send() {
  local beep_id="0"
  local message="$1"

  while [[ "$1" != "" ]]; do
    case "$1" in
      -b) shift; beep_id="$1"; shift ;;
      *) message="$1"; shift ;;
    esac
  done

  echo "$beep_id|$message" | nc 10.0.0.75 12345
}

beep_sound() {
  local beep_id="$1"

  case "$beep_id" in
    1) beep_standard ;;
    2) beep_high ;;
    3) beep_low ;;
    4) beep_melody ;;
    *) ;;  # No beep if beep_id is invalid or 0
  esac
}

beep_standard() {
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

beep_high() {
  if command -v beep &> /dev/null; then
    beep -f 1000 -l 100
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    afplay /System/Library/Sounds/Submarine.aiff
  elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/message.oga
  elif command -v aplay &> /dev/null; then
    aplay /usr/share/sounds/alsa/Rear_Right.wav
  else
    echo -e "\a"
  fi
}

beep_low() {
  if command -v beep &> /dev/null; then
    beep -f 200 -l 200
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    afplay /System/Library/Sounds/Funk.aiff
  elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/phone-outgoing-busy.oga
  elif command -v aplay &> /dev/null; then
    aplay /usr/share/sounds/alsa/Rear_Left.wav
  else
    echo -e "\a"
  fi
}

beep_melody() {
  if command -v beep &> /dev/null; then
    beep -f 500 -l 100 -n -f 600 -l 100 -n -f 700 -l 100
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    afplay /System/Library/Sounds/Glass.aiff
  elif command -v paplay &> /dev/null; then
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga
  elif command -v aplay &> /dev/null; then
    aplay /usr/share/sounds/alsa/Side_Left.wav
  else
    echo -e "\a\a\a"
  fi
}
