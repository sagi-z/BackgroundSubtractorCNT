CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(bgsubcnt)

FIND_PACKAGE(OpenCV 3.1.0 REQUIRED)

MESSAGE("OpenCV version : ${OpenCV_VERSION}")

INCLUDE_DIRECTORIES(${OpenCV_INCLUDE_DIRS})

IF(NOT CMAKE_BUILD_TYPE)
    SET(CMAKE_BUILD_TYPE Release)
ENDIF(NOT CMAKE_BUILD_TYPE)

FILE(GLOB bgsubcnt_SRC
    "*.h"
    "*.cpp"
)
FILE(GLOB bgsubcnt_SRC_TST "main.cpp")
LIST(REMOVE_ITEM bgsubcnt_SRC "${bgsubcnt_SRC_TST}")

INCLUDE(CheckIncludeFileCXX)
check_include_file_cxx(opencv2/bgsegm.hpp HAVE_OPENCV_CONTRIB)
IF(HAVE_OPENCV_CONTRIB)
    ADD_DEFINITIONS(-DHAVE_OPENCV_CONTRIB)
ENDIF()

# Allow the developer to select IF Dynamic or Static libraries are built
OPTION (BUILD_SHARED_LIBS "Build Shared Libraries" OFF)
# Set the LIB_TYPE variable to STATIC
SET(LIB_TYPE STATIC)
IF(BUILD_SHARED_LIBS)
        # User wants to build Shared Libraries, so change the LIB_TYPE variable to CMake keyword 'SHARED'
        SET(LIB_TYPE SHARED)
        IF(UNIX AND NOT WIN32)
            SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/deb/postinst;${CMAKE_CURRENT_SOURCE_DIR}/deb/postrm;")
        ENDIF()
ENDIF()

ADD_LIBRARY(bgsubcnt ${LIB_TYPE} ${bgsubcnt_SRC})

IF(WIN32 AND NOT UNIX)
INCLUDE (GenerateExportHeader)
GENERATE_EXPORT_HEADER(bgsubcnt
             BASE_NAME bgsubcnt
             EXPORT_MACRO_NAME bgsubcnt_EXPORT
             EXPORT_FILE_NAME bgsubcnt_Export.h
             STATIC_DEFINE bgsubcnt_BUILT_AS_STATIC
)
ENDIF()

OPTION(BUILD_TEST "Create and executable" OFF)
IF(BUILD_TEST)
        add_executable(demo ${bgsubcnt_SRC_TST})
        target_link_libraries (demo bgsubcnt ${OpenCV_LIBS})
ENDIF()

INSTALL(TARGETS bgsubcnt
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib)

INSTALL(FILES bgsubcnt.h DESTINATION include)

SET(CPACK_PACKAGE_NAME "bgsubcnt")
SET(CPACK_PACKAGE_VENDOR "theimpossiblecode.com")
SET(CPACK_PACKAGE_CONTACT "sagi@theimpossiblecode.com")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Fast background subtraction for OpenCV 3.1.0")
SET(CPACK_PACKAGE_VERSION "1.0.0")
SET(CPACK_PACKAGE_VERSION_MAJOR "1")
SET(CPACK_PACKAGE_VERSION_MINOR "0")
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

# This must always be last!
INCLUDE(CPack)
