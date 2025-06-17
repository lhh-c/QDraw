import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "constants.js" as Constants
import "."

Rectangle {
    id: toolPanel
    color: "#e0e0e0"
    border.color: "#a0a0a0"
    border.width: 1

    property color selectedColor: Constants.Defaults.COLOR
    property int selectedTool: Constants.Tools.PENCIL
    property string selectedToolName: "铅笔"
    property int lineWidth: Constants.Defaults.LINE_WIDTH

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        GroupBox {
            title: "绘图工具"
            Layout.fillWidth: true

            GridLayout {
                columns: 2
                rowSpacing: 10
                columnSpacing: 10
                width: parent.width

                ToolButton {
                    //icon.source: ""
                    icon.color: selectedTool === Constants.Tools.PENCIL ? "blue" : "black"
                    onClicked: {
                        selectedTool = Constants.Tools.PENCIL
                        selectedToolName = "铅笔"
                    }
                }
                Label { text: "铅笔" }

                ToolButton {
                    //icon.source: ""
                    icon.color: selectedTool === Constants.Tools.LINE ? "blue" : "black"
                    onClicked: {
                        selectedTool = Constants.Tools.LINE
                        selectedToolName = "直线"
                    }
                }
                Label { text: "直线" }

                ToolButton {
                    //icon.source: ""
                    icon.color: selectedTool === Constants.Tools.RECTANGLE ? "blue" : "black"
                    onClicked: {
                        selectedTool = Constants.Tools.RECTANGLE
                        selectedToolName = "矩形"
                    }
                }
                Label { text: "矩形" }

                ToolButton {
                    //icon.source:""
                    icon.color: selectedTool === Constants.Tools.CIRCLE ? "blue" : "black"
                    onClicked: {
                        selectedTool = Constants.Tools.CIRCLE
                        selectedToolName = "圆形"
                    }
                }
                Label { text: "圆形" }

                ToolButton {
                    // icon.source:""
                    icon.color: selectedTool === Constants.Tools.ERASER ? "blue" : "black"
                    onClicked: {
                        selectedTool = Constants.Tools.ERASER
                        selectedToolName = "橡皮擦"
                    }
                }
                Label { text: "橡皮擦" }
            }
        }

        ColorPicker {
            id: colorPicker
            Layout.fillWidth: true
            onColorSelected: {
                selectedColor = color
            }
        }

        GroupBox {
            title: "线宽"
            Layout.fillWidth: true

            //确保GroupBox内容区域填充
            Layout.preferredWidth: parent.width  // 继承父项宽度

            ColumnLayout {
                anchors.fill: parent  //填充GroupBox内容区
                spacing: 5  // 适当间距

                Slider {
                    id: widthSlider
                    from: 1
                    to: 20
                    value: lineWidth
                    onValueChanged: lineWidth = value

                    //设置Slider宽度
                    Layout.fillWidth: true  // 填充ColumnLayout宽度
                    Layout.leftMargin: 5   // 左边距
                    Layout.rightMargin: 5  // 右边距
                }

                Label {
                    text: "当前: " + lineWidth + "px"
                    horizontalAlignment: Text.AlignHCenter

                    // 关键修改4：标签宽度设置
                    Layout.fillWidth: true  // 与Slider同宽
                    Layout.topMargin: -5   // 上移减少间距
                }
            }
        }

        GroupBox {
            title: "操作"
            Layout.fillWidth: true

            GridLayout {
                columns: 1
                rowSpacing: 10
                columnSpacing: 10

                Button {
                    text: "撤销"
                    Layout.fillWidth: true
                }
                Button {
                    text: "重做"
                    Layout.fillWidth: true
                }
                Button {
                    text: "清空画布"
                    Layout.columnSpan: 1
                    Layout.fillWidth: true
                }
            }
        }

        GroupBox {
            title: "文件"
            Layout.fillWidth: true

            GridLayout {
                columns: 1
                rowSpacing: 10
                columnSpacing: 10

                Button {
                    text: "保存"
                    Layout.fillWidth: true
                }
                Button {
                    text: "加载"
                    Layout.fillWidth: true
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
