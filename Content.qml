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
    property var pos: []
    function globalScreenToCanvas(x, y) {
            return drawarea.screenToCanvas(x, y);
        }
    //用于实现撤销
    property var undoStack: []
    property var redoStack: []
    property int maxUndoSteps: 20 // 最大撤销步数

    //视图控制属性
    property real scale: 1.0
    property point viewOffset: Qt.point(0, 0)
    property color penColor: "black"
    property real penWidth: 3

    //路径数据
    property var paths: []
    property var currentPath: ({
        "points": [],
        "width": penWidth,
        "color": Qt.rgba(penColor.r, penColor.g, penColor.b, penColor.a)
    })

    //黑色背景
    Rectangle {
        id: canvasBackground
        anchors.fill: parent
        color: "gray"
        z: -1
    }

    //画布容器
    Item {
        id: _canvasContainer
        width: 990
        height: 990
        anchors.top: parent.top
        anchors.left: parent.left

        // 可滚动区域
            Flickable {
                id: flickable
                anchors.fill: parent
                contentWidth: _mycanvas.width * content.scale  // 乘以缩放系数
                contentHeight: _mycanvas.height * content.scale
                clip: true
                interactive: content.scale > 1.0

                ScrollBar.horizontal: ScrollBar {
                    id: hbar
                    width: 12
                    visible: flickable.contentWidth > flickable.width // 内容超出时显示
                    height: 12
                    padding: 0

                    // 滚动条轨道样式
                    background: Rectangle {
                        implicitHeight: 10
                        color: "#40000000" // 半透明黑色
                        radius: 3
                    }

                    // 滚动条滑块样式
                    contentItem: Rectangle {
                        implicitHeight: 10
                        color: "#80000000"
                        radius: 3
                        opacity: hbar.hovered ? 0.9 : 0.6  // 悬停加深颜色
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

                // 现代风格垂直滚动条（与水平样式对称）
                ScrollBar.vertical: ScrollBar {
                    id: vbar
                    visible: flickable.contentHeight > flickable.height
                    height:12
                    width: 12
                    padding: 0

                    background: Rectangle {
                        implicitWidth: 10
                        color: "#40000000"
                        radius: 3
                    }

                    contentItem: Rectangle {
                        implicitWidth: 10
                        color: "#80000000"
                        radius: 3
                        opacity: vbar.hovered ? 0.9 : 0.6
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }

            Canvas {
                id: _mycanvas
                width: _canvasContainer.width
                height: _canvasContainer.height

                transform: [
                    Rotation {
                        origin.x: _mycanvas.width / 2
                        origin.y: _mycanvas.height / 2
                        angle: content.rotationAngle
                    },
                    Scale {
                        xScale: scale
                        yScale: scale
                        origin.x: viewOffset.x
                        origin.y: viewOffset.y
                    }
                ]

                property bool isDrawing: false
                property var lastPoint: Qt.point(0, 0)
                property point currentMousePos: Qt.point(0, 0)

                //离屏缓冲画布
                Canvas {
                    id: _bufferCanvas
                    visible: false
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
                    ctx.clearRect(0, 0, width, height)
                    ctx.drawImage(_bufferCanvas, 0, 0)

                    //应用缩放和平移
                    ctx.save()

                    //实时绘制当前笔迹
                    function drawPath(points, width, color) {
                        ctx.lineWidth = width//线条宽度，后续应该会在ui左侧添加显示的选择区域  //调整线宽用于适应缩放
                        ctx.lineCap = "round"//线端样式（butt、round、square），这和kolourpaint里面可选择的一样
                        ctx.lineJoin = "round"//转角样式（miter、round、bevel），还不知道是什么效果
                        ctx.strokeStyle = color

                        ctx.beginPath()
                        ctx.moveTo(points[0].x, points[0].y)
                        for (var i = 1; i < points.length; i++) {
                            ctx.lineTo(points[i].x, points[i].y)
                        }
                        ctx.stroke()
                    }

                    //绘制所有已完成路径
                    for (var i = 0; i < content.paths.length; i++) {
                        var path = content.paths[i]
                        drawPath(path.points, path.width, path.color)
                    }

                    //绘制当前路径
                    if (content.currentPath.points.length > 1) {
                        drawPath(content.currentPath.points, content.currentPath.width, content.currentPath.color)
                    }
                    ctx.restore()
                }
            }

            Item {
                id: drawarea
                anchors.fill: parent

                //屏幕坐标转换为画布坐标的函数
                function screenToCanvas(x, y) {
                //1.获取鼠标在画布上的原始坐标
                var canvasPos = _mycanvas.mapFromItem(drawarea, x, y);

                //2.转换为相对于旋转中心的坐标
                var centerX = _mycanvas.width / 2;
                var centerY = _mycanvas.height / 2;
                var point = Qt.point(canvasPos.x - centerX, canvasPos.y - centerY);

                //3.应用逆旋转（使用正角度）
                var rad = rotationAngle * Math.PI / 180;
                var cos = Math.cos(rad);
                var sin = Math.sin(rad);
                var x1 = point.x * cos + point.y * sin;
                var y1 = -point.x * sin + point.y * cos;

                //4.应用逆缩放
                x1 = x1 / scale;
                y1 = y1 / scale;

                //5.转换回绝对坐标
                return Qt.point(x1 + centerX, y1 + centerY);
            }

            property bool isDrawing: false

            //处理鼠标滚轮缩放
            WheelHandler {
                onWheel: function(event) {
                    var factor = event.angleDelta.y > 0 ? 1.1 : 0.9;
                    content.zoom(factor);
                    _mycanvas.requestPaint();
                }
            }

            //处理绘图操作
            DragHandler {
                acceptedButtons: Qt.LeftButton |Qt.RightButton

                onActiveChanged: {
                    if (active) {
                        drawarea.isDrawing = true;
                        content.pos = drawarea.screenToCanvas(centroid.position.x, centroid.position.y);
                        content.currentPath = {
                            "points": [pos],
                            "width": content.penWidth,
                            "color": Qt.rgba(content.penColor.r, content.penColor.g,
                            content.penColor.b, content.penColor.a)
                        };
                        _mycanvas.requestPaint();
                    }
                    else if (drawarea.isDrawing) {
                        if (content.currentPath.points.length >= 1) {
                            content.undoStack.push(JSON.parse(JSON.stringify(content.paths)));

                            content.paths.push({
                                "points": content.currentPath.points,
                                "width": content.currentPath.width,
                                "color": Qt.rgba(content.currentPath.color.r,content.currentPath.color.g,content.currentPath.color.b,content.currentPath.color.a)
                            });
                            if (content.undoStack.length > content.maxUndoSteps) {
                                content.undoStack.shift();
                            }
                            content.redoStack = [];

                            //重置当前路径
                            content.currentPath = {
                                "points": [],
                                "width": content.penWidth,
                                "color": Qt.rgba(content.penColor.r,content.penColor.g,content.penColor.b,content.penColor.a)
                            };

                            //更新缓冲画布
                            var bufferCtx = _bufferCanvas.getContext("2d");
                            bufferCtx.drawImage(_mycanvas, 0, 0);
                        }
                        drawarea.isDrawing = false;
                    }
                }

                onCentroidChanged: {
                    if (drawarea.isDrawing) {
                        //绘制过程中移动鼠标
                        var pos = drawarea.screenToCanvas(centroid.position.x, centroid.position.y);
                        content.currentPath.points.push(pos);
                        _mycanvas.requestPaint();
                    }
                }
            }
        }
    }
    function rotateCanvas(angle) {
        var newAngle = content.rotationAngle + angle
        if (newAngle < 0) newAngle += 360

        var bufferCtx = _bufferCanvas.getContext("2d")
        bufferCtx.drawImage(_mycanvas, 0, 0)

        content.rotationAngle = newAngle

        Qt.callLater(() => {
            _mycanvas.width = _canvasContainer.width
            _mycanvas.height = _canvasContainer.height
            flickable.contentWidth = _mycanvas.width
            flickable.contentHeight = _mycanvas.height
            _mycanvas.requestPaint()
        })
    }
}

    function zoom(factor) {
        scale = Math.max(0.1, Math.min(scale * factor, 10))

        _mycanvas.requestPaint()
    }

    Connections {
        target: window
        function onVisibilityChanged() {
            if (window.visibility === Window.FullScreen) {
                _mycanvas.requestPaint();
            }
        }
    }

    property url songUrl

    Connections {
            target: window
            function onVisibilityChanged() {
                if (window.visibility === Window.FullScreen) {
                    _mycanvas.requestPaint();
                }
            }
        }

    Dialogs {
        id: _dialogs
        fileOpen.onRejected: {
            return;
        }

        fileOpen {
            onAccepted: {
                let filePath = fileOpen.selectedFile;
                songUrl=filePath;
            }
        }
    }
}
