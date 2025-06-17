import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs
Item {
    id: root
        property alias fileOpen: _fileOpen
        property alias about: _about
        property alias colorDialog: _colorDialog
    FileDialog {
        id: _fileOpen
        title: "Select some draw files"
        currentFolder: StandardPaths.standardLocations
                       (StandardPaths.DocumentsLocation)[0]
        fileMode: FileDialog.OpenFiles
        nameFilters: ["draw files (*.bmp *.jpg *.jpeg *.tiff *.gif)"]
    }

    MessageDialog{
        id:_about
        modality: Qt.WindowModal
        buttons:MessageDialog.Ok
        text:"qml-app"
        informativeText: qsTr("qml-app is a free software")
        // detailedText: "Copyright©2025 Wei Gong (open-src@qq.com)"
    }

        // 颜色选择对话框
        ColorDialog {
            id: _colorDialog
            title: "选择画笔颜色"
            onAccepted: {
                // 当用户选择颜色后，可以通过Controller设置颜色
                Controller.setPenColor(selectedColor)
            }
        }


}
