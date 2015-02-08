/*
 * Copied from webbrowser app
 * Copyright 2014 Canonical Ltd.
 *
 * This file is part of webbrowser-app.
 *
 * webbrowser-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * webbrowser-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups
import Ubuntu.Content 1.1
import "../js/Utils.js" as Utils

Popups.PopupBase  {
    id: picker
    property var activeTransfer
    property var selectedItems
    property bool isUpload: false
    property var exportFilesPath;

    signal transferCompleteForUpload(var files);//files in [String]

    ContentTransferHint {
        anchors.fill: parent
        activeTransfer: picker.activeTransfer
    }

    ContentPeerPicker {
        id: peerPicker
        anchors.fill: parent
        visible: true
        contentType: ContentType.All
        handler: picker.isUpload ? ContentHandler.Source : ContentHandler.Destination
        headerText: picker.isUpload ? "Upload from" : "Open with"
        onPeerSelected: {
            if (!picker.isUpload) {
                peer.selectionType = ContentTransfer.Single
            } else {
                peer.selectionType = ContentTransfer.Multiple
            }
            picker.activeTransfer = peer.request()
            stateChangeConnection.target = picker.activeTransfer
        }
        onCancelPressed: {
            picker.close();
        }
    }

    Connections {
        id: stateChangeConnection
        onStateChanged: {
            console.log("Transfer state is " + picker.activeTransfer.state + " " + ContentTransfer.InProgress)
            if (!picker.isUpload && picker.activeTransfer.state === ContentTransfer.InProgress) {
                var contentItems = [];
                for (var i in picker.exportFilesPath) {
                    contentItems.push(transferComponent.createObject(mainView, {"url": picker.exportFilesPath[i]}))
                }

                picker.activeTransfer.items = contentItems;
                picker.activeTransfer.state = ContentTransfer.Charged;
                closeTimer.start()
            } else if (picker.isUpload && picker.activeTransfer.state === ContentTransfer.Charged) {
                closeTimer.start();
                picker.transferCompleteForUpload(Utils.transferItems2UrlStrings(picker.activeTransfer.items));
            }
        }
    }
    Timer {
        id: closeTimer
        interval: 1000
        repeat: false
        onTriggered: {
            picker.close();
        }
    }
    function close() {
        PopupUtils.close(picker);
    }
}
