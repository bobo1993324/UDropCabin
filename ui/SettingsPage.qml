import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "../js/Utils.js" as Utils
Page {
    title: "Settings"
    Item {
        id: userInfo
        property string displayName: ""
        property int quota_normal: 0
        property int quota_quota: 0
    }

    Column {
        width: parent.width
        ListItem.Standard {
            text: "Login"
            visible: false
        }

        ListItem.Header {
            text: "User Info"
        }
        ListItem.Standard {
            text: "Name"
            control: Label {
                id: nameLabel
                text: userInfo.displayName
            }
        }
        ListItem.Standard {
            text: "Quota"
            control: Label {
                text: userInfo.quota_normal + " / " + userInfo.quota_quota
            }
        }
    }
    function setUserInfo(value) {
        userInfo.displayName = value.display_name;
        userInfo.quota_normal = value.quota_info.normal;
        userInfo.quota_quota = value.quota_info.quota;
    }

    Component.onCompleted: {
        if (settings.accessToken !== "") {
            Utils.getUserInfo(settings.accessToken, setUserInfo);
        }
    }
}
