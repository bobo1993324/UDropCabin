import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItems
Page {
    title: "About"
    Column {
        width: Math.min(parent.width - units.gu(2) * 2, units.gu(50))
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(1)
        ListItems.ThinDivider {}
        Image {
            height: units.gu(15)
            width: height
            source: "../graphics/logo.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: "UDropCabin"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            width: parent.width
            wrapMode: Text.Wrap
            text: "This is an UNOFFICIAL dropbox app. You can list files, open them in other apps.\n\nThanks to QtDropbox(http://lycis.github.io/QtDropbox/) which provides api the app calls.\n\nAuthor: Boren Zhang <bobo1993324@gmail.com>\n\nSource code & report issue @ https://github.com/bobo1993324/UDropCabin\n\n Icons came from the open source Silk Icon set by Mark James, available at http://www.famfamfam.com/lab/icons/silk/."
        }
    }
}
