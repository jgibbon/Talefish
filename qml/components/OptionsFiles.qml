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
    id: opnArea
    //: Section Header: Options for file handling and saved directory progress
    text: qsTr("Open Files", 'section header')

    TextSwitch {
        id:placesAutoShowRecentDirectorySwitch
        //: Option Entry (TextSwitch)
        text: qsTr('Automatically display most recent directory')
        checked: app.options.placesAutoShowRecentDirectory
        onClicked: {
            app.options.placesAutoShowRecentDirectory = checked
        }
    }
    TextSwitch {
        //: Option Entry (TextSwitch)
        text: qsTr('Remember sort mode')
        checked: app.options.placesRememberSort
        onClicked: {
            app.options.placesRememberSort = checked
        }
    }

    TextSwitch {
        //: Option Entry (TextSwitch)
        text: qsTr('Remember enqueue mode')
        checked: app.options.placesRememberEnqueue
        onClicked: {
            app.options.placesRememberEnqueue = checked
        }
    }

    TextSwitch {
        id:saveProgressPeriodicallySwitch
        //: Option Entry (TextSwitch)
        text: qsTr('Save progress periodically')
        //: Option Entry (TextSwitch) description for "Save progress periodically"
        description: qsTr('If disabled, the current playback state will only be saved when the app cleanly exits. Otherwise, It will save the progress every few seconds.')

        checked: app.options.saveProgressPeriodically
        onClicked: {
            app.options.saveProgressPeriodically = checked
        }
    }

    OptionComboBox {
        optionname: 'keepUnopenedDirectoryProgressDays'
        //: ComboBox label: Beginning of sentence "Keep directory progress for X days"
        label:qsTr("Keep directory progress")
        jsonData: [
            {text:qsTr('for %1 day(s)', 'keep progress for x days', 1).arg(1), value: 1},
            {text:qsTr('for %1 day(s)', 'keep progress for x days', 10).arg(10), value: 10},
            {text:qsTr('for %1 day(s)', 'keep progress for x days', 30).arg(30), value: 30},
            {text:qsTr('for %1 day(s)', 'keep progress for x days', 50).arg(50), value: 50},
            {text:qsTr('for %1 day(s)', 'keep progress for x days', 100).arg(100), value: 100},
            {text:qsTr('forever', 'keep progress forever'), value: 9999}
        ]
        //: ComboBox description for "Keep directory progress"
        description: qsTr('To prevent cached data for old or even deleted directories to accumulate over time, Talefish will check for old entries at application start. This will not affect the currently loaded directory.')
    }


}
