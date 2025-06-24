import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "draw.js" as Controller


ApplicationWindow {
    id: window
    width: 1440
    height: 1440
    visible: true
    title:"绘图窗口"

    // 添加窗口标识属性
    property bool isPrimaryWindow: true

    RowLayout {
            anchors.fill: parent
            spacing: 0

            // 左侧内容区域
            Content {
                id: content
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // 右侧工具栏区域
            Rectangle {
                id: rightToolbar
                width: 450
                Layout.fillHeight: true
                color: "gray"
                border.color: "gray"

                ColumnLayout {
                    anchors.fill: parent
                    spacing:2
                    // 旋转按钮组使其右对齐
                    ColumnLayout {
                        Layout.alignment: Qt.AlignRight
                        spacing: 2
                        RowLayout{
                        // 工具按钮
                            ToolButton {
                                 action: actions.counterclockwise   //text: qsTr("左旋")
                                 implicitWidth: 80
                                 implicitHeight: 50
                            }

                            ToolButton {
                                 action: actions.clockwise          //text: qsTr("右旋")
                                 implicitWidth: 80
                                 implicitHeight: 50
                            }
                        }
                        Rectangle{
                            id:placeholderRectangle
                            height: 80
                            width: 40
                            color:"gray"
                        }
                        Rectangle{
                            id:color
                            implicitHeight: 300
                            implicitWidth: 200
                            color:"gray"
                            ColumnLayout{
                                anchors.fill: parent
                                spacing: 5
                                //当前颜色预览
                                Rectangle {
                                    id: currentColorPreview
                                    implicitHeight: colorGridView.cellWidth
                                    implicitWidth: colorGridView.cellWidth
                                    color: content.penColor
                                    border.color: "white"
                                    border.width: 2
                                    Layout.alignment: Qt.AlignHCenter


                                    //"当前颜色"标签
                                    Label {
                                        text: "当前颜色"
                                        anchors {
                                            bottom: parent.top
                                            bottomMargin: 5
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                        font.bold: true
                                        color: "white"
                                    }
                                }
                                GridView{
                                    id:colorGridView
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    cellWidth: (parent.width - 20)/4
                                    cellHeight: cellWidth
                                    clip: true
                                    model:[
                                        "black", "white", "red", "green",
                                        "blue", "yellow", "orange", "purple",
                                        "pink", "brown", "gray", "cyan",
                                        "magenta", "lime", "navy", "teal"
                                    ]
                                    //网格布局
                                    delegate: Rectangle{
                                        required property int index// 显式声明索引
                                        required property string modelData// 显式声明颜色值
                                        width:colorGridView.cellWidth - 5
                                        height: colorGridView.cellHeight - 5
                                        color: modelData
                                        border.color: "white"
                                        border.width: 2
                                        TapHandler{
                                            onTapped: {
                                                colorGridView.currentIndex = index
                                                content.penColor = parent.modelData
                                            }
                                        }
                                    }

                                }
                            }
                        }

                    //橡皮擦大小选择器
                    Rectangle {
                        id: _eraserSizePanel
                        visible: true
                        width: 200
                        height: 80
                        color: "gray"
                        radius: 5
                        Layout.alignment: Qt.AlignRight

                        ColumnLayout{
                            anchors.fill: parent
                            anchors.margins: 5
                            spacing: 5
                            ToolButton {
                                action: actions.eraser
                                ToolTip.text: qsTr("橡皮擦 (Ctrl+E)")
                                ToolTip.visible: hovered
                                icon.color: content.isEraser ? "red" : "black"
                            }
                            RowLayout{

                                Label {
                                    text: "橡皮擦大小:"
                                    font.bold: true
                                    Layout.alignment: Qt.AlignHCenter
                                }
                                Label {
                                    text: _eraserSizeSlider.value + "px"
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                            Slider {
                                id: _eraserSizeSlider
                                width:120
                                from: 5
                                to: 50
                                stepSize: 1
                                value: content.eraserWidth

                                onMoved: {
                                    content.eraserWidth = value
                                }
                            }


                        }
                    }
                    //笔号大小选择器
                    Rectangle{
                        id:penSizeRectangle
                        width:200
                        height:80
                        color:"gray"
                        Layout.alignment: Qt.AlignRight
                        ColumnLayout{
                            anchors.fill: parent
                            spacing: 5
                            RowLayout{
                            Label{
                                Layout.leftMargin: 5
                                text:"笔号大小:"
                                font.bold:true
                            }
                            Label{
                                text:penSizeSlider.value + "px"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            }
                        Slider{
                            id:penSizeSlider
                            // padding: 10
                            Layout.leftMargin: 5
                            width:120
                            from: 1
                            to: 20
                            stepSize: 1
                            value: content.penWidth
                            onMoved: {
                                content.penWidth = value
                            }
                        }

                        }
                    }
                    Item {
                            Layout.fillHeight: true  //占据剩余空间
                        }
                }
            }
        }
    }
    //菜单栏定义
    menuBar: MenuBar {
        //文件菜单
        Menu {
            title: qsTr("文件")
        MenuItem {
                action: actions.newfile
                ToolTip.text: qsTr("新建窗口 (Ctrl+N)")
                ToolTip.visible: hovered}
            MenuItem {
                action: actions.open}
            MenuSeparator {}  //分隔线
            MenuItem {
                action: actions.save}
            MenuItem {
                action: actions.close }
            MenuSeparator {}
            MenuItem {
                action: actions.quit }
        }

        //编辑菜单
        Menu {
            title: qsTr("编辑")
            MenuItem{action:actions.pen}//之后将会做成点击之后弹出一个对话框用于笔号的选择
            MenuItem{action:actions.color}//同上做成一个对话框用于颜色的选择
            MenuSeparator {}
            MenuItem {
                action: actions.undo}//撤销
            MenuItem {
                action: actions.redo}//重做
            MenuItem {
                action: actions.deleteall}//删除所有
            MenuSeparator {}
            MenuItem {
                action: actions.cut}//剪切
            MenuItem {
                action: actions.copy}//复制
            MenuItem {
                action: actions.paste}//粘贴
        }

        // 视图菜单
        Menu {
            title: qsTr("视图")
            MenuItem {
                action: actions.fullscreen
                text: checked ? qsTr("退出全屏") : qsTr("全屏模式")
                checkable: true
            }
            MenuSeparator {}
            MenuItem {
                action: actions.zoomin  //text: qsTr("放大 (+)")
            }
            MenuItem {
                action: actions.zoomout  //text: qsTr("缩小 (-)")
            }
            MenuItem {
                action: actions.counterclockwise  //text: qsTr("左旋")
            }
            MenuItem {
                action: actions.clockwise  //text: qsTr("右旋")
            }
        }

        Menu {
            title: qsTr("帮助")
            MenuItem {
                action: actions.about}
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton { action: actions.newfile }
            ToolButton { action: actions.open }
            ToolButton { action: actions.save }

            //分隔条
            ToolSeparator {}
            ToolButton { action: actions.undo }
            ToolButton { action: actions.redo }
            ToolButton { action: actions.deleteall }
            ToolSeparator {}
            ToolButton { action: actions.cut }
            ToolButton { action: actions.copy }
            ToolButton { action: actions.paste }
            ToolSeparator {}
            ToolButton{ action: actions.zoomin}
            ComboBox{
                //是根据当前的画布大小进行缩放
                id:zoomComboBox
                model:["50%","75","100%","125%","150%","200%"]
                currentIndex: 2 //一般默认是100%的缩放
                onActivated:{
                    var zoomvalues = [0.5,0.75,1.0,1.25,1.5,2]

                    content.zoom(zoomvalues[index])
                }
            }

            ToolButton{ action: actions.zoomout}
            //右侧对齐的空间占位
            Item { Layout.fillWidth: true }

            //视图操作按钮
            ToolButton {
                action: actions.fullscreen
                ToolTip.text: action.checked ? qsTr("退出全屏 (F11)") : qsTr("进入全屏 (F11)")
                ToolTip.visible: hovered
                icon.name: action.checked ? "view-restore" : "view-fullscreen"
            }
        }
    }

    Actions {
        id: actions
        open.onTriggered: Controller.open();
        color.onTriggered: Controller.openColorDialog(); //绑定颜色动作
        newfile.onTriggered:Controller.createNewWindow();
        // close.onTriggered:Controller.close();
        undo.onTriggered:Controller.undo();
        redo.onTriggered:Controller.redo();
        deleteall.onTriggered:Controller.deleteall();
        cut.onTriggered:Controller.cut();
        copy.onTriggered:Controller.copy();
        paste.onTriggered:Controller.paste();
        eraser.onTriggered: Controller.toggleEraser();
        pen.onTriggered:Controller.openPenSizeDialog();
        clockwise.onTriggered: Controller.rotateCanvas(90);
        counterclockwise.onTriggered: Controller.rotateCanvas(-90);
        about.onTriggered: content.dialogs.about.open();
        fullscreen.onTriggered:Controller.toggleFullscreen();
        save.onTriggered: Controller.save();
        zoomin.onTriggered:content.zoom(1.2);
        zoomout.onTriggered: content.zoom(0.8);
    }
    //Content Area
    // Content {
    //     id:content
    //     anchors.fill: parent
    // }
    Component.onCompleted: {
        Controller.registerWindow(window); // 注册窗口引用
    }

}


