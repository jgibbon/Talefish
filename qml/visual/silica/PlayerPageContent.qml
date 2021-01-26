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
import QtGraphicalEffects 1.0
import QtFeedback 5.0

import '../../lib'
import '../'
Item {
    id: pageContent
    states: [
        State {
            name: "landscape"
            when: page.isLandscape

            PropertyChanges {
                target: mainPageHeader
                // put right of iconButtons if vertical space is limited
                leftMargin: ((pageContent.height - iconButtons.height)/2 < mainPageHeader.height - Theme.paddingMedium)
                    ? iconButtons.width + Theme.paddingLarge + Theme.horizontalPageMargin
                    : Theme.horizontalPageMargin

            }
            AnchorChanges {
                target: coverImageContainer
                anchors.top: pageContent.top
                anchors.right: iconButtons.left
            }
            AnchorChanges {
                target: infoColumn
                anchors.right: iconButtons.left
                anchors.bottom: pageContent.bottom
            }
            AnchorChanges {
                target: iconButtons
                anchors.bottom: undefined
                anchors.horizontalCenter: undefined
                anchors.verticalCenter: pageContent.verticalCenter
                anchors.right: pageContent.right
            }
            PropertyChanges {
                target: iconButtons
                height: sizeOfEntries
                width: Theme.iconSizeLarge
                anchors.bottomMargin: 0
                anchors.rightMargin: Theme.horizontalPageMargin
            }
        }
    ]
    PageHeader {
        id: mainPageHeader
        title: 'Talefish'
    }
    PageHeader { // Overlay white PageHeader where it's hidden by cassette progress
        id: mainPageHeaderMasked
        anchors.fill: mainPageHeader
        title: mainPageHeader.title
        leftMargin: mainPageHeader.leftMargin
        visible: false
        titleColor: "white" // since SFOS 3.1
    }
    Item {
        id: headerMask
        anchors.fill: mainPageHeader

        ProgressCassette {
            id:cassette
            width: Screen.width * 2
            reelAnchorColor: Theme.highlightColor
            height: width
            x: -width / 2
            y: coverImage.sourceSize.width > 1 ? x : x/2
            opacity: page.status === PageStatus.Active ? (page.metadataCount > 0 && mainFlickable.contentY > -Theme.itemSizeSmall ? 0.8 : 0.2) : 0
            maximumValue: (app.options.cassetteUseDirectoryDurationProgress
                          ? playlist.totalDuration
                          : playlist.currentMetaData.duration) || 0.5 //nothing loaded
            value: app.options.cassetteUseDirectoryDurationProgress ? playlist.totalPosition: audio.displayPosition
            running: app.active && page.status !== PageStatus.Inactive && app.options.useAnimations && app.options.usePlayerAnimations && audio.isPlaying

            Behavior on opacity { NumberAnimation {duration: 500; easing.type: Easing.InOutCubic}}

        }
    }
    OpacityMask {
        anchors.fill: source
        source: mainPageHeaderMasked
        maskSource: headerMask
    }
    Item {
        id: coverImageContainer
        anchors {
            top: mainPageHeader.bottom //landscape: pageContent.top
            left: pageContent.left
            right: pageContent.right // landscape: iconButtons.left
            bottom: infoColumn.top
            bottomMargin: -primaryLabel.height
        }

        FadeImage {
            id: coverImage
            source: 'image://taglib-cover-art/'+playlist.currentMetaData.path
            width: parent.width
            height: parent.height
            asynchronous: true
            cache: false

            fillMode: Image.PreserveAspectFit
            verticalAlignment: Image.AlignTop
            horizontalAlignment: Image.AlignHCenter
            // leads to re-process when resizing (mostly swiping back with search/vkb in playlist), but may be acceptable:
            sourceSize {
                width: coverImage.width
                height: coverImage.height
            }
            NumberAnimation on x { // drag via
                id: animateCoverContainerXBack0
                to: 0
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

    }
    OpacityRampEffect {
        id: effect
        readonly property double factor: 0.6 * (coverImageContainer.height) / (infoColumn.height - progressArea.height)
        clampMax: 0.7
        clampMin: 0.2
        direction: OpacityRamp.TopToBottom
        offset: 1-(1/factor)
        slope: factor * 1.3 //the more, the shorter
        sourceItem: coverImageContainer
    }
    TouchInteractionHint {
        id: hint
        readonly property bool shouldBeRunning: page.metadataCount === 0
        onShouldBeRunningChanged: check()
        function check() {
            if(shouldBeRunning) {
                start()
            } else {
                stop()
            }
        }
        direction: TouchInteraction.Down
        interactionMode: TouchInteraction.Pull
        Component.onCompleted: check()
    }
    InteractionHintLabel {
        opacity: (page.metadataCount > 0) ? 0.0 : 1.0
        Behavior on opacity { FadeAnimation {} }
        anchors.bottom: parent.bottom
        InfoLabel {
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:qsTr('Nothing to play')
            visible: page.metadataCount === 0
            textFormat: Text.PlainText

            Text {
                text: qsTr('Open Files by pulling down.')
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: Theme.secondaryColor
                anchors.fill: parent
                anchors.topMargin: Theme.itemSizeSmall
                font.pixelSize: Theme.fontSizeSmall
                textFormat: Text.PlainText
            }
        }
    }
    MouseArea {
        id: coverMouseArea

        readonly property int maxDrag: Theme.itemSizeLarge
        visible: options.playerSwipeForNextPrev && (page.metadataCount > 1 || audio.displayPosition > options.skipBackTrackThreshold)
        property bool sideTriggerActive: false
        readonly property alias target: coverImage
        anchors.fill: coverImageContainer
        drag.target: target
        drag.axis: Drag.XAxis
        drag.threshold: 30
        drag.minimumX: playlist.currentIndex < page.metadataCount-1 ? maxDrag*-1 : 0 //next
        drag.maximumX: playlist.currentIndex > 0 || audio.displayPosition > options.skipBackTrackThreshold ? maxDrag:0 //prev

        onMouseXChanged: {
            var m = mouse, act = sideTriggerActive;
            act = false;
            if(target.x !== 0){

                switch(target.x){
                case drag.maximumX:
                    act = true;
                    break;
                case drag.minimumX:
                    act = true;
                    break;
                default:

                }
            }
            if(act !== sideTriggerActive){
                sideTriggerActive = act;
            }
        }

        onReleased: {
            animateCoverContainerXBack0.duration = (dragValue / maxDrag) * 400
            animateCoverContainerXBack0.start()
            if(sideTriggerActive){
                console.log('Player Page: Slided to skip' )


                sideTriggerActive = false;
                if(target.x < 0){//next
                    playlist.currentIndex = playlist.currentIndex + 1;
                } else if(target.x > 0) {//prev
                    if(audio.displayPosition > options.skipBackTrackThreshold) {
                        app.playerCommands.seek(0, playlist.currentIndex)
                    } else {
                        playlist.currentIndex = playlist.currentIndex - 1;
                    }
                }
            }
        }
        onSideTriggerActiveChanged: {
            if(sideTriggerActive && _ngfEffect) {
                _ngfEffect.play()
            }
        }

        property QtObject _ngfEffect //qt feedback won't run if
        Component.onCompleted: {
            _ngfEffect = Qt.createQmlObject("import org.nemomobile.ngf 1.0; NonGraphicalFeedback { event: 'pulldown_highlight' }",
                               coverMouseArea, 'NonGraphicalFeedback');
        }

        readonly property int dragValue: Math.abs(target.x)
        readonly property real dragFactor: maxDrag / dragValue

        Item {
            id: coverDraggedLabelContainer
            anchors.fill: parent
            visible: coverMouseArea.dragValue > coverMouseArea.maxDrag * 0.5
            opacity: coverMouseArea.sideTriggerActive ? 1.0 : 0.0

            Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}

            Rectangle{
                id: coverDragRect
                color: Theme.rgba(Theme.highlightDimmerColor, 0.85)
                anchors.fill: parent
            }

            OpacityRampEffect {
                sourceItem: coverDragRect
                direction: coverMouseArea.target.x > 0 ? OpacityRamp.RightToLeft: OpacityRamp.LeftToRight
                offset: 0.0
                slope: parent.opacity * 0.8
            }


            Label {
                color: Theme.primaryColor
                anchors.fill: parent
                anchors {
                    fill: parent
                    margins: Theme.paddingLarge
                }

                horizontalAlignment: coverMouseArea.target.x > 0 ? Text.AlignRight: Text.AlignLeft
                text: coverMouseArea.target.x > 0 ? (audio.displayPosition > options.skipBackTrackThreshold? qsTr('Rewind Track'): qsTr('Previous Track')): qsTr('Next Track')
                verticalAlignment: Text.AlignVCenter
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                textFormat: Text.PlainText
            }
        }
        Item {
            id: draggableContainer
            anchors.fill: parent
            clip:true
            Item {
                id: maxItem
                height: parent.height
                width:  coverMouseArea.dragValue*2 + coverMouseArea.maxDrag * 0.1
                visible: coverMouseArea.target.x < 0
                anchors.right: parent.right
                Rectangle{
                    id: maxBg
                    color: Qt.rgba(Theme.highlightBackgroundColor.r, Theme.highlightBackgroundColor.g, Theme.highlightBackgroundColor.b, coverMouseArea.sideTriggerActive ? 0.7 : 0.4)
                    anchors.fill: parent

                }
                OpacityRampEffect {
                    sourceItem: maxBg
                    offset: 0
                    slope: coverMouseArea.sideTriggerActive ? 1.0 : 1.0

                    direction: OpacityRamp.RightToLeft
                }
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    x: parent.width-width + (coverMouseArea.maxDrag - coverMouseArea.dragValue) *2
                    opacity: coverMouseArea.sideTriggerActive ? 1.0 : 0.8
                    source: 'image://theme/icon-m-next?'+(coverMouseArea.sideTriggerActive ? Theme.primaryColor : Theme.highlightColor)
                }
            }

            Item {
                id: minItem
                visible: coverMouseArea.target.x > 0
                height: parent.height
                width:  coverMouseArea.dragValue*2 + coverMouseArea.maxDrag * 0.1
                anchors.left: parent.left
                Rectangle{
                    id: minBg
                    color: Qt.rgba(Theme.highlightBackgroundColor.r, Theme.highlightBackgroundColor.g, Theme.highlightBackgroundColor.b, coverMouseArea.sideTriggerActive ? 0.7 : 0.4)
                    anchors {
                        fill: parent
                        right: parent.right
                    }
                }
                OpacityRampEffect {
                    direction: OpacityRamp.LeftToRight
                    offset: 0
                    slope: coverMouseArea.sideTriggerActive ? 1.0 : 1.0
                    sourceItem: minBg
                }
                Image {
                    opacity: coverMouseArea.sideTriggerActive ? 1.0 : 0.8
                    source: 'image://theme/icon-m-previous?'+(coverMouseArea.sideTriggerActive ? Theme.primaryColor : Theme.highlightColor)
                    x: -(coverMouseArea.maxDrag - coverMouseArea.dragValue) *2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

    }
    Column {
        id: infoColumn
        opacity: page.metadataCount > 0 ? 1 : 0
        anchors {
            left: parent.left
            right: parent.right
            bottom: iconButtons.top
        }

        Label {
            id: primaryLabel
            color: Theme.highlightColor
            fontSizeMode: Text.HorizontalFit
            horizontalAlignment: Text.AlignHCenter
            minimumPixelSize: Theme.fontSizeMedium
            style: Theme.colorScheme ? Text.Raised : Text.Normal
            styleColor: '#FFFFFF'
            text: playlist.currentTitle
            verticalAlignment: Text.AlignBottom
            width: parent.width - Theme.horizontalPageMargin * 2 // does not account for landscape, but that's acceptable
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            x: Theme.horizontalPageMargin
            font.pixelSize: Theme.fontSizeLarge
            textFormat: Text.PlainText
        }

        Label {
            property string displayPath: playlist.currentAlbum
            color: Theme.secondaryHighlightColor
            horizontalAlignment: Text.AlignHCenter
            style: Theme.colorScheme ? Text.Raised : Text.Normal
            styleColor: '#FFFFFF'
            text: displayPath
            visible: displayPath !== '' //&& options.playerDisplayDirectoryName
            width: parent.width - Theme.paddingSmall * 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            x: Theme.paddingSmall
            font.pixelSize: Theme.fontSizeSmall
            textFormat: Text.PlainText
        }
        Label {
            property string displayPath: playlist.currentArtist
            color: Theme.secondaryHighlightColor
            horizontalAlignment: Text.AlignHCenter
            text: displayPath
            verticalAlignment: Text.AlignVCenter
            visible: displayPath !== ''
            width: parent.width - Theme.paddingSmall * 2
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            x: Theme.paddingSmall
            font.pixelSize: Theme.fontSizeExtraSmall
            textFormat: Text.PlainText
        }

        PlayerPageProgressArea {
            id: progressArea
            opacity: audio.errorVisible ? 0.0 : 1.0
        }
    }


    //control panel
    Flow {
        id: iconButtons
        property int numberOfEntries: 5
        property int sizeOfEntries: (Theme.iconSizeLarge + spacing) * numberOfEntries - spacing;
        height: Theme.iconSizeLarge
        width: sizeOfEntries
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Theme.paddingLarge
        }

        spacing: Screen.widthRatio === 1 ? Theme.paddingSmall : 0 // jolla phone: same size, but spaced


        PlayerPageSeekButton {
            enabled: play.enabled
            opacity: play.enabled && playlist.totalPosition > options.skipDurationNormal ? 1 : 0.4
            rotation: 180
            seekBy: -options.skipDurationNormal
            icon.source: "../../assets/icon-l-ffwd.svg"
        }
        PlayerPageSeekButton {
            enabled: play.enabled
            opacity: play.enabled && playlist.totalPosition > options.skipDurationSmall ? 1 : 0.4
            rotation: 180
            seekBy: -options.skipDurationSmall
            icon.source: "../../assets/icon-l-fwd.svg"
        }

        IconButton {
            id: play
            onClicked: audio.playPause()
            enabled: page.metadataCount > 0
            height: width
            width: Theme.iconSizeLarge
            icon.source: audio.isPlaying ? "image://theme/icon-l-pause": "image://theme/icon-l-play"
        }

        PlayerPageSeekButton {
            enabled: play.enabled
            opacity: play.enabled && playlist.totalDuration - playlist.totalPosition > options.skipDurationSmall ? 1 : 0.4
            seekBy: options.skipDurationSmall
            icon.source: "../../assets/icon-l-fwd.svg"
        }
        PlayerPageSeekButton {
            enabled: play.enabled
            opacity: play.enabled && playlist.totalDuration - playlist.totalPosition > options.skipDurationNormal ? 1 : 0.4
            seekBy: options.skipDurationNormal
            icon.source: "../../assets/icon-l-ffwd.svg"
        }
    }
}
