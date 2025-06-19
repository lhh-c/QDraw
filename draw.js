function func() {

}
var currentPenColor = "black" // 默认颜色

function openColorDialog() {
    content.dialogs.colorDialog.open()
}

function setPenColor(color) {
    currentPenColor = color
    console.log("画笔颜色已设置为:", color)
}

// fullscreen实现
var windowRef = null;

function registerWindow(window) {
    windowRef = window;
    console.log("窗口引用已注册");
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

// 暴露函数给QML
Qt.include({

    currentPenColor: currentPenColor,
    setPenColor: setPenColor
})


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
