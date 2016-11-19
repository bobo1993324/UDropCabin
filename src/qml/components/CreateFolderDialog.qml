import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups
import Ubuntu.Components.ListItems 1.0 as ListItem

Popups.Dialog {
    id: dialog

    signal createFolder(var folderName)

    title: i18n.tr("Create Folder")
    TextField {
        id: folderNameTextField
        width: parent.width
    }

    Button {
        text: i18n.tr("Confirm")
        enabled: folderNameTextField.text.length > 0
        onTriggered: {
            dialog.createFolder(folderNameTextField.text);
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
