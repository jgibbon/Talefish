import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0

import Launcher 1.0
import TaglibPlugin 1.0
import "pages"
import "lib"

ApplicationWindow
{
    id: app
    property string cwd:''
    initialPage: Component { PlayerPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
    property Launcher launcher: launcher
    property var log: (options.doLog ? console.log : function(){})
    function isBetweenTimes(start, end) {
        var current = new Date();
        current.setFullYear(1970);
        current.setMonth(0,1);

        start.setFullYear(1970);
        start.setMonth(0,1);
        end.setFullYear(1970);
        end.setMonth(0,1);
        var timeIsRight;
        if(end < start) {
            //assume 'before' is next day
            timeIsRight = current > start || current < end
        } else {
            timeIsRight = current > start && current < end
        }
        app.log('Are we in the time frame for starting slumber?', timeIsRight)
        return timeIsRight;
    }

    Options {
        id: options
        Component.onCompleted: {
            if(autoStartSlumber && launcher.fileExists('/usr/bin/harbour-slumber')
                    && (!autoStartSlumberInTimeframe || isBetweenTimes(autoStartSlumberAfterTime, autoStartSlumberBeforeTime))) {
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
        id: reactivateTimer
        interval: 50
        onTriggered: {
            if(Qt.application.state == Qt.ApplicationActive) {
                reactivateTimer.restart()
            } else {
                app.activate()
            }
        }
    }

    Appstate {
        id: appstate
    }


    function formatMSeconds (duration) {
        var dur = duration / 1000,
                hours =  Math.floor(dur /3600),
                minutes =  Math.floor((dur - hours * 3600) / 60),
                seconds = Math.floor(dur - (hours * 3600) - minutes * 60);

        return (hours?(hours+':'):'')+ ("0"+minutes).slice(-2) + ':' + ("0"+seconds).slice(-2);
    }
    Launcher {
        id: launcher
    }
    property var baseNameRegex: /(.*)\.[^.]+$/
    property var findDotRegex: /\./g
    property var arguments: Qt.application.arguments;
    function openFilesOnStartup(cwdOverride){
        var workingDir = cwdOverride || cwd;
        var arguments = app.arguments;
        var playlistJSON = [];
        var enqueue = false;
        if(arguments.length < 2){
            console.log('no files to open.');
            return;
        }
        console.log('ARGS', workingDir, arguments.length, JSON.stringify(arguments));
        for(var i = 1; i<arguments.length;i++){
                var arg = arguments[i];
                if(arg === "-e") {
                    enqueue = true;
                    console.log('enqueue!', arguments.length - 1);
                    continue;
                }
//
                var abs = launcher.fileAbsolutePath(arg);
                console.log('abs:',abs)
                if(!launcher.fileExists((abs))){
                    // try with cwd…
                    // TODO make relative paths work for command line use if time permits
                    console.log('file not found', abs, ' with cwd:', workingDir+'/'+arg);
                    var cwdpath = launcher.fileAbsolutePath(workingDir+'/'+arg);
                    if(launcher.fileExists(cwdpath)) {
                        abs = cwdpath;
                        console.log('but with cwd!', arg);
                    } else {
                        console.log('also not ', cwdpath);
                        continue;
                    }
                } else {
                }

                var fileName = abs.slice(abs.lastIndexOf("/")+1);
                var folder = abs.slice(0, abs.length-fileName.length-1);

                var based = fileName.replace(baseNameRegex, '$1');
                var basedFolder = folder.slice(folder.lastIndexOf("/")+1)

                console.log('file found!', fileName)
                  playlistJSON.push({
                    name:based,
                    path:abs,
                    url:Qt.resolvedUrl(abs),
                    baseName:based.replace(findDotRegex, ' '),
                    suffix:'.sfx',
                    size:0, //does that matter?
                    //folder: folder+'',
                    folderName: basedFolder.replace(findDotRegex, ' '),//folderName.replace(findDotRegex, ' '),
                    title:'',
                    playlistOffset:0,
                    duration:0,
                    artist:'',
                    album:'',
                    track:0,
                    coverImage:''
                })
            }
        console.log('tried: ', enqueue, JSON.stringify(playlistJSON));
            if(playlistJSON.length > 0) {
                var currentProgress = {percent:0, index:0, position:0};
                if(playlistJSON.length === 1 && appstate.savedDirectoryProgress[playlistJSON[0].path]) {
                    currentProgress = appstate.savedDirectoryProgress[playlistJSON[0].path];
                }

                var scanDialog = pageStack.push(Qt.resolvedUrl("./pages/OpenFileScanInfosDialog.qml", {enqueue: enqueue,
                                                                   currentProgress: currentProgress}))
                scanDialog.playlist.fromJSON(playlistJSON, enqueue);
                scanDialog.scan();

            }

    }
    onCwdChanged: { // cwd gets set from c++ anyway, so we don't need onCompleted
        openFilesOnStartup();
    }

    DBusAdaptor {
        id: dbus

        service: 'de.gibbon.talefish'
        iface: 'de.gibbon.talefish'
        path: '/de/gibbon/talefish'

        xml: '  <interface name="de.gibbon.talefish">\n' +
             '    <method name="setArguments" >\n' +
             '      <arg name="args" direction="in" type="a(s)"/>' +
             '      <arg name="cwd" direction="in" type="s"/>' +
             '    </method>' +
             '  </interface>\n'

        function setArguments(args, cwd) {
            console.log("SET ARGUMENTS", typeof args, JSON.stringify(args), args.length, cwd)
            app.arguments = (args);
            openFilesOnStartup(cwd);
            app.activate();
        }
    }
}


