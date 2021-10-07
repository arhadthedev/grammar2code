# update_version.cmake - regenerate a version header file if it is out-of-date
#
# This file is called from a root CMakeLists.txt.
#
# Synopsis:
#
#     cmake -DVERSION_HEADER_TEMPLATE_PATH="<h.in-file-path>"
#           -DVERSION_HEADER_OUTPUT_PATH="<h-file-path>"
#           -DGRAMMAR2CODE_BUILD_VERSION="<maj.min.rev-string>"
#           -P update_version.cmake
#
# Description:
#
# Populates VERSION_HEADER_TEMPLATE_PATH template with version information and
# compares the result with content of `VERSION_HEADER_OUTPUT_PATH` .h-file. If
# different, outputs a new version updating a timestamp of a file.
#
# Copyright:
#
# Copyright (c) 2021 Oleg Iarygin <oleg@arhadthedev.net>
#
# Distributed under the MIT software license; see the accompanying
# file LICENSE.txt or <https://www.opensource.org/licenses/mit-license.php>.

find_package(Git)


##################################################
#
# Unconditionally generate version information
#
##################################################

message(STATUS "Detecting version information")

if(Git_FOUND)
    execute_process(COMMAND "${GIT_EXECUTABLE}" describe --exact-match --tags
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    RESULT_VARIABLE GRAMMAR2CODE_BUILD_IS_PRERELEASE
                    OUTPUT_QUIET
                    ERROR_QUIET)
    execute_process(COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    OUTPUT_VARIABLE GRAMMAR2CODE_BUILD_COMMIT_ID
                    OUTPUT_STRIP_TRAILING_WHITESPACE
                    ERROR_QUIET)
    execute_process(COMMAND "${GIT_EXECUTABLE}" diff --exit-code
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                    RESULT_VARIABLE GRAMMAR2CODE_BUILD_IS_PATCHED
                    OUTPUT_QUIET
                    ERROR_QUIET)
endif()

if((NOT GRAMMAR2CODE_BUILD_COMMIT_ID) OR GRAMMAR2CODE_BUILD_IS_PATCHED)
    string(TIMESTAMP GRAMMAR2CODE_BUILD_TIME "%Y-%m-%d.%H-%M-%S" UTC)
endif()

set(VER_H "${VERSION_HEADER_OUTPUT_PATH}")
configure_file("${VERSION_HEADER_TEMPLATE_PATH}" "${VER_H}.tmp" @ONLY)
message(STATUS "Detecting version information - done")


##################################################
#
# Trigger project regeneration on version change
#
##################################################

message(STATUS "Updating version.h")
execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files "${VER_H}.tmp" "${VER_H}"
                RESULT_VARIABLE VERSION_NEEDS_UPDATING
                OUTPUT_QUIET
                ERROR_QUIET
)
if(VERSION_NEEDS_UPDATING)
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "${VER_H}.tmp" "${VER_H}")
    message(STATUS "Updating version.h - done")
else()
    message(STATUS "Updating version.h - skipped")
endif()
file(REMOVE "${VER_H}.tmp")
