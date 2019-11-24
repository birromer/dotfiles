#!/bin/bash

die() {
  echo "$1"
  exit 1 #error
}

echo "Install dependencies..."

sudo apt-get update
sudo apt-get upgrade -y
sudo apt install build-essential cmake git pkg-config libgtk-3-dev
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
sudo apt install libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev
sudo apt install python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-22-dev

echo "Cloning OpenCV source..."

mkdir ./opencv_build
cd ./opencv_build
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

echo "Configuring OpenCV with CMake..."

cd ./opencv
mkdir build && cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
    -D BUILD_EXAMPLES=ON ..

echo "Compiling OpenCV..."

make -j7

echo "Installing OpenCV..."

sudo make install

echo "Finished installing OpenCV"
