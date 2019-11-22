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
    id: timerArea
    //: Section Header: Sleep timer options (for starting "slumber" automatically)
    text: qsTr("Sleep timer integration", 'section header')

    Item {
        width: parent.width - Theme.horizontalPageMargin*2
        x: Theme.horizontalPageMargin
        height: installSlumberLabel.height
        Icon {
            id: installSlumberIcon
            source: 'image://theme/icon-s-high-importance'
            anchors.verticalCenter: parent.verticalCenter
            highlighted: true
        }

        Label {
            id: installSlumberLabel
            visible: !autoStartSlumberSwitch.enabled
            //: Label: Shown if "slumber" isn't installed
            text: qsTr('Install the slumber sleep timer application to enable these options')
            color: Theme.highlightColor
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            anchors {
                left: installSlumberIcon.right
                leftMargin: Theme.paddingMedium
                right: parent.right
            }
        }

    }

    OptionComboBox {
        enabled: autoStartSlumberSwitch.enabled
        optionname: 'slumberPauseRewindDuration'

        //: ComboBox label
        label: qsTr('Rewind when paused by slumber:')
        jsonData: [
            //: ComboBox option: no, do not rewind when paused by slumber
            {text: qsTr('no'), value: '0'},
            //: ComboBox option: skip back the duration set as "short" when paused by slumber
            {text: qsTr('Short Skip duration'), value: 'small'},
            //: ComboBox option: skip back the duration set as "long" when paused by slumber
            {text: qsTr('Long Skip duration'), value: 'normal'},
            //: ComboBox option: skip back double the duration set as "long" when paused by slumber
            {text: qsTr('Double Long Skip duration'), value: 'long'},
        ]
    }
    TextSwitch {
        id:autoStartSlumberSwitch
        enabled: app.launcher.fileExists('/usr/bin/harbour-slumber')
        //: Option Entry (TextSwitch)
        text: qsTr('Launch sleep timer automatically')

        checked: app.options.autoStartSlumber
        onClicked: {
            app.options.autoStartSlumber = checked
        }
        //: Option Entry (TextSwitch) description text
        description: qsTr('Launch the slumber sleep timer application automatically when starting Talefish.')
    }
    TextSwitch {
        id:autoStartSlumberAndRefocusTalefishSwitch
        enabled: autoStartSlumberSwitch.enabled && autoStartSlumberSwitch.checked

        //: Option Entry (TextSwitch)
        text: qsTr('Bring Talefish to foreground again after launching slumber')

        checked: app.options.autoStartSlumberAndRefocusTalefish
        onClicked: {
            app.options.autoStartSlumberAndRefocusTalefish = checked
        }
    }

    TextSwitch {
        id: autoStartSlumberInTimeframeSwitch
        //: Option Entry (TextSwitch)
        text: qsTr('Only launch slumber at certain times')
        enabled: autoStartSlumberSwitch.enabled && autoStartSlumberSwitch.checked
        checked: app.options.autoStartSlumberInTimeframe
        onClicked: {
            app.options.autoStartSlumberInTimeframe = checked
        }
    }

    Flow {
        id: launchTimesFlow
        width: parent.width

        states: [
            State {
                name: 'visible'
                when: autoStartSlumberInTimeframeSwitch.checked
                PropertyChanges { target: launchTimesFlow; height: launchAfterSwitch.height + launchBeforeSwitch.height ; opacity:1 }
            },
            State {
                name: 'hidden'
                when: !autoStartSlumberInTimeframeSwitch.checked
                PropertyChanges { target: launchTimesFlow; height: 0; opacity:0 }
            }
        ]
        transitions: Transition {
            PropertyAnimation { properties: "height,opacity"; easing.type: Easing.InOutQuad }
        }

        property bool halfWidth: (Screen.sizeCategory >= Screen.Large || page.isLandscape)
        ValueButton {
            id: launchAfterSwitch

            //: ComboBox/ValueButton label: Launch slumber application only after "X o'clock" (starts time picker after click)
            label: qsTr("Launch slumber after")
            enabled: autoStartSlumberInTimeframeSwitch.checked
            value: Format.formatDate(app.options.autoStartSlumberAfterTime, Formatter.TimeValue)
            width: parent.halfWidth ? parent.width / 2 : parent.width
            onClicked: {
                console.log( app.options.autoStartSlumberAfterTime.getHours(), app.options.autoStartSlumberAfterTime.getMinutes());
                var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                hour: app.options.autoStartSlumberAfterTime.getHours(),
                                                minute: app.options.autoStartSlumberAfterTime.getMinutes()
                                            })
                dialog.accepted.connect(function() {
                    app.options.autoStartSlumberAfterTime = dialog.time;
                })
            }
        }

        ValueButton {
            id: launchBeforeSwitch
            //: ComboBox/ValueButton label: Launch slumber application only before "X o'clock" (starts time picker after click)
            label: qsTr("Launch slumber before")
            enabled: autoStartSlumberInTimeframeSwitch.checked
            value: Format.formatDate(app.options.autoStartSlumberBeforeTime, Formatter.TimeValue)
            width: parent.halfWidth ? parent.width / 2 : parent.width
            onClicked: {
                var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                hour: app.options.autoStartSlumberBeforeTime.getHours(),
                                                minute: app.options.autoStartSlumberBeforeTime.getMinutes()
                                            })
                dialog.accepted.connect(function() {
                    app.options.autoStartSlumberBeforeTime = dialog.time;
                })
            }
        }

    }

}
