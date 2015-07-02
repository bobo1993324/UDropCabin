import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.OnlineAccounts 0.1

Item {
    AccountServiceModel {
        id: accounts
        applicationId: "com.ubuntu.developer.bobo1993324.udropcabin"
    }

    Setup {
        id: setup
        applicationId: accounts.applicationId
        providerId: "com.ubuntu.developer.bobo1993324.udropcabin_dropbox-account-plugin"
    }

    ListView {
        anchors.fill: parent
        model: accounts
        delegate: Text { text: "Account: " + model.displayName }
    }

    Button {
        visible: accounts.count === 0
        text: "Authorize a Dropbox account"
        onClicked: setup.exec()
    }
}
