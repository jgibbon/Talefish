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

Item {
    id: progressArea
    width: parent.width
    height: childrenRect.height

    readonly property int sliderHeight: Theme.itemSizeExtraSmall
    property int sliderTopMargin: -sliderHeight * 0.2
    states: [
        State {
            name: 'small'
            when: page.isLandscape && Screen.sizeCategory !== Screen.Large && Screen.sizeCategory !== Screen.ExtraLarge

            PropertyChanges {
                target: currentPositionLabel
                font.pixelSize: Theme.fontSizeExtraSmall
            }
            PropertyChanges {
                target: progressArea
                sliderTopMargin: -sliderHeight / 3
            }
        }
    ]

    Slider {
        id: currentPositionSlider
        height: progressArea.sliderHeight
        width: parent.width
        anchors {
            top: parent.top
            topMargin:sliderTopMargin
        }

        value: app.audio.displayPosition
        minimumValue: 0
        maximumValue: app.playlist.currentMetaData.duration > 0 ? app.playlist.currentMetaData.duration : 0.1 // Audio has -1 initially

        onDownChanged: {
            if(!down)
                app.playerCommands.seek(value, app.playlist.currentIndex)
                value = Qt.binding(function() { return app.audio.displayPosition })
        }
        z:2
    }

    Label {
        id: currentPositionLabel
        color: Theme.highlightColor
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeSmall
        textFormat: Text.PlainText
        text: app.js.formatMSeconds(currentPositionSlider.value)+" / "+app.js.formatMSeconds(currentPositionSlider.maximumValue) +' ('+ (Math.floor(( currentPositionSlider.value / currentPositionSlider.maximumValue) * 1000 ) / 10)+'%)'
        anchors {
            verticalCenter: currentPositionSlider.bottom
            topMargin: -currentPositionSlider.height / 3
        }
    }
    Slider {
        id: totalPosition

        width: currentPositionSlider.width
        height: visible ? progressArea.sliderHeight : 0
        leftMargin: currentPositionSlider.leftMargin
        rightMargin: currentPositionSlider.rightMargin
        value: app.playlist.totalPosition
        visible: options.playerDisplayDirectoryProgress && app.playlist.metadata.count > 1
        opacity: Theme.colorScheme ? 0.7 : 0.5
        minimumValue: 0
        maximumValue: app.playlist.totalDuration || 0.1
        anchors {
            top: currentPositionSlider.bottom
            topMargin:sliderTopMargin / 2
        }
        enabled: false
        handleVisible: false
        highlighted: true
        Component.onCompleted: {
            // check for private api availability
            if('_backgroundItem' in totalPosition) {
                _backgroundItem.radius = Qt.binding(function(){
                    return (Theme.colorScheme ? 1.0 : 2.0)
                })
            }
        }
    }

    Label {
        id: totalPositionLabel
        color: Theme.secondaryHighlightColor
        width: parent.width
        visible: totalPosition.visible
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeExtraSmall
        textFormat: Text.PlainText
        text:  qsTr('%1 / %2 (File %L3 of %L4)', 'formatted file/directory durations, then file number/count )').arg(app.js.formatMSeconds( totalPosition.value)).arg(app.js.formatMSeconds(totalPosition.maximumValue)).arg(app.playlist.currentIndex+1).arg(app.playlist.metadata.count)
        anchors {
            verticalCenter: totalPosition.bottom
        }
    }

}
