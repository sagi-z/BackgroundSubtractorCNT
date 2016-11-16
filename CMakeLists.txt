# set minimum required version for cmake
cmake_minimum_required(VERSION 2.8)

project(bgsubcnt)

find_package(OpenCV 3.1.0 REQUIRED)

MESSAGE("OpenCV version : ${OpenCV_VERSION}")

if(NOT CMAKE_BUILD_TYPE)
    set (CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_BUILD_TYPE)

file(GLOB bgsubcnt_SRC
    "*.h"
    "*.cpp"
)
file(GLOB bgsubcnt_SRC_TST "main.cpp")
list(REMOVE_ITEM bgsubcnt_SRC "${bgsubcnt_SRC_TST}")

include(CheckIncludeFileCXX)
check_include_file_cxx(opencv2/bgsegm.hpp HAVE_OPENCV_CONTRIB)
if(HAVE_OPENCV_CONTRIB)
    add_definitions(-DHAVE_OPENCV_CONTRIB)
endif(HAVE_OPENCV_CONTRIB)

add_library(bgsubcnt SHARED ${bgsubcnt_SRC})

option(BUILD_TEST "Create and executable" OFF)
if(BUILD_TEST)
        add_executable(demo ${bgsubcnt_SRC_TST})
        target_link_libraries (demo bgsubcnt ${OpenCV_LIBS})
endif()

install(TARGETS bgsubcnt
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib)

install(FILES bgsubcnt.h DESTINATION include)

set(CPACK_PACKAGE_NAME "bgsubcnt")
set(CPACK_PACKAGE_VENDOR "theimpossiblecode.com")
set(CPACK_PACKAGE_CONTACT "sagi@theimpossiblecode.com")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Fast background subtraction for OpenCV 3.1.0")
set(CPACK_PACKAGE_VERSION "1.0.0")
set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "0")
set(CPACK_PACKAGING_INSTALL_PREFIX "/usr/local")

# This must always be last!
include(CPack)
