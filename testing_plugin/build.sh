#!/usr/bin/env bash
#---------- Directories
# Get the root directory 
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$ROOT_DIR")"
TESTING_PLUGIN_DIR=testing_plugin
SOURCE_DIR=src
BUILD_DIR=build

#------------ Commands and misc
ADT=${AIR_SDK_PATH}/bin/adt
COMPC=${AIR_SDK_PATH}/bin/compc
COMPC_CLASSES="com.adjust.sdktesting.AdjustTesting"
VERSION=`cat ${ADOBE_AIR_SDK_DIR}/VERSION`

#----------- echo colors
RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> AA build script: BEGIN${NC}"
cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}

#----------- emulator
echo -e "${GREEN}>>> AA build script: running emulator tasks${NC}"
mkdir -p ${BUILD_DIR}/default
${COMPC} -source-path default/src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -directory=true -output ${BUILD_DIR}/default
rm -rf ${BUILD_DIR}/default/catalog.xml

#----------- Run android and iOS build scripts
echo -e "${GREEN}>>> AA build script:  Running Android and iOS build scripts${NC}"
android/build.sh

#----------- Copy generated files to BUILD_DIR
echo -e "${GREEN}>>> AA build script: copying generated files to ${BUILD_DIR} ${NC}"
cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}
mkdir -p ${BUILD_DIR}/Android
cp -v android/adjust-testing-bridge.jar ${BUILD_DIR}/Android

#------------ Making swc file
echo -e "${GREEN}>>> AA build script:  Making swc file${NC}"
${COMPC} -source-path src -swf-version 27 -external-library-path ${AIR_SDK_PATH}/frameworks/libs/air/airglobal.swc -include-classes ${COMPC_CLASSES} -output ${BUILD_DIR}/adjust-testing.swc

#------------ Running ADT and finalizing the ANE file 
echo -e "${GREEN}>>> AA build script: Running ADT and finalizing the ANE file ${NC}"
unzip -d ${BUILD_DIR}/Android -qq -o ${BUILD_DIR}/adjust-testing.swc -x catalog.xml
cp -af ${SOURCE_DIR}/platformoptions_android.xml ${BUILD_DIR}/platformoptions_android.xml
cp -af ${SOURCE_DIR}/extension.xml ${BUILD_DIR}/extension.xml

cd ${ROOT_DIR}/${TESTING_PLUGIN_DIR}
cd ${BUILD_DIR}; ${ADT} -package -target ane ../../Adjust-testing-${VERSION}.ane extension.xml -swc adjust-testing.swc -platform Android-ARM -C Android . -platformoptions platformoptions_android.xml -platform default -C default .

echo -e "${GREEN}>>> AA build script: END ${NC}"
