#!/bin/bash
git clone https://github.com/bobo1993324/QtDropbox.git
cd QtDropbox
qmake
make
cd ..
mkdir build
cd build
cmake ..
make
cd ..
