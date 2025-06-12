#!/usr/bin/env bash

execCommand=$1
className=$2
workspaceOnStart=$3

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\")")

if [[ $running != "" ]]; then
	hyprctl dispatch focuswindow "class:$className"    
else 
	hyprctl dispatch workspace "$workspaceOnStart" 
	${execCommand} & 
fi
