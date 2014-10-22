import QtQuick 2.2
import Ubuntu.Components 1.1
Item {
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
