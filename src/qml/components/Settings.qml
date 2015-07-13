import QtQuick 2.2
import U1db 1.0 as U1db
Item {
    property string token: ""
    property string tokenSecret: ""
    property string lastViewType: "grid" // grid or list
    signal loadFinished();
    U1db.Database {
        id: aDatabase
        path: "aU1DbDatabase"
    }

    U1db.Document {
        id: aDocument
        database: aDatabase
        docId: 'settings'
        create: true
    }
    function load() {
        var settingsDoc = aDocument.contents;
        if (settingsDoc !== undefined){
            console.log (JSON.stringify(settingsDoc));
            if (settingsDoc.hasOwnProperty("token")) {
                token = settingsDoc.token;
                console.log ("load token " + "xxxxxxx");
            }
            if (settingsDoc.hasOwnProperty("tokenSecret")) {
                tokenSecret = settingsDoc.tokenSecret;
                console.log ("load tokenSecret " + "xxxxxxx");
            }
            if (settingsDoc.hasOwnProperty("lastViewType")) {
                lastViewType = settingsDoc.lastViewType;
                console.log ("load lastViewType " + lastViewType);
            }
        }
        loadFinished();
    }
    function save() {
        var settingsDoc = aDocument.contents;
        if (typeof settingsDoc == "undefined")
            settingsDoc = {};
        settingsDoc["token"] = token;
        settingsDoc["tokenSecret"] = tokenSecret;
        settingsDoc["lastViewType"] = lastViewType;
        aDocument.contents = settingsDoc;
    }
    function logout() {
        token = ""
        tokenSecret = ""
        save();
    }

    Component.onCompleted: {
        settings.load()
    }
}
