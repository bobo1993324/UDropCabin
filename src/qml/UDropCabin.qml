import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Content 0.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.Connectivity 1.0
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
    automaticOrientation: true
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)
    property var accountInfo: ({})
    property var fileMetaInfo: ({})
    property var contentTransfer;
    property list<ContentItem> transferItemList
    property bool busy: false
    property bool isOnline: NetworkingStatus.online
    property bool importingFiles: false;
    property bool exportingFiles: false
    property bool editingPhotoUploadPath: false

    property var _filesPage
    function sendContentToOtherApps(path) {
        if (mainView.contentTransfer === undefined) {
            PopupUtils.open(Qt.resolvedUrl("./components/ContentPickerDialog.qml"), mainView, {"exportFilesPath" : path})
        } else {
            //TODO support multiple files
            mainView.transferItemList = [transferComponent.createObject(mainView, {"url": path[0]}) ]
            mainView.contentTransfer.items = mainView.transferItemList;
            mainView.contentTransfer.state = ContentTransfer.Charged;

            mainView.exportingFiles = false;
            mainView.contentTransfer = undefined;
        }
    }

    function cancelImport() {
        if (mainView.contentTransfer != undefined) {
            mainView.contentTransfer.state = ContentTransfer.Aborted;
        } else {
            console.log("WARN: contentTransfer empty.");
        }
        mainView.importingFiles = false;
        mainView.contentTransfer = undefined;
    }

    function cancelExport() {
        if (mainView.contentTransfer != undefined) {
            mainView.contentTransfer.state = ContentTransfer.Aborted;
        } else {
            console.log("WARN: contentTransfer empty.");
        }
        mainView.exportingFiles = false;
        mainView.contentTransfer = undefined;
    }

    function accessGranted() {
        console.log("access granted")
        //request access
        QDropbox.requestAccessToken();
        pageStack.pop();
    }

    function afterAccessGranted() {
        QDropbox.requestAccountInfo();
        listDir("/");
    }

    function listDir(path) {
        console.log("listDir " + path)
        var newDir = metaDb.get(path);
        if (newDir !== undefined)
            fileMetaInfo = newDir
        if (mainView.isOnline) {
            busy = true
            if (newDir && newDir.hash)
                QDropbox.requestMetadata("/dropbox/" + path, false, newDir.hash);
            else
                QDropbox.requestMetadata("/dropbox/" + path);
        }
    }

    function refreshDir() {
        listDir(fileMetaInfo.path)
    }

    function uploadPhotoes() {
        if (!exportingFiles && !importingFiles && settings.photoUploadEnabled && settings.dropboxPhotoUploadPath.length > 0) {
            //automatic upload photo
            console.log("automatic upload photo")
            autoPhotoUploadTimer.start();
        }
    }

    onIsOnlineChanged: {
        console.log("isOnlineChanged", isOnline);
        if (!isOnline && fileMetaInfo.path === undefined) {
            fileMetaInfo = metaDb.get("/");
        }
        if (isOnline) {
            if (fileMetaInfo.path)
                refreshDirTimer.restart();
        }
    }

    onActiveChanged: {
        if (active)
            uploadPhotoes();
    }

    Component.onCompleted: uploadPhotoes();

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
            _filesPage = pageStack.push(Qt.resolvedUrl("./ui/FilesPage.qml"))
        }
    }

    Connections {
        target: QDropbox
        onRequestTokenFinished:  {
            console.log("request token finished")
            pageStack.push(Qt.resolvedUrl("./ui/LoginPage.qml"), {url: QDropbox.authorizeLink});
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
            QDropbox.requestToken();
        }
        onAccountInfoReceived: {
            console.log("Receive account info");
            accountInfo = eval(accountJson)
            console.log(JSON.stringify(accountInfo))
        }
        onMetadataReceived: {
            console.log("file meta recieved", editingPhotoUploadPath)
            if (pageStack.depth == 1 || editingPhotoUploadPath) {
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
                busy = false
            }
        }
        onFileDeleteCompleted: {
            console.log("delete complete")
            mainView.busy = false;
            refreshDirTimer.restart();
        }
        onCreateFolderCompleted: {
            console.log("create folder complete")
            mainView.busy = false;
            refreshDirTimer.restart();
        }
        onMetaNotModified: {
            console.log("No update on current directory");
            busy = false;
        }
    }

    Connections {
        target: ContentHub
        onExportRequested: {
            // show content picker
            console.log("export requested");
            exportingFiles = true;
            contentTransfer = transfer
            //TODO switch on the export mode
        }
        onImportRequested: {
            console.log("import requested");
            importingFiles = true;
            contentTransfer = transfer;
        }
    }
    Timer {
        id: refreshDirTimer
        repeat: false
        interval: 1000
        onTriggered: mainView.refreshDir();
    }
    Timer {
        id: autoPhotoUploadTimer
        repeat: false
        interval: 1000
        onTriggered: {
            var photoesToUpload = uploadFile.photosToUpload();
            if (photoesToUpload.length > 0) {
                _filesPage.uploadFilesInCurrentDirectory2(photoesToUpload, settings.dropboxPhotoUploadPath);
            }
        }
    }
}
