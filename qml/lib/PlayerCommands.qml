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
    function play() { app.log('external command: play'); app.audio.play();}
    function pause() {app.log('external command: pause'); app.audio.pause();}
    function playPause() {app.log('external command: playPause'); app.audio.playPause();}
    function next() {
        app.log('external command: next');
        switch(options.externalCommandSkipDuration){
        case 'small':
            playerCommands.seekBy(options.skipDurationSmall)
            break;

        case 'normal':
            playerCommands.seekBy(options.skipDurationNormal)
            break;

        default:
            app.playlist.next()
        }
    }
    function prev() {app.log('external command: prev');
        switch(options.externalCommandSkipDuration){
        case 'small':
            playerCommands.seekBy(0 - options.skipDurationSmall)
            break;

        case 'normal':
            playerCommands.seekBy(0 - options.skipDurationNormal)
            break;

        default:
            if(app.playlist.metadata.count > 0){
                app.playlist.previous();
            }
            else {
                app.audio.seek(0);
            }
        }
    }
    function stop() {app.log('external command: stop');
        playback.pause()
    }

    // standard internal commands
    function seek(position, index) {
        if(index > -1 && index !== app.playlist.currentIndex) {
            console.log('setting index', index)
            app.playlist.currentIndex = index;
        }
        if(app.audio.seekable) {
            console.log('seekable')
            app.playlist.applyingSavedPosition = false;
            app.playlist.applyThisTrackPosition = -1;
            app.audio.seek(position);
        } else { // handle in audio.onSeekableChanged

            console.log('applying later', position)
            applyingSavedPosition = true
            applyThisTrackPosition = position;
        }
    }

    function seekBy(mseconds) {
        var totalMilliSeconds = app.playlist.totalPosition + mseconds;
//        console.log('seekby',mseconds, 'from', app.playlist.totalPosition, 'to', totalMilliSeconds)
        if(totalMilliSeconds < 0) {
            app.playlist.totalPosition = 0;
            seek(0,0);
            return;
        }

        // same track:
        if((mseconds < 0 && totalMilliSeconds >= app.playlist.currentMetaData.previousDurations)
                || mseconds > 0 && totalMilliSeconds <= app.playlist.currentMetaData.previousDurations + app.playlist.currentMetaData.duration) {
            app.playlist.totalPosition = totalMilliSeconds;
            seek(totalMilliSeconds - app.playlist.currentMetaData.previousDurations, app.playlist.currentIndex);
            return;
        }
        // search other track
        var cur, curMin, curMax;
        for(var i=0; i < app.playlist.metadata.count; i++) {
            cur = app.playlist.metadata.get(i);
            curMin = cur.previousDurations;
            if(curMin <= totalMilliSeconds && (cur.previousDurations + cur.duration) >= totalMilliSeconds) {
//                console.log('matched other track #', i, totalMilliSeconds - curMin, 'of total', cur.duration)
                app.playlist.totalPosition = totalMilliSeconds;
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
                case 'play':
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
        function triggered(){
            // '0': disabled, 'small'/'normal': use set durations, 'long': normal*2
            if(options.slumberPauseRewindDuration !== '0' && app.audio.isPlaying) {
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
                }
            }
        }

    }
}
