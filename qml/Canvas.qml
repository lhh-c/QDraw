import QtQuick
import QtQuick.Controls

Rectangle {
    id: canvas
    color: "white"
    border.color: "gray"
    border.width: 1

    // 画布属性
    property color currentColor: "black"
    property int currentTool: 0 // 默认为铅笔
    property int lineWidth: 2

    // 用于存储绘图数据 (后续将用C++实现)
    property var drawingData: []

    // 鼠标区域 - 处理绘图交互
    MouseArea {
        id: drawingArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // 鼠标按下事件
        onPressed: {
            // 这里将处理绘图开始逻辑
            console.log("开始绘图:", currentTool, "颜色:", currentColor, "线宽:", lineWidth)
        }

        // 鼠标移动事件
        onPositionChanged: {
            // 这里将处理绘图过程中的逻辑
        }

        // 鼠标释放事件
        onReleased: {
            // 这里将处理绘图结束逻辑
        }
    }

    // 绘图逻辑 (后续将用C++实现)
    Canvas {
        id: drawCanvas
        anchors.fill: parent
        contextType: "2d"

        onPaint: {
            // 这里将实现实际的绘图逻辑
        }
    }

    // 清空画布
    function clear() {
        // 这里将实现清空画布的逻辑
        drawCanvas.requestPaint()
    }
}
