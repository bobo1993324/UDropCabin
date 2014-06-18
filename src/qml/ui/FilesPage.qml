import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: "UDropCabin"
    ListView {
        id: dirView
        anchors.fill: parent
        visible: mainView.fileMetaInfo.is_dir
        model: mainView.fileMetaInfo.contents
        header: ListItem.Header {
            text: mainView.fileMetaInfo.path
        }

        delegate: ListItem.Standard {
            text: Utils.getFileNameFromPath(modelData.path)
            progression: modelData.is_dir
            onClicked: {
                if (modelData.is_dir)
                    QDropbox.requestMetadata("/dropbox"+ modelData.path);
                else
                    pageStack.push(Qt.resolvedUrl("./FileDetailPage.qml"), {file: modelData})

            }
            iconSource: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
        }
    }

    ActivityIndicator {
        id: ai
        anchors.centerIn: parent
        visible: running
        running: mainView.busy
    }

    tools: ToolbarItems {
        back: ToolbarButton {
            visible: mainView.fileMetaInfo.path !== "/"
            action: Action {
                text: "Up"
                iconSource: "image://theme/keyboard-caps"
                onTriggered: {
                    console.log(mainView.fileMetaInfo.path !== "/")
                    QDropbox.requestMetadata("/dropbox/" + Utils.getParentPath(mainView.fileMetaInfo.path))
                }
            }
        }

        ToolbarButton {
            action: Action {
                text: "Settings"
                iconSource: "image://theme/navigation-menu"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
        }

        ToolbarButton {
            action: Action {
                text: "About"
                iconSource: "image://theme/help"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                }
            }
        }
    }
}
