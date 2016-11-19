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

    title: i18n.tr("Override ") + Utils.getFileNameFromPath(files[currentIndex]) + i18n.tr(" ? ") + i18n.tr("( ") + (files.length - currentIndex) + i18n.tr(" left )")

    function goNextQuitIfComplete() {
        currentIndex ++;
        if (currentIndex >= files.length) {
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }

    Button {
        text: i18n.tr("Ignore")
        onTriggered: {
            ignoredFiles.push(files[currentIndex]);
            goNextQuitIfComplete();
        }
    }
    Button {
        text: i18n.tr("Ignore All")
        onTriggered: {
            for (var i = currentIndex; i < files.length; i++) {
                ignoredFiles.push(files[i]);
            }
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }
    Button {
        text: i18n.tr("Override")
        onTriggered: {
           goNextQuitIfComplete();
        }
    }
    Button {
        text: i18n.tr("Override All")
        onTriggered: {
            dialog.complete(ignoredFiles);
            PopupUtils.close(dialog);
        }
    }
}
