#!/bin/bash
cd ~
mkdir "Cellulo_Games"
cd Cellulo_Games
mkdir $1
cd $1
wget $2 -O "build.zip"
unzip build.zip

var shell = new Shell();

shell.navigate('/home/kali/Desktop');
shell.run('touch', arguments: ['happy']);
shell.run('touch', arguments: ['happy2']);
shell.run('mkdir', arguments: ['dir']);
shell.run('rm', arguments: ['happy']);
var find = await shell.start('find', arguments: ['.']);

print(await find.stdout.readAsString());