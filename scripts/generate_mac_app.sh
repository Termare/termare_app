flutter build macos
rm -rf ./build/macos/Build/Products/Release/移动到这
ln -s -f /Applications ./build/macos/Build/Products/Release/移动到这
mkdir -p ./build/macos/Build/Products/Release/Termare.app/Contents/MacOS/data/usr/bin
cp ./executable/macos/adb ./build/macos/Build/Products/Release/Termare.app/Contents/MacOS/data/usr/bin
tar -zcvf ./remote.tar  -C ./build/macos/Build/Products/  Release/Termare.app/ Release/移动到这
rm -rf ./build/macos/Build/Products/Release/移动到这