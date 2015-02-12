import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 1.0
import "../js/Utils.js" as Utils
import "../components"
Page {
    title: "Settings"
    Flickable {
        id: listView
        height: parent.height
        width: parent.width
        contentWidth: parent.width
        contentHeight: column.height
        clip: true
        Column {
            id: column
            width: mainView.width

            ListItem.Header {
                text: "User Info"
            }
            ListItem.Standard {
                text: "Name"
                control: Label {
                    id: nameLabel
                    text: mainView.accountInfo.display_name ? mainView.accountInfo.display_name : "Not Available"
                }
            }
            ListItem.Standard {
                text: "Email"
                control: Label {
                    text: mainView.accountInfo.email ? mainView.accountInfo.email : "Not Available"
                }
            }
            ListItem.Standard {
                text: "Quota"
                control: Label {
                    text: mainView.accountInfo.quota_info ? Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.normal)
                          + " / " + Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.quota) : "Not Available"
                }
            }
            ListItem.SingleControl {
                control: Button {
                    text: "Logout"
                    onClicked: {
                        settings.logout();
                        QDropbox.token = "";
                        QDropbox.tokenSecret = "";
                        DownloadFile.clear();
                        metaDb.clear();
                        pageStack.pop();
                        settings.loadFinished();
                    }
                }
            }
            ListItem.Header {
                text: "Automatic photo upload"
                Icon {
                    name: "help"
                    anchors.right: parent.right
                }
            }
            ListItem.Expandable {
                expanded: uploadSwitch.checked
                collapseOnClick: false
                collapsedHeight: units.gu(6)
                expandedHeight: units.gu(12)
                __contentsMargins: 0
                Column {
                    width: parent.width
                    ListItem.Standard {
                        text: "Enable"
                        control: Switch {
                            id: uploadSwitch
                            checked: settings.photoUploadEnabled
                            onCheckedChanged: {
                                settings.photoUploadEnabled = checked
                                settings.save();
                            }
                        }
                    }
                    ListItem.Standard {
                        text: (settings.dropboxPhotoUploadPath.length > 0 ? "Directory: " :
                                                                            "<font color='red'>Directory: </font>"
                                                                           )+ settings.dropboxPhotoUploadPath
                        control: Button {
                            text: settings.dropboxPhotoUploadPath.length > 0 ? "Change" : "Set"
                            onClicked: {
                                mainView.listDir("/")
                                mainView.editingPhotoUploadPath = true;
                                PopupUtils.open(folderChooserDialogComponent);
                            }
                        }
                    }
                }
            }
            ListItem.Header {
                text: "Local cache"
            }
            ListItem.Standard {
                text: "Local cache size"
                control: Label {
                    id: cacheSizeLabel
                    text: Utils.getReadableFileSizeString(DownloadFile.localCacheSize());
                }
            }
            ListItem.SingleControl {
                id: clearCacheControl
                height: DownloadFile.localCacheSize() > 0 ? units.gu(6) : 0
                Behavior on height { UbuntuNumberAnimation { } }
                control: Button {
                    text: "Clear local cache"
                    onClicked: {
                        DownloadFile.clear();
                        clearCacheControl.height = 0;
                        cacheSizeLabel.text = "0";
                    }
                }
                showDivider: height > 0
            }
        }
        Component {
            id: folderChooserDialogComponent
            Dialog {
                id: folderChooserDialog
                title: "Set upload directory"
                Column {
                    DirView {
                        width: parent.width
                        height: Math.min (mainView.height - units.gu(20), units.gu(30))
                        model: mainView.fileMetaInfo.contents
                        format: "list"
                        dirOnly: true

                        ActivityIndicator {
                            anchors.centerIn: parent
                            visible: running
                            running: mainView.busy
                        }
                    }

                    ListItem.Standard {
                        text: mainView.fileMetaInfo.path
                        showDivider: false
                    }
                    ListItem.Standard {
                        Row {
                            height: parent.height
                            anchors.centerIn: parent
                            spacing: units.gu(1)
                            Button {
                                text: "Up"
                                enabled: mainView.fileMetaInfo.path != "/"
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    mainView.listDir(Utils.getParentPath(mainView.fileMetaInfo.path))
                                }
                            }
                            Button {
                                text: "OK"
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    mainView.editingPhotoUploadPath = false
                                    settings.dropboxPhotoUploadPath = mainView.fileMetaInfo.path;
                                    PopupUtils.close(folderChooserDialog)
                                }
                            }
                            Button {
                                text: "Cancel"
                                anchors.verticalCenter: parent.verticalCenter
                                onClicked: {
                                    mainView.editingPhotoUploadPath = false
                                    PopupUtils.close(folderChooserDialog)
                                }
                            }
                        }
                        showDivider: false
                    }
                }
            }
        }
    }
}
