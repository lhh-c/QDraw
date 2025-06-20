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

//笔号实现
function openPenSizeDialog() {
    content.dialogs.penSizeDialog.open()
}

function setPenSize(size) {
    content.penWidth = size
}

// 全屏实现
var windowRef = null;

function registerWindow(window) {
    windowRef = window;
}

function toggleFullscreen() {
    if (!windowRef) {
        console.error("未获取到窗口引用");
        return;
    }

    if (windowRef.visibility === ApplicationWindow.FullScreen) {
        windowRef.visibility = ApplicationWindow.Windowed;
        console.log("退出全屏");
    } else {
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

// 撤销实现
function undo() {
    if (content.undoStack.length > 0) {
        // 当前状态存入重做栈
        content.redoStack.push(JSON.parse(JSON.stringify(content.paths)))

        // 恢复上一个状态
        content.paths = JSON.parse(JSON.stringify(content.undoStack.pop()))

        // 重绘画布
        var bufferCtx = content.bufferCanvas.getContext("2d")
        bufferCtx.clearRect(0, 0, content.canvas.width, content.canvas.height)
        content.canvas.requestPaint()
    }
}

// 重做实现
function redo() {
    if (content.redoStack.length > 0) {
        // 当前状态存入撤销栈
        content.undoStack.push(JSON.parse(JSON.stringify(content.paths)))

        // 恢复重做状态
        content.paths = JSON.parse(JSON.stringify(content.redoStack.pop()))

        // 重绘画布
        var bufferCtx = content.bufferCanvas.getContext("2d")
        bufferCtx.clearRect(0, 0, content.canvas.width, content.canvas.height)
        content.canvas.requestPaint()
    }
}
// function zoomin(){
//     content.mycanvas.zoom(1.25)
// }

// function zoomout(){
//     content.mycanvas.zoom(0.75)
// }

