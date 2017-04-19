cmake_minimum_required(VERSION 3.7)
project(C_CPPExploration)

set(CMAKE_C_STANDARD 99)

set(SOURCE_FILES main.c getnumber.cpp)
add_executable(C_CPPExploration ${SOURCE_FILES})