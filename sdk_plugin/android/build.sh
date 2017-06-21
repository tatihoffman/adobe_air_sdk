#!/usr/bin/env bash

# Get the root directory
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
SDK_PLUGIN_DIR=sdk_plugin/android
BUILD_DIR=src/AdjustExtension
JAR_IN_DIR=src/AdjustExtension/extension/build/outputs
ORIGINAL_SDK_DIR=ext/android/sdk/Adjust/adjust/src/main/java/com/adjust/sdk
EXTENSION_DIR=src/AdjustExtension/extension/src/main/java/com/adjust/sdk

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd ${ROOT_DIR}/${SDK_PLUGIN_DIR}/${EXTENSION_DIR}
mv -v AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
rm -rv *
mv -v ../Adjust*.java .

# Copy all files from original SDK location
cd ${ROOT_DIR}/${ORIGINAL_SDK_DIR}
cp -rv * ${ROOT_DIR}/${SDK_PLUGIN_DIR}/${EXTENSION_DIR}

echo -e "${GREEN}>>> Android build script: Running Gradle tasks: clean makeJar ${NC}"
cd ${ROOT_DIR}/${SDK_PLUGIN_DIR}/${BUILD_DIR}
./gradlew clean makeJar

echo -e "${GREEN}>>> Android build script: Copy JAR to ${SDK_PLUGIN_DIR} ${NC}"
cd ${ROOT_DIR}/${SDK_PLUGIN_DIR}
cp -v ${JAR_IN_DIR}/adjust-android.jar .

echo -e "${GREEN}>>> Android build script: Complete ${NC}"
