import QtQuick
import "draw.js" as Controller

Item {
    id:content
    anchors.fill: parent
    property alias dialogs: _dialogs
    property alias canvas: _mycanvas
    // 视图控制
    property real scale: 1.0
    property point viewOffset: Qt.point(0, 0)

    property color penColor: "black"
    property real penWidth: 3
    //可见的Canvas,用于显示
    Canvas{
        id:_mycanvas
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "lightgray"
            z: -1
        }

        property bool isDrawing: false
        property var lastPoint: Qt.point(0, 0)
        property point currentMousePos: Qt.point(0, 0)
        // property color penColor: "black"
        // property real penWidth: 3

        transform: Scale {
            xScale: scale;
            yScale: scale;
            origin.x: viewOffset.x;
            origin.y: viewOffset.y
        }


        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // 应用缩放和平移
            ctx.save()


            // 实时绘制当前笔迹（预览）
            function drawPath(points,width,color) {
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
            // 绘制所有已完成路径
                for (var i = 0; i < paths.length; i++) {
                    var path = paths[i]
                    drawPath(path.points, path.width, path.color)
                }

                // 绘制当前路径（实时预览）
                if (currentPath.points.length > 1) {
                    drawPath(currentPath.points, currentPath.width, currentPath.color)
                }
                ctx.restore()
        }
    }
    property var paths: []
    property var currentPath: {
        "points": [],
        "width": penWidth,
        "color": Qt.rgba(penColor.r, penColor.g, penColor.b, penColor.a) // 关键！复制颜色值
    }
    // property real penWidth: 3
    // property color penColor: penColor



    // 鼠标处理
    MouseArea {
        id: mouseArea
        anchors.fill: parent

        function screenToCanvas(x, y) {
            console.log(x+" "+y)//可以得知这里的x,y是相对于画布的坐标
                // 直接转换为画布坐标（考虑缩放）
                return Qt.point(
                    x ,
                    y

                )
            }

        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true // 必须启用hover才能接收滚轮事件


        property bool isDrawing: false

        onWheel: function(wheel)  {
                    // 鼠标滚轮缩放（更直观）
                    var factor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
                    content.zoom(factor)
                    _mycanvas.requestPaint()
                }

        onPressed: (mouse) => {
            isDrawing = true
            var pos = screenToCanvas(mouse.x, mouse.y)
                currentPath = {
                    "points": [pos],
                    "width": penWidth,
                    "color":Qt.rgba(penColor.r, penColor.g, penColor.b, penColor.a) // 关键！复制颜色值
                }
            _mycanvas.requestPaint()
        }

        onPositionChanged: (mouse) => {
            if (isDrawing) {
                var pos = screenToCanvas(mouse.x, mouse.y)
                currentPath.points.push(pos)
                _mycanvas.requestPaint()
            }
        }

        onReleased: {
            if (isDrawing && currentPath.points.length > 1) {
                paths.push({
                            "points": currentPath.points,
                            "width": currentPath.width,
                            "color": Qt.rgba(currentPath.color.r, currentPath.color.g, currentPath.color.b, currentPath.color.a) // 安全复制
                        })
                        currentPath = {
                            "points": [],
                            "width": penWidth,
                            "color": Qt.rgba(penColor.r, penColor.g, penColor.b, penColor.a)
                        }
            }
            isDrawing = false
        }
        // function screenToCanvas(x, y) {
        //             return Qt.point(
        //                 x / scale,
        //                 y / scale
        //             )
        // }
    }

        // 缩放控制
    function zoom(factor) {
        var oldScale = scale
        scale = Math.max(0.1, Math.min(scale * factor, 10))

        _mycanvas.requestPaint()
    }



    Dialogs{
        id:_dialogs
        fileOpen.onRejected: {
            return;
        }
        // fileOpen is a group property
        fileOpen{
            onAccepted: {

            }
        }
    }
}
