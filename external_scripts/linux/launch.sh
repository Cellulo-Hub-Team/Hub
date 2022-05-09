#!/bin/bash
cd ~
cd Cellulo_Games
cd $1
NAME=$(find . -maxdepth 1 -name $1)
chmod +x $NAME
./$NAME