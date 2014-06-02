include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
	${CMAKE_SOURCE_DIR}/QtDropbox/src
)

set(
    UDropCabinbackend_SRCS
    modules/UDropCabin/backend.cpp
    modules/UDropCabin/dropbox.cpp
    modules/UDropCabin/dropboxfile.cpp
    modules/UDropCabin/mytype.cpp
)

add_library(UDropCabinbackend MODULE
    ${UDropCabinbackend_SRCS}
)

set_target_properties(UDropCabinbackend PROPERTIES
         LIBRARY_OUTPUT_DIRECTORY UDropCabin)

qt5_use_modules(UDropCabinbackend Gui Qml Quick Network Xml)

target_link_libraries(UDropCabinbackend
	${CMAKE_SOURCE_DIR}/QtDropbox/libQtDropbox.so
)
# Copy qmldir file to build dir for running in QtCreator
add_custom_target(UDropCabinbackend-qmldir ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/modules/UDropCabin/qmldir ${CMAKE_CURRENT_BINARY_DIR}/UDropCabin
    DEPENDS ${QMLFILES}
)

# Install plugin file
install(TARGETS UDropCabinbackend DESTINATION ${QT_IMPORTS_DIR}/UDropCabin/)
install(FILES   modules/UDropCabin/qmldir DESTINATION ${QT_IMPORTS_DIR}/UDropCabin/)
