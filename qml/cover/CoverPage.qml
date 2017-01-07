import QtQuick 2.0
import Sailfish.Silica 1.0

import '../lib'

CoverBackground {
    id:mainCoverBackground
    property bool active: status === Cover.Active

    property bool isPlaying: appstate.player.isPlaying
    property bool cassetteAnimationRunning: options.useAnimations && options.useCoverAnimations && active && isPlaying


    property string coverActionCommand:''

    Item {
        id: paddingcontainer
        anchors.fill: parent
        anchors.topMargin: Theme.paddingSmall
        anchors.leftMargin: Theme.paddingSmall
        anchors.rightMargin: Theme.paddingSmall
        anchors.bottomMargin: Theme.paddingSmall
        clip: true




        Image {
            id: coverImage
            source: appstate.playlistActive ? appstate.playlistActive.coverImage:''

            anchors.fill: parent

            fillMode: Image.PreserveAspectCrop
            x: (parent.width - width) / 2
            z:-1
            opacity: 0.3
        }
    }


    ProgressCassette {
        id: coverCassette
        opacity: 0.3
        width: parent.width * 2
        height: width
        x: (-width) / 2
        y: parent.height - (height / 2)

        //                z: -2

        maximumValue: options.cassetteUseDirectoryDurationProgress ? appstate.playlist.duration: (appstate.playlistIndex > -1 ? appstate.playlist.get(appstate.playlistIndex).duration: 0) //appstate.playlistActive.duration
        value: (appstate.currentPosition || (maximumValue - minimumValue) * 0.01 ) + (options.cassetteUseDirectoryDurationProgress ? appstate.playlist.get(appstate.playlistIndex).playlistOffset :0)
        running: cassetteAnimationRunning
        rotationOffset: -45
    }

    Column {
        id: centeredItem

        anchors.centerIn: parent

        anchors.bottomMargin: coverCassette.tapeWidth / 3
        //        height: folderNameLabel.implicitHeight + fileNameLabel.implicitHeight + progressLabel.implicitHeight
        width: parent.width - Theme.paddingLarge * 2

        Label {
            width: parent.width
            id: fileNameLabel

            text: appstate.playlistActive ? appstate.playlistActive.baseName : ''

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            id: progressLabel
            text: formatMSeconds( appstate.currentPosition)+" / "+formatMSeconds (appstate.playlistActive ? appstate.playlistActive.duration : 0)

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            id: folderNameLabel3
            text: appstate.playlistActive && appstate.playlistActive.folderName || ''

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
    }








    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource:isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: {

                cmd.cover = 'playpause'
                cmd.cover = ''
            }
        }
    }
}
