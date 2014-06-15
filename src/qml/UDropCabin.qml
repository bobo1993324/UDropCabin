import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"
import "ui"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    id: mainView
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
    property var accountInfo: ({})
    property var fileMetaInfo: ({})
    Settings {
        id: settings
        onLoadFinished: {
            QDropbox.key = "o28bortadg3cjbt";
            QDropbox.sharedSecret = "wqm8zgaxvtrehbh";
            if (settings.token !== "") {
                console.log("Load token")
                QDropbox.token = settings.token
                QDropbox.tokenSecret = settings.tokenSecret
                afterAccessGranted();
            } else {
                console.log("request Token")
                QDropbox.requestToken();
            }
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: {
            push(Qt.resolvedUrl("ui/FilesPage.qml"))
        }
    }
    LoginPage {
        id: loginPage
        visible: false
        onAccessGranted: {
            console.log("access granted")
            //request access
            QDropbox.requestAccessToken();
        }
    }

    Connections {
        target: QDropbox
        onRequestTokenFinished:  {
            console.log("request token finished")
            QDropbox.requestAccessToken();
//            console.log(QDropbox.authorizeLink)
//            pageStack.push(Qt.resolvedUrl("./ui/LoginPage.qml"), {url: QDropbox.authorizeLink});
        }
        onAccessTokenFinished: {
            console.log("accessTokenFinished");
            settings.token = token;
            settings.tokenSecret = secret;
            settings.save();
            afterAccessGranted();
        }
        onTokenExpired: {
            console.log("token expired");
            loginPage.url = QDropbox.authorizeLink;
            pageStack.push(loginPage);
        }
        onAccountInfoReceived: {
            console.log("Receive account info");
            accountInfo = eval(accountJson)
            console.log(JSON.stringify(accountInfo))
        }
        onMetadataReceived: {
            console.log("file meta recieved")
            fileMetaInfo = eval(metadataJson);
            console.log(JSON.stringify(metadataJson))
        }
    }

    function afterAccessGranted() {
        QDropbox.requestAccountInfo();
        QDropbox.requestMetadata("/dropbox/");
    }
}
