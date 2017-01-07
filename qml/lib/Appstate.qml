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
                position: currentPosition
            }
            savedDirectoryProgress = dirprogress;
            } else {

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
        running: options.saveProgressPeriodically && tplayer.isplaying
        onTriggered: persistentObj.save()
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
            //            console.log('onPlaylistJSChanged:', persistentObj.playlistJS)
            playlist.fromJSON(persistentObj.playlistJS);
        }
    }
    Component.onDestruction: { // hopefully before destruction of persistentObj :)
        persistentObj.playlistJS = appstate.playlist.toJSON();
        //        console.log('save this shit!', persistentObj.playlistJS)
        //persistentObj.save();
    }
    Component.onCompleted: {
        //        console.log('completed:', persistentObj.playlistJS)
        playlist.fromJSON(persistentObj.playlistJS);
    }
}
