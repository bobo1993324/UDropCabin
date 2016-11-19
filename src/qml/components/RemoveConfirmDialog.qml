import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups
import Ubuntu.Components.ListItems 1.0 as ListItem
import "../js/Utils.js" as Utils
Popups.Dialog {
    id: dialog
    property var removeFilesPath

    signal confirmed

    title: i18n.tr("Delete %1 files").arg(removeFilesPath.length)
    ListView {
        id: listView
        width: parent.width
        height: Math.min(removeFilesPath.length, 5) * units.gu(4)
        model: removeFilesPath
        clip: true
        delegate: ListItem.Standard {
            height: units.gu(4)
            text: Utils.getFileNameFromPath(modelData)
            showDivider: false
        }
        Scrollbar {
            flickableItem: listView
        }
    }
    Button {
        text: i18n.tr"Confirm")
        onTriggered: {
            dialog.confirmed();
            PopupUtils.close(dialog);
        }
    }
    Button {
        text: i18n.tr("Cancel")
        onTriggered: {
            PopupUtils.close(dialog);
        }
    }
}
