import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import "draw.js" as Controller

Item {
    id: root
    property alias fileOpen: _fileOpen
    property alias about: _about
    property alias colorDialog: _colorDialog
    property alias fileSave: _fileSave
    property alias failToSave: _failToSave
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

    // 笔号选择对话框
    Dialog {
        id: _penSizeDialog
        title: "选择笔号大小"
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        property int selectedSize: 3 // 默认值 (1-5范围)

        ColumnLayout {
            anchors.fill: parent
            spacing: 15

            // 滑块控件
            Slider {
                id: penSizeSlider
                from: 1
                to: 10
                stepSize: 1
                value: _penSizeDialog.selectedSize
                snapMode: Slider.SnapAlways

                Layout.fillWidth: true

                onMoved: {
                    _penSizeDialog.selectedSize = value
                    sizeDisplay.text = "当前大小: " + value + "px"
                }
            }

            // 显示当前笔号大小
            Label {
                id: sizeDisplay
                text: "当前大小: " + _penSizeDialog.selectedSize + "px"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            Controller.setPenSize(selectedSize)
        }
    }

    FileDialog {
        id: _fileSave
        title: "Give a file name"
        modality: Qt.ApplicationModal
        currentFolder: StandardPaths.writableLocation
                       (StandardPaths.DocumentsLocation)
        fileMode: FileDialog.SaveFile
        nameFilters: [ "Audio files (*.mp3 *.wav *.ogg)" ]
    }

    MessageDialog{
        id:_failToSave
        modality: Qt.WindowModal
        buttons:MessageDialog.Ok
        text:"Fail to save the file!"
    }


}
