project(udropcabin)
set(SRC src/main.cpp)

set(CMAKE_AUTOMOC ON)
find_package(Qt5Core)
find_package(Qt5Quick)

add_executable(udropcabin ${SRC})

file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/src/qml DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
qt5_use_modules(udropcabin Core Quick)
