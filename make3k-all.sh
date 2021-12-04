#!/usr/bin/env bash

set -euo pipefail

function build {
  echo "Building $1"
  avr-gcc -c -mmcu=atmega32u4 -I. -x assembler-with-cpp -o "$1.o" cathy3k.asm $2
  avr-ld -T "$HOME/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/avr/lib/ldscripts/avr5.x" -Ttext=0x7400 -Tdata=0x800100 --section-start=.boot=0x7800 --section-start=.bootsignature=0x7ffa -o "$1.elf" "$1.o"
  avr-objcopy -O ihex "$1.elf" "cathy3k/$1.hex"
  rm "$1.o"
  rm "$1.elf"
}

echo "Cathy 3K bootloader make                      by Mr. Blinky Oct 2017 - Dec 2018"
echo "________________________________________________________________________________"

PATH=$HOME/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin:$PATH

# Arduboy bootloaders with SDA as flash chip select and start with menu
build arduboy3k-bootloader-menu-dotmg "-DARDUBOY -DCART_CS_SDA -DARDUBOY_PROMICRO -DARDUBOY_DOTMG -DDEVICE_VID=0x2341 -DDEVICE_PID=0x0036"

# Arduboy bootloaders with SDA as flash chip select and poweron with last game
build arduboy3k-bootloader-game-dotmg "-DARDUBOY -DCART_CS_SDA -DARDUBOY_PROMICRO -DARDUBOY_DOTMG -DRUN_APP_ON_POWERON -DDEVICE_VID=0x2341 -DDEVICE_PID=0x0036"
