# Copyright (c) 2016, Ruslan Baratov
# All rights reserved.

if(DEFINED POLLY_NINJA_VS_12_2013_WIN64_CMAKE_)
  return()
else()
  set(POLLY_NINJA_VS_12_2013_WIN64_CMAKE_ 1)
endif()

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_init.cmake")

polly_init(
    "Ninja / Visual Studio 2013 / x64"
    "Ninja"
)

include("${CMAKE_CURRENT_LIST_DIR}/utilities/polly_common.cmake")
