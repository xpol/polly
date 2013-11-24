# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_IOS_CMAKE)
  return()
else()
  set(POLLY_IOS_CMAKE 1)
endif()

# Error while building using 'ExternalProject_Add':

#CMake Error at /.../share/cmake/Modules/Platform/Darwin.cmake:211 (message):
#  CMAKE_OSX_DEPLOYMENT_TARGET is '10.9' but CMAKE_OSX_SYSROOT:
#   "iphoneos"
#  is not set to a MacOSX SDK with a recognized version.  Either set
#  CMAKE_OSX_SYSROOT to a valid SDK or set CMAKE_OSX_DEPLOYMENT_TARGET to
#  empty.
set(ENV{CMAKE_OSX_DEPLOYMENT_TARGET} "")

set(POLLY_TOOLCHAIN_NAME "iOS")
set(POLLY_TOOLCHAIN_TAG "ios")

include("${CMAKE_CURRENT_LIST_DIR}/Common.cmake")

if(NOT XCODE_VERSION)
  message(FATAL_ERROR "This toolchain is available only on Xcode")
endif()

set(CMAKE_OSX_SYSROOT "iphoneos" CACHE STRING "System root for iOS" FORCE)

# Skip compiler check:
#     http://cmake.org/Bug/view.php?id=12288
#     http://code.google.com/p/ios-cmake/issues/detail?id=1
set(CMAKE_CXX_COMPILER_WORKS TRUE CACHE BOOL "Skip compiler check" FORCE)
set(CMAKE_C_COMPILER_WORKS TRUE CACHE BOOL "Skip compiler check" FORCE)

# find 'iphoneos' and 'iphonesimulator' roots and version
find_program(XCODE_SELECT_EXECUTABLE xcode-select)
if(NOT XCODE_SELECT_EXECUTABLE)
  message(FATAL_ERROR "xcode-select not found")
endif()

if(NOT IOS_ARCHS)
  set(IOS_ARCHS armv7;armv7s)
endif()

execute_process(
    COMMAND
    ${XCODE_SELECT_EXECUTABLE}
    "-print-path"
    OUTPUT_VARIABLE
    XCODE_DEVELOPER_ROOT # /.../Xcode.app/Contents/Developer
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

find_program(XCODEBUILD_EXECUTABLE xcodebuild)
if(NOT XCODEBUILD_EXECUTABLE)
  message(FATAL_ERROR "xcodebuild not found")
endif()

# Order is important(!)
# Set high priority to the last
if(NOT IOS_SDK_VERSION)
  set(IOS_SDK_VERSIONS 5.0 5.1 6.0 6.1 7.0)
  foreach(x ${IOS_SDK_VERSIONS})
    execute_process(
        COMMAND
        ${XCODEBUILD_EXECUTABLE}
        -showsdks
        -sdk
        "iphoneos${x}"
        RESULT_VARIABLE
        IOS_SDK_VERSION_RESULT
        OUTPUT_QUIET
        ERROR_QUIET
    )
    if(${IOS_SDK_VERSION_RESULT} EQUAL 0)
      set(IOS_SDK_VERSION ${x})
    endif()
  endforeach()
endif()

if(NOT IOS_SDK_VERSION)
  message(FATAL_ERROR "iOS version not found, tested: [${IOS_SDK_VERSIONS}]")
endif()

# support for hunter (github.com/ruslo/hunter)
set(HUNTER_CMAKE_GENERATOR Xcode)
