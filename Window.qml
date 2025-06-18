import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "draw.js" as Controller


ApplicationWindow {
    id: window
    width: 2560
    height: 1440
    visible: true

    // 菜单栏定义
    menuBar: MenuBar {
        // 文件菜单
        Menu {
            title: qsTr("文件")
        MenuItem {
                action: actions.newfile}
            MenuItem {
                action: actions.open}
            MenuSeparator {}  // 分隔线
            MenuItem {
                action: actions.save}
            MenuItem {
                action: actions.close }
            MenuSeparator {}
            MenuItem {
                action: actions.quit }
        }

        // 编辑菜单
        Menu {
            title: qsTr("编辑")
            MenuItem{action:actions.pen}//之后将会做成点击之后弹出一个对话框用于笔号的选择
            MenuItem{action:actions.color}//同上做成一个对话框用于颜色的选择
            MenuSeparator {}
            MenuItem {
                action: actions.undo}//撤销
            MenuItem {
                action: actions.redo}//重做
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
                action: actions.zoomin//text: qsTr("放大 (+)")
            }
            MenuItem {
                action: actions.zoomout//text: qsTr("缩小 (-)")
            }
        }

        // 帮助菜单
        Menu {
            title: qsTr("帮助")
            MenuItem {
                action: actions.about}
        }
    }

    // 工具栏定义
    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            // 文件操作按钮组
            ToolButton { action: actions.newfile }
            ToolButton { action: actions.open }
            ToolButton { action: actions.save }

            // 分隔条
            ToolSeparator {}

            // 编辑操作按钮组
            ToolButton { action: actions.undo }
            ToolButton { action: actions.redo }
            ToolSeparator {}
            ToolButton { action: actions.cut }
            ToolButton { action: actions.copy }
            ToolButton { action: actions.paste }

            // 右侧对齐的空间占位
            Item { Layout.fillWidth: true }

            // 视图操作按钮
            ToolButton {
                action: actions.fullscreen
                ToolTip.text: action.checked ? qsTr("退出全屏 (F11)") : qsTr("进入全屏 (F11)")
                ToolTip.visible: hovered
                icon.name: action.checked ? "view-restore" : "view-fullscreen"
            }
        }
    }

    Component.onCompleted: {
            Controller.registerWindow(window); // 注册窗口引用
        }

    Actions {
        id: actions
        open.onTriggered:Controller.open();
        color.onTriggered: Controller.openColorDialog() // 绑定颜色动作
        // newFile.onTriggered:Controller.newfile();
        // close.onTriggered:Controller.close();
        // quit.conTriggered:Controller.quit();
        // undo.onTriggered:Controller.undo();
        // redo.onTriggered:Controller.redo();
        // cut.onTriggered:Controller.cut();
        // copy.onTriggered:Controller.copy();
        // paste.onTriggered:Controller.paste();
        // pen.onTriggered:Controller.pen();
        // color.onTriggered:Controller.color()
        about.onTriggered: content.dialogs.about.open();
<<<<<<< HEAD
        fullscreen.onTriggered:Controller.toggleFullscreen();
=======
        // fullscreen.onTriggered:
>>>>>>> 14234416c01a11f81cf6480ae8f9914b38a52de1
        save.onTriggered: Controller.save();
    }
    //Content Area
    Content {
        id:content
        anchors.fill: parent
    }
}


