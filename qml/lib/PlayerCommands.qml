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
import Nemo.DBus 2.0

Item {
    id: playerCommands

    signal seeked(int position)

    property TalefishAudio audio: app.audio
    property TalefishPlaylist playlist: app.playlist
    property alias slumberInterface: slumberInterface

    readonly property int skipDuration: options.externalCommandSkipDuration === 'small'
                                            ? options.skipDurationSmall
                                            : options.externalCommandSkipDuration === 'normal'
                                                ? options.skipDurationNormal
                                                : 0
    readonly property bool canGoNext: skipDuration
        ? playlist.totalDuration > playlist.totalPosition + skipDuration
        : playlist.currentIndex < playlist.metadata.count - 1
    readonly property bool canGoPrevious: skipDuration
        ? playlist.totalPosition > skipDuration
        : playlist.currentIndex > 0


    function play() { console.log('external command: play'); audio.play();}
    function pause() {console.log('external command: pause'); audio.pause();}
    function playPause() {console.log('external command: playPause'); audio.playPause();}

    function next() {
        console.log('external command: next');
        if(!canGoNext) {
            return;
        }

        if(skipDuration === 0) {
            return app.playlist.next()
        }
        playerCommands.seekBy(skipDuration)
    }
    function prev() {console.log('external command: prev');
        if(!canGoPrevious) {
            return;
        }

        if(skipDuration === 0) {
            return app.playlist.previous()
        }
        playerCommands.seekBy(0 - skipDuration)
    }
    function stop() {console.log('external command: stop');
        playback.pause()
    }

    // standard internal commands
    function seek(position, index) {
        if(index > -1 && index !== playlist.currentIndex) {
            //            console.log('setting index', index)
            playlist.currentIndex = index;
        }
        if(audio.seekable) {
            playlist.applyingSavedPosition = false;
            playlist.applyThisTrackPosition = -1;
            audio.seek(position);
            seeked(position)
        } else { // handle in audio.onSeekableChanged
            playlist.applyingSavedPosition = true
            playlist.applyThisTrackPosition = position;
        }
    }

    function seekBy(mseconds) {
        var totalMilliSeconds = playlist.totalPosition + mseconds;
        //        console.log('seekby',mseconds, 'from', playlist.totalPosition, 'to', totalMilliSeconds)
        if(totalMilliSeconds < 0) {
            playlist.totalPosition = 0;
            seek(0,0);
            return;
        }

        // same track:
        if((mseconds < 0 && totalMilliSeconds >= playlist.currentMetaData.previousDurations)
                || mseconds > 0 && totalMilliSeconds <= playlist.currentMetaData.previousDurations + playlist.currentMetaData.duration) {
            playlist.totalPosition = totalMilliSeconds;
            seek(totalMilliSeconds - playlist.currentMetaData.previousDurations, playlist.currentIndex);
            return;
        }
        // search other track
        var cur, curMin, curMax;
        for(var i=0; i < playlist.metadata.count; i++) {
            cur = playlist.metadata.get(i);
            curMin = cur.previousDurations;
            if(curMin <= totalMilliSeconds && (cur.previousDurations + cur.duration) >= totalMilliSeconds) {
                //                console.log('matched other track #', i, totalMilliSeconds - curMin, 'of total', cur.duration)
                playlist.totalPosition = totalMilliSeconds;
                seek(totalMilliSeconds - curMin, i);
                return;
            }
        }
    }

    RemoteControl {
        parent: app //needed for MediaKey
        onCommand: {
            console.log('remote control', cmd);
            switch(cmd) {
            case 'pause':
                playerCommands.pause()
                break;
            case 'play':
                playerCommands.play()
                break;
            case 'playPause':
                playerCommands.playPause()
                break;
            case 'stop':
                playerCommands.stop()
                break;
            case 'next':
                playerCommands.next()
                break;
            case 'prev':
                playerCommands.prev()
                break;
            }
        }
    }

    DBusInterface {
        id:slumberInterface
        service: 'de.gibbon.slumber'
        path: '/de/gibbon/slumber'
        iface: 'de.gibbon.slumber'
        signalsEnabled: true
        watchServiceStatus: true

        function triggered(){
            // '0': disabled, 'small'/'normal': use set durations, 'long': normal*2
            if(options.slumberPauseRewindDuration !== '0' && audio.isPlaying) {
                switch(options.slumberPauseRewindDuration){
                case 'small':
                    console.log('slumber triggered small');
                    playerCommands.seekBy(0 - options.skipDurationSmall)
                    break;

                case 'normal':
                    console.log('slumber triggered normal');
                    playerCommands.seekBy(0 - options.skipDurationNormal)
                    break;
                case 'long':
                    console.log('slumber triggered long');
                    playerCommands.seekBy(0 - options.skipDurationNormal * 2)
                    break;
                case 'timer':
                    var secs = slumberInterface.getProperty("timerSeconds");
                    if(secs) {
                        playerCommands.seekBy(0 - secs*1000)
                    }

                    break;
                }
            }
        }

    }
}
