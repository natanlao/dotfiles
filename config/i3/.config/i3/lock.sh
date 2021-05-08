#!/usr/bin/env bash
letterEnteredColor=002b36ff
letterRemovedColor=dc322fff
passwordCorrect=00000000
passwordIncorrect=d23c3dff
background=00000000
foreground=fdf6e3ff

i3lock-color \
    -t -e \
    -i "$1" \
    --timepos="40:h-70" \
    --datepos="40:h-45" \
    --clock \
    --datestr "%A, %B %-d" \
    --timestr="%-I:%M %p" \
    --date-align 1 \
    --time-align 1\
    --insidecolor=$background --ringcolor=$foreground --line-uses-inside \
    --keyhlcolor=$letterEnteredColor --bshlcolor=$letterRemovedColor --separatorcolor=$background \
    --insidevercolor=$passwordCorrect --insidewrongcolor=$passwordIncorrect \
    --ringvercolor=$foreground --ringwrongcolor=$foreground --indpos="x+240:h-70" \
    --radius=20 --ring-width=4 --veriftext="" --wrongtext="" \
    --verifcolor="$foreground" --timecolor="$foreground" --datecolor="$foreground" \
    --noinputtext="" --force-clock $lockargs