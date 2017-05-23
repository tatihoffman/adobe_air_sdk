#!/usr/bin/env bash

# Get the current directory (sdk_plugin/android/)
SDK_PLUGIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=src/AdjustExtension
JAR_IN_DIR=src/AdjustExtension/extension/build/outputs
ORIGINAL_SDK_DIR=../../ext/android/sdk/Adjust/adjust/src/main/java/com/adjust/sdk
EXTENSION_DIR=src/AdjustExtension/extension/src/main/java/com/adjust/sdk

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd $(dirname $0) 
cd ${SDK_PLUGIN_DIR}

cd ${EXTENSION_DIR}
mv AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
rm -r *
mv ../Adjust*.java .

# Copy all files from ext/android/sdk towards sdk_plugin/android/src/AdjustExtension/extension/src/main/java/com/adjust/sdk/
cd ${SDK_PLUGIN_DIR}/${ORIGINAL_SDK_DIR}
cp -rv * ${SDK_PLUGIN_DIR}/${EXTENSION_DIR}

echo -e "${GREEN}>>> Android build script: Running Gradle tasks: clean clearJar makeJar ${NC}"
cd ${SDK_PLUGIN_DIR}/${BUILD_DIR}; ./gradlew clean makeJar

echo -e "${GREEN}>>> Android build script: Copy JAR to ${SDK_PLUGIN_DIR} ${NC}"
cd ${SDK_PLUGIN_DIR}
cp ${JAR_IN_DIR}/adjust-android.jar ${SDK_PLUGIN_DIR}

echo -e "${GREEN}>>> Android build script: Complete ${NC}"
