import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: "Files"
    ListModel {
        id: fileModel
        property string currentPath: "/"
        onCurrentPathChanged: fileModel.loadDir(currentPath);
        function loadDir(currentPath) {
            if (settings.accessToken !== "") {
                Utils.getFileList(fileModel.currentPath, settings.accessToken, fileModel.setFileModel);
            } else {
                settings.load();
                console.log("needs to log in");
            }
        }
        function setFileModel(value) {
            fileModel.clear();
            var tmp = value.contents;
            for (var i in tmp) {
                fileModel.append(tmp[i]);
            }
        }
    }
    ListView {
        anchors.fill: parent
        model: fileModel
        header: ListItem.Header {
            text: fileModel.currentPath
        }

        delegate: ListItem.Standard {
            text: model.path
            onClicked: {
                if (model.is_dir) {
                    fileModel.currentPath = model.path
                }
            }
        }
    }

    tools: ToolbarItems {
        back: ToolbarButton {
            visible: fileModel.currentPath !== "/"
            action: Action {
                text: "Up"
                onTriggered: {
                    fileModel.currentPath = Utils.getParentPath(fileModel.currentPath)
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

    Component.onCompleted: {
        settings.load();
        if (settings.accessToken !== "") {
            Utils.getFileList(fileModel.currentPath, settings.accessToken, fileModel.setFileModel);
        } else {
            console.log("needs to log in");
        }
    }
}
