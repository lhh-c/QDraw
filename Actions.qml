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
    Action {
        id:_open
        text: qsTr("&Open...")
        icon.name: "document-open"
        shortcut: StandardKey.Open
    }

    Action {
        id: _close
        text: qsTr("&Close...")
        icon.name: "document-close"
        shortcut: StandardKey.Close
    }

    Action {
        id: _save
        text: qsTr("&Save")
        shortcut: StandardKey.Save
        icon.name: "document-save"
    }

    Action {
        id: _quit
        text: qsTr("&Exit")
        icon.name: "application-exit"
        shortcut: StandardKey.Quit
        onTriggered: Qt.quit();
    }

    Action {
        id: _about
        text: qsTr("&About")
        icon.name: "help-about"
    }

    Action {
        id:_newfile
        text:qsTr("&NewFile")
        // icon://暂时不知道
    }

    Action {
        id:_pen
        text:qsTr("&Pensize")
        // icon:
    }

    Action {
        id:_color
        text:qsTr("&Pencolor")
        icon.name: "color-picker" // 可以使用合适的图标
           onTriggered: {
               // 触发打开颜色对话框
               dialogs.openColorDialog()
           }
    }

    Action {
        id:_undo
        text:qsTr("&Undo")
        // icon:
    }

    Action {
        id:_redo
        text:qsTr("&Redo")
        // icon:
    }

    Action {
        id:_cut
        text:qsTr("&Cut")
        // icon:
    }

    Action {
        id:_copy
        text:qsTr("&Copy")
        // icon:
    }

    Action {
        id:_paste
        text:qsTr("&Paste")
        // icon:
    }

    Action {
        id:_zoomin
        text:qsTr("&ZoomIn")
        // icon:
    }

    Action {
        id:_zoomout
        text:qsTr("&ZoomOut")
        // icon:
    }
}
