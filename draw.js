function func() {

}
var currentPenColor = "black" // 默认颜色

function openColorDialog() {
    content.dialogs.colorDialog.open()
}

function setPenColor(color) {
    currentPenColor = color
    // 这里可以添加更新画布颜色的逻辑
    console.log("画笔颜色已设置为:", color)
}

// 暴露函数给QML
Qt.include({
    setPenColor: setPenColor
})

function open(){
    content.dialogs.fileOpen.open()
}
