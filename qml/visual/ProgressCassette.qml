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

Item {
    id:progressComponent

    width: parent.width
    height: width

    property bool indeterminate
    property bool running
    property real maximumValue: 2000
    property real minimumValue: 0
    property real value: 2000
    property bool reverseDirectionAfterHalf: true

    property string tapeColor: '#000'
    property string reelAnchorColor: '#f00b44'
    property alias tapeBackgroundColor: tape.color

    property real rotationOffset: 0

    property alias tapeWidth: tape.width
    clip: true

    // this does not care about minimumValue (performance; unused)
    property bool isSecondHalf: reverseDirectionAfterHalf && (value / maximumValue) >= 0.5
    property int animationTargetDegrees: isSecondHalf ? 360 : -360;
    property bool animationPaused: false

    onIsSecondHalfChanged: {
        animationPaused = true;
        directionChangeTimer.start();
    }

    Timer {
        id: directionChangeTimer
        interval: 3
        onTriggered: animationPaused = false
    }

    Rectangle {
        id: tape
        property real valuefactor: maximumValue > minimumValue ? (Math.min(progressComponent.value, maximumValue) - minimumValue) / (maximumValue - minimumValue) : 0 //valuepercent / 100
        anchors.centerIn: parent

        property int maxReelBorder: parent.width / 4
        property int reelWidthBase: parent.width / 2
        property int reelWidthBorder: maxReelBorder * valuefactor
//        property int reelWidthBorderNegative: maxReelBorder * (1-valuefactor)

        visible: !!border.width

        width: parent.width/2 + border.width * 2
        height: width
        color: 'transparent'
        radius: width / 2


        border.width: reelWidthBorder
        border.color: progressComponent.tapeColor
//        Behavior on border.width { NumberAnimation { duration: 1000;}}
    }

    Item {
        id: cassetteWheelRotationContainer
        width: parent.width / 2
        anchors.centerIn: parent
        height: width

        Rectangle {
            id: anchorRectangle
            width: parent.width
            height: width
            color: 'transparent'
            radius: width / 2
            border.color: progressComponent.reelAnchorColor
            border.width: parent.width / 5

            anchors.centerIn: parent
        }

        Image {
            id: cassetteWheelImage
            source: "../assets/wheel_1.svg"
            width: parent.width
            height:width
            rotation: rotationOffset
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: cassetteWheelImage.rotation
                to: cassetteWheelImage.rotation + progressComponent.animationTargetDegrees
                running: progressComponent.running && !progressComponent.animationPaused
                duration:12000
            }
        }


    }











}
