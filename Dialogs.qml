import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
Item {
    id: root
    property alias fileOpen: _fileOpen
    property alias about: _about
    property alias colorDialog: _colorDialog
    property alias penSizeDialog: _penSizeDialog
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

        // 笔号设置对话框
        Dialog {
                id: _penSizeDialog
                title: "设置笔号"
                standardButtons: Dialog.Ok | Dialog.Cancel

                ColumnLayout {
                    spacing: 10
                    anchors.fill: parent

                    ComboBox {
                        id: penSizeCombo
                        model: ["细笔", "中笔", "粗笔"]
                        Layout.fillWidth: true
                    }

                    Label {
                        text: "当前选择: " + penSizeCombo.currentText
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                }
            }

}
