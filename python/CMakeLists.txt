# Allow the developer to select if to build a python extension
OPTION(PYTHON_EXTENSION "Build Python PYTHON_EXTENSION" OFF)

# Macro to replace _VAR vaiable name with a path content to "native path",
# escaping '\' and puting the result in a variable name given in _RESULT
# SINGLE VAR API
MACRO(NATIVE_STRING _VAR _RESULT)
	SET(${_RESULT} "")
	FILE(TO_NATIVE_PATH ${${_VAR}} VAR_NATIV)
	STRING(REPLACE "\\" "\\\\" ${_RESULT} "${VAR_NATIV}")
        #MESSAGE("_RESULT is: ${${_RESULT}}")
ENDMACRO()

# Macro to replace _LST vaiable name with list of path contents to "native path" list,
# escaping '\' and puting the result in a variable name given in _RESULT.
# The result is a list of python strings with commas.
# LIST VAR API
MACRO(NATIVE_STRINGS _LST _RESULT)
	SET(${_RESULT} "")
	SET(_SEPERATOR "")
	FOREACH(PATH_STR ${${_LST}})
		#MESSAGE("PATH_STR is: ${PATH_STR}")
		NATIVE_STRING(PATH_STR PATH_STR_NATIVE)
		SET(${_RESULT} "${${_RESULT}}${_SEPERATOR}'${PATH_STR_NATIVE}'")
		SET(_SEPERATOR ",")
	ENDFOREACH()
ENDMACRO()

# Get lib or its import lib for a dll
# SINGLE VAR API
MACRO(NATIVE_LIB_STRING _LIB _RESULT)
	#MESSAGE("_LIB is: ${${_LIB}}")
	STRING(TOUPPER ${CMAKE_BUILD_TYPE} _BUILD_TYPE)
	GET_TARGET_PROPERTY(_RES ${${_LIB}} IMPORTED_IMPLIB_${_BUILD_TYPE})
        STRING(FIND "${_RES}" "NOTFOUND" _POS)
        IF(_POS EQUAL -1) # found an import lib
		GET_FILENAME_COMPONENT(_LIB_NAME_NATIVE ${_RES} NAME)
                STRING(REGEX REPLACE "[.].*" ""
			${_RESULT} "${_LIB_NAME_NATIVE}")
	ELSE()
		SET(${_RESULT} ${${_LIB}})
        ENDIF()
ENDMACRO()

# Get libs or their import libs for dlls
# The result is a list of python strings with commas.
# LIST VAR API
MACRO(NATIVE_LIB_STRINGS _LST _RESULT)
	SET(${_RESULT} "")
	SET(_SEPERATOR "")
	FOREACH(LIB_NAME ${${_LST}})
		#MESSAGE("LIB_NAME is: ${LIB_NAME}")
		NATIVE_LIB_STRING(LIB_NAME LIB_NAME_NATIVE)
		STRING(FIND "${${_RESULT}}" "'${LIB_NAME_NATIVE}'" _POS)
		IF(_POS EQUAL -1)
			SET(${_RESULT} "${${_RESULT}}${_SEPERATOR}'${LIB_NAME_NATIVE}'")
		ENDIF()
		SET(_SEPERATOR ",")
	ENDFOREACH()
ENDMACRO()

IF(PYTHON_EXTENSION)
	FIND_PROGRAM(PYTHON "python" DOC "Path to python executable")
        IF(PYTHON)
                SET(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
                SET(SETUP_PY    "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
                SET(OUTPUT      "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")

		NATIVE_LIB_STRINGS(OpenCV_LIBS OpenCV_LIBS_NATIVE)
		NATIVE_STRINGS(OpenCV_LIB_DIR OpenCV_LIB_DIR_NATIVE)
		NATIVE_STRINGS(OpenCV_INCLUDE_DIRS OpenCV_INCLUDE_DIRS_NATIVE)
		NATIVE_STRING(CMAKE_CURRENT_SOURCE_DIR CMAKE_CURRENT_SOURCE_DIR_NATIVE)
		NATIVE_STRING(BGSUBCNT_INCLUDE_DIR BGSUBCNT_INCLUDE_DIR_NATIVE)
		MESSAGE("OpenCV_LIBS_NATIVE is: ${OpenCV_LIBS_NATIVE}")
		MESSAGE("OpenCV_LIB_DIR_NATIVE is: ${OpenCV_LIB_DIR_NATIVE}")
		MESSAGE("OpenCV_INCLUDE_DIRS_NATIVE is: ${OpenCV_INCLUDE_DIRS_NATIVE}")
		MESSAGE("CMAKE_CURRENT_SOURCE_DIR_NATIVE is: ${CMAKE_CURRENT_SOURCE_DIR_NATIVE}")
		MESSAGE("BGSUBCNT_INCLUDE_DIR_NATIVE is: ${BGSUBCNT_INCLUDE_DIR_NATIVE}")
                CONFIGURE_FILE(${SETUP_PY_IN} ${SETUP_PY})

                FILE(GLOB PyDep_SRC
                        "*.h"
                        "*.hpp"
                        "*.i"
                        "*.cpp"
                        "*.c"
                        "*.cxx"
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
                        COMPONENT python_extension)
        ELSE()
                MESSAGE("python was not found")
        ENDIF()
ENDIF()

