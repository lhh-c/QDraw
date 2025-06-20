function func() {

}

//笔色实现
function openColorDialog() {
    content.dialogs.colorDialog.open()
}

function setPenColor(color) {

    content.penColor = color

}

//笔号实现
function openPenSizeDialog() {
    content.dialogs.penSizeDialog.open()
}

function setPenSize(size) {
    content.penWidth = size
}

// fullscreen实现
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

// function zoomin(){
//     content.mycanvas.zoom(1.25)
// }

// function zoomout(){
//     content.mycanvas.zoom(0.75)
// }

