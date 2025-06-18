import QtQuick
import "draw.js" as Controller

Item {
    id:content
    anchors.fill: parent
    property alias dialogs: _dialogs
    property alias mycanvas: _mycanvas
    // property bool isDrawing: false
    // property point lastPoint: Qt.point(0, 0)

    // Canvas {
    //     id: canvas
    //     anchors.fill: parent
    //     z:1
    //     // renderTarget: Canvas.Image//使用位图缓冲，提升性能，没看懂


    //     // opacity: 0.8  // 半透明以便观察
    //     //     Rectangle {  // 仅用于调试画布是否正常加载
    //     //         anchors.fill: parent
    //     //         color: "lightgray"
    //     //         border.color: "red"
    //     //         border.width: 2
    //     //     }

    //     //每次触发 requestPaint() 会重新执行 onPaint
    //     onPaint: {
    //         var ctx = getContext("2d")
    //         if (!ctx) {
    //                     console.error("Failed to get 2D context");
    //                     return;
    //                 }
    //         ctx.lineWidth = 2
    //         ctx.strokeStyle = Controller.currentPenColor//动态颜色
    //         ctx.lineCap = "round"//圆角线头
    //         ctx.beginPath()
    //         //从上一个点到当前鼠标位置画线
    //         ctx.moveTo(lastPoint.x, lastPoint.y)//起点
    //         ctx.lineTo(mouseArea.mouseX, mouseArea.mouseY)//终点
    //         ctx.stroke()//执行绘制
    //     }

    //     // onPaint: {
    //     //         console.log("onPaint triggered");  // 调试输出
    //     //         var ctx = getContext("2d");
    //     //         ctx.fillStyle = "blue";
    //     //         ctx.fillRect(10, 10, 100, 100);  // 绘制一个蓝色矩形
    //     //     }

    //     //     Component.onCompleted: {
    //     //         requestPaint();  // 主动触发首次绘制
    //     //     }
    // }

    // MouseArea {
    //     id: mouseArea
    //     anchors.fill: parent
    //     acceptedButtons: Qt.LeftButton

    //     onPressed: (mouse) => {
    //         content.isDrawing = true
    //         content.lastPoint = Qt.point(mouse.x, mouse.y)
    //         canvas.requestPaint()
    //     }

    //     onPositionChanged: (mouse) => {
    //         if (content.isDrawing) {
    //             canvas.requestPaint()
    //             content.lastPoint = Qt.point(mouse.x, mouse.y)
    //         }
    //     }

    //     onReleased: {
    //         content.isDrawing = false
    //     }
    // }

    Canvas{
        id:_mycanvas
        anchors.fill: parent

        property bool isDrawing: false
        property var lastPoint: Qt.point(0, 0)
        property point currentPoint: Qt.point(0, 0)  // 新增当前点属性
        // property color penColor: "black"
        property real penWidth: 3
        property real scaleFactor: 1.0

        Rectangle {
            anchors.fill: parent
            color: "lightgray"
            z: -1
        }

        // 使用transform实现视觉缩放
        transform: Scale {
            id: canvasScale
            origin.x: 0
            origin.y: 0
            xScale: _mycanvas.scaleFactor
            yScale: _mycanvas.scaleFactor
        }


        onPaint: {
            var ctx = getContext("2d")
            ctx.save()//保存当前状态，不然下次缩放的时候缩放的效果会叠加

            if (isDrawing) {
            // 设置绘图样式
            ctx.lineWidth = penWidth/scaleFactor//线条宽度，后续应该会在ui左侧添加显示的选择区域  //调整线宽用于适应缩放
            ctx.lineCap = "round"//线端样式（butt、round、square），这和kolourpaint里面可选择的一样
            ctx.lineJoin = "round"//转角样式（miter、round、bevel），还不知道是什么效果
            ctx.strokeStyle = Controller.currentPenColor

            // 开始绘制路径
            ctx.beginPath()
            ctx.moveTo(lastPoint.x, lastPoint.y)
            ctx.lineTo(currentPoint.x, currentPoint.y)
            ctx.stroke()
            }

            ctx.restore()//恢复状态
        }

        function zoom(factor) {
            var newScale = scaleFactor * factor
            // 限制缩放范围
            if (newScale > 0.1 && newScale < 10) {
                scaleFactor = newScale
                console.log("当前缩放比例:", scaleFactor)
                requestPaint()
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton

            onPressed:(mouse)=>{
                _mycanvas.isDrawing = true
                _mycanvas.lastPoint = Qt.point(mouseX * _mycanvas.scaleFactor, mouseY * _mycanvas.scaleFactor)
                _mycanvas.currentPoint = Qt.point(mouseX * _mycanvas.scaleFactor, mouseY * _mycanvas.scaleFactor)  // 初始化当前点
                _mycanvas.requestPaint()
            }

            onPositionChanged: (mouse)=>{
                if (_mycanvas.isDrawing) {
                   _mycanvas.lastPoint = _mycanvas.currentPoint  // 更新上一个点为当前点
                   _mycanvas.currentPoint = Qt.point(mouseX, mouseY)  // 更新当前点
                   _mycanvas.requestPaint()
                }
            }

            onReleased: {
                _mycanvas.isDrawing =false
            }
        }
    }

    // ColorDialog{

    // }

    //可用的版本
    // Canvas {
    //     id: _mycanvas
    //     anchors.fill: parent

    //     property bool isDrawing: false
    //     property point lastPoint: Qt.point(0, 0)
    //     property point currentPoint: Qt.point(0, 0)
    //     property real penWidth: 3
    //     property real scaleFactor: 1.0

    //     // 使用transform实现视觉缩放
    //     transform: Scale {
    //         id: canvasScale
    //         origin.x: 0
    //         origin.y: 0
    //         xScale: _mycanvas.scaleFactor
    //         yScale: _mycanvas.scaleFactor
    //     }

    //     Rectangle {
    //         anchors.fill: parent
    //         color: "lightgray"
    //         z: -1
    //     }

    //     onPaint: {
    //         var ctx = getContext("2d")
    //         ctx.save()

    //         //不再使用ctx.scale()，transform已经处理了视觉缩放
    //         if (isDrawing) {
    //             ctx.lineWidth = penWidth
    //             ctx.lineCap = "round"
    //             ctx.lineJoin = "round"
    //             ctx.strokeStyle = Controller.currentPenColor

    //             ctx.beginPath()
    //             ctx.moveTo(lastPoint.x, lastPoint.y)
    //             ctx.lineTo(currentPoint.x, currentPoint.y)
    //             ctx.stroke()
    //         }

    //         ctx.restore()
    //     }

    //     function zoom(factor) {
    //         var newScale = scaleFactor * factor
    //         // 限制缩放范围
    //         if (newScale > 0.1 && newScale < 10) {
    //             scaleFactor = newScale
    //             console.log("当前缩放比例:", scaleFactor)
    //             requestPaint()
    //         }
    //     }

    //     MouseArea {
    //         id: mouseArea
    //         anchors.fill: parent
    //         acceptedButtons: Qt.LeftButton

    //         onPressed: (mouse) => {
    //             _mycanvas.isDrawing = true
    //             // 坐标需要除以缩放因子
    //             _mycanvas.lastPoint = Qt.point(mouse.x / _mycanvas.scaleFactor, mouse.y / _mycanvas.scaleFactor)
    //             _mycanvas.currentPoint = _mycanvas.lastPoint
    //             _mycanvas.requestPaint()
    //         }

    //         onPositionChanged: (mouse) => {
    //             if (_mycanvas.isDrawing) {
    //                 _mycanvas.lastPoint = _mycanvas.currentPoint
    //                 _mycanvas.currentPoint = Qt.point(mouse.x / _mycanvas.scaleFactor, mouse.y / _mycanvas.scaleFactor)
    //                 _mycanvas.requestPaint()
    //             }
    //         }

    //         onReleased: {
    //             _mycanvas.isDrawing = false
    //         }
    //     }
    // }


    Dialogs{
        id:_dialogs
        fileOpen.onRejected: {
            return;
        }
        // fileOpen is a group property
        fileOpen{
            onAccepted: {
               //  let filePath = fileOpen.selectedFile;
               // content.player.video.source = filePath; //触发player加载视频文件，然后读取元数据
               //  // videoMetaData.videoUrl=filePath; //添加视频文件路径到元数据对象中
               //  console.log("视频 path: ",filePath)
               //  content.player.video.play()
            }
        }
    }
}
