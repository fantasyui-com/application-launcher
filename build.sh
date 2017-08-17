#!/bin/bash

rm -fr tmp;
rm -fr downloads;
rm -fr default_app
rm -f default_app.asar

mkdir default_app

cp -fR LICENSE.md default_app
cp -fR README.md default_app
cp -fR index.html default_app
cp -fR main.js default_app
cp -fR node_modules default_app
cp -fR package-lock.json default_app
cp -fR package.json default_app
cp -fR renderer.js default_app
cp -fR style.css default_app

asar pack default_app default_app.asar
rm -fr default_app

mkdir -p downloads;
mkdir -p tmp;
mkdir -p download-cache;

mkdir -p tmp/darwin-x64/
mkdir -p tmp/linux-x64/
mkdir -p tmp/win32-ia32/
mkdir -p tmp/win32-x64/

curl -L -o tmp/darwin-x64/darwin-x64.zip https://github.com/electron/electron/releases/download/v1.7.6/electron-v1.7.6-darwin-x64.zip
# cp download-cache/darwin-x64.zip tmp/darwin-x64/darwin-x64.zip
cd tmp/darwin-x64/
  unzip -q darwin-x64.zip;
  mv darwin-x64.zip ../../download-cache;
  mv Electron.app Launch.app
  cp -f ../../default_app.asar Launch.app/Contents/Resources/
  cp ../../configuration.json Launch.app/Contents/Resources/
  zip -y -9 -r ../../downloads/launch-mac-x64.zip .
cd -;

curl -L -o tmp/linux-x64/linux-x64.zip https://github.com/electron/electron/releases/download/v1.7.6/electron-v1.7.6-linux-x64.zip
cd tmp/linux-x64/
  unzip -q linux-x64.zip;
  mv linux-x64.zip ../../download-cache;
  mv electron start
  cp -f ../../default_app.asar resources/
  cp ../../configuration.json resources/
  zip -y -9 -r ../../downloads/app-store-linux-x64.zip .
cd -;

curl -L -o tmp/win32-ia32/win32-ia32.zip https://github.com/electron/electron/releases/download/v1.7.6/electron-v1.7.6-win32-ia32.zip
cd tmp/win32-ia32/
  unzip -q win32-ia32.zip;
  mv win32-ia32.zip ../../download-cache;
  mv electron.exe start.exe
  cp -f ../../default_app.asar resources/
  cp ../../configuration.json resources/
  zip -9 -r ../../downloads/app-store-windows-32.zip .
cd -;

curl -L -o tmp/win32-x64/win32-x64.zip https://github.com/electron/electron/releases/download/v1.7.6/electron-v1.7.6-win32-x64.zip
cd tmp/win32-x64/
  unzip -q win32-x64.zip;
  mv win32-x64.zip ../../download-cache;
  mv electron.exe start.exe
  cp -f ../../default_app.asar resources/
  cp ../../configuration.json resources/
  zip -9 -r ../../downloads/app-store-windows-64.zip .
cd -;

rm default_app.asar
rm -fr tmp
