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
    property PlayerCommands playerCommands: app.playerCommands
    property TalefishAudio audio: app.audio
    property TalefishPlaylist playlist: app.playlist
    Item {
        id: paddingcontainer
        clip: true
        anchors {
            fill: parent
            margins: Theme.paddingSmall
        }
        Image {
            id: coverImage
            source: 'image://taglib-cover-art/'+playlist.currentMetaData.path
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
           ? playlist.totalDuration
           : audio.duration
        value: app.options.cassetteUseDirectoryDurationProgress ? playlist.totalPosition: audio.displayPosition
        running: app.options.useAnimations && app.options.usePlayerAnimations && audio.isPlaying

        rotationOffset: -45
    }

    InteractionHintLabel {
        invert: true
        anchors.fill: parent
        opacity: (playlist.metadata.count > 0) ? 0.0 : 1.0
        Behavior on opacity { FadeAnimation {} }
        InfoLabel {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:qsTr('Nothing to play')
            visible: playlist.metadata.count === 0
            textFormat: Text.PlainText
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
        opacity: playlist.metadata.count > 0 ? 1 : 0
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
            text: playlist.currentTitle

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.PlainText
            color: Theme.primaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            text: app.js.formatMSeconds( audio.displayPosition )+" / "+app.js.formatMSeconds (playlist.currentMetaData.duration > 0 ? playlist.currentMetaData.duration : 0.1)
            visible: playlist.metadata.count > 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeExtraSmall
            textFormat: Text.PlainText
            color: Theme.primaryColor
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            visible: text !== ''
            text: playlist.currentAlbum

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            textFormat: Text.PlainText
            color: Theme.secondaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
        Label {
            width: parent.width
            visible: text !== ''
            text: playlist.currentArtist

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: Theme.fontSizeTiny
            textFormat: Text.PlainText
            color: Theme.secondaryColor
            maximumLineCount: 4
            elide: Text.ElideRight
            wrapMode: 'WrapAtWordBoundaryOrAnywhere'
        }
    }

    property string externalCommandSkipDuration: app.options.externalCommandSkipDuration
    property string skipImageBase: '../assets/icon-cover-'+(Theme.colorScheme ? 'dark-' : 'light-')
    property string skipImageDuration: externalCommandSkipDuration === 'normal' ? 'f' : ''
    property string skipImagePrev: externalCommandSkipDuration === '0' ? 'image://theme/icon-cover-previous-song' : Qt.resolvedUrl(skipImageBase + skipImageDuration + 'rwd.svg')
    property string skipImageNext: externalCommandSkipDuration === '0' ? 'image://theme/icon-cover-next-song' : Qt.resolvedUrl(skipImageBase + skipImageDuration + 'fwd.svg')

    CoverActionList {
        id: coverActionPrev
        enabled: playlist.metadata.count > 0 && options.secondaryCoverAction === 'prev'

        CoverAction {
            iconSource: mainCoverBackground.skipImagePrev
            onTriggered: playerCommands.prev()
        }

        CoverAction {
            iconSource: audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: playerCommands.playPause()
        }
    }

    CoverActionList {
        id: coverActionNext
        enabled: playlist.metadata.count > 0 && options.secondaryCoverAction === 'next'

        CoverAction {
            iconSource: audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: playerCommands.playPause()
        }

        CoverAction {
            iconSource: mainCoverBackground.skipImageNext

            onTriggered: playerCommands.next()
        }
    }

    CoverActionList {
        id: coverActionBoth
        enabled: playlist.metadata.count > 0 && options.secondaryCoverAction === 'both'

        CoverAction {
            iconSource: mainCoverBackground.skipImagePrev
            onTriggered: playerCommands.prev()
        }

        CoverAction {
            iconSource: audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }

        CoverAction {
            iconSource: mainCoverBackground.skipImageNext

            onTriggered: playerCommands.next()
        }
    }

    CoverActionList {
        id: coverAction
        enabled: playlist.metadata.count > 0 && options.secondaryCoverAction === ''

        CoverAction {
            iconSource: audio.isPlaying ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"

            onTriggered: playerCommands.playPause()
        }
    }
    CoverActionList {
        id: coverActionEmpty
        enabled: playlist.metadata.count === 0

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
