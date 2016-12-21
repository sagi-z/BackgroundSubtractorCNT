# Allow the developer to select if to build a python extension
OPTION(PYTHON_EXTENSION "Build Python PYTHON_EXTENSION" OFF)
IF(PYTHON_EXTENSION)
        FIND_PROGRAM(PYTHON "python")
        IF(PYTHON)
                SET(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
                SET(SETUP_PY    "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
                SET(OUTPUT      "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")

                CONFIGURE_FILE(${SETUP_PY_IN} ${SETUP_PY})

                ADD_CUSTOM_COMMAND(OUTPUT ${OUTPUT}
                                   COMMAND ${PYTHON} ${SETUP_PY} build
                                   COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT})

                ADD_CUSTOM_TARGET(target ALL DEPENDS ${OUTPUT})

                INSTALL(CODE "execute_process(COMMAND ${PYTHON} ${SETUP_PY} install)")
        ELSE()
                MESSAGE("python was not found")
        ENDIF()
ENDIF()

