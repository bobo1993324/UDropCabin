project(udropcabin)
set(CMAKE_VERBOSE_MAKEFILE ON)
set(SRC
    src/main.cpp
    src/downloadfile.cpp
)

set(CMAKE_AUTOMOC ON)

set(QtDropboxDir ${CMAKE_SOURCE_DIR}/QtDropbox/)

find_package(Qt5Core)
find_package(Qt5Quick)
find_package(Qt5Network)
find_package(Qt5Xml)

add_executable(udropcabin ${SRC})

include_directories("${QtDropboxDir}/src")

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/src/qml DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(udropcabin ${QtDropboxDir}/libQtDropbox.a)
qt5_use_modules(udropcabin Core Quick Xml Network)
