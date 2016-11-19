import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: i18n.tr("Settings")
    Column {
        width: parent.width

        ListItem.Header {
            text: i18n.tr("User Info")
        }
        ListItem.Standard {
            text: i18n.tr("Name")
            control: Label {
                id: nameLabel
                text: mainView.accountInfo.display_name ? mainView.accountInfo.display_name : i18n.tr("Not Available")
            }
        }
        ListItem.Standard {
            text: i18n.tr("Email")
            control: Label {
                text: mainView.accountInfo.email ? mainView.accountInfo.email : i18n.tr("Not Available")
            }
        }
        ListItem.Standard {
            text: i18n.tr("Quota")
            control: Label {
                text: mainView.accountInfo.quota_info ? Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.normal)
                      + " / " + Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.quota) : i18n.tr("Not Available")
            }
        }
        ListItem.SingleControl {
            control: Button {
                text: i18n.tr("Logout")
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
            text: i18n.tr("Local cache")
        }
        ListItem.Standard {
            text: i18n.tr("Local cache size")
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
                text: i18n.tr("Clear local cache")
                onClicked: {
                    DownloadFile.clear();
                    clearCacheControl.height = 0;
                    cacheSizeLabel.text = "0";
                }
            }
            showDivider: height > 0
        }
    }
}
