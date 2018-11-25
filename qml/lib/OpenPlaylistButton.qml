import QtQuick 2.0

import Sailfish.Silica 1.0
import '../lib'



Button {
    id: scanButton
    text: 'open'
    property bool enqueue: false
    property string directoryCover:''

    property bool willScan: false
    property bool isDone: false
    property var coverArray:[]

    property var currentProgress : ({percent:0, index:-1, position:0})

    Playlist {
        id: playlist

    }

    function openDirectoryDialog(){
        app.log('open directory input');
        var directoryDialog = pageStack.push("../lib/FolderSelector.qml", {
                                                 //value: options.directory,
                                                 title: 'Enter Path',
                                                 enqueue: scanButton.enqueue
                                             });
        if(directoryDialog){
            directoryDialog.accepted.connect(function() {
                var v = directoryDialog.value,
                        i = 0
                playlist.clear();
                scanButton.coverArray = directoryDialog.coverArray;
                while(i < v.count){
                    var item = v.get(i);
                    //todo: search for individual cover images?
                    item.coverImage = directoryDialog.coverUrl;
                    playlist.append(item);
                    i++;
                }
                if(directoryDialog.sortByNameAsc && options.resortNaturally) {
                    playlist.sortNaturally();
                }
                currentProgress = directoryDialog.currentProgress;
                appstate.lastDirectory = directoryDialog.folderModel.folder;
                willScan = true
                rescanTimer.start();
            });

        } else {
            directoryTimer.start();
        }

    }
    Timer {
        id: directoryTimer
        interval: 501

        onTriggered: {
            openDirectoryDialog();
        }
    }
    Timer {
        id: rescanTimer
        interval: 501
        onTriggered: {
            willScan = false
            var scanDialog = pageStack.push("../lib/scanDialog.qml", {
                                                //value: options.directory,
                                                playlist: playlist,
                                                scanCoverForFilenames: options.scanCoverForFilenames,
                                                coverArray: coverArray,
                                                log: log
                                            });
            if(scanDialog === null){ // Warning: cannot push while transition is in progress
                restart();
                return;
            }

            scanDialog.accepted.connect(function(){

                playback.pause();

                appstate.playlist.fromJSON(playlist.toJSON(), scanButton.enqueue);

                if(appstate.playlist.count > 0){

                    app.log('current progress', currentProgress.index, currentProgress.position)
                    if(currentProgress && currentProgress.index > -1 && currentProgress.position > 0){
                        app.log('setting progress to saved')
                        appstate.playlistIndex = currentProgress.index;
                        appstate.currentPosition = currentProgress.position;
                        playOffset.start();
                    }else {
                        if(!currentProgress ){
                            app.log('currentprogress unset, setting to 0');
                            currentProgress = {percent:0, index:0, position:0};
                        }
                        app.log('setting progress to 0')
                        appstate.currentPosition = 0;
                        currentProgress.index = 0;
                        currentProgress.position = 0;


                        appstate.playlistIndex = 0;
                        appstate.currentPosition = 0;

                        playOffset.start();
                    }
                } else {
                    app.log('empty pl');
                    appstate.playlistIndex = -1;
                    appstate.currentPosition = 0;

                    currentProgress.position = 0;
                    currentProgress.index = -1;
                }
                appstate.player.seek(currentProgress.position);
            });
            isDone = true;
        }
    }
    Timer {
        id: playOffset
        interval: 200
        onTriggered: {
            if(currentProgress && currentProgress.index > -1 && currentProgress.position) {
                app.log('play offset…', currentProgress.position)
                appstate.tplayer.playPause();
                appstate.tplayer.playPause();
            }
        }
    }

    onClicked: openDirectoryDialog()
}
