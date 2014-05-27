import QtQuick 2.0
import Ubuntu.Components 0.1
Page {
    title: "Files"
    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: "Settings"
                onTriggered: {
                    pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
                }
            }
        }
    }
}
