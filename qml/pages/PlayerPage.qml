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
import QtMultimedia 5.0
import QtGraphicalEffects 1.0
import QtFeedback 5.0

import '../lib'
import '../visual'
import '../visual/silica'

Page {
    id: page
    objectName: 'playerPage' // to find this page easily (coverActionEmpty)
    allowedOrientations: Orientation.All

    // cache those for reduced lookups too app scope
    property TalefishAudio audio
    property TalefishPlaylist playlist
    property int metadataCount: playlist.metadata.count

    SilicaFlickable {
        anchors.fill: parent
        id: mainFlickable
        PullDownMenu {
            id: pulleyTop
            MenuItem {
                //: MenuItem: Go to Options Page
                text: qsTr('Options', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("OptionsPage.qml"), {});
                }
            }
            MenuItem {
                visible: page.metadataCount > 1
                //: MenuItem: Go to Playlist Page
                text: qsTr('Playlist', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("PlaylistPage.qml"), {});
                }
            }

            MenuItem {
                //: MenuItem: Go to "Open Files" (Places) Page
                text: qsTr("Open", 'pulley')
                onClicked:
                    pageStack.push(Qt.resolvedUrl("OpenPage.qml"), {});
            }

        }

        PageHeader {
            id: mainPageHeader
            //align right in portrait or when the page is high enough
            width: parent.width - ( page.isLandscape && ((page.height - iconButtons.height)/2 < mainPageHeader.height - Theme.paddingMedium) ? controlPanel.width + Theme.paddingLarge : 0)
            title: 'Talefish'
        }
        PageHeader { // Overlay white PageHeader where it's hidden by cassette progress
            id: mainPageHeaderMasked
            anchors.fill: mainPageHeader
            title: mainPageHeader.title
            visible: false


            Component.onCompleted: { // titleColor was added in SFOS 3.1, everyone else get's a custom shader below
                if('titleColor' in mainPageHeaderMasked) {
                    titleColor = 'white'
                }
            }
        }

        Item {
            id: headerMask
            anchors.fill: mainPageHeader

            ProgressCassette {
                id:cassette
                width: Math.min( page.width, page.height) * 2
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
        Loader {
            sourceComponent: Component {
                id: titleMaskComponent
                OpacityMask {
                    width: mainPageHeaderMasked.width
                    height: mainPageHeaderMasked.height
                    source: mainPageHeaderMasked
                    maskSource: headerMask

                    // fallback for SFOS < 3.1 (no titleColor in PageHeader)
                    layer.enabled: !('titleColor' in mainPageHeaderMasked)
                    layer.effect: ShaderEffect {
                        property color color:  "white"

                        fragmentShader: "
                                    varying mediump vec2 qt_TexCoord0;
                                    uniform highp float qt_Opacity;
                                    uniform lowp sampler2D source;
                                    uniform highp vec4 color;
                                    void main() {
                                        highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                                        gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                                    }
                                "
                    }
                    layer.samplerName: "source"
                }
            }
            active: app.active
        }


        Item {
            id: coverImageContainer

            width: parent.width - (page.isLandscape ? controlPanel.width + controlPanel.anchors.rightMargin : 0)
            y:page.isPortrait ? mainPageHeader.height : 0
            height: parent.height - progressArea.height - primaryLabel.height - (page.isPortrait ? controlPanel.height + mainPageHeader.height : 0)

            FadeImage {
                id: coverImage
                source: 'image://taglib-cover-art/'+playlist.currentMetaData.path
                anchors.fill: parent
                asynchronous: true

                fillMode: Image.PreserveAspectFit
                verticalAlignment: Image.AlignTop
                horizontalAlignment: Image.AlignHCenter
                // leads to re-process when resizing (mostly swiping back with search/vkb in playlist), but may be acceptable:
                sourceSize {
                    width: coverImage.width
                    height: coverImage.height
                }
            }

            NumberAnimation on x {
                id: animateCoverContainerXBack0
                to: 0
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }


        OpacityRampEffect {
            id: effect
            property double factor: 0.6 * (coverImageContainer.height) / (infoColumn.height - progressArea.height)
            clampMax: 0.7
            clampMin: 0.2
            direction: OpacityRamp.TopToBottom
            offset: 1-(1/factor)
            slope: factor * 1.3 //* 0.9//1 //the more, the shorter
            sourceItem: coverImageContainer
        }



        TouchInteractionHint {
            id: hint
            property bool shouldBeRunning: page.metadataCount === 0
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

            property int maxDrag: Theme.itemSizeLarge
            visible: options.playerSwipeForNextPrev && (page.metadataCount > 1 || audio.displayPosition > options.skipBackTrackThreshold)
            property bool sideTriggerActive: false
            property alias target: coverImageContainer
            anchors.fill: target
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
                animateCoverContainerXBack0.duration =  (dragValue / maxDrag) * 400
                animateCoverContainerXBack0.start()
                if(sideTriggerActive){
                    console.log('Player Page: Slided to skip' )


                    sideTriggerActive = false;
                    if(target.x < 0){//next
                        playlist.currentIndex = playlist.currentIndex + 1;
                    } else if(target.x > 0) {//prev
                        if(audio.displayPosition > options.skipBackTrackThreshold) {
                            audio.seek(0)
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

            property int dragValue: Math.abs(target.x)
            property real dragFactor: maxDrag / dragValue
            Item {
                id: coverDraggedLabelContainer
                height: parent.height
                width: parent.width
                visible: coverMouseArea.dragValue > coverMouseArea.maxDrag * 0.5
                opacity: coverMouseArea.sideTriggerActive ? 1.0:0.0

                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}

                Rectangle{
                    id: coverDragRect
                    color: Qt.rgba(Theme.highlightDimmerColor.r, Theme.highlightDimmerColor.g, Theme.highlightDimmerColor.b, 0.85)
                    height: parent.height
                    width: parent.width // + parent.maxDrag*2
                    x:( -coverMouseArea.target.x )
                }

                OpacityRampEffect {
                    sourceItem: coverDragRect
                    direction: coverMouseArea.target.x > 0 ? OpacityRamp.RightToLeft: OpacityRamp.LeftToRight
                    offset: 0.0//-0.5 * coverMouseArea.dragFactor
                    slope: parent.opacity * 0.8//coverMouseArea.sideTriggerActive ? 1.0 : 1.0
                }


                Label {
                    color: Theme.primaryColor//Theme.highlightColor
                    height: parent.height
                    width: parent.width - (Theme.paddingSmall * 2)
                    horizontalAlignment: coverMouseArea.target.x > 0 ? Text.AlignRight: Text.AlignLeft // Text.AlignHCenter
                    text: coverMouseArea.target.x > 0 ? (audio.displayPosition > options.skipBackTrackThreshold? qsTr('Rewind Track'): qsTr('Previous Track')): qsTr('Next Track')
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    x: (-coverMouseArea.target.x ) + Theme.paddingSmall
                    textFormat: Text.PlainText
                }
            }
            Item {
                id: draggableContainer
                x: -coverMouseArea.target.x

                width: parent.width// + (coverMouseArea.drag.maximumX  ) + (-coverMouseArea.drag.minimumX)
                height: parent.height
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
                        width: parent.width
                        height: parent.height

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
                        height: parent.height
                        width: parent.width
                        anchors.right: parent.right
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

        Item {
            id: column
            anchors.fill: parent
            anchors.rightMargin: page.isLandscape ? Theme.iconSizeLarge + Theme.horizontalPageMargin : 0


            Column {
                id: infoColumn
                opacity: page.metadataCount > 0 ? 1 : 0
                width: parent.width

                anchors.bottom: parent.bottom
                anchors.bottomMargin: page.isPortrait? controlPanel.height + controlPanel.anchors.bottomMargin : 0//Theme.paddingMedium
                    Label {
                        id: primaryLabel
                        color: Theme.highlightColor
                        fontSizeMode: Text.HorizontalFit
                        horizontalAlignment: Text.AlignHCenter
                        minimumPixelSize: Theme.fontSizeMedium
                        style: Theme.colorScheme ? Text.Raised : Text.Normal
                        styleColor: '#FFFFFF'
                        text: playlist.currentTitle
                        verticalAlignment: Text.AlignBottom//Text.AlignVCenter
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


        }

        //control panel

        Item {
            id: controlPanel
            height: page.isPortrait ? Theme.iconSizeLarge : parent.height
            width: page.isPortrait ? parent.width : Theme.iconSizeLarge
            anchors.bottom: parent.bottom
            anchors.bottomMargin: page.isPortrait ? Theme.paddingLarge : 0
            anchors.right: parent.right
            anchors.rightMargin: page.isLandscape ? Theme.horizontalPageMargin : 0


            Flow {
                id:iconButtons
                property int numberOfEntries: 5
                property int sizeOfEntries: (Theme.iconSizeLarge + spacing) * numberOfEntries - spacing;
                height: page.isLandscape ? sizeOfEntries : (Theme.iconSizeLarge)
                width: page.isPortrait ? sizeOfEntries : Theme.iconSizeLarge
                spacing: Screen.widthRatio === 1 ? Theme.paddingSmall : 0 // jolla phone: same size, but spaced
                anchors.centerIn: parent

                PlayerPageSeekButton {
                    enabled: play.enabled
                    opacity: play.enabled && playlist.totalPosition > options.skipDurationNormal ? 1 : 0.4
                    rotation: 180
                    seekBy: -options.skipDurationNormal
                    icon.source: "../assets/icon-l-ffwd.svg"
                }
                PlayerPageSeekButton {
                    enabled: play.enabled
                    opacity: play.enabled && playlist.totalPosition > options.skipDurationSmall ? 1 : 0.4
                    rotation: 180
                    seekBy: -options.skipDurationSmall
                    icon.source: "../assets/icon-l-fwd.svg"
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
                    icon.source: "../assets/icon-l-fwd.svg"
                }
                PlayerPageSeekButton {
                    enabled: play.enabled
                    opacity: play.enabled && playlist.totalDuration - playlist.totalPosition > options.skipDurationNormal ? 1 : 0.4
                    seekBy: options.skipDurationNormal
                    icon.source: "../assets/icon-l-ffwd.svg"
                }
            }
        }
    }
}
