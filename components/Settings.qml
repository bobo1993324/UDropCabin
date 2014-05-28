import QtQuick 2.0
import U1db 1.0 as U1db
Item {
    property string accessToken: ""
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
            if (settingsDoc.hasOwnProperty("accessToken")) {
                accessToken = settingsDoc.accessToken;
                console.log ("load accessToken " + accessToken);
            }
        }
    }
    function save() {
        var settingsDoc = aDocument.contents;
        if (typeof settingsDoc == "undefined")
            settingsDoc = {};
        console.log (JSON.stringify(settingsDoc) + " " + accessToken)
        settingsDoc["accessToken"] = accessToken;
        aDocument.contents = settingsDoc;
    }
}
