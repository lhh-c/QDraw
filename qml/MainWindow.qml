import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "."

ApplicationWindow {
    id: root
    title: "画板应用程序"
    width: 800
    height: 810
    visible: true
    color: "#f0f0f0"

    // 使用DockLayout替代RowLayout确保不重叠
    Item {
        anchors.fill: parent

        // 左侧工具栏固定宽度
        ToolPanel {
            id: toolPanel
            width: 180  // 固定宽度
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        // 右侧画布自适应剩余空间
        Canvas {
            id: canvas
            anchors {
                left: toolPanel.right  // 紧贴工具栏右侧
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            currentColor: toolPanel.selectedColor
            currentTool: toolPanel.selectedTool
            lineWidth: toolPanel.lineWidth
        }
    }

    // 状态栏
    footer: Rectangle {
        height: 30
        color: "#e0e0e0"
        border.color: "#a0a0a0"
        border.width: 1

        Label {
            anchors.fill: parent
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            text: "画板应用程序 | 当前工具: " +
                  toolPanel.selectedToolName +
                  " | 线宽: " + toolPanel.lineWidth
        }
    }
}
