CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(bgsubcnt)

FIND_PACKAGE(OpenCV 3.1.0 REQUIRED)

INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS})

IF(NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE Release)
ENDIF(NOT CMAKE_BUILD_TYPE)

SET(bgsubcnt_SRC
    "bgsubcnt.h"
    "bgsubcnt.cpp"
)
FILE(GLOB bgsubcnt_SRC_TST "main.cpp")

INCLUDE(CheckIncludeFileCXX)
check_include_file_cxx(opencv2/bgsegm.hpp HAVE_OPENCV_CONTRIB)
IF(HAVE_OPENCV_CONTRIB)
    ADD_DEFINITIONS(-DHAVE_OPENCV_CONTRIB)
ENDIF()

# Allow the developer to select if Dynamic or Static libraries are built
OPTION(BUILD_SHARED_LIBS "Build Shared Libraries" OFF)
# Set the LIB_TYPE variable to STATIC
SET(LIB_TYPE STATIC)
IF(NOT WIN32)
    IF(BUILD_SHARED_LIBS)
            # User wants to build Shared Libraries, so change the LIB_TYPE variable to CMake keyword 'SHARED'
            SET(LIB_TYPE SHARED)
            SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/deb/postinst;${CMAKE_CURRENT_SOURCE_DIR}/deb/postrm;")
    ENDIF()
ENDIF()

ADD_LIBRARY(bgsubcnt ${LIB_TYPE} ${bgsubcnt_SRC})

OPTION(BUILD_TEST "Create a demo executable" OFF)
IF(BUILD_TEST)
        ADD_EXECUTABLE(demo ${bgsubcnt_SRC_TST})
        TARGET_LINK_LIBRARIES(demo bgsubcnt ${OpenCV_LIBS})
ENDIF()

INSTALL(TARGETS bgsubcnt
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
	COMPONENT library)

INSTALL(FILES bgsubcnt.h DESTINATION include
	COMPONENT library)

SET(CPACK_PACKAGE_NAME "bgsubcnt")
SET(CPACK_PACKAGE_VENDOR "theimpossiblecode.com")
SET(CPACK_PACKAGE_CONTACT "sagi@theimpossiblecode.com")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Fast background subtraction for OpenCV 3.1.0")
SET(CPACK_PACKAGE_VERSION "1.1.0")
SET(CPACK_PACKAGE_VERSION_MAJOR "1")
SET(CPACK_PACKAGE_VERSION_MINOR "1")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one SET of four (4) backlasshes.
  SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} BackgroundSubtractorCNT")
  SET(CPACK_NSIS_MODIFY_PATH ON)
ELSE()
  SET(CPACK_PACKAGING_INSTALL_PREFIX "/usr/local")
ENDIF()

# These vars are used by python/CMakeLists.txt
SET(BGSUBCNT_LIB_DIR ${CMAKE_CURRENT_BINARY_DIR})
SET(BGSUBCNT_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

ADD_SUBDIRECTORY(python) 

# This must always be last!
INCLUDE(CPack)
