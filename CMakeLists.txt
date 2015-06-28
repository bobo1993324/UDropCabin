project(udropcabin)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Core)
find_package(Qt5Quick)
find_package(Qt5Network)
find_package(Qt5Xml)

#lib QtDropbox
set(QTDROPBOX_PATH ${CMAKE_SOURCE_DIR}/3rdParty/QtDropbox/)
file(GLOB QTQROPBOX_SRC ${QTDROPBOX_PATH}/src/*.cpp)
add_library(QtDropbox ${QTQROPBOX_SRC})
qt5_use_modules(QtDropbox Core Network Xml)

#UDropcabin
include_directories("${QTDROPBOX_PATH}/src")
set(SRC
    src/main.cpp
    src/downloadfile.cpp
    src/uploadfile.cpp
    src/path.cpp
    src/taskwithprogress.cpp
)
add_executable(udropcabin ${SRC})

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/src/qml DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(udropcabin QtDropbox)
qt5_use_modules(udropcabin Core Quick Xml Network)

add_subdirectory("src/qml")

install(DIRECTORY ${CMAKE_SOURCE_DIR}/src/qml DESTINATION /)
install(PROGRAMS ${CMAKE_BINARY_DIR}/udropcabin DESTINATION /)
install(FILES
    ${CMAKE_SOURCE_DIR}/uDropCabin-content.json
    ${CMAKE_SOURCE_DIR}/manifest.json
    ${CMAKE_SOURCE_DIR}/uDropCabin.desktop
    ${CMAKE_SOURCE_DIR}/uDropCabin.json
    ${CMAKE_SOURCE_DIR}/logo.png
    DESTINATION /
)

add_custom_target(manifest ALL SOURCES
    ${CMAKE_SOURCE_DIR}/manifest.json
    ${CMAKE_SOURCE_DIR}/uDropCabin.desktop
    ${CMAKE_SOURCE_DIR}/uDropCabin.json
    ${CMAKE_SOURCE_DIR}/uDropCabin-content.json
)
