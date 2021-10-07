# CMakeLists.txt - a root build file
#
# Copyright (c) 2021 Oleg Iarygin <oleg@arhadthedev.net>
#
# Distributed under the MIT software license; see the accompanying
# file LICENSE.txt or <https://www.opensource.org/licenses/mit-license.php>.

# cxx_std_17 in CMAKE_CXX_KNOWN_FEATURES was introduced in 3.8
# install(FILES TYPE <type>) was introduced in 3.14
#
# New versions of C++ remove unsafe practices from the standard library, so
# force the latest version available. "cxx_std_*" means "at least C++ xxx".
#
# Features removed in C++14: <https://isocpp.org/files/papers/p1319r0.html>.
# Features removed in C++17: <https://isocpp.org/files/papers/p0636r0.html>.
# Features removed in C++20: <http://open-std.org/JTC1/SC22/WG21/docs/papers/2020/p2131r0.html>.
cmake_minimum_required(VERSION 3.14)


##################################################
#
# Project and policies
#
##################################################

file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg.json" MANIFEST ENCODING UTF-8)
string(REGEX MATCH "[0-9]+\.[0-9.]+" BUILD_VERSION ${MANIFEST})

project(grammar2code VERSION ${BUILD_VERSION} LANGUAGES CXX)


##################################################
#
# Files managed unprocessed
#
##################################################

install(FILES LICENSE.txt README.md TYPE DOC)


##################################################
#
# Files generated into a build directory
#
##################################################

# A version header need to be regenerated each build to catch git checkouts.
# However, doing it in this CMakeLists.txt requires manual reconfiguration
# to trigger updates, so instead this file adds an always-rebuilt custom target
# that invokes a script to update the header conditionallys.

set(IN ${CMAKE_CURRENT_SOURCE_DIR}/src/version.h.in)
set(OUT ${CMAKE_CURRENT_BINARY_DIR}/version.h)
set(TOOLS ${CMAKE_CURRENT_SOURCE_DIR}/tools)
add_custom_target(version_info
    ALL
    COMMAND "${CMAKE_COMMAND}" -DVERSION_HEADER_TEMPLATE_PATH="${IN}"
                               -DVERSION_HEADER_OUTPUT_PATH="${OUT}"
                               -DGRAMMAR2CODE_BUILD_VERSION="${BUILD_VERSION}"
                               -P "${TOOLS}/update_version.cmake"
    BYPRODUCTS version.h)
