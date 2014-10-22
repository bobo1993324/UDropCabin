import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
Page {
    id: filesPage
    title: "UDropCabin"
    head {
        backAction: Action {
            text: "Up"
            iconName: "back"
            enabled: mainView.fileMetaInfo.path !== "/"
            onTriggered: {
                mainView.listDir(Utils.getParentPath(mainView.fileMetaInfo.path))
                dirView.reset()
            }
        }
        actions: [
            Action {
                text: "Upload"
                iconName: "add"
                onTriggered: {
                    var contentDialog = PopupUtils.open(Qt.resolvedUrl("../components/ContentPickerDialog.qml"),
                                   filesPage,
                                   {
                                       isUpload: true
                                   });
                    contentDialog.transferCompleteForUpload.connect(
                        function(files) {
                            for (var i in files) {
                                var sourcePath = files[i].url.toString().replace("file://", "");
                                mainView.busy = true;
                                UploadFile.upload(sourcePath,
                                    mainView.fileMetaInfo.path + "/" + Utils.getFileNameFromPath(sourcePath));
                                mainView.busy = false;
                            }
                            mainView.refreshDir();
                        });

                    UploadFile.upload("/home/boren/examples.desktop",
                                      mainView.fileMetaInfo.path + "/example.desktop")
                    mainView.refreshDir();
                }
            },
            Action {
                text: "Refresh"
                iconName: "reload"
                onTriggered: mainView.refreshDir();
            },
            Action {
                text: "Settings"
                iconName: "settings"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }, Action {
                text: "About"
                iconSource: "image://theme/help"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
            }

        ]
        contents: Item {
            height: parent.height
            width: parent.width
            Label {
                text: mainView.fileMetaInfo.path != undefined? mainView.fileMetaInfo.path : ""
                anchors.verticalCenter: parent.verticalCenter
            }
            Label {
                color: "red"
                text: "No network"
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: units.gu(2)
                }
                visible: !mainView.isOnline
            }
        }
    }

    ListView {
        id: dirView
        property int positionIndex
        property var selectedIndexes: {[]}
        signal selectedCountChanged
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: fileOpsPanel.height - fileOpsPanel.position
        }

        model: mainView.fileMetaInfo.contents
        clip: true

        function reset() {
            dirView.selectedIndexes = [];
            dirView.selectedCountChanged();
        }

        delegate: ListItem.Standard {
            property bool selected;
            text: Utils.getFileNameFromPath(modelData.path)
            Component.onCompleted: selected = dirView.selectedIndexes.indexOf(index) > -1
            onClicked: {
                if (!selected) {
                    dirView.selectedIndexes.push(index)
                    selected = true;
                    dirView.positionIndex = index
                } else {
                    for (var i in dirView.selectedIndexes) {
                        if (dirView.selectedIndexes[i] === index) {
                            dirView.selectedIndexes.splice(i, 1);
                            break;
                        }
                    }
                    console.log(dirView.selectedIndexes);
                    selected = false;
                }
                dirView.selectedCountChanged();
            }
            Item {
                height: parent.height
                width: units.gu(10)
                anchors.right: parent.right
                visible: modelData.is_dir
                Icon {
                    name: 'next'
                    width: units.gu(3)
                    height: width
                    anchors {
                        centerIn: parent
                    }
                }
                MouseArea {
                    enabled: modelData.is_dir
                    preventStealing: true
                    anchors.fill: parent
                    onClicked: {
                        mainView.listDir(modelData.path);
                        dirView.reset();
                        fileOpsPanel.close();
                    }
                }
            }

            iconSource: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
            iconFrame: false
            Rectangle {
                visible: selected
                anchors.fill: parent
                color: "#1382DE";
                z: -1
            }
        }
        Timer {
            id: positionTimer
            property int positionIndex
            interval: 1000
            repeat: false
            onTriggered: {

            }
        }
    }
    Panel {
        id: fileOpsPanel
        property bool singleFileOps: true;
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: units.gu(8)
        locked: true
        onAnimatingChanged: {
            if (!animating && opened) {
                dirView.positionViewAtIndex(dirView.positionIndex, ListView.Visible);
            }
        }
        Rectangle {
            height: parent.height
            width: parent.width
            anchors.right: parent.right
            Row {
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: units.gu(2)
                spacing: units.gu(2)
                ToolbarButton {
                    iconName: "share"
                    text: "Open"
                    enabled: fileOpsPanel.singleFileOps
                    onTriggered: {
                        var file = mainView.fileMetaInfo.contents[dirView.selectedIndexes[0]];
                        if (DownloadFile.fileExists(file.path) &&
                                DownloadFile.getModify(file.path) > DownloadFile.getDateTimeUTC(file.modified, "ddd, dd MMM yyyy hh:mm:ss +0000")){
                            mainView.sendContentToOtherApps(Utils.dropboxPathToLocalPath(file.path));
                        } else {
                            downloadAI.running = true;
                            DownloadFile.download(file.path);
                            downloadAI.running = false;
                            mainView.sendContentToOtherApps(Utils.dropboxPathToLocalPath(file.path));
                        }
                    }
                }
                ToolbarButton {
                    iconName: "delete"
                    text: "Delete"
                    onTriggered: {
                        mainView.busy = true;
                        for (var i in dirView.selectedIndexes) {
                            QDropbox.requestDeleteFile(mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]].path);
                        }
                        dirView.selectedIndexes = [];
                    }
                }
                ToolbarButton {
                    enabled: fileOpsPanel.singleFileOps
                    iconName: "info"
                    text: "Property"
                    onTriggered: {
                        pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: mainView.fileMetaInfo.contents[dirView.selectedIndexes[0]]})
                    }
                }
            }
        }
        Connections {
            target: dirView
            onSelectedCountChanged: {
                fileOpsPanel.singleFileOps = (dirView.selectedIndexes.length == 1)
                if (dirView.selectedIndexes.length == 0) {
                    fileOpsPanel.close();
                } else {
                    fileOpsPanel.open();
                }
            }
        }
    }

    ActivityIndicator {
        id: ai
        anchors.centerIn: parent
        visible: running
        running: mainView.busy
    }
    ActivityIndicator {
        id: downloadAI
        anchors.centerIn: parent
        visible: running
        running: false
    }
}
