import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/Utils.js" as Utils

Popups.Dialog {
    id: dialog

    property var files;
    property int currentIndex;
    property var ignoredFiles: {[]}

    signal complete(var ignoredFiles);

    title: "Override " + Utils.getFileNameFromPath(files[currentIndex]) + " ? " + "( " + (files.length - currentIndex) + " left )"

    function goNextQuitIfComplete() {
        currentIndex ++;
        if (currentIndex >= files.length) {
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }

    Button {
        text: "Ignore"
        onTriggered: {
            ignoredFiles.push(files[currentIndex]);
            goNextQuitIfComplete();
        }
    }
    Button {
        text: "Ignore All"
        onTriggered: {
            for (var i = currentIndex; i < files.length; i++) {
                ignoredFiles.push(files[i]);
            }
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }
    Button {
        text: "Override"
        onTriggered: {
           goNextQuitIfComplete();
        }
    }
    Button {
        text: "Override All"
        onTriggered: {
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }
}
