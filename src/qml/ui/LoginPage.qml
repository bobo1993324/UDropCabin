import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.OnlineAccounts 0.1
import Ubuntu.OnlineAccounts.Client 0.1
import "../js/Utils.js" as Utils
Page {
    id: loginPage
    title: "Login"
    property string url
    AccountServiceModel {
        id: accounts
        provider: "com.ubuntu.developer.bobo1993324.udropcabin_account-plugin"
    }

    Setup {
        id: setup
        applicationId: accounts.applicationId
        providerId: "com.ubuntu.developer.bobo1993324.udropcabin_account-plugin"
    }

    ListView {
        anchors.fill: parent
        model: accounts
        delegate: ListItem.Standard {
            id: stan
            text: "Account: " + model.displayName + " " + model.providerName
            onTriggered: accountService.authenticate()

            AccountService {
              id: accountService
              objectHandle: stan.model.accountServiceHandle
              onAuthenticated: { console.log("Access token is " + reply.AccessToken) }
              onAuthenticationError: { console.log("Authentication failed, code " + error.code) }
            }
        }
    }

    Button {
        visible: accounts.count === 0 /* remove this if your app supports
                                       multiple accounts */
        anchors.centerIn: parent
        text: "Authorize a Dropbox account"
        onClicked: setup.exec()
    }
}
