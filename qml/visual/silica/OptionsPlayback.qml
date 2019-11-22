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

OptionArea {
    id: playbackArea
    //: Section Header: Playback Options
    text: qsTr("Playback", 'section header')
    expanded: true

    Slider {
        width: parent.width
        minimumValue: 0.8
        maximumValue: 1.2
        value: app.options.playbackRate
        stepSize: 0.01
        property bool isLongPressed: false
        //: Slider Label: Playback Speed in percent, %1 is replaced with the value
        label: qsTr('Playback Speed: %1\%', 'percent').arg(Math.round(value * 100))

        onPressed: {
            isLongPressed = false
        }

        onPressAndHold: {
            app.options.playbackRate = value = 1
            isLongPressed = true
        }
        onReleased: {
            if(!isLongPressed) {
                app.options.playbackRate = value
            }
            else {
                value = 1
            }
        }
        onValueChanged: {
            if(isLongPressed) {
                value = 1
            }
        }
    }
    Flow {
        width: parent.width

        property bool halfWidth: (Screen.sizeCategory >= Screen.Large || page.isLandscape)
        OptionComboBox {
            width: parent.halfWidth ? parent.width / 2 : parent.width
            optionname: 'skipDurationSmall'
            //: ComboBox label: Set the duration for "short skip" on the player page (values are in seconds; for example 30s)
            label:qsTr('Short Skip duration')
            jsonData: [{text:'10s', value: 10000}, {text:'20s', value: 20000}, {text:'30s', value: 30000}, ]
        }
        OptionComboBox {
            width: parent.halfWidth ? parent.width / 2 : parent.width
            optionname: 'skipDurationNormal'
            //: ComboBox label: Set the duration for "long skip" on the player page (values are in seconds; for example 30s)
            label:qsTr('Long Skip duration')
            jsonData: [{text:'30s', value: 30000}, {text:'45s', value: 45000}, {text:'60s', value: 60000},{text:'120s', value: 120000}, ]
        }
    }



}
