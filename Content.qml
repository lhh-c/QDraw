import QtQuick
import "draw.js" as Controller

Item {
    id:content
    anchors.fill: parent
    property alias dialogs: _dialogs
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
        id:mycanvas
        anchors.fill: parent

        property bool isDrawing: false
        property var lastPoint: Qt.point(0, 0)
        property point currentPoint: Qt.point(0, 0)  // 新增当前点属性
        // property color penColor: "black"
        property real penWidth: 3

        Rectangle {
            anchors.fill: parent
            color: "lightgray"
            z: -1
        }

        onPaint: {
            var ctx = getContext("2d")
            if (isDrawing) {
            // 设置绘图样式
            ctx.lineWidth = penWidth//线条宽度，后续应该会在ui左侧添加显示的选择区域
            ctx.lineCap = "round"//线端样式（butt、round、square），这和kolourpaint里面可选择的一样
            ctx.lineJoin = "round"//转角样式（miter、round、bevel），还不知道是什么效果
            ctx.strokeStyle = Controller.currentPenColor

            // 开始绘制路径
            ctx.beginPath()
            ctx.moveTo(lastPoint.x, lastPoint.y)
            ctx.lineTo(currentPoint.x, currentPoint.y)
            ctx.stroke()
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            onPressed: {
                mycanvas.isDrawing = true
                mycanvas.lastPoint = Qt.point(mouseX, mouseY)
                mycanvas.currentPoint = Qt.point(mouseX, mouseY)  // 初始化当前点
                mycanvas.requestPaint()
            }

            onPositionChanged: {
                if (mycanvas.isDrawing) {
                   mycanvas.lastPoint = mycanvas.currentPoint  // 更新上一个点为当前点
                   mycanvas.currentPoint = Qt.point(mouseX, mouseY)  // 更新当前点
                   mycanvas.requestPaint()
                }
            }

            onReleased: {
                mycanvas.isDrawing =false
            }
        }
    }

    // ColorDialog{

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
