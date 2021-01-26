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

import '../lib'
import '../visual'
import '../visual/silica'

Page {
    id: page
    objectName: 'playerPage' // to find this page easily (coverActionEmpty)
    allowedOrientations: Orientation.All

    // cache those for reduced lookups too app scope
    property TalefishAudio audio
    property TalefishPlaylist playlist
    readonly property int metadataCount: playlist.metadata.count

    SilicaFlickable {
        id: mainFlickable
        anchors.fill: parent
        contentHeight: height
        contentWidth: width
        PullDownMenu {
            id: pulleyTop
            MenuItem {
                //: MenuItem: Go to Options Page
                text: qsTr('Options', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("OptionsPage.qml"), {});
                }
            }
            MenuItem {
                visible: page.metadataCount > 1
                //: MenuItem: Go to Playlist Page
                text: qsTr('Playlist', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("PlaylistPage.qml"), {});
                }
            }

            MenuItem {
                //: MenuItem: Go to "Open Files" (Places) Page
                text: qsTr("Open", 'pulley')
                onClicked:
                    pageStack.push(Qt.resolvedUrl("OpenPage.qml"), {});
            }

        }


        Loader {
            active: app.active
            anchors.fill: parent
            opacity: status === Loader.Ready ? 1.0 : 0.0
            Behavior on opacity { FadeAnimator {} }
            source: Qt.resolvedUrl("../visual/silica/PlayerPageContent.qml");
        }

    }
}
