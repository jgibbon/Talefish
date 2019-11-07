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
    id: aprncArea
    //: Section Header/Button Text for Options Section
    text: qsTr("Appearance", 'section header')

    TextSwitch {
        id:playerDirectoryProgressEnabledSwitch
        //: Option Entry: Display total progress on player page
        text: qsTr('Display playlist progress')

        checked: app.options.playerDisplayDirectoryProgress
        onClicked: {
            app.options.playerDisplayDirectoryProgress = checked
        }

    }
    TextSwitch {
        id:playerSwipeNextPrevEnabledSwitch
        //: Option Entry (TextSwitch): Enable swiping album cover area (or if there is no cover, the area above track info) on player page
        text: qsTr('Swipe Cover (or above Title) to skip Tracks')

        checked: app.options.playerSwipeForNextPrev
        onClicked: {
            app.options.playerSwipeForNextPrev = checked
        }

    }

    OptionComboBox {
        //: ComboBox label: Enable a second (or third) application cover button
        label:qsTr("Additional App-Cover Actions")
        //: ComboBox description: Skip commands follow duration set with "external command duration"
        description: qsTr('App-Cover Actions are external Commands, as well.')
        optionname: 'secondaryCoverAction'
        property var secondaryCoverActionCommands : [
            //: ComboBox option: No secondary App-Cover action
            {text: qsTr('Hidden'), value: ''},
            //: ComboBox option: Skip to next track as secondary App-Cover action
            {text:qsTr('Skip forward'), value: 'next'},
            //: ComboBox option: Skip to previous track as secondary App-Cover action
            {text:qsTr('Skip backward'), value: 'prev'},
            //: ComboBox option: Skip to next and previous track as secondary/tertiary App-Cover action
            {text:qsTr('Skip backward and forward'), value: 'both'} ]
        jsonData: secondaryCoverActionCommands
    }

    SectionHeader {
        //: Section Header: 'Cassette tape' options (visible on player page and App-Cover)
        text: qsTr("Cassette tape", 'section header')
    }

    OptionComboBox {
        optionname: 'cassetteUseDirectoryDurationProgress'
        //: ComboBox label: Beginning of sentence
        label:qsTr("Cassette shows progress of")
        jsonData: [
            //: ComboBox option: "Track" as end of sentence "Cassette shows progress of…"
            {text:qsTr('track'), value: false},
            //: ComboBox option: "Playlist" as end of sentence "Cassette shows progress of…"
            {text:qsTr('playlist'), value: true} ]
    }
    TextSwitch {
        id:useAnimationEnabledSwitch
        //: Option Entry (TextSwitch): Enable (cassette) animations generally
        text: qsTr('Do Animations')
        checked: app.options.useAnimations
        onClicked: {
            app.options.useAnimations = checked
        }
    }
    TextSwitch {
        visible: useAnimationEnabledSwitch.checked
        id: playerAnimationEnabledSwitch

        //: Option Entry (TextSwitch): Enable (cassette) animations on the player page
        text: qsTr('Player Page Animation')
        width: parent.width - Theme.horizontalPageMargin - x
        x: Theme.horizontalPageMargin * 2
        checked: app.options.usePlayerAnimations
        onClicked: {
            app.options.usePlayerAnimations = checked
        }

    }

    TextSwitch {
        visible: useAnimationEnabledSwitch.checked
        id:coverAnimationEnabledSwitch
        //: Option Entry (TextSwitch): Enable (cassette) animations on the App-Cover
        text: qsTr('App-Cover Animation')
        width: parent.width - Theme.horizontalPageMargin - x
        x: Theme.horizontalPageMargin * 2
        checked: app.options.useCoverAnimations
        onClicked: {
            app.options.useCoverAnimations = checked
        }

    }


}
