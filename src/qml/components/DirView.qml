import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/Utils.js" as Utils

Item {
    id: root
    property int selectMode: 0 //0: multiple, 1: single, 2:none
    property string format: "grid" // list or grid
    property var selectedIndexes: {[]}
    property int selectedCount: 0;
    property var model;

    clip: true
    function reset() {
        selectedIndexes = [];
        selectedCount = 0;
    }
    Loader {
        id: viewLoader
        sourceComponent: root.format == "list" ? dirListComponent : dirGridComponent
        anchors.fill: parent
    }

    //TODO refactor dirGridComponent and dirListComponent
    Component {
        id: dirGridComponent
        GridView {
            id: dirGridView
            anchors.fill: parent
            model: root.model
            cellHeight: units.gu(14)
            cellWidth: cellHeight
            delegate: Item {
                id: fileGridItem
                property bool selected
                width: dirGridView.cellHeight
                height: width
                Column {
                    id: contentColumn
                    anchors.centerIn: parent
                    Icon {
                        width: units.gu(6);
                        height: width
                        source: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        text: Utils.getFileNameFromPath(modelData.path)
                        width: units.gu(12);
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (modelData.is_dir && !filesPage.editMode) {
                            mainView.listDir(modelData.path);
                            root.reset();
                            return;
                        }
                        if (selectMode != 2) {
                            if (!selected) {
                                root.selectedIndexes.push(index)
                                selected = true;
                                root.selectedCount ++;
                            } else {
                                for (var i in root.selectedIndexes) {
                                    if (root.selectedIndexes[i] === index) {
                                        root.selectedIndexes.splice(i, 1);
                                        root.selectedCount --;
                                        break;
                                    }
                                }
                                selected = false;
                            }
                        }
                    }
                }
                Connections {
                    target: root
                    onSelectedCountChanged: {
                        if (root.selectedCount == 0) fileGridItem.selected = false;
                    }
                }

                UbuntuShape {
                    visible: selected
                    anchors.fill: parent
                    anchors.margins: units.gu(1)
                    color: "#1382DE";
                    z: -1
                }
            }
        }
    }

    Component {
        id: dirListComponent
        ListView {
            anchors.fill: parent
            model: root.model
            Component.onCompleted: console.log("ListView loaded")
            delegate: ListItem.Standard {
                id: fileListItem
                property bool selected;
                text: Utils.getFileNameFromPath(modelData.path)

                iconSource: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + modelData.icon + "48.gif")
                iconFrame: false
                Component.onCompleted: selected = root.selectedIndexes.indexOf(index) > -1
                onClicked: {
                    if (modelData.is_dir && !filesPage.editMode) {
                        mainView.listDir(modelData.path);
                        root.reset();
                        return;
                    }

                    if (selectMode != 2) {
                        if (!selected) {
                            root.selectedIndexes.push(index)
                            selected = true;
                            root.selectedCount ++;
                        } else {
                            for (var i in root.selectedIndexes) {
                                if (root.selectedIndexes[i] === index) {
                                    root.selectedIndexes.splice(i, 1);
                                    root.selectedCount --;
                                    break;
                                }
                            }
                            selected = false;
                        }
                    }
                }

                Rectangle {
                    visible: selected
                    anchors.fill: parent
                    color: "#1382DE";
                    z: -1
                }

                Connections {
                    target: root
                    onSelectedCountChanged: {
                        if (root.selectedCount == 0) fileListItem.selected = false;
                    }
                }
            }
        }
    }
}
