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

import '../visual'
import '../lib'

CoverBackground {
    id:mainCoverBackground
    property bool active: status === Cover.Active
    property PlayerCommands playerCommands: app.playlist.commands

    Item {
        id: paddingcontainer
        clip: true
        anchors {
            fill: parent
            margins: Theme.paddingSmall
        }
        Image {
            id: coverImage
            source: 'image://taglib-cover-art/'+app.playlist.currentMetaData.path
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            sourceSize {
                width: coverImage.width
                height: coverImage.height
            }
            z:-1
            opacity: 0.3
        }
    }

    ProgressCassette {
        id: coverCassette
        opacity: 0.3
        width: parent.width * 2
        reelAnchorColor: Theme.highlightColor
        height: width
        anchors {
            horizontalCenter: parent.left
            verticalCenter: parent.bottom
        }

        maximumValue: app.options.cassetteUseDirectoryDurationProgress
           ? app.playlist.totalDuration
           : app.audio.duration
        value: app.options.cassetteUseDirectoryDurationProgress ? app.playlist.totalPosition: app.audio.displayPosition
        running: app.options.useAnimations && app.options.usePlayerAnimations && app.audio.isPlaying

        rotationOffset: -45
    }

    InteractionHintLabel {
        invert: true
        anchors.fill: parent
        opacity: (app.playlist.metadata.count > 0) ? 0.0 : 1.0
        Behavior on opacity { FadeAnimation {} }
        InfoLabel {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:qsTr('Nothing to play')
            visible: app.playlist.metadata.count === 0
        }
    }


    OpacityRampEffect {
        sourceItem: centeredItem
        direction: OpacityRamp.TopToBottom
        slope: 5
        offset: centeredItem.largeContent ? 0.7 : 1.0
    }

    Column {
        id: centeredItem
        property bool largeContent: implicitHeight > parent.height - bottomPadding + Theme.paddingLarge
        opacity: app.playlist.metadata.count > 0 ? 1 : 0
        states: [
            State {
                name: 'top'
                when: centeredItem.largeContent
                AnchorChanges {
                    target: centeredItem
                    anchors.verticalCenter: undefined
                    anchors.top: parent.top
                }
            }
        ]
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        topPadding: Theme.paddingSmall
        bottomPadding: width / 4
        width: parent.width - Theme.paddingMedium * 2

        Label {
            width: parent.width
            text: app.playlist.currentTitle

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            text: app.js.formatMSeconds( app.audio.displayPosition )+" / "+app.js.formatMSeconds (app.playlist.currentMetaData.duration > 0 ? app.playlist.currentMetaData.duration : 0.1)
            visible: app.playlist.metadata.count > 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            visible: text !== ''
            text: app.playlist.currentAlbum

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            visible: text !== ''
            text: app.playlist.currentArtist

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
    }







    CoverActionList {
        id: coverActionPrev
        enabled: app.playlist.metadata.count > 0 && options.secondaryCoverAction === 'prev'

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
        enabled: app.playlist.metadata.count > 0 && options.secondaryCoverAction === 'next'

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
        enabled: app.playlist.metadata.count > 0 && options.secondaryCoverAction === 'both'

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
        enabled: app.playlist.metadata.count > 0 && options.secondaryCoverAction === ''

        CoverAction {
            iconSource: app.audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }
    }
    CoverActionList {
        id: coverActionEmpty
        enabled: app.playlist.metadata.count === 0

        CoverAction {
            iconSource:  "image://theme/icon-cover-new"
            onTriggered: {
                if(app.pageStack.depth > 1) { // remove all below PlayerPage
                    app.pageStack.pop(app.pageStack.find(function(page){return page.objectName === 'playerPage';}), PageStackAction.Immediate);
                }
                pageStack.push(Qt.resolvedUrl("../pages/OpenPage.qml"), {}, PageStackAction.Immediate);
                app.activate();
            }
        }
    }


}
