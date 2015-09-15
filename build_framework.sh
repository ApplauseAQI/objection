#!/bin/bash

PROJECT_NAME=Objection
CONFIGURATION=Release
SRCROOT=${PWD}
BUILD_DIR=${SRCROOT}/build
PRODUCT_NAME=Objection-iOS

xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphonesimulator -target ${PROJECT_NAME}-StaticLib -configuration ${CONFIGURATION} clean build
xcodebuild -project ${PROJECT_NAME}.xcodeproj -sdk iphoneos -target ${PROJECT_NAME}-StaticLib -configuration ${CONFIGURATION} clean build

SIMULATOR_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/lib${PROJECT_NAME}-StaticLib.a" &&
DEVICE_LIBRARY_PATH="${BUILD_DIR}/${CONFIGURATION}-iphoneos/lib${PROJECT_NAME}-StaticLib.a" &&
UNIVERSAL_LIBRARY_DIR="${BUILD_DIR}/${CONFIGURATION}-iphoneuniversal" &&
UNIVERSAL_LIBRARY_PATH="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}" &&
FRAMEWORK="${UNIVERSAL_LIBRARY_DIR}/${PRODUCT_NAME}.framework" &&
HEADERS_DIR="${SRCROOT}"/Source/*.h

# Create framework directory structure.
rm -rf "${FRAMEWORK}" &&
mkdir -p "${UNIVERSAL_LIBRARY_DIR}" &&
mkdir -p "${FRAMEWORK}/Versions/A/Headers" &&
mkdir -p "${FRAMEWORK}/Versions/A/Resources" &&

# Generate universal binary from desktop, device, and simulator builds.
lipo "${SIMULATOR_LIBRARY_PATH}" "${DEVICE_LIBRARY_PATH}" -create -output "${UNIVERSAL_LIBRARY_PATH}" &&

# Move files to appropriate locations in framework paths.
cp "${UNIVERSAL_LIBRARY_PATH}" "${FRAMEWORK}/Versions/A" &&
ln -s "A" "${FRAMEWORK}/Versions/Current" &&
ln -s "Versions/Current/Headers" "${FRAMEWORK}/Headers" &&
ln -s "Versions/Current/Resources" "${FRAMEWORK}/Resources" &&
ln -s "Versions/Current/${PRODUCT_NAME}" "${FRAMEWORK}/${PRODUCT_NAME}" &&
cp "${SRCROOT}/${PROJECT_NAME}-Info.plist" "${FRAMEWORK}/Resources/Info.plist"
cp ${HEADERS_DIR} "${FRAMEWORK}/Versions/A/Headers"
