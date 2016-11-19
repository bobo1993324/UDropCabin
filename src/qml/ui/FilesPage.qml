import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
import "../components"
Page {
    id: filesPage
    title: i18n.tr("UDropCabin")
    property bool editMode: false;
    state: mainView.exportingFiles ? "export" : (mainView.importingFiles ? "import" : (editMode ? "edit" : "navigate"))
    states: [
        PageHeadState {
           name: "navigate"
           head: filesPage.head
           backAction: upAction
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
                openAction,
                deleteAction,
                infoAction
            ]
            backAction: Action {
                text: i18n.tr("Cancel")
                iconName: "close"
                onTriggered: {
                    filesPage.editMode = false;
                    dirView.reset();
                }
            }
            contents: CurrentPathHeader { }
        },
        PageHeadState {
           name: "import"
           head: filesPage.head
           backAction: upAction
           actions: [
               createFolderAction,
               refreshAction
            ]
            contents: CurrentPathHeader { }
        },
        PageHeadState {
            name: "export"
            head: filesPage.head
            backAction: upAction
            actions: []
            contents: CurrentPathHeader { }
        }
    ]
    function uploadFilesInCurrentDirectory(localFilesPath) {
        // resolve conflicts
        var filesToOverride = []
        for (var i in localFilesPath) {
            for (var j in mainView.fileMetaInfo.contents) {
                if (Utils.getFileNameFromPath(localFilesPath[i]) === Utils.getFileNameFromPath(mainView.fileMetaInfo.contents[j].path)) {
                    filesToOverride.push(localFilesPath[i])
                }
            }
        }
        console.log("files to override " + filesToOverride);
        if (filesToOverride.length > 0) {
            var overrideConfirmDialog = PopupUtils.open(Qt.resolvedUrl("../components/OverrideConfirmDialog.qml"), filesPage, {
                                                            files: filesToOverride
                                                        });
            overrideConfirmDialog.complete.connect(function(ignoredFiles) {
                console.log("ignored files " + ignoredFiles);
                for (var i in ignoredFiles) {
                    for (var j in localFilesPath) {
                        if (ignoredFiles[i] === localFilesPath[j]) {
                            localFilesPath.splice(j, 1);
                            break;
                        }
                    }
                }
                if (localFilesPath.length > 0) {
                    uploadFilesInCurrentDirectory2(localFilesPath);
                }
            });
        } else {
            uploadFilesInCurrentDirectory2(localFilesPath);
        }
    }
    function uploadFilesInCurrentDirectory2(localFilesPath) {
        var files = localFilesPath;
        var uploadProgressDialog = PopupUtils.open(Qt.resolvedUrl("../components/ProgressDialog.qml"), filesPage, {
                                                     isDownloading: false
                                                   });
        for (var i in files) {
            var sourcePath = files[i].replace("file://", "");
            uploadProgressDialog.currentFileName = Utils.getFileNameFromPath(sourcePath);
            UploadFile.upload(sourcePath,
                mainView.fileMetaInfo.path + "/" + Utils.getFileNameFromPath(sourcePath));
        }
        uploadProgressDialog.close();
        refreshTimer.start();
    }
    Action {
        id: cancelAction
        text: i18n.tr("Cancel")
        iconName: "close"
        onTriggered: {
            if (filesPage.state == "import")
                mainView.cancelImport();
            else if (filesPage.state == "export") {
                dirView.selectedCount = 0;
                mainView.cancelExport();
            }
        }
    }

    Action {
        id: infoAction
        enabled: dirView.selectedCount == 1
        iconName: "info"
        text: i18n.tr("Property")
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: mainView.fileMetaInfo.contents[dirView.selectedIndexes[0]]})
            dirView.reset()
        }
    }
    Action {
        id: deleteAction
        iconName: "delete"
        text: i18n.tr("Delete")
        enabled: dirView.selectedCount >= 1 && mainView.isOnline
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
    }
    Action {
        id: openAction
        iconName: "external-link"
        text: i18n.tr("Open")
        enabled: dirView.selectedCount >= 1 && dirView.folderSelectedCount == 0
        onTriggered: {
            var files = [];
            for (var i in dirView.selectedIndexes) {
                files.push (mainView.fileMetaInfo.contents[dirView.selectedIndexes[i]]);
            }
            var filesNeedToDownload = [];
            for (var i in files) {
                console.log(JSON.stringify(files[i]));
                if (DownloadFile.fileExists(files[i].path) &&
                        DownloadFile.getModify(files[i].path) > DownloadFile.getDateTimeUTC(files[i].modified, "ddd, dd MMM yyyy hh:mm:ss +0000")
                        ) {
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
    }
    Action {
        id: confirmImportAction
        text: i18n.tr("Confirm")
        iconName: "tick"
        onTriggered: {
            var transferItems = mainView.contentTransfer.items;
            uploadFilesInCurrentDirectory(Utils.transferItems2UrlStrings(transferItems));
            mainView.importingFiles = false;
            mainView.contentTransfer = undefined;
        }
    }
    Action {
       id: upAction
       text: i18n.tr("Up")
       iconName: "back"
       enabled: mainView.fileMetaInfo.path !== "/"
       onTriggered: {
           mainView.listDir(Utils.getParentPath(mainView.fileMetaInfo.path))
           dirView.reset()
       }
   }
    Action {
        id: createFolderAction
        enabled: mainView.isOnline
        iconSource: Qt.resolvedUrl("../graphics/new-folder.svg")
        text: i18n.tr("Create Folder")
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
        text: i18n.tr("Upload")
        iconName: "note-new"
        enabled: mainView.isOnline
        onTriggered: {
            var contentDialog = PopupUtils.open(Qt.resolvedUrl("../components/ContentPickerDialog.qml"),
                           filesPage,
                           {
                               isUpload: true
                           });
            contentDialog.transferCompleteForUpload.connect(filesPage.uploadFilesInCurrentDirectory);
        }
    }
    Action {
        id: editAction
        text: i18n.tr("Edit")
        iconName: "edit"
        enabled: mainView.isOnline
        onTriggered: {
            filesPage.editMode = true;
        }
    }
    Action {
        id: refreshAction
        text: i18n.tr("Refresh")
        iconName: "reload"
        enabled: mainView.isOnline
        onTriggered: mainView.refreshDir();
    }
    Action {
        id: listGridViewAction
        property bool listView: dirView.format == "list"
        text: listView ? i18n.tr("Grid View") : i18n.tr("List View")
        iconName: dirView.format == "list" ? "view-grid-symbolic" : "view-list-symbolic"
        onTriggered: {
            dirView.format = (listView ? "grid" : "list");
            settings.lastViewType = dirView.format;
            settings.save();
        }
    }
    Action {
        id: settingAction
        text: i18n.tr("Settings")
        iconName: "settings"
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
        }
    }
    Action {
        id: aboutAction
        text: i18n.tr("About")
        iconSource: "image://theme/help"
        onTriggered: {
            pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
        }
    }
    DirView {
        id: dirView
        selectMode: filesPage.state == "export" ? 1 : (filesPage.state == "import" ? 2 : 0)
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: statusBar.top

        }

        model: mainView.fileMetaInfo.contents
        onSelectedCountChanged: {
            filesPage.editMode = selectedCount > 0;
        }
    }
    ListItem.ThinDivider {
        width: parent.width
        anchors.bottom: statusBar.top
    }

    ListItem.Standard {
        id: statusBar
        width: parent.width
        anchors.bottom: openDialogSelectBar.top
        height: filesPage.state == "edit" ? units.gu(4) : 0
        text: i18n.tr("Edit mode: ") + dirView.selectedCount + i18n.tr(" files selected")
        clip: true
        showDivider: false;
    }

    ListItem.Empty {
        id: openDialogSelectBar
        height: (filesPage.state == "export" || filesPage.state == "import") ? units.gu(6) : 0;
        width: parent.width;
        anchors.bottom: parent.bottom
        showDivider: false;
        Rectangle {
            anchors.fill: parent
            color: UbuntuColors.darkGrey
        }
        Row {
            height: selectButton.height
            anchors.centerIn: parent
            spacing: units.gu(8)
            Button {
                id: selectButton
                text: i18n.tr("Select")
                visible: filesPage.state == "export";
                enabled: openAction.enabled
                onClicked: openAction.trigger();
            }
            Button {
                id: uploadButton
                text: i18n.tr("Upload")
                visible: filesPage.state == "import";
                onClicked: confirmImportAction.trigger();
            }
            Button {
                text: i18n.tr("Cancel")
                onClicked: cancelAction.trigger();
            }
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

    Timer {
        id: refreshTimer
        interval: 1000
        repeat: false
        onTriggered: {
            mainView.refreshDir();
        }
    }
}
