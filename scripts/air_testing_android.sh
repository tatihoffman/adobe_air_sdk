#!/usr/bin/env bash

EXAMPLE_DIR=${ADOBE_AIR_SDK_DIR}/example
MAIN_FILE=Main.as
VERSION=`cat ${ADOBE_AIR_SDK_DIR}/VERSION`
KEYSTORE_FILE=`cd ${EXAMPLE_DIR}; find . -name "*.pfx" -print` # Get any keystore file with extension .pfx

RED='\033[0;31m' # Red color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No Color

echo -e "${GREEN}>>> Update submodules"
#git submodule update --init --recursive

echo -e "${GREEN}>>> Removing ANE file from example/lib ${NC}"
rm -rfv ${EXAMPLE_DIR}/lib/Adjust-*.*.*.ane

echo -e "${GREEN}>>> Removing ANE file from root dir ${NC}"
rm -rfv ${ADOBE_AIR_SDK_DIR}/Adjust*.ane

echo -e "${GREEN}>>> Building ANE for version ${VERSION} ${NC}"

cd ${ADOBE_AIR_SDK_DIR}
sdk_plugin//build.sh
mkdir -p ${EXAMPLE_DIR}/lib
cp -v Adjust-${VERSION}.ane ${EXAMPLE_DIR}/lib/

echo -e "${GREEN}>>> Checking if ANE is built successfully in location: ${EXAMPLE_DIR}/lib/Adjust-${VERSION}.ane ${NC}"

if [ ! -f "${EXAMPLE_DIR}/lib/Adjust-${VERSION}.ane" ]; then
    echo -e "${RED}>>> Bulding ANE failed ${NC}"
    exit 1
fi

echo -e "${GREEN}>>> ANE built successfully ${NC}"

echo -e "${GREEN}>>> Building example app ${NC}"
echo -e "${GREEN}>>> Running amxmlc ${NC}"
cd ${EXAMPLE_DIR}
amxmlc -external-library-path+=lib/Adjust-${VERSION}.ane -output=Main.swf -- ${MAIN_FILE}

echo -e "${GREEN}>>> Checking if keystore exists ${NC}"
if [ ! -f "${KEYSTORE_FILE}" ]; then
    echo -e "${GREEN}>>> Keystore file does not exist; creating one with password [pass] ${NC}"
    adt -certificate -validityPeriod 25 -cn SelfSigned 1024-RSA sampleCert.pfx pass
    echo -e "${GREEN}>>> Keystore file created ${NC}"
fi

echo -e "${GREEN}>>> Keystore file exists ${NC}"

echo -e "${GREEN}>>> Packaging APK file. Password will enter automatically ${NC}"
echo "pass" | adt -package -target apk-debug -storetype pkcs12 -keystore sampleCert.pfx Main.apk Main-app.xml Main.swf -extdir lib

echo -e "${GREEN}>>> APK file created. Running ADB install ${NC}"
adb install -r Main.apk

echo -e "${GREEN}>>> ADB installed ${NC}"
