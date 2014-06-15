import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: mainView.fileMetaInfo.path
//    ListModel {
//        id: fileModel
//        property string currentPath: "/"
//        onCurrentPathChanged: fileModel.loadDir(currentPath);
//        function loadDir(currentPath) {
//            if (settings.accessToken !== "") {
//                Utils.getFileList(fileModel.currentPath, settings.accessToken, fileModel.setFileModel);
//            }
//        }
//        function setFileModel(value) {
//            fileModel.clear();
//            var tmp = value.contents;
//            for (var i in tmp) {
//                fileModel.append(tmp[i]);
//            }
//        }
//    }
    ListView {
        id: dirView
        anchors.fill: parent
        visible: mainView.fileMetaInfo.is_dir
        model: mainView.fileMetaInfo.contents
        delegate: ListItem.Standard {
            text: modelData.path
            progression: modelData.is_dir
            onClicked: {
                if (modelData.is_dir)
                    QDropbox.requestMetadata("/dropbox"+ modelData.path);
                else
                    pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: modelData})
            }
        }
    }

    tools: ToolbarItems {
        back: ToolbarButton {
            visible: mainView.fileMetaInfo.path !== "/"
            action: Action {
                text: "Up"
                onTriggered: {
                    QDropbox.requestMetadata("/dropbox/" + Utils.getParentPath(mainView.fileMetaInfo.path))
                }
            }
        }

        ToolbarButton {
            action: Action {
                text: "Settings"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
        }
    }
}
