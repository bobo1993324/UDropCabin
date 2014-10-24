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

Popups.PopupBase  {
    id: picker
    property var activeTransfer
    property var selectedItems
    property bool isUpload: false
    property string exportFilePath;

    signal transferCompleteForUpload(var files);

    Rectangle {
        anchors.fill: parent

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
    }

    Connections {
        id: stateChangeConnection
        onStateChanged: {
            console.log("Transfer state is " + picker.activeTransfer.state + " " + ContentTransfer.InProgress)
            if (!picker.isUpload && picker.activeTransfer.state === ContentTransfer.InProgress) {
                picker.activeTransfer.items = [transferComponent.createObject(mainView, {"url": picker.exportFilePath}) ]
                picker.activeTransfer.state = ContentTransfer.Charged;
                closeTimer.start()
            } else if (picker.isUpload && picker.activeTransfer.state === ContentTransfer.Charged) {
                picker.transferCompleteForUpload(picker.activeTransfer.items);
                closeTimer.start();
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
    property color originalTextColor;
    Component.onCompleted: {
        originalTextColor = Theme.palette.selected.backgroundText;
        Theme.palette.selected.backgroundText  = "black";
    }
    function close() {
        Theme.palette.selected.backgroundText = originalTextColor;
        PopupUtils.close(picker);
    }
}
