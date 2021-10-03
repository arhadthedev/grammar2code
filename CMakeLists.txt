# CMakeLists.txt - a root build file
#
# Copyright (c) 2021 Oleg Iarygin <oleg@arhadthedev.net>
#
# Distributed under the MIT software license; see the accompanying
# file LICENSE.txt or <https://www.opensource.org/licenses/mit-license.php>.

# cxx_std_17 in CMAKE_CXX_KNOWN_FEATURES was introduced in 3.8
#
# New versions of C++ remove unsafe practices from the standard library, so
# force the latest version available. "cxx_std_*" means "at least C++ xxx".
#
# Features removed in C++14: <https://isocpp.org/files/papers/p1319r0.html>.
# Features removed in C++17: <https://isocpp.org/files/papers/p0636r0.html>.
# Features removed in C++20: <http://open-std.org/JTC1/SC22/WG21/docs/papers/2020/p2131r0.html>.
cmake_minimum_required(VERSION 3.8)
