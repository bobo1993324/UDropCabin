import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    property var file
    property bool isDownloading: false;
    title: file.path
    Column {
        width: parent.width
        ListItem.Standard {
            text: "Size"
            control: Label {
                text: file.size
            }
        }
        ListItem.Standard {
            text: "Modified"
            control: Label {
                text: file.modified
            }
        }
        ListItem.Standard {
            control: Row {
                height: downloadButton.height
                spacing: units.gu(2)
                Button {
                    id: downloadButton
                    text: "Download"
                    visible: !isDownloading
                    onClicked: {
                        downloadProgressBar.value = 0;
                        isDownloading = true;
                        Utils.downloadFile(file.path, settings.accessToken, saveFile, reportProgress);
                    }
                }
                ProgressBar {
                    id: downloadProgressBar
                    visible: isDownloading
                    minimumValue: 0
                    maximumValue: file.bytes
                }
            }
        }
    }
    function saveFile(fileContent) {
        fileModel.saveFile(file.path, fileContent);
        console.log("TODO openFile");
        isDownloading = false;
    }
    function reportProgress(sizeDownloaded) {
        downloadProgressBar.value = sizeDownloaded;
    }
}
