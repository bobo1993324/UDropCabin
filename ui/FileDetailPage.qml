import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    property var file
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
            control: Button {
                text: "Open"
                onClicked: {
                    Utils.downloadFile(file.path, settings.accessToken, openFile);
                }
            }
        }
    }
    function openFile(file) {
        console.log("TODO openFile");
        console.log(file);
    }
}
