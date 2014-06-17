import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Content 0.1
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
//    useDeprecatedToolbar: false

    backgroundColor: "#5FBCD3"
    headerColor: "#00A9D3"

    width: units.gu(50)
    height: units.gu(75)
    property var accountInfo: ({})
    property var fileMetaInfo: ({})
    property var contentTransfer;
    property list<ContentItem> transferItemList
    property bool busy: false
    Component {
        id: transferComponent
        ContentItem {}
    }

    Settings {
        id: settings
        onLoadFinished: {
            busy = true;
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
            pageStack.push(Qt.resolvedUrl("./ui/FilesPage.qml"))
        }
    }

    function accessGranted() {
        console.log("access granted")
        //request access
        accessTimer.start()
        pageStack.pop();
    }

    Timer {
        id: accessTimer
        interval: 1000
        repeat: false
        onTriggered: {
            QDropbox.requestAccessToken();
        }
    }
    Timer {
        id: loginTimer
        interval: 1000
        repeat: false
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("./ui/LoginPage.qml"), {url: QDropbox.authorizeLink});
        }
    }

    Connections {
        target: QDropbox
        onRequestTokenFinished:  {
            console.log("request token finished")
            QDropbox.requestAccessToken();
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
            loginTimer.start()
        }
        onAccountInfoReceived: {
            console.log("Receive account info");
            accountInfo = eval(accountJson)
            console.log(JSON.stringify(accountInfo))
        }
        onMetadataReceived: {
            console.log("file meta recieved")
            if (pageStack.depth == 1) {
                fileMetaInfo = eval(metadataJson);
            }
            console.log(JSON.stringify(metadataJson))
            busy = false;
        }
    }

    function afterAccessGranted() {
        QDropbox.requestAccountInfo();
        QDropbox.requestMetadata("/dropbox/");
    }

    Connections {
        target: ContentHub
        onExportRequested: {
            // show content picker
            console.log("export requested");
            contentTransfer = transfer
        }
    }
}
