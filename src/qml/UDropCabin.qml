import QtQuick 2.2
import Ubuntu.Components 1.1
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
    useDeprecatedToolbar: false

    backgroundColor: "#5FBCD3"
    headerColor: "#00A9D3"

    width: units.gu(50)
    height: units.gu(75)
    property var accountInfo: ({})
    property var fileMetaInfo: ({})
    property var contentTransfer;
    property list<ContentItem> transferItemList
    property bool busy: false
    property bool isOnline: true
    Component {
        id: transferComponent
        ContentItem {}
    }

    Settings {
        id: settings
        onLoadFinished: {
            busy = true;
            QDropbox.key = "2n3x34hh0g822al";
            QDropbox.sharedSecret = "3lb111pil5xfgjq";
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

    MetaDb {
        id:metaDb
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
            mainView.isOnline = true;
            if (pageStack.depth == 1) {
                var tmpFileMetaInfo = eval(metadataJson);
                //sort files, display directroy first
                tmpFileMetaInfo.contents.sort(function(a, b) {
                    if (a.is_dir && !b.is_dir) {
                        return -1;
                    } else if (!a.is_dir && b.is_dir) {
                        return 1;
                    }
                    return 0;
                });
                mainView.fileMetaInfo = tmpFileMetaInfo;
                metaDb.set(fileMetaInfo.path, fileMetaInfo)
            }
            busy = false;
        }
        onErrorOccured: {
            console.log("Error " + errorcode)
            if (errorcode == 1) {
                console.log("communication error")
                mainView.isOnline = false;
                busy = false
            }
        }
    }

    function afterAccessGranted() {
        QDropbox.requestAccountInfo();
        listDir("/");
    }

    Connections {
        target: ContentHub
        onExportRequested: {
            // show content picker
            console.log("export requested");
            contentTransfer = transfer
        }
    }

    function listDir(path) {
        console.log("listDir " + path)
        if (mainView.isOnline) {
            busy = true
            QDropbox.requestMetadata("/dropbox/" + path);
        } else {
            var newDir = metaDb.get(path);
            if (newDir !== undefined)
                fileMetaInfo = newDir
            else {
                console.log("Error: not online, no cache for the directory")
            }
        }
    }
}
