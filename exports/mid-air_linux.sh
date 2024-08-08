#!/bin/sh
echo -ne '\033c\033]0;MidAir\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/mid-air_linux.x86_64" "$@"
