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
    property bool active: Qt.application.state === Qt.ApplicationActive
    property string cwd:''
    initialPage: Component { PlayerPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
//    _defaultPageOrientations: Orientation.All
    // resources handled in c++
//    signal releaseResources();
//    signal aquireResources();
    property var js: Jslib.lib()
    property TalefishState state: TalefishState {}
    property Options options: Options {
        Component.onCompleted: {
            if(autoStartSlumber && launcher.fileExists('/usr/bin/harbour-slumber')
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
    property TalefishPlaylist playlist: TalefishPlaylist{}
    property TalefishAudio audio: TalefishAudio {
        playlist: app.playlist
    }

    Timer {
            id: saveProgressPeriodicallyTimer
            interval: 5000
            repeat: true
            running: options.saveProgressPeriodically && audio.playbackState === audio.PlayingState
            onTriggered: parent.save(['playlistProgress'])
        }

    property Launcher launcher: Launcher {}
    property var log: console.log//(options.doLog ? console.log : function(){})

    Timer {
        id: reactivateTimer
        interval: 50
        onTriggered: {
            if(Qt.application.state === Qt.ApplicationActive) {
                reactivateTimer.restart()
            } else {
                app.activate()
            }
        }
    }
//    Component.onCompleted: {
////        aquireResources()
//    }
//    Component.onDestruction: {
//        releaseResources()
//    }
//    Keys.onPressed: {

//        if (event.isAutoRepeat) {
//            return;
//        }
//        console.log('key pressed', event.key);
//        switch(event.key) {
//        case Qt.Key_Play:
//        case Qt.Key_MediaPlay:
//        case Qt.Key_MediaPlay:
//        case Qt.Key_Pause:
//            console.log('playpause');
//            break;
//        case Qt.Key_AudioForward:
//            console.log('next');
//            break;
//        case Qt.Key_AudioRewind:
//            console.log('prev');
//            break;
//        case Qt.Key_Call:
//            console.log('callbutton');
//            break;
//        }
//    }
//    property var baseNameRegex: /(.*)\.[^.]+$/
//    property var findDotRegex: /\./g
//    property var arguments: Qt.application.arguments;
//    function openFilesOnStartup(cwdOverride){
//        var workingDir = cwdOverride || cwd;
//        var arguments = app.arguments;
//        var playlistJSON = [];
//        var enqueue = false;
//        if(arguments.length < 2){
//            console.log('no files to open.');
//            return;
//        }
//        console.log('ARGS', workingDir, arguments.length, JSON.stringify(arguments));
//        for(var i = 1; i<arguments.length;i++){
//                var arg = arguments[i];
//                if(arg === "-e") {
//                    enqueue = true;
//                    console.log('enqueue!', arguments.length - 1);
//                    continue;
//                }
////
//                var abs = launcher.fileAbsolutePath(arg);
//                console.log('abs:',abs)
//                if(!launcher.fileExists((abs))){
//                    // try with cwd…
//                    // TODO make relative paths work for command line use if time permits
//                    console.log('file not found', abs, ' with cwd:', workingDir+'/'+arg);
//                    var cwdpath = launcher.fileAbsolutePath(workingDir+'/'+arg);
//                    if(launcher.fileExists(cwdpath)) {
//                        abs = cwdpath;
//                        console.log('but with cwd!', arg);
//                    } else {
//                        console.log('also not ', cwdpath);
//                        continue;
//                    }
//                } else {
//                }

//                var fileName = abs.slice(abs.lastIndexOf("/")+1);
//                var folder = abs.slice(0, abs.length-fileName.length-1);

//                var based = fileName.replace(baseNameRegex, '$1');
//                var basedFolder = folder.slice(folder.lastIndexOf("/")+1)

//                console.log('file found!', fileName)
//                  playlistJSON.push({
//                    name:based,
//                    path:abs,
//                    url:Qt.resolvedUrl(abs),
//                    baseName:based.replace(findDotRegex, ' '),
//                    suffix:'.sfx',
//                    size:0, //does that matter?
//                    //folder: folder+'',
//                    folderName: basedFolder.replace(findDotRegex, ' '),//folderName.replace(findDotRegex, ' '),
//                    title:'',
//                    playlistOffset:0,
//                    duration:0,
//                    artist:'',
//                    album:'',
//                    track:0,
//                    coverImage:''
//                })
//            }
//        console.log('tried: ', enqueue, JSON.stringify(playlistJSON));
//            if(playlistJSON.length > 0) {
//                var currentProgress = {percent:0, index:0, position:0};
//                if(playlistJSON.length === 1 && appstate.savedDirectoryProgress[playlistJSON[0].path]) {
//                    currentProgress = appstate.savedDirectoryProgress[playlistJSON[0].path];
//                }

//                var scanDialog = pageStack.push(Qt.resolvedUrl("./pages/OpenFileScanInfosDialog.qml", {enqueue: enqueue,
//                                                                   currentProgress: currentProgress}))
//                scanDialog.playlist.fromJSON(playlistJSON, enqueue);
//                scanDialog.scan();

//            }

//    }
//    onCwdChanged: { // cwd gets set from c++ anyway, so we don't need onCompleted
//        openFilesOnStartup();
//    }

//    DBusAdaptor {
//        id: dbus

//        service: 'de.gibbon.talefish'
//        iface: 'de.gibbon.talefish'
//        path: '/de/gibbon/talefish'

//        xml: '  <interface name="de.gibbon.talefish">\n' +
//             '    <method name="setArguments" >\n' +
//             '      <arg name="args" direction="in" type="a(s)"/>' +
//             '      <arg name="cwd" direction="in" type="s"/>' +
//             '    </method>' +
//             '  </interface>\n'

//        function setArguments(args, cwd) {
//            console.log("SET ARGUMENTS", typeof args, JSON.stringify(args), args.length, cwd)
//            app.arguments = (args);
//            openFilesOnStartup(cwd);
//            app.activate();
//        }
//    }
}


