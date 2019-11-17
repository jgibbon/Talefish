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
ProgressBar {
    property string path
    property var progress: visible ? app.state.playlistProgress[path] : {}
    visible: path && path in app.state.playlistProgress
    height: visible ? implicitHeight : 0
    width: parent.width
    minimumValue: 0
    maximumValue: progress.totalDuration || 1
    value: progress.totalPosition || 0.5

}
