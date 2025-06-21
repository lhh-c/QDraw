function func() {

}

//笔色实现
function openColorDialog() {
    content.dialogs.colorDialog.open()
}

function setPenColor(color) {

    content.penColor = color
}

// 单例组件管理器
var WindowManager = {
    component: null,
    instances: [],

    initialize: function() {
        if (!this.component) {
            this.component = Qt.createComponent("Window.qml");
            if (this.component.status === Component.Error) {
                console.error("组件创建失败:", this.component.errorString());
            }
        }
    },

    createWindow: function(properties) {
        if (!this.component || this.component.status !== Component.Ready) {
            console.warn("组件未就绪，尝试初始化...");
            this.initialize();
            return null;
        }

        var win = this.component.createObject(null, properties);
        if (win) {
            this.instances.push(win);
            win.closing.connect(function() {
                WindowManager.removeWindow(win);
            });
        }
        return win;
    },

    removeWindow: function(win) {
        var index = this.instances.indexOf(win);
        if (index >= 0) {
            this.instances.splice(index, 1);
        }
    }
};

// 初始化组件
WindowManager.initialize();

// 对外接口
function createNewWindow() {
    return WindowManager.createWindow({
        isPrimaryWindow: false,
        width: 1280,
        height: 800,
        title: "绘图窗口 "
    });
}

// 注册窗口函数
function registerWindow(window) {
    windowInstances.push(window);
    window.closing.connect(function() {
        windowClosed(window);
    });

}

// 笔号实现
function openPenSizeDialog() {
    content.dialogs.penSizeDialog.open()
}

function setPenSize(size) {
    content.penWidth = size
}


var windowRef = null;

function registerWindow(window) {
    windowRef = window;
}

// 全屏实现
function toggleFullscreen() {
    if (!windowRef) {
        console.error("未获取到窗口引用");
        return;
    }

    if (windowRef.visibility === ApplicationWindow.FullScreen) {
        windowRef.visibility = ApplicationWindow.Windowed;
        console.log("退出全屏");
    } else {
        content.mycanvas.width = 1024
        content.mycanvas.height = 1024
        windowRef.visibility = ApplicationWindow.FullScreen;
        console.log("进入全屏");
    }
}


function open(){
    content.dialogs.fileOpen.open()
}

function rotateCanvas(angle) {
    if (content && content.mycanvas) {
        content.mycanvas.rotateCanvas(angle)
    } else {
        console.error("Canvas is unavailable.")
    }
}



function save(){
    content.dialogs.fileSave.open()
}

//存储复制的路径数据
var clipboardPaths = [];

//复制
function copy() {
    if (content.paths.length === 0) return;
    clipboardPaths = [content.paths[content.paths.length - 1]]; // 复制最后一条路径
}

//剪切
function cut() {
    copy();
    if (content.paths.length > 0) {
        content.paths.pop(); //删除最后一条路径,但是不知道为什么第一次的剪切是不能删除原路径的
        content.canvas.requestPaint(); //重绘画布
    }
}

//粘贴
function paste() {
    if (clipboardPaths.length === 0) return;

    //创建新路径,但是暂时还不能指定粘贴位置，只能实现在原有的线条上进行偏移以区别，证明复制成功
    var newPath = JSON.parse(JSON.stringify(clipboardPaths[0]));
    for (var i = 0; i < newPath.points.length; i++) {
        newPath.points[i].x += 20;
        newPath.points[i].y += 20;
    }

    content.paths.push(newPath);
    content.canvas.requestPaint();
}

//粘贴（可以指定粘贴位置），还是不可以
//本来是想通过content.qml里面已经有的函数实现对鼠标进行定位，把鼠标的位置作为参数传递给requestPaint的
// function paste(){
//     if (clipboardPaths.length === 0) {
//             console.log("cutboard is empty");
//             return;
//         }

//     // //获取鼠标当前的位置
//     // var mouseScreenPos = content.pos;
//     // console.log(content.pos)

//     // 获取鼠标位置（带默认值）
//     var mouseScreenPos = content.pos || { x: content.width/2, y: content.height/2 };
//     console.log("Raw mouse position:", mouseScreenPos.x, mouseScreenPos.y);

//     // //转换成画布的坐标
//     // var mouseCanvasPos = content.globalScreenToCanvas(mouseScreenPos.x,mouseScreenPos.y);
//     // console.log(mouseScreenPos)

//     // 坐标转换
//         try {
//             var mouseCanvasPos = content.globalScreenToCanvas(mouseScreenPos.x, mouseScreenPos.y);
//             console.log("Converted canvas position:", mouseCanvasPos.x, mouseCanvasPos.y);

//             // 剩余粘贴逻辑...
//         } catch (e) {
//             console.error("Conversion failed:", e);
//         }
//     //计算路径偏移量
//     var firstPoints = clipboardPaths[0][0];
//     var offsetX = mouseCanvasPos.x - firstPoints.x;//说是x未定义，前面没有复制成功
//     var offsetY = mouseCanvasPos.y - firstPoints.y;

//     //创建路经
//     var newPath = JSON.parse(JSON.stringify(clipboardPaths[0]))
//     for (var i = 0 ; i < newPath.points.length; i++){
//         newPath.points[i].x += offsetX;
//         newPath.points[i].y += offsetY;
//     }

//     //添加到画布并重画
//     content.paths.push(newPath);
//     content.canvas.requestPaint();

// 撤销实现
function undo() {
    if (content.undoStack.length > 0) {
        //当前状态存入重做栈
        content.redoStack.push(JSON.parse(JSON.stringify(content.paths)))
        //恢复上一个状态
        content.paths = JSON.parse(JSON.stringify(content.undoStack.pop()))
        //重绘画布
        var bufferCtx = content.bufferCanvas.getContext("2d")
        bufferCtx.clearRect(0, 0, content.canvas.width, content.canvas.height)
        content.canvas.requestPaint()
    }
}

// 重做实现
function redo() {
    if (content.redoStack.length > 0) {
        //当前状态存入撤销栈
        content.undoStack.push(JSON.parse(JSON.stringify(content.paths)))
        //恢复重做状态
        content.paths = JSON.parse(JSON.stringify(content.redoStack.pop()))
        //重绘画布
        var bufferCtx = content.bufferCanvas.getContext("2d")
        bufferCtx.clearRect(0, 0, content.canvas.width, content.canvas.height)
        content.canvas.requestPaint()
    }
}

// 删除所有
function deleteall() {
    if (!content || !content.paths) {
           console.error("Content or paths not available");
           return;
       }
       //保存当前状态到撤销栈
       content.undoStack.push(JSON.parse(JSON.stringify(content.paths)));
       if (content.undoStack.length > content.maxUndoSteps) {
           content.undoStack.shift();
       }
       content.paths = [];
       content.currentPath = {
           "points": [],
           "width": content.penWidth,
           "color": Qt.rgba(content.penColor.r, content.penColor.g, content.penColor.b, content.penColor.a)
       };
       content.redoStack = [];
       //清除缓冲画布
       var bufferCtx = content.bufferCanvas.getContext("2d");
       bufferCtx.clearRect(0, 0, content.canvas.width, content.canvas.height);
       //重绘主画布
       content.canvas.requestPaint();
}

// function zoomin(){
//     content.mycanvas.zoom(1.25)
// }






