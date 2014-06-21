#!/bin/bash
mkdir package
cp build/udropcabin build/qml uDropCabin-content.json manifest.json uDropCabin.desktop uDropCabin.json logo.png package -rf
cd package
click build .
cp *.click ..
cd ..
rm package -rf 
