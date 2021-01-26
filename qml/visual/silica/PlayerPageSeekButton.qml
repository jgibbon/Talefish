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

IconButton {
    id: button
    width: Theme.iconSizeLarge
    readonly property int padding: Screen.widthRatio === 1 ? 0 : Theme.paddingLarge  // jolla phone: same size
    property int seekBy
    height: width
    states: [
        State {
            name: 'landscape'
            when: page.isLandscape
            PropertyChanges {
                target: button.icon
                anchors.topMargin: button.padding
                anchors.leftMargin: button.padding / 2
            }
        }

    ]
    icon {
        width: button.width - button.padding
        height: button.height - button.padding
        anchors.centerIn: undefined
        anchors.left: button.left
        anchors.top: button.top
        anchors.leftMargin: button.padding
        anchors.topMargin: button.padding / 2
    }
    transformOrigin: Item.Center
    onClicked: {
        app.playerCommands.seekBy(seekBy)
    }
}
