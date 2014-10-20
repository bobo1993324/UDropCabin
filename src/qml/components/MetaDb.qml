import QtQuick 2.2
import U1db 1.0 as U1db

Item {
    U1db.Database {
        id: aDatabase
        path: "metaDB"
    }

    U1db.Document {
        id: aDocument
        database: aDatabase
        docId: 'settings'
        create: true
    }

    function get(path) {
        if (aDocument.contents == undefined) {
            aDocument.contents = {};
        }
        return aDocument.contents[path]
    }

    function set(path, value) {
        console.log("set " + path);
        var tmp = aDocument.contents;
        if (tmp == undefined) {
            tmp = {};
        }
        tmp[path] = value;
        aDocument.contents = tmp;
    }
    function clear() {
        aDocument.contents = {};
    }
}
