import QtQuick
import QtQuick.Controls

Item {
    property alias open: _open
    property alias save: _save
    property alias quit: _quit
    property alias about: _about
    property alias close: _close
    property alias  newfile: _newfile
    property alias  pen: _pen
    property alias color: _color
    property alias undo: _undo
    property alias redo: _redo
    property alias cut: _cut
    property alias copy: _copy
    property alias paste: _paste
    property alias zoomin: _zoomin
    property alias zoomout: _zoomout
    property alias fullscreen: _fullscreen
    Action {
        id:_open
        text: qsTr("&打开")
        icon.name: "document-open"
        shortcut: StandardKey.Open
    }

    Action {
        id: _close
        text: qsTr("&关闭")
        icon.name: "document-close"
        shortcut: StandardKey.Close
    }

    Action {
        id: _save
        text: qsTr("&保存")
        shortcut: StandardKey.Save
        icon.name: "document-save"
    }

    Action {
        id: _quit
        text: qsTr("&退出")
        icon.name: "application-exit"
        shortcut: StandardKey.Quit
        onTriggered: Qt.quit();
    }

    Action {
        id: _about
        text: qsTr("&关于")
        icon.name: "help-about"
    }

    Action {
        id:_newfile
        text:qsTr("&新建")
        icon.name:"document-new"
    }

    Action {
        id:_pen
        text:qsTr("&笔号")
        // icon.name:"document-new"
    }

    Action {
        id:_color
        text:qsTr("&笔色")
        icon.name: "color-picker" // 可以使用合适的图标
           // onTriggered: {
           //     // 触发打开颜色对话框
           //     dialogs.openColorDialog()
           // }
    }

    Action {
        id:_undo
        text:qsTr("&撤销")
        icon.name:"edit-undo"
    }

    Action {
        id:_redo
        text:qsTr("&重画")
        icon.name:"edit-redo"
    }

    Action {
        id:_cut
        text:qsTr("&剪切")
        icon.name:"edit-cut"
    }

    Action {
        id:_copy
        text:qsTr("&复制")
        icon.name:"edit-copy"
    }

    Action {
        id:_paste
        text:qsTr("&粘贴")
        icon.name:"edit-paste"
    }

    Action {
        id:_zoomin
        text:qsTr("&放大")
        icon.name:"zoom-in"
        shortcut: StandardKey.ZoomIn
    }

    Action {
        id:_zoomout
        text:qsTr("&缩小")
        icon.name:"zoom-out"
    }

    Action {
        id:_fullscreen
        text:qsTr("&全屏")
        icon.name:"view-fullscreen"
        shortcut: "F11" // 添加F11快捷键
        checkable: true
    }
}
