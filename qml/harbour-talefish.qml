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
import Nemo.DBus 2.0

import Launcher 1.0
import TaglibPlugin 1.0
import "pages"
import "lib"
import "lib/Jslib.js" as Jslib

ApplicationWindow
{
    id: app
    initialPage: Component { PlayerPage { audio: app.audio; playlist: app.playlist } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: defaultAllowedOrientations // workaround for a Silica ComboBox bug in Landscape, see https://together.jolla.com/question/49831/
    readonly property bool active: Qt.application.state === Qt.ApplicationActive
    readonly property var js: Jslib.lib()

    property var allowedFileExtensions // set via c++; used by directory list
    property bool commandLineArgumentDoEnqueue
    property var commandLineArgumentFilesToOpen
    onCommandLineArgumentFilesToOpenChanged: {
        // this should be set when state isn't loaded yet (and handled in state load), but just in case:
        if(state._loaded) {
            app.playlist.fromJSON(commandLineArgumentFilesToOpen, commandLineArgumentDoEnqueue);
        }
    }

    readonly property Launcher launcher: Launcher {}
    readonly property TalefishAudio audio: TalefishAudio { playlist: app.playlist }
    readonly property TalefishPlaylist playlist: TalefishPlaylist { audio: app.audio }
    readonly property PlayerCommands playerCommands: PlayerCommands {audio: app.audio; playlist: app.playlist}
    readonly property TalefishState state: TalefishState {}
    readonly property Options options: Options {
        Component.onCompleted: {
            if(options._loaded && autoStartSlumber && launcher.fileExists('/usr/bin/harbour-slumber')
                    && (!autoStartSlumberInTimeframe || js.isBetweenTimes(autoStartSlumberAfterTime, autoStartSlumberBeforeTime))) {
                if(launcher.launch('ps -C harbour-slumber').indexOf('harbour-slumber') === -1) {
                    console.log('slumber does not seem to be running');
                    launcher.launchAndForget('/usr/bin/harbour-slumber', []);
                    if(autoStartSlumberAndRefocusTalefish) {
                        reactivateTimer.start();
                    }
                } else {
                    console.log('slumber already running');
                }
            }
        }
    }

    Timer {
        id: autoSaveProgressPeriodicallyTimer
        interval: 10000
        repeat: true
        running: options.autoSaveProgressPeriodically && audio.isPlaying
        onTriggered: {
            playlist.saveCurrentPosition();
            app.state.saveKey('playlistProgress')
        }
    }

    Timer {
        id: reactivateTimer
        interval: 50
        onTriggered: {
            if(app.active) {
                reactivateTimer.restart()
            } else {
                app.activate()
            }
        }
    }

    DBusAdaptor {
        id: dbus

        service: 'de.gibbon.talefish'
        iface: 'de.gibbon.talefish'
        path: '/de/gibbon/talefish'

        xml: '  <interface name="de.gibbon.talefish">\n' +
             '    <method name="openFiles" >\n' +
             '      <arg name="files" direction="in" type="a(s)"/>' +
             '      <arg name="enqueue" direction="in" type="b"/>' +
             '    </method>' +
             '  </interface>\n'

        function openFiles(files, enqueue) {
            app.playlist.fromJSON(files,enqueue);
            app.activate();
        }
    }
}


