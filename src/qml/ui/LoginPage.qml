import QtQuick 2.0
import Ubuntu.Components 0.1
import QtWebKit 3.0
import "../js/Utils.js" as Utils
Page {
    id: loginPage
    title: "Login"
    property alias url: webView.url
    signal accessGranted()
    WebView {
        id: webView
        anchors.fill: parent
//        url: "https://www.dropbox.com/1/oauth2/authorize?response_type=token&client_id=o28bortadg3cjbt&redirect_uri=http://localhost"
        onUrlChanged: {
            console.log(url);
            if (url.toString().indexOf("authorize_submit") >= 0) {
                accessGranted();
            }

//            console.log(JSON.stringify(Utils.queryTokenUrl(url.toString())));
//            var returnVal = Utils.queryTokenUrl(url.toString());
//            if (returnVal.hasOwnProperty("access_token")) {
//                settings.accessToken = returnVal.access_token;
//                console.log("setAccessToken to " + settings.accessToken)
//                pageStack.pop();
//            }
        }
    }
	flickable: webView
}
