import QtQuick 2.2
import U1db 1.0 as U1db
Item {
    property string token: ""
    property string tokenSecret: ""
    property bool photoUploadEnabled: true
    property string dropboxPhotoUploadPath: ""
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
        if (settingsDoc == undefined) {
            settingsDoc = { };
        }

        //check integrity
        var writeBack = false;
        if (settingsDoc.token == undefined) {
            settingsDoc.token = "";
            writeBack = true;
        }
        if (settingsDoc.tokenSecret == undefined) {
            settingsDoc.tokenSecret = "";
            writeBack = true;
        }
        if (settingsDoc.photoUploadEnabled == undefined) {
            settingsDoc.photoUploadEnabled = false;
            writeBack = true;
        }
        if (settingsDoc.dropboxPhotoUploadPath == undefined) {
            settingsDoc.dropboxPhotoUploadPath = "";
            writeBack = true;
        }
        if (writeBack) {
            aDocument.contents = settingsDoc;
        }

        if (settingsDoc !== undefined){
            token = settingsDoc.token;
            tokenSecret = settingsDoc.tokenSecret;
            photoUploadEnabled = settingsDoc.photoUploadEnabled
            dropboxPhotoUploadPath = settingsDoc.dropboxPhotoUploadPath
            console.log (JSON.stringify(settingsDoc));
        }
        loadFinished();
    }
    function save() {
        var settingsDoc = aDocument.contents;
        if (typeof settingsDoc == "undefined")
            settingsDoc = {};
        settingsDoc["token"] = token;
        settingsDoc["tokenSecret"] = tokenSecret;
        settingsDoc["photoUploadEnabled"] = photoUploadEnabled;
        settingsDoc["dropboxPhotoUploadPath"] = dropboxPhotoUploadPath;
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
