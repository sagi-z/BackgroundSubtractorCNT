# Allow the developer to select if to build a python extension
OPTION(PYTHON_EXTENSION "Build Python PYTHON_EXTENSION" OFF)
IF(PYTHON_EXTENSION)
        FIND_PROGRAM(PYTHON "python")
        IF(PYTHON)
                SET(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
                SET(SETUP_PY    "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
                SET(OUTPUT      "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")

                FOREACH(var CMAKE_CURRENT_SOURCE_DIR
                            BGSUBCNT_INCLUDE_DIR
                            _OPENCV_INCLUDE_DIR
                            _OPENCV_LIB_DIR
                            )
                        FILE(TO_NATIVE_PATH ${${var}} ${var}_NATIVE)
                ENDFOREACH()
                CONFIGURE_FILE(${SETUP_PY_IN} ${SETUP_PY})

                FILE(GLOB PyDep_SRC
                        "*.h"
                        "*.i"
                        "*.cpp"
                        )

                ADD_CUSTOM_COMMAND(OUTPUT ${OUTPUT}
                                   COMMAND ${PYTHON} ${SETUP_PY} install --home=.
                                   COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT}
                                   DEPENDS ${BGSUBCNT_LIB_DIR} ${PyDep_SRC})

                ADD_CUSTOM_TARGET(bgsubcnt_python ALL DEPENDS ${OUTPUT})

                EXECUTE_PROCESS (
                        COMMAND ${PYTHON} -c
                        "import site, sys; sys.stdout.write(site.PREFIXES[-1])"
                        OUTPUT_VARIABLE PYTHON_PREFIX
                        )
                FILE(TO_CMAKE_PATH "${PYTHON_PREFIX}" PYTHON_PREFIX)
                EXECUTE_PROCESS (
                        COMMAND ${PYTHON} -c
                        "import site, sys; sys.stdout.write(site.getsitepackages()[-1])"
                        OUTPUT_VARIABLE PYTHON_SITE_DIR
                        )
                FILE(TO_CMAKE_PATH "${PYTHON_SITE_DIR}" PYTHON_SITE_DIR)
                STRING ( REGEX REPLACE "^${PYTHON_PREFIX}/" ""
                        PYTHON_SITE_DIR "${PYTHON_SITE_DIR}"
                        )
                MESSAGE("PYTHON_PREFIX is ${PYTHON_PREFIX}")
                MESSAGE("PYTHON_SITE_DIR is ${PYTHON_SITE_DIR}")

                INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib/python/
                        DESTINATION ${PYTHON_SITE_DIR}
                        COMPONENT library)
        ELSE()
                MESSAGE("python was not found")
        ENDIF()
ENDIF()

