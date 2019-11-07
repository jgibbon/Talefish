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
    id: miscArea
    //: Section Header: Miscellaneous options
    text: qsTr("Miscellaneous", 'section header')

    Label {
        width: parent.width - Theme.horizontalPageMargin * 2
        x: Theme.horizontalPageMargin
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.highlightColor
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        //: Label text describing the reset & quit button
        text: qsTr('For debugging purposes, it is sometimes useful to reset all options and application states to default. You will hopefully never need this.')
    }

    Button {
        //: Button Text: Reset all options/application state and quit
        text: qsTr('Reset & Quit')
        x: Theme.horizontalPageMargin
        onClicked: {
            app.state.reset();
            app.options.reset();
            Qt.quit();
        }
    }
}
