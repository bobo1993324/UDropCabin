#!/bin/bash
git clone https://github.com/bobo1993324/QtDropbox.git
cd QtDropbox
git pull origin qmlIntegration
qmake
make
cd ..
mkdir build
cd build
cmake ..
make
cd ..
