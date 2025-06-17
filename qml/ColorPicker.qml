import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform 1.1 as Platform

GroupBox {
    id: colorPicker
    title: "颜色选择"

    property color currentColor: "#000000"
    signal colorSelected(color color)

    GridLayout {
        columns: 5
        rowSpacing: 5
        columnSpacing: 5

        Repeater {
            model: [
                "#000000", "#ffffff", "#ff0000", "#00ff00", "#0000ff",
                "#ffff00", "#00ffff", "#ff00ff", "#c0c0c0", "#808080",
                "#800000", "#808000", "#008000", "#800080", "#008080", "#000080"
            ]

            Rectangle {
                width: 25
                height: 25
                color: modelData
                border.color: currentColor === modelData ? "blue" : "#a0a0a0"
                border.width: currentColor === modelData ? 2 : 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currentColor = modelData
                        colorSelected(modelData)
                    }
                }
            }
        }

        Rectangle {
            Layout.columnSpan: 5
            Layout.fillWidth: true
            height: 40
            color: currentColor
            border.color: "#a0a0a0"
            border.width: 1

            Label {
                anchors.centerIn: parent
                text: "点击选择更多颜色"
                color: Qt.rgba(1 - currentColor.r, 1 - currentColor.g, 1 - currentColor.b, 1)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog.open()
            }
        }
    }

    // 使用 Qt.labs.platform 的 ColorDialog
    Platform.ColorDialog {
        id: colorDialog
        title: "选择颜色"
        onAccepted: {
            currentColor = color
            colorSelected(color)
        }
    }
}
