import QtQuick 2.0
import Ubuntu.Components 0.1
import QtWebKit 3.0
import "components"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer..UDropCabin"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    Page {
        id: loginPage
        WebView {
            anchors.fill: parent
            url: "https://www.dropbox.com/1/oauth2/authorize?response_type=token&client_id=o28bortadg3cjbt&redirect_uri=http://localhost"
            onUrlChanged: console.log(url)
        }
    }
}
