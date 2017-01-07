import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0


Dialog {
    id:dialog
    canAccept: false


    OpenPlaylistButton {
        id: opnBtn
        visible: false
        onIsDoneChanged: {
            if(isDone){
                dialog.canAccept = true;
                dialog.accept();
            }
        }
    }

    SilicaFlickable {

        id: flickable
        anchors.fill: parent
        //        contentHeight: childrenRect.height
        Column {
            width: parent.width


            PageHeader {
                id: headertext
                title: "Opening Directory"
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
            }

            Label {
                id: willscanLabel
                font.pixelSize: Theme.fontSizeTiny
                anchors.horizontalCenter: parent.Center
                anchors.bottom: headertext.bottom
                visible: opnBtn.willScan
                text: 'will scan durations, this may take a while'
                horizontalAlignment: Text.horizontalCenter
            }
        }

    }
    Component.onCompleted: {
        opnBtn.openDirectoryDialog();
    }
}
