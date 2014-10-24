import QtQuick 2.2
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups

Popups.Dialog {
    id: dialog
    property bool isDownloading: false; //otherwise it is uploading
    property string currentFileName
    property var _targetBackendModel: isDownloading ? DownloadFile : UploadFile
    title: isDownloading ? "Downloading" : "Uploading"
    text: currentFileName
    ProgressBar {
        indeterminate: _targetBackendModel.progress < 0
        minimumValue: 0
        maximumValue: 1
        value: _targetBackendModel.progress
    }
    function close() {
        PopupUtils.close(dialog);
    }
}
