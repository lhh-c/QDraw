import QtQuick
import QtQuick.Dialogs
Item {
    id: root

        // 颜色选择对话框
        ColorDialog {
            id: colorDialog
            title: "选择画笔颜色"
            onAccepted: {
                // 当用户选择颜色后，可以通过Controller设置颜色
                Controller.setPenColor(selectedColor)
            }
        }

        // 暴露打开对话框的方法
        function openColorDialog() {
            colorDialog.open()
        }
}
