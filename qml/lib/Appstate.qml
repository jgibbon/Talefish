import QtQuick 2.0
Item {
    id: appstate

    property QtObject persistent: persistentObj
    property Playlist playlist: pl
    property alias player: tplayer.player
    property alias tplayer: tplayer

    property alias lastDirectory: persistentObj.lastDirectory
    property alias currentPosition: persistentObj.currentPosition
    onCurrentPositionChanged: {
        if(currentPosition>0 && tplayer.isplaying && playlistActive && player.source != ''){
            if(playlistActive.folder === playlist.get(0).folder)  {
            var dirprogress = savedDirectoryProgress;

            dirprogress[playlistActive.folder.replace('file://', '')] = {
                percent: ((currentPosition + playlistActive.playlistOffset) * 100)/playlist.duration,
                index: playlistIndex,
                position: currentPosition,
                lastAccess: new Date().getTime()
            }
            savedDirectoryProgress = dirprogress;
            } else {
                //current file was enqueued
            }
        }
    }

    property alias coverActionCommand: persistentObj.coverActionCommand
    property alias playlistIndex: persistentObj.playlistIndex
    property alias playlistDuration: persistentObj.playlistDuration
    property alias savedDirectoryProgress: persistentObj.savedDirectoryProgress

    onPlaylistIndexChanged:  updatePlaylistActive()

    property var playlistActive: (updatePlaylistActive(false))

    function updatePlaylistActive(set){
        var a = {coverImage:'', path:'', baseName:'', name:'', url:'', suffix:'', size:'', folder:'', duration:0.0, artist:'', playlistOffset:'', title:'', coverImage:'', folderName:''}
        if(playlistIndex > -1 && playlist.count > playlistIndex){
            a = playlist.get(playlistIndex);
        }
        if(set !== false){
            playlistActive = a;
        }
        return a;
    }
    Playlist {
        id: pl
        onCountChanged: {
            if(getActiveOnChange){
                updatePlaylistActive()
            }
        }
    }
    TalefishPlayer {
        id: tplayer
    }


    Timer {
        id: saveProgressPeriodicallyTimer
        interval: 5000
        repeat: true
        running: options.saveProgressPeriodically && tplayer.player.isPlaying
        onTriggered: persistentObj.save()
    }

    property bool allDBsLoaded: persistentObj._loaded && options._loaded
    onAllDBsLoadedChanged: {
        var keepDays = options.keepUnopenedDirectoryProgressDays,
            keepMs = keepDays * 24 * 360000;

        if(keepDays < 9999) {
            var progress = {}
            var now = new Date().getTime();
            app.log('checking for obsolete directory progress');
            for(var dir in savedDirectoryProgress) {
                var el = savedDirectoryProgress[dir];
                if(!el.lastAccess) { //compatibility with older versions. remove at some point.
                    app.log('progress: last access not saved, setting to now', dir);
                    el.lastAccess = now;
                }
                var diff = now - el.lastAccess;
                if(diff < keepMs){
                    app.log('keeping progress for ', dir);
                    progress[dir] = el;
                } else {
                    app.log('removing progress for ', dir);
                }
            }
            savedDirectoryProgress = progress;
        }


    }

    PersistentObject {
        id: persistentObj

        objectName: 'appstate'
        //        storeSettings: ['Talefish','1.0','Appstate']

        property real currentPosition:0
        property string coverActionCommand: ''
        property string lastDirectory: ''
        property var playlistJS: []
        property int playlistIndex:-1
        property int playlistDuration: appstate.playlist.duration
        property var savedDirectoryProgress: ({})
        onPlaylistJSChanged: {
            playlist.fromJSON(persistentObj.playlistJS);
        }

    }
    Component.onDestruction: { // hopefully before destruction of persistentObj :)
        persistentObj.playlistJS = appstate.playlist.toJSON();
    }
    Component.onCompleted: {
        playlist.fromJSON(persistentObj.playlistJS);
    }
}
