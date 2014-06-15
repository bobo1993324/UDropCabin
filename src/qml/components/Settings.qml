import QtQuick 2.0
import U1db 1.0 as U1db
Item {
    property string token: ""
    property string tokenSecret: ""
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
                console.log ("load token " + token);
            }
            if (settingsDoc.hasOwnProperty("tokenSecret")) {
                tokenSecret = settingsDoc.tokenSecret;
                console.log ("load tokenSecret " + tokenSecret);
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
        aDocument.contents = settingsDoc;
    }

    Component.onCompleted: {
        settings.load()
    }
}
