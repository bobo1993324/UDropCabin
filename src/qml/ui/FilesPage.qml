import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
import "../components"
Page {
    id: filesPage
    title: "UDropCabin"
    property bool editMode: false;
    state: editMode ? "edit" : "navigate"
    states: [
        PageHeadState {
           name: "navigate"
           head: filesPage.head
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
                   text: "Edit"
                   iconName: "edit"
                   onTriggered: {
                       filesPage.editMode = true;
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
            contents: CurrentPathHeader { }
       },
        PageHeadState {
            name: "edit"
            head: filesPage.head
            actions: [
                Action {
                    iconName: "share"
                    text: "Open"
                    enabled: dirView.selectedCount == 1
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
                },
                Action {
                    iconName: "delete"
                    text: "Delete"
                    enabled: dirView.selectedCount >= 1
                    onTriggered: {
                        mainView.busy = true;
                        for (var i in dirView.selectedIndexes) {
                            QDropbox.requestDeleteFile(mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]].path);
                        }
                        dirView.selectedIndexes = [];
                    }
                },
                Action {
                    enabled: dirView.selectedCount == 1
                    iconName: "info"
                    text: "Property"
                    onTriggered: {
                        pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: mainView.fileMetaInfo.contents[dirView.selectedIndexes[0]]})
                    }
                }
            ]
            backAction: Action {
                text: "Cancel"
                iconName: "close"
                onTriggered: {
                    filesPage.editMode = false;
                    dirView.reset();
                }
            }
            contents: CurrentPathHeader { }
        }
    ]

//    GridView {
//        id: dirGridView
//        anchors.fill: parent
//        visible: false
//        anchors.topMargin: units.gu(2)
//        model: mainView.fileMetaInfo.contents
//        delegate: Item {
//            Column {
//                Icon {
//                    width: units.gu(6);
//                    height: width
//                    source: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
//                    anchors.horizontalCenter: parent.horizontalCenter
//                }
//                Label {
//                    text: Utils.getFileNameFromPath(modelData.path)
//                    width: units.gu(12);
//                    elide: Text.ElideRight
//                    horizontalAlignment: Text.AlignHCenter
//                }
//            }
//        }
//    }

    ListView {
        id: dirView
        //visible: false
        property int positionIndex
        property var selectedIndexes: {[]}
        property int selectedCount: 0;
        anchors.fill: parent

        model: mainView.fileMetaInfo.contents
        clip: true

        function reset() {
            dirView.selectedIndexes = [];
            selectedCount = 0;
        }

        onSelectedCountChanged: {
            filesPage.editMode = selectedCount > 0;
        }
        delegate: ListItem.Standard {
            id: fileListItem
            property bool selected;
            text: Utils.getFileNameFromPath(modelData.path)

            iconSource: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
            iconFrame: false
            Component.onCompleted: selected = dirView.selectedIndexes.indexOf(index) > -1
            onClicked: {
                if (modelData.is_dir && !filesPage.editMode) {
                    mainView.listDir(modelData.path);
                    dirView.reset();
                    return;
                }

                if (!selected) {
                    dirView.selectedIndexes.push(index)
                    selected = true;
                    dirView.positionIndex = index
                    dirView.selectedCount ++;
                } else {
                    for (var i in dirView.selectedIndexes) {
                        if (dirView.selectedIndexes[i] === index) {
                            dirView.selectedIndexes.splice(i, 1);
                            dirView.selectedCount --;
                            break;
                        }
                    }
                    selected = false;
                }
            }

            Rectangle {
                visible: selected
                anchors.fill: parent
                color: "#1382DE";
                z: -1
            }

            Connections {
                target: dirView
                onSelectedCountChanged: {
                    if (dirView.selectedCount == 0) fileListItem.selected = false;
                }
            }
        }
    }
    Item {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            enabled: ai.running || downloadAI.running
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
}
