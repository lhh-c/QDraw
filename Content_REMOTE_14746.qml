import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: content
    anchors.fill: parent

    property int rotationAngle: 0
    property alias dialogs: _dialogs
    property alias mycanvas: _canvasContainer
    property alias canvas: _mycanvas
    property alias bufferCanvas: _bufferCanvas

    Rectangle {
        id: canvasBackground
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height
        color: "black"
        z: -1
    }

    // 旋转后的实际内容区域容器
    Item {
        id: _canvasContainer
        width: 960
        height:960
        anchors.top: parent.top
        anchors.left: parent.left


        Flickable {
            id: flickable
            anchors.fill: parent
            contentWidth: _mycanvas.width
            contentHeight: _mycanvas.height

            // 结合放缩，滚动条待完善
            // ScrollBar.horizontal: ScrollBar {
            //     id: hbar
            //     policy: flickable.contentWidth > flickable.width ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            // }

            // ScrollBar.vertical: ScrollBar {
            //     id: vbar
            //     policy: flickable.contentHeight > flickable.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
            // }


            Canvas {
                id: _mycanvas
                width: _canvasContainer.width
                height: _canvasContainer.height
                // 旋转变换
                transform: Rotation {
                    origin.x: _mycanvas.width / 2
                    origin.y: _mycanvas.height / 2
                    angle: content.rotationAngle
                }

                property bool isDrawing: false
                property var lastPoint: Qt.point(0, 0)  // 上一个绘制点坐标
                property point currentPoint: Qt.point(0, 0) // 当前绘制点坐标
                property real penWidth: 3

                // 离屏缓冲画布
                Canvas {
                    id: _bufferCanvas
                    visible: false  // 不可见
                    anchors.fill: parent
                    renderTarget: Canvas.FramebufferObject
                }

                Rectangle {
                    anchors.fill: parent
                    color: "lightgray"
                    z: -1
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.drawImage(_bufferCanvas, 0, 0)

                    if (isDrawing) {
                        ctx.lineWidth = penWidth
                        ctx.lineCap = "round"
                        ctx.strokeStyle = "black"

                        ctx.beginPath()
                        ctx.moveTo(lastPoint.x, lastPoint.y)

                        var cpx = (lastPoint.x + currentPoint.x) / 2
                        var cpy = (lastPoint.y + currentPoint.y) / 2

                        ctx.quadraticCurveTo(cpx, cpy, currentPoint.x, currentPoint.y)
                        ctx.stroke()
                    }
                }

                // 鼠标区域
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton


                    onPressed: {
                        _mycanvas.isDrawing = true
                        _mycanvas.lastPoint = Qt.point(mouseX, mouseY)
                        _mycanvas.currentPoint = Qt.point(mouseX, mouseY)
                        _mycanvas.requestPaint()
                    }

                    onPositionChanged: {
                        if (_mycanvas.isDrawing) {
                            _mycanvas.lastPoint = _mycanvas.currentPoint
                            _mycanvas.currentPoint = Qt.point(mouseX, mouseY)
                            _mycanvas.requestPaint()
                        }
                    }

                    // 鼠标释放事件
                    onReleased: {
                        _mycanvas.isDrawing = false
                        var bufferCtx = _bufferCanvas.getContext("2d")
                        bufferCtx.drawImage(_mycanvas, 0, 0)
                    }
                }
            }
        }

        // 旋转函数
        function rotateCanvas(angle) {
            var newAngle = rotationAngle + angle
            if (newAngle < 0) newAngle += 360

            var bufferCtx = _bufferCanvas.getContext("2d")
            bufferCtx.drawImage(_mycanvas, 0, 0)

            rotationAngle = newAngle

            Qt.callLater(() => {
                _mycanvas.width = _canvasContainer.width
                _mycanvas.height = _canvasContainer.height
                flickable.contentWidth = _mycanvas.width
                flickable.contentHeight = _mycanvas.height
                _mycanvas.requestPaint()
            })
        }
    }


    // 全屏切换时的处理
    Connections {
        target: window
        function onVisibilityChanged() {
            if (window.visibility === Window.FullScreen) {
                _mycanvas.requestPaint();
            }
        }
    }

    // 对话框组件
    Dialogs {
        id: _dialogs
        fileOpen.onRejected: {
            return;
        }

        // 文件打开对话框接受事件
        fileOpen {
            onAccepted: {
                // 这里可以添加文件打开后的处理逻辑
                // let filePath = fileOpen.selectedFile;
                // content.player.video.source = filePath;
                // content.player.video.play()
            }
        }
    }
}
