import QtQuick 2.0
import org.nemomobile.mpris 1.0
import '../lib'

import QtMultimedia 5.0
import org.nemomobile.policy 1.0
import Sailfish.Media 1.0

Item {
    id:root
    visible: false
    property Audio player: playback
    property MprisPlayer mpris: mprisPlayer
    property bool isplaying: false
    property int initialSeekTo: 0
    property alias externalCommand: externalCommand
    Timer {
        id: initialSeekTimer
        interval: 200
        onTriggered: {
            seekToInitial();
        }

    }
    Item {
        id: externalCommand
        function play() { app.log('external command: play'); playback.play();}
        function pause() {app.log('external command: pause'); playback.pause();}
        function playPause() {app.log('external command: playPause'); root.playPause();}
        function next() {
            app.log('external command: next');
            switch(options.externalCommandSkipDuration){
            case 'small':
                seek(options.skipDurationSmall)
                break;

            case 'normal':
                seek(options.skipDurationNormal)
                break;

            default:
                if(appstate.playlistIndex < appstate.playlist.count - 1){
                    playIndex(appstate.playlistIndex+1, {isPlaying: !!playback.isPlaying});
                }
            }

        }
        function prev() {app.log('external command: prev');

            switch(options.externalCommandSkipDuration){
            case 'small':
                seek(0 - options.skipDurationSmall)
                break;

            case 'normal':
                seek(0 - options.skipDurationNormal)
                break;

            default:
                if(appstate.playlistIndex > 0){
                    playIndex(appstate.playlistIndex-1, {isPlaying: !!playback.isPlaying});
                }
                else {
                    playIndex(0, {isPlaying: !!playback.isPlaying});
                }
            }
        }
        function stop() {app.log('external command: stop');
            playback.pause()
        }
        function nothing(){} //for call button setting.
    }

    function seekToInitial(){
        if(playback.stateposition > 0 && playback.position < playback.stateposition) {
            playback.seek(playback.stateposition);
        }
        else{
            initialSeekTo = 0;
        }

    }

    function updatePlaybackStatus (){
        if(playback.fixingPlaybackRate) {return;}
        app.log('playback.playbackState', playback.playbackState)
        switch (playback.playbackState) {
        case Audio.PlayingState:
            app.log('mpris: playbackstatus playing');
            mprisPlayer.playbackStatus = Mpris.Playing
            break;

        case Audio.PausedState:

            app.log('mpris: set playbackstatus paused');
            mprisPlayer.playbackStatus = Mpris.Paused
            break;
        case Audio.StoppedState:
            mprisPlayer.playbackStatus = Mpris.Paused
            break;

        default:
            mprisPlayer.playbackStatus = Mpris.Paused
        }

    }

    function playPause () {

        app.log(playback.playbackState, Audio.PlayingState, playback.source)
        if(playback.playbackState == Audio.PlayingState) { playback.pause(); }
        else {
            if(playback.status == Audio.EndOfMedia){
                app.log('end of media!');
                if(appstate.playlistIndex + 1 < appstate.playlist.count){
                    playIndex(appstate.playlistIndex + 1,{isPlaying:true, isUserAction:true});
                }
                playIndex(0,{isPlaying:true, isUserAction:true});
            } else {
                playIndex(appstate.index, {offset:appstate.currentPosition, isPlaying:true});
                playback.play();
            }
        }
        root.isplaying = (playback.playbackState == Audio.PlayingState);
    }

    function playIndex(index, opts) {//ops: offset, isPlaying, isUserAction
        //might crash with no current file:
        opts = opts || {};
        app.log('player: playIndex', index, 'offset:', opts.offset, 'isPlaying:', opts.isPlaying)
        if(index === -1 && appstate.playlistIndex > -1) {//short cut to jump start playback
            //index = appstate.playlistIndex;
            playback.stop();
            playback.play();

            if(appstate.currentPosition) playback.seek(appstate.currentPosition);
            app.log('seek:',appstate.currentPosition);


        } else {
            if(index === -1 || typeof index === 'undefined'){
                index = appstate.playlistIndex;
                opts.offset = appstate.currentPosition;
            }

            if(typeof opts.offset === 'number' && opts.offset < 0){
                opts.offset = appstate.playlist.get(index).duration + opts.offset
                app.log('player: playIndex: seek to previous track! new offset:', opts.offset)
            }

            appstate.currentPosition = opts.offset > 0 ? opts.offset: 0;
            if(appstate.currentPosition === 0) {
                app.log('current position is 0; stopping')
                playback.stop();
            }
            app.log('setting new playlist index to', index)
            appstate.playlistIndex = index;

            app.log('opening statefile:', appstate.playlistActive.path)
            playback.statefile = appstate.playlistActive.path
            app.log('seeking to:', appstate.currentPosition)

            playback.seek(appstate.currentPosition);
        }
        playback.pause();
        if(opts.isPlaying) {
            playback.play();
        }

        root.isplaying = playback.isPlaying;

        if(opts.isUserAction){
            //            sleepTimer.restart();
        }
        updatePlaybackStatus()

        if(opts.isPlaying) { //has to be called twice for skipping to previous track?! TODO: check if still necessary
            playback.play();
        }
    }
    function seek(value) {
        var targetposition = appstate.currentPosition + value,
                isplaying = playback.playbackState === Audio.PlayingState;
        app.log('seek', value, targetposition, 'next track',targetposition > appstate.playlist.get(appstate.playlistIndex).duration );
        app.log('isPlaying', isplaying, appstate.tplayer.isPlaying, appstate.tplayer.isplaying)
        if(targetposition < 0) {//previousfile

            if(appstate.playlistIndex > 0) {

                app.log('seeking to previous track. seekable:', playback.seekable )
                appstate.tplayer.playIndex(appstate.playlistIndex - 1, {
                                               offset: targetposition,
                                               isPlaying: appstate.tplayer.isplaying,
                                               isUserAction:true
                                           });


            } else {

                app.log('no previous track. seeking to position 0. seekable:', playback.seekable )
                appstate.tplayer.playIndex(appstate.playlistIndex, {
                                               offset: 0,
                                               isPlaying: appstate.tplayer.isplaying,
                                               isUserAction:true
                                           });
            }

        } else if(targetposition > appstate.playlist.get(appstate.playlistIndex).duration) {
            app.log('seeking to next track. seekable:', playback.seekable )
            if( appstate.playlist.count - 1 > appstate.playlistIndex && appstate.playlist.get(appstate.playlistIndex + 1).path) {
                appstate.tplayer.playIndex(appstate.playlistIndex + 1, {
                                               offset:targetposition - appstate.playlist.get(appstate.playlistIndex).duration,
                                               isPlaying: appstate.tplayer.isplaying,
                                               isUserAction: true
                                           });

            }
        } else {
            appstate.tplayer.playIndex(appstate.playlistIndex, {
                                           offset:targetposition,
                                           isPlaying: appstate.tplayer.isplaying,
                                           isUserAction: true
                                       });
        }
    }

    MediaPlayer {
        id: playback

        autoLoad: true
        property int stateposition: appstate.currentPosition
        property bool isPlaying: playback.playbackState == Audio.PlayingState
        property string statefile: appstate.playlistActive ? appstate.playlistActive.path: ''
        playbackRate: options.playbackRate
        onPlaybackRateChanged: {
            app.log('player: playbackRate changed')
            fixPlaybackRate()
        }




        property bool fixingPlaybackRate: false // might be obsolete
        function fixPlaybackRate(){
            fixingPlaybackRate = true
            if(seekable) {
                seek(position - 0.01); //we have to seek to fix playback rate – but this keeps stuttering to a minimum
                fixingPlaybackRate = false
            }
        }

        onStatefileChanged: {

            if(statefile !== '') {
                app.log('player: statefile changed')
                playback.stop()
                playback.source = 'file://'+statefile;
                if(isplaying) {
                    playback.play();
                }


            }else {
                app.log('player: state file empty?')
            }

        }
        onStatusChanged: {

            mprisDataTimer.restart()
            app.log('player: status changed', status)
            app.log('states: ',Audio.NoMedia, Audio.Loading, Audio.Loaded, Audio.Buffering, Audio.Stalled, Audio.Buffered, Audio.EndOfMedia, Audio.InvalidMedia,Audio.UnknownStatus)
            if(status == Audio.EndOfMedia && appstate.playlistIndex < appstate.playlist.count - 1){
                app.log('player: end of media', options.playNextFile)
                appstate.currentPosition = 0;
                appstate.playlistIndex = appstate.playlistIndex + 1;
                playIndex(appstate.playlistIndex , { isPlaying: options.playNextFile });

            } else if(seekable && position == 0 && appstate.currentPosition) {
                app.log('player: file loaded', seekable, position)
                if(seekable && position == 0 && appstate.currentPosition) {

                    app.log('trying to set position: '+appstate.currentPosition);
                    playback.seek(stateposition);

                    if(root.isplaying) {
                        app.log('trying to play');
                        playback.play()
                    }

                }
            } else if(status !== Audio.Loaded)  {
                app.log('player error or file not loaded yet: not seekable, not at end of playlist')
            }
        }

        onDurationChanged: {
            app.log('player: duration changed. ', stateposition, ' - ', duration, 'recalc playlist length')
            if(duration > -1) {
                playlist.setProperty(appstate.playlistIndex,'duration', duration);
                playlist.getDuration();

                appstate.updatePlaylistActive();

            }
        }
        onPositionChanged: {
            app.log('player position changed', position);
            if((position > 10 ) && (appstate.currentPosition < position)){

                appstate.currentPosition = position
            }
        }
        onSeekableChanged: {
            app.log('player: seekable changed', seekable, appstate.currentPosition);
            if(seekable) {
                if(appstate.currentPosition > position) { // open previously played file, setting app state position…
                    seek(appstate.currentPosition);
                }
                if(fixingPlaybackRate && playbackRate !== 1.0) {
                    fixPlaybackRate();
                }
            }

        }

        onPlaybackStateChanged: {
            app.log('player: playbackState changed:', playbackState)
            updatePlaybackStatus();
            mprisDataTimer.restart();


        }

    }

    Timer {
        id: mprisDataTimer
        interval: 400
        repeat: false
        onTriggered: interval=10, updateMprisMetadata()
    }
    function updateMprisMetadata(){



        app.log('update mpris meta data', mprisPlayer.artist, mprisPlayer.song)
        mprisPlayer.artist = appstate.playlistActive.folderName || ''
        mprisPlayer.song = appstate.playlistActive.baseName || ''
    }

    MprisPlayer {
        id: mprisPlayer

        property string artist
        property string song
        //        property string cover

        serviceName: "talefish"

        identity: "Talefish"
        supportedUriSchemes: ["file"]
        supportedMimeTypes: ["audio/x-wav", "audio/x-vorbis+ogg", "audio/mpeg", "audio/mp4a-latm", "audio/x-aiff"]

        // Mpris2 Player Interface
        canControl: true

        canGoNext: true //appstate.playlistIndex < appstate.playlist.count
        canGoPrevious: true // appstate.playlistIndex > 0
        canPause: true
        canPlay: true

        canSeek: true// playback.seekable
        hasTrackList: true
        playbackStatus: Mpris.Paused
        loopStatus: Mpris.None
        shuffle: false
        volume: playback.volume
        onPauseRequested: {externalCommand.playPause()}

        onPlayRequested: {externalCommand.play()}
        onPlayPauseRequested: {externalCommand.playPause()}
        onStopRequested: {externalCommand.stop()}
        onNextRequested: {externalCommand.next()}

        onPreviousRequested: {externalCommand.prev()}

        onSongChanged: {
            var metadata = mprisPlayer.metadata
            metadata[Mpris.metadataToString(Mpris.Artist)] = [artist]
            metadata[Mpris.metadataToString(Mpris.Title)] = song
            mprisPlayer.metadata = metadata
        }

    }




    Permissions {
        applicationClass: "player"
        enabled: appstate.playlist.count > 0

        Resource {
            type: Resource.HeadsetButtons
            optional: true
        }
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaTogglePlayPause
        onReleased: externalCommand.playPause()
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaPlay
        onReleased: externalCommand.play()
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaPause
        onReleased: externalCommand.pause()
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaStop
        onReleased: externalCommand.stop()
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaNext
        onReleased: externalCommand.next()
    }

    MediaKey {
        enabled: options.useHeadphoneCommands
        key: Qt.Key_MediaPrevious
        onReleased: externalCommand.prev()
    }

    MediaKey {
        property bool isLongPressed: false
        enabled: options.useHeadphoneCommands
        key: Qt.Key_ToggleCallHangup
        onReleased: {
            hangupButtonTimer.stop()
            if(!isLongPressed) {externalCommand[options.headphoneCallButtonDoes]()}
        }
        onPressed: {
            isLongPressed=false
            hangupButtonTimer.restart()
        }
        Timer {
            id: hangupButtonTimer
            interval: 1000
            onTriggered: {
                parent.isLongPressed = true
                externalCommand[options.headphoneCallButtonLongpressDoes]()
                start()
            }
        }
    }





    Component.onCompleted: {
        updatePlaybackStatus();
    }
}

