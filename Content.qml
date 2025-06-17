import QtQuick

Item {
    id:content
    anchors.fill: parent

    property alias dialogs: _dialogs

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
