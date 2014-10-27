import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: "Settings"

    Column {
        width: parent.width

        ListItem.Header {
            text: "User Info"
        }
        ListItem.Standard {
            text: "Name"
            control: Label {
                id: nameLabel
                text: mainView.accountInfo.display_name
            }
        }
        ListItem.Standard {
            text: "Email"
            control: Label {
                text: mainView.accountInfo.email
            }
        }
        ListItem.Standard {
            text: "Quota"
            control: Label {
                text: Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.normal)
                      + " / " + Utils.getReadableFileSizeString(mainView.accountInfo.quota_info.quota)
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
    }
}
