#!/bin/bash
mkdir package
cp components/ js/ ui/ uDropCabin-content.json manifest.json uDropCabin.desktop uDropCabin.json uDropCabin.qml package -rf
cd package
click build .
cp *.click ..
cd ..
rm package -rf 
