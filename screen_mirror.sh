#!/bin/sh -f

# Mirror screen to projector. Needs adjustment to resolution.
function enable {
	xrandr -q
	#xrandr --output VGA1 --auto --output LVDS1 --auto
	xrandr --output VGA1 --mode 1920x1080 --output LVDS1 --primary --scale-from 1920x1080
}

function disable {
	#xrandr --output LVDS1 --auto --output VGA1 --off
	xrandr --output VGA1 --off --output LVDS1 --primary --auto --scale-from 1600x900
}
