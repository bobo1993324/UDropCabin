import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Web 0.2
import "../js/Utils.js" as Utils
Page {
    id: loginPage
    title: "Login"
    property alias url: webView.url
    WebView {
        id: webView
        width: parent.width
        height: parent.height
        onUrlChanged: {
            console.log(url);
            if (url.toString().indexOf("authorize_submit") >= 0) {
                mainView.accessGranted();
            }
        }
    }
}
