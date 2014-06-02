import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import UDropCabin 1.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.bobo1993324.udropcabin"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    Settings {
        id: settings
    }

    PageStack {
        id: pageStack
        Component.onCompleted: {
            push(Qt.resolvedUrl("ui/FilesPage.qml"))
        }
    }

    MyType {
        id: fileModel
    }
}
