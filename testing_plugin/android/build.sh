#!/usr/bin/env bash

# Get the current directory (testing_plugin/android)
TESTING_PLUGIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR=src/AdjustTestingExtension
JAR_IN_DIR=src/AdjustTestingExtension/extension_testing/build/outputs
#ORIGINAL_SDK_DIR=sdk/Adjust/adjust/src/main/java/com/adjust/sdk
EXTENSION_DIR=src/AdjustTestingExtension/extension/src/main/java/com/adjust/sdktesting

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

# cd to the called directory to be able to run the script from anywhere
cd $(dirname $0) 
cd ${TESTING_PLUGIN_DIR}

# TODO: Make it so that it copies from test_ci Android SDK branch
#cd ${EXTENSION_DIR}
#mv AdjustActivity.java AdjustExtension.java AdjustFunction.java AdjustContext.java ..
#rm -r *
#mv ../Adjust*.java .

# Copy all files from ext/android/sdk towards ext/android/src/AdjustExtension/extension/src/main/java/com/adjust/sdk/
#cd ${TESTING_PLUGIN_DIR}/${ORIGINAL_SDK_DIR}
#cp -rv * ${TESTING_PLUGIN_DIR}/${EXTENSION_DIR}

echo -e "${GREEN}>>> Android build script: Running Gradle tasks: clean clearJar makeJar ${NC}"
cd ${TESTING_PLUGIN_DIR}/${BUILD_DIR}; ./gradlew clean makeJar

echo -e "${GREEN}>>> Android build script: Copy JAR to ${TESTING_PLUGIN_DIR} ${NC}"
cd ${TESTING_PLUGIN_DIR}
cp ${JAR_IN_DIR}/adjust-testing-bridge.jar ${TESTING_PLUGIN_DIR}

# echo -e "${GREEN}>>> Android build script: remove unneeded Javadoc and sources JARs ${NC}"
# rm ${TESTING_PLUGIN_DIR}/*-javadoc.jar;
# rm ${TESTING_PLUGIN_DIR}/*-sources.jar;

# echo -e "${GREEN}>>> Android build script: Rename to Adjust.jar ${NC}"
# mv ${TESTING_PLUGIN_DIR}/adjust-android.jar ${TESTING_PLUGIN_DIR}/Adjust.jar

echo -e "${GREEN}>>> Android build script: Complete ${NC}"
