file(GLOB QML_JS_FILES *.qml components/*.qml ui/*.qml js/*.js)
add_custom_target(udropcabin_QMlFiles ALL SOURCES ${QML_JS_FILES})
