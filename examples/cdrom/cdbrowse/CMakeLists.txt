# PSn00bSDK example CMake script
# (C) 2021 spicyjpeg - MPL licensed

cmake_minimum_required(VERSION 3.20)

project(
	cdbrowse
	LANGUAGES    C
	VERSION      1.0.0
	DESCRIPTION  "PSn00bSDK CD file browser example"
	HOMEPAGE_URL "http://lameguy64.net/?page=psn00bsdk"
)

file(GLOB _sources *.c)
psn00bsdk_add_executable(cdbrowse STATIC ${_sources})
psn00bsdk_add_cd_image(cdbrowse_iso cdbrowse iso.xml DEPENDS cdbrowse)

install(
	FILES
		${PROJECT_BINARY_DIR}/cdbrowse.bin
		${PROJECT_BINARY_DIR}/cdbrowse.cue
	TYPE BIN
)
