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
    id: extArea
    //: Section Header: Options to control Talefish "externally": Headphone buttons, app cover etc
    text: qsTr("External control", 'section header')

    OptionComboBox {
        optionname: 'externalCommandSkipDuration'

        //: ComboBox label: Beginning of sentence
        label: qsTr('External Commands skip')
        jsonData: [
            //: ComboBox option: "to track beginning" as end of sentence "External Commands skip…"
            {text: qsTr('to track beginning'), value: '0'},
            //: ComboBox option: "Short Skip duration" as end of sentence "External Commands skip…"
            {text: qsTr('Short Skip duration'), value: 'small'},
            //: ComboBox option: "Long Skip duration" as end of sentence "External Commands skip…"
            {text: qsTr('Long Skip duration'), value: 'normal'},
        ]
        //: ComboBox description
        description: qsTr('External Commands are those executed from the lock screen or via headsets/bluetooth.')
    }

    TextSwitch {
        id:useHeadphoneCommandsSwitch
        //: Option Entry (TextSwitch)
        text: qsTr('Use head phone buttons/Bluetooth to control Talefish')

        checked: app.options.useHeadphoneCommands
        onClicked: {
            app.options.useHeadphoneCommands = checked
        }

    }
    Column {
        id: headPhoneButtonColumn

        opacity: 0
        height: 0
        states: [
            State {
                name: "active"
                when: app.options.useHeadphoneCommands
                PropertyChanges { target: headPhoneButtonColumn; height: headPhoneButtonColumn.implicitHeight; opacity: 1 }
            }
        ]

        transitions: Transition {
            NumberAnimation { properties: "height,opacity"; easing.type: Easing.InOutQuad }
        }
        width: parent.width - Theme.horizontalPageMargin - x
        x: Theme.horizontalPageMargin * 2

        Label {
            wrapMode: Text.Wrap
            x: Theme.horizontalPageMargin
            width: parent.width - Theme.horizontalPageMargin * 2
            font.pixelSize: Theme.fontSizeTiny
            //: Label
            text: qsTr('You can choose the action you prefer to be executed when pressing the "Call/Hangup" button, which often is the only button on a headset:')
        }

        property var headPhonesCommands : [
            //: ComboBox option: Do nothing on "Call button" press
            {text: qsTr('Do nothing'), value: 'nothing'},
            //: ComboBox option: Play/Pause on "Call button" press
            {text:qsTr('Play/Pause'), value: 'playPause'},
            //: ComboBox option: Next on "Call button" press
            {text:qsTr('Skip forward'), value: 'next'},
            //: ComboBox option: Previous on "Call button" press
            {text:qsTr('Skip backward'), value: 'prev'} ]


        Flow {
            width: parent.width

            property bool halfWidth: (Screen.sizeCategory >= Screen.Large || page.isLandscape)
            OptionComboBox {
                width: parent.halfWidth ? parent.width / 2 : parent.width
                enabled: app.options.useHeadphoneCommands
                optionname: 'headphoneCallButtonDoes'
                //: ComboBox label: What to do on "Call button" short press
                label:qsTr("Button Press:")
                jsonData: headPhoneButtonColumn.headPhonesCommands
            }

            OptionComboBox {
                width: parent.halfWidth ? parent.width / 2 : parent.width
                enabled: app.options.useHeadphoneCommands
                optionname: 'headphoneCallButtonLongpressDoes'
                //: ComboBox label: What to do on "Call button" long press
                label:qsTr("Long press:")
                jsonData: headPhoneButtonColumn.headPhonesCommands
            }
        }
    }

}
