import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: "UDropCabin"
    head {
        backAction: Action {
            text: "Up"
            iconSource: "image://theme/keyboard-caps"
            enabled: mainView.fileMetaInfo.path !== "/"
            onTriggered: {
                console.log(mainView.fileMetaInfo.path !== "/")
                mainView.listDir(Utils.getParentPath(mainView.fileMetaInfo.path))
            }
        }
        actions: [
            Action {
                text: "Settings"
                iconSource: "image://theme/navigation-menu"
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
        anchors.fill: parent
        model: mainView.fileMetaInfo.contents

        delegate: ListItem.Standard {
            text: Utils.getFileNameFromPath(modelData.path)
            progression: modelData.is_dir
            onClicked: {
                if (modelData.is_dir) {
                    mainView.listDir(modelData.path);
                }
                else
                    pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: modelData})

            }
            iconSource: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
            iconFrame: false
        }
    }

    ActivityIndicator {
        id: ai
        anchors.centerIn: parent
        visible: running
        running: mainView.busy
    }
}
