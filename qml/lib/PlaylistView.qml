import QtQuick 2.0

import Sailfish.Silica 1.0
SilicaListView {
    id: root

    delegate: BackgroundItem {

        width: parent.width
        height: Theme.itemSizeSmall

        anchors.left: parent.left
        anchors.right: parent.right
        property bool isActive:appstate.playlistIndex === index
        highlighted: isActive
        Item {
            width: parent.width - Theme.paddingSmall *2
            x: Theme.paddingSmall
            height: parent.height
            Image {
                id: imgItem
                source: model.coverImage
                width: model.coverImage !== '' ? parent.height : 0
                height: parent.height
            }
            Label {
                id: nameItem
                height: Theme.itemSizeSmall/2
                text: model.baseName
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeTiny
                verticalAlignment: Text.AlignVCenter
                anchors.left: imgItem.right
                anchors.right: sizeItem.left
                anchors.rightMargin: Theme.paddingSmall
                anchors.leftMargin: Theme.paddingSmall
                anchors.top: parent.top
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }

            Label {
                id: folderItem
                height: Theme.itemSizeSmall/2
                text: model.folderName
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                verticalAlignment: Text.AlignVCenter
                anchors.left: imgItem.right
                anchors.right: sizeItem.left
                anchors.rightMargin: Theme.paddingSmall
                anchors.leftMargin: Theme.paddingSmall
                anchors.bottom: parent.bottom
            }
            Label {
                id: sizeItem
                height: Theme.itemSizeSmall
                text: model.duration > 0 ? formatMSeconds(model.duration) : qsTr('Error')
                font.pixelSize: Theme.fontSizeTiny
                verticalAlignment: Text.AlignVCenter
                anchors.right: parent.right
            }
        }
        onClicked: {
            appstate.currentPosition = 0;
            appstate.tplayer.playIndex(index, {isplaying: appstate.tplayer.isplaying});
        }
    }
}

