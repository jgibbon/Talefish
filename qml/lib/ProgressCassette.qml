import QtQuick 2.0

import Sailfish.Silica 1.0

Rectangle {
    id:progressComponent

    width: parent.width
    height: width
    color: "transparent"

    property bool indeterminate
    property bool running
    property real maximumValue: 2000
    property real minimumValue: 0
    property real value: 2000

    property string tapeColor: '#000'
    property string reelAnchorColor: Theme.highlightColor
    property alias tapeBackgroundColor: tape.color


    property real rotationOffset: 0




    property alias tapeWidth: tape.width





    Rectangle {
        id: tape
        property real valuefactor: maximumValue > minimumValue ? (progressComponent.value - minimumValue) / (maximumValue - minimumValue) : 0 //valuepercent / 100
        anchors.centerIn: parent


        property int maxReelBorder: parent.width / 4

        property int reelWidthBase: parent.width / 2

        //property int reelWidth: reelWidthBase + reelWidthBorder *2



        property int reelWidthBorder: maxReelBorder * valuefactor
        property int reelWidthBorderNegative: maxReelBorder * (1-valuefactor)

        visible: !!border.width

        width: parent.width/2 + border.width * 2
        height: width
        color: 'transparent'
        radius: width / 2


        border.width: reelWidthBorder // appstate.playlist[appstate.playlistIndex] ? (( appstate.currentPosition / appstate.playlist[appstate.playlistIndex].duration) * parent.width / 2)||0 : 0
        border.color: progressComponent.tapeColor
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
                to: cassetteWheelImage.rotation-360
                running: progressComponent.running
                duration:12000
            }
        }


    }











}
