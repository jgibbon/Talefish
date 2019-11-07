/*

Talefish Audiobook Player
Copyright (C) 2016-2019  John Gibbon

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

*/
import QtQuick 2.6
import Sailfish.Silica 1.0

import '../lib'

CoverBackground {
    id:mainCoverBackground
    property bool active: status === Cover.Active


    property string coverActionCommand:''
    property var playerCommands: app.playlist.commands

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
            source: 'image://taglib-cover-art/'+app.playlist.currentMetaData.path

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
        maximumValue: app.options.cassetteUseDirectoryDurationProgress
           ? app.playlist.totalDuration
           : app.audio.duration
        value: app.options.cassetteUseDirectoryDurationProgress ? app.playlist.totalPosition: app.audio.displayPosition
        running: app.options.useAnimations && app.options.usePlayerAnimations && app.audio.isPlaying

        rotationOffset: -45
    }

    InteractionHintLabel {
        anchors.bottom: parent.bottom
        opacity: (app.playlist.metadata.count > 0) ? 0.0 : 1.0
        Behavior on opacity { FadeAnimation {} }
        InfoLabel {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:qsTr('Nothing to play')
            visible: app.playlist.metadata.count === 0
        }
    }
    Column {
        id: centeredItem

        opacity: app.playlist.metadata.count > 0 ? 1 : 0
        anchors.centerIn: parent

        anchors.bottomMargin: coverCassette.tapeWidth / 3
        //        height: folderNameLabel.implicitHeight + fileNameLabel.implicitHeight + progressLabel.implicitHeight
        width: parent.width - Theme.paddingLarge * 2

        Label {
            width: parent.width
            id: fileNameLabel

            text: (app.playlist.currentMetaData.title || app.audio.source) + (app.audio.errorString !== '' ? '<br>['+app.audio.errorString+']' : '')

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            id: progressLabel
            text: app.js.formatMSeconds( app.audio.position )+" / "+app.js.formatMSeconds (app.audio.displayPosition)

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            id: folderNameLabel3
            property string displayPath:(app.playlist.currentMetaData.album || app.audio.source)
            visible: displayPath !== '' //&& options.playerDisplayDirectoryName
            text: displayPath

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
    }







    CoverActionList {
        id: coverActionPrev
        enabled: options.secondaryCoverAction === 'prev'

        CoverAction {
            iconSource: "image://theme/icon-cover-previous-song"

            onTriggered: playerCommands.prev()
        }

        CoverAction {
            iconSource: app.audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }
    }

    CoverActionList {
        id: coverActionNext
        enabled: options.secondaryCoverAction === 'next'

        CoverAction {
            iconSource: app.audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"

            onTriggered: playerCommands.next()
        }
    }

    CoverActionList {
        id: coverActionBoth
        enabled: options.secondaryCoverAction === 'both'

        CoverAction {
            iconSource: "image://theme/icon-cover-previous-song"

            onTriggered: playerCommands.prev()
        }

        CoverAction {
            iconSource: app.audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next-song"

            onTriggered: playerCommands.next()
        }
    }

    CoverActionList {
        id: coverAction
        enabled: options.secondaryCoverAction === ''

        CoverAction {
            iconSource: app.audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }
    }


}
