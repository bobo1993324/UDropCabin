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
               uploadAction,
               createFolderAction,
               editAction,
               refreshAction,
               listGridViewAction,
               settingAction,
               aboutAction
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
                    enabled: dirView.selectedCount >= 1
                    onTriggered: {
                        var files = [];
                        for (var i in dirView.selectedIndexes) {
                            files.push (mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]]);
                        }
                        var filesNeedToDownload = [];
                        for (var i in files) {
                            if (DownloadFile.fileExists(files[i].path) &&
                                    DownloadFile.getModify(files[i].path) > DownloadFile.getDateTimeUTC(files[i].modified, "ddd, dd MMM yyyy hh:mm:ss +0000")) {
                                //already downloaded
                            } else {
                                filesNeedToDownload.push(files[i]);
                            }
                        }
                        if (filesNeedToDownload.length > 0) {
                            var downloadDialog = PopupUtils.open(Qt.resolvedUrl("../components/ProgressDialog.qml"), filesPage,
                                                                 {
                                                                     isDownloading: true
                                                                 });
                            for (var i in filesNeedToDownload) {
                                downloadDialog.currentFileName = Utils.getFileNameFromPath(filesNeedToDownload[i].path);
                                DownloadFile.download(filesNeedToDownload[i].path);
                            }
                            downloadDialog.close();
                        }
                        var filesLocalPath = [];
                        for (var i in files) {
                            filesLocalPath.push(Utils.dropboxPathToLocalPath(files[i].path));
                        }

                        mainView.sendContentToOtherApps(filesLocalPath);
                        dirView.reset();
                    }
                },
                Action {
                    iconName: "delete"
                    text: "Delete"
                    enabled: dirView.selectedCount >= 1
                    onTriggered: {
                        var selectedFiles = [];
                        for (var i in dirView.selectedIndexes) {
                            selectedFiles.push(mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]].path);
                        }
                        var confirmDialog = PopupUtils.open(Qt.resolvedUrl("../components/RemoveConfirmDialog.qml"), filesPage,
                                                            {
                                                                removeFilesPath: selectedFiles
                                                            });
                        confirmDialog.confirmed.connect(function() {
                            mainView.busy = true;
                            for (var i in dirView.selectedIndexes) {
                                QDropbox.requestDeleteFile(mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]].path);
                            }
                            dirView.reset()
                        });
                    }
                },
                Action {
                    enabled: dirView.selectedCount == 1
                    iconName: "info"
                    text: "Property"
                    onTriggered: {
                        pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: mainView.fileMetaInfo.contents[dirView.selectedIndexes[0]]})
                        dirView.reset()
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

    Action {
        id: createFolderAction
        iconSource: Qt.resolvedUrl("../graphics/new-folder.svg")
        text: "Create Folder"
        onTriggered: {
            var createFolderDialog = PopupUtils.open(Qt.resolvedUrl("../components/CreateFolderDialog.qml"))
            createFolderDialog.createFolder.connect(function(folderName) {
                console.log("create folder " + folderName);
                mainView.busy = true;
                QDropbox.requestCreateFolder(mainView.fileMetaInfo.path + "/" + folderName);
            });
        }
    }

    Action {
        id: uploadAction
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
                    var uploadProgressDialog = PopupUtils.open(Qt.resolvedUrl("../components/ProgressDialog.qml"), filesPage, {
                                                                 isDownloading: false
                                                               });
                    for (var i in files) {
                        var sourcePath = files[i].url.toString().replace("file://", "");
                        uploadProgressDialog.currentFileName = Utils.getFileNameFromPath(sourcePath);
                        UploadFile.upload(sourcePath,
                            mainView.fileMetaInfo.path + "/" + Utils.getFileNameFromPath(sourcePath));
                    }
                    uploadProgressDialog.close();
                    mainView.refreshDir();
                });
        }
    }
    Action {
        id: editAction
        text: "Edit"
        iconName: "edit"
        onTriggered: {
            filesPage.editMode = true;
        }
    }
    Action {
        id: refreshAction
        text: "Refresh"
        iconName: "reload"
        onTriggered: mainView.refreshDir();
    }
    Action {
        id: listGridViewAction
        property bool listView: dirView.format == "list"
        text: listView ? "Grid View" : "List View"
        iconName: dirView.format == "list" ? "view-grid-symbolic" : "view-list-symbolic"
        onTriggered: {
            dirView.format = (listView ? "grid" : "list");
        }
    }
    Action {
        id: settingAction
        text: "Settings"
        iconName: "settings"
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }
    }
    Action {
        id: aboutAction
        text: "About"
        iconSource: "image://theme/help"
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
        }
    }

    DirView {
        id: dirView
        anchors.fill: parent
        model: mainView.fileMetaInfo.contents
        onSelectedCountChanged: {
            filesPage.editMode = selectedCount > 0;
        }
    }

    Item {
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            enabled: ai.running
        }

        ActivityIndicator {
        id: ai
        anchors.centerIn: parent
        visible: running
        running: mainView.busy
        }
    }
}
