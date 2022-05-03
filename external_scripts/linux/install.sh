#!/bin/bash
cd ~
mkdir "Cellulo_Games"
cd Cellulo_Games
mkdir $1
cd $1
wget $2 -O "build.zip"
unzip build.zip