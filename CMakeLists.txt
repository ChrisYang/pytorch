cmake_minimum_required(VERSION 2.8)

#find_package(Lua51 REQUIRED)
#include_directories(${LUA_INCLUDE_DIR})
FIND_PACKAGE(Torch REQUIRED)  # you need to run source ~/torch/install/bin/torch-activate if this line
                              # gives an error

SET(CMAKE_C_FLAGS "-std=c99 ")
SET(CMAKE_CXX_FLAGS "-std=c++0x -Wall")

set(HOME $ENV{HOME})
#include_directories(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lua-5.1.5/src)
include_directories(${HOME}/torch/install/include/TH)
include_directories(${HOME}/torch/install/include)

ADD_DEFINITIONS(-DLUA_USE_LINUX)

file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/lua-5.1.5/files.txt lua_src1)
foreach(source ${lua_src1})
    set( lua_src ${lua_src} thirdparty/lua-5.1.5/src/${source})
endforeach()

add_library(PyTorchLua SHARED ${lua_src})
message("lua_src ${lua_src}")

#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wl,-export-dynamic")
add_library(PyTorchNative SHARED src/nnWrapper.cpp src/LuaHelper.cpp)
#add_library(nnWrapper SHARED nnWrapper.cpp ${lua_src})
#target_link_libraries(PyTorchNative ${LUA_LIBRARIES})
target_link_libraries(PyTorchLua m)
target_link_libraries(PyTorchNative PyTorchLua)
target_link_libraries(PyTorchNative luaT)
target_link_libraries(PyTorchNative TH)

install(TARGETS PyTorchNative PyTorchLua
    RUNTIME DESTINATION bin
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib)

