#!/usr/bin/env bash

# Get the root directory
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
ROOT_DIR="$(dirname "$ROOT_DIR")"
TESTING_PLUGIN_DIR=testing_plugin/android
BUILD_DIR=src/AdjustTestingExtension
JAR_IN_DIR=src/AdjustTestingExtension/extension_testing/build/outputs
TEST_LIBRARY_DIR=ext/android/sdk/Adjust/testlibrary/src/main/java/com/adjust/testlibrary
EXTENSION_DIR=src/AdjustTestingExtension/extension_testing/src/main/java/com/adjust/sdktesting

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}/${EXTENSION_DIR}
mv -v AdjustExtension.java AdjustFunction.java AdjustContext.java CommandListener.java ..
rm -rv *
mv -v ../Adjust*.java .
mv -v ../CommandListener.java .

# Copy all files from original test library location
cd ${ROOT_DIR}/${TEST_LIBRARY_DIR}
cp -rv * ${ROOT_DIR}/${TESTING_PLUGIN_DIR}/${EXTENSION_DIR}
cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}/${EXTENSION_DIR}
sed -i '' -e s/'com.adjust.testlibrary'/'com.adjust.sdktesting'/g *.java

echo -e "${GREEN}>>> Android build script: Running Gradle tasks: clean makeJar ${NC}"
cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}/${BUILD_DIR}
./gradlew clean makeJar

echo -e "${GREEN}>>> Android build script: Copy JAR to ${TESTING_PLUGIN_DIR} ${NC}"
cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}
cp -v ${JAR_IN_DIR}/adjust-testing-bridge.jar .

echo -e "${GREEN}>>> Android build script: Complete ${NC}"
