import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Content 0.1
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
import "../components"
Page {
    title: "Property"
    property var file
    property string systemPath: "file://" + PATH.homeDir() + "/.local/share/com.ubuntu.developer.bobo1993324.udropcabin/Documents/" + file.path
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
            text: "Size"
            control: Label {
                text: file.size
            }
        }
        ListItem.Standard {
            text: "Modified"
            control: Label {
                text: Qt.formatDateTime(DownloadFile.getDateTimeUTC(file.modified, "ddd, dd MMM yyyy hh:mm:ss +0000"), "MMMM d yyyy hh:mm:ss")
            }
        }
        ListItem.Standard {
            text: "Mime-type"
            control: Label {
                text: file.mime_type
            }
        }

        ListItem.Standard {
            visible: mainView.contentTransfer === undefined
            control: Row {
                id : downloadRow
                state: "notCached"
                spacing: units.gu(1)
                Component.onCompleted: {
                    if (DownloadFile.fileExists(file.path)) {
                        if (DownloadFile.getModify(file.path) > DownloadFile.getDateTimeUTC(file.modified, "ddd, dd MMM yyyy hh:mm:ss +0000"))
                            state = "cached"
                    }
                }

                Button {
                    id: downloadButton
                    visible: downloadRow.state == "notCached"
                    text: "Download"
                    onClicked: {
                        downloadRow.state = "downloading"
                        DownloadFile.download(file.path);
                    }
                }
                ActivityIndicator {
                    visible: downloadRow.state == "downloading"
                    running: visible
                }
                Button {
                    id: openButton
                    text: "Open"
                    visible: downloadRow.state == "cached"
                    onClicked: {
                        PopupUtils.open(contentPicker)
                    }
                }
                Label {
                    id: donwloadedLabel
                    text: "Downloaded"
                    visible: downloadRow.state == "cached"
                }
            }
        }
        ListItem.Standard {
            visible: mainView.contentTransfer !== undefined
            control: Row {
                Button {
                    text: "Open"
                    onClicked: {
                        if (downloadRow.state == "cached")
                            transferContent()
                        else {
                            downloadRow.state == "downloading"
                            DownloadFile.download(file.path)
                        }
                    }
                    ActivityIndicator {
                        visible: downloadRow.state == "downloading"
                        running: visible
                    }
                }
            }
        }
    }
    Connections {
        target: DownloadFile
        onDownloadFinished: {
            downloadRow.state = "cached"
            if (mainView.contentTransfer !== undefined) {
                transferContent();
            }
        }
    }
    function transferContent() {
        mainView.transferItemList = [transferComponent.createObject(mainView, {"url": systemPath}) ]
        mainView.contentTransfer.items = mainView.transferItemList;
        mainView.contentTransfer.state = ContentTransfer.Charged;
        Qt.quit()
    }
    ContentPickerDialog {
        id: contentPicker
    }
}
