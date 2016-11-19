import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Content 0.1
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
import "../components"
Page {
    id: fileDetailPage
    title: i18n.tr("Property")
    property var file
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width, units.gu(50))
        ListItem.Base {
            height: units.gu(14)
            Image {
                id: img
                height: units.gu(8)
                width: height
                source: Qt.resolvedUrl("../graphics/dropbox-api-icons/48x48/" + file.icon + "48.gif")
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: units.gu(2)
                }
            }
            Label {
                anchors {
                    top: img.bottom
                    horizontalCenter: parent.horizontalCenter
                }
                text: file.path
            }
        }
        ListItem.Standard {
            text: i18n.tr("Size")
            control: Label {
                text: file.size
            }
        }
        ListItem.Standard {
            text: i18n.tr("Modified")
            control: Label {
                text: Qt.formatDateTime(DownloadFile.getDateTimeUTC(file.modified, "ddd, dd MMM yyyy hh:mm:ss +0000"), "MMMM d yyyy hh:mm:ss")
            }
        }
        ListItem.Standard {
            text: i18n.tr("Mime-type")
            control: Label {
                text: file.mime_type
            }
        }
    }
}
