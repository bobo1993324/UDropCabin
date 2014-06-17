import QtQuick 2.0
import Ubuntu.Components 0.1
import QtWebKit 3.0
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
