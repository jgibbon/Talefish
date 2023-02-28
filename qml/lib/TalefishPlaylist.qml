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
import QtMultimedia 5.6
import TaglibPlugin 1.0

Playlist {
    id: playlist
    property TalefishAudio audio
    // Playlist.CurrentItemOnce seems to reset index, so we don't use that for !app.options.playNextFile.
    // see TalefishAudio onStatusChanged
    playbackMode: audio.error ? Playlist.CurrentItemOnce : Playlist.Sequential
    property int totalDuration: 0
    property int totalPosition: 0
    property string pathsIdentifier // pathsIdentifier is for saving current progress
    readonly property Timer durationListTimer: Timer {
        // we want to debounce some operations to reduce double work
        interval: 100
        onTriggered: {
            setDurations();
        }
    }
    onCurrentIndexChanged: {
        console.log('currentIndex', currentIndex, audio.error) //error: 1
        // when played through, we want to activate the first track again
        if(currentIndex === -1 && metadata.count > 0 && !audio.error) {

            audio.pause();
            currentIndex = 0;
            // total position stays at "100%" by default, which is nice and correct but may be seen as inconsistent
            totalPosition = 0;
            if(options.slumberTriggerOnPlaylistEnd) {
                app.playerCommands.slumberInterface.call('trigger')
            }

        }
    }
    property string currentAlbumArtUrl: ''
    function setAlbumArt(coverUrl) {
        var setCoverUrl = launcher.fileExists(coverUrl) ? coverUrl : '';
        if(setCoverUrl !== currentAlbumArtUrl) {
            currentAlbumArtUrl = setCoverUrl;
        }
    }

    readonly property var currentMetaData: {
        var md = metadata.get(currentIndex);
        if(!md || metadata.count === 0) {// we need to access .count here to trigger update nicely (otherwise it becomes null)
            return {title:'',album:'',artist:'', duration: 0};
        }
        return md;
    }

    // set displayed metadata strings + fallbacks
    // title (or base name)
    function title(index) {
        if(metadata.count === 0 || index < 0 || index > metadata.count - 1) {
            return '';
        }
        var md = metadata.get(index);
        if(md.title === '') {return app.js.fileName(md.path, true);}
        return md.title;
    }
    property string currentTitle: title(currentIndex) + (audio.errorVisible ? '\n['+audio.errorString+']' : '')

    // album (or directory base name)
    function album(index) {
        if(metadata.count === 0 || index < 0 || index > metadata.count - 1) {
            return '';
        }
        var md = metadata.get(index);
        if(md.album === '') {return app.js.fileName(app.js.filePath(currentItemSource)); }
        return md.album;
    }
    readonly property string currentAlbum: album(currentIndex)

    // artist (or empty string)
    function artist(index) {
        if(metadata.count === 0 || index < 0 || index > metadata.count - 1) {
            return '';
        }
        var md = metadata.get(index);
        return md.artist;
    }
    readonly property string currentArtist: artist(currentIndex)

    readonly property ListModel metadata: ListModel {}
    readonly property TaglibPlugin taglib: TaglibPlugin {
        id: taglib
        onTagInfos: {
            if(queryIndex > -1 && queryIndex <= playlist.metadata.count) {
                playlist.metadata.set(queryIndex, {artist:artist, title:title, album:album, duration:duration});
                durationListTimer.restart();
                if(queryIndex === playlist.currentIndex) {
                    playlist.currentMetaDataChanged()
                }
            }
        }
    }
    function setDurations() {
        console.log('setDurations')
        var totalDuration = 0;
        for(var i=0; i < playlist.metadata.count; i++) {
            var metadataItem = playlist.metadata.get(i);
            playlist.metadata.setProperty(i, 'previousDurations', totalDuration);
            totalDuration = totalDuration + metadataItem.duration;
        }
        playlist.totalDuration = totalDuration;

        // if this is done, we can save the current playlist:
        app.state.currentPlaylist = playlist.toJSON();
        console.log('saved current playlist…');
    }
    function toJSON() { // to save current state
        var json = {
            pathsIdentifier: pathsIdentifier,
            totalDuration: playlist.totalDuration,
            items:[]
        }
        for(var i=0; i < playlist.metadata.count; i++) {
            json.items.push(playlist.metadata.get(i))
        }
        return json
    }
    function fromJSON(json, enqueue, directory) { //directory overrides pathsIdentifier to display progress in file selector
        if (enqueue && playlist.metadata.count === 0) {
            enqueue = false;
        }
        if (!enqueue) {
            audio.stop();
            playlist.clear();
            playlist.metadata.clear();
        }

        var i; //we reuse i as a general-purpose iterator

        if (!json.items) {// case 1: json is just an array of urls (opening files etc)
            totalDuration = 0;
            for(i=0; i < json.length; i++) {
                var source = Qt.resolvedUrl(json[i].replace(/#/g, '%23'));
                playlist.addItem(source);
                metadata.append({path:json[i], artist:'', title:'', album:'', duration:0, previousDurations:0});
                taglib.getFileTagInfos(json[i], metadata.count - 1, false);
            }
        } else {// case 2: json is prefilled
            totalDuration = json.totalDuration;
            for(i=0; i < json.items.length; i++) {
                playlist.addItem(Qt.resolvedUrl(json.items[i].path.replace(/#/g, '%23')));
                metadata.append(json.items[i]);
            }
            pathsIdentifier = json.pathsIdentifier;
        }

        if(directory && !enqueue) {
            pathsIdentifier = directory;
        } else if(!json.pathsIdentifier) {
            var pathsArray = [];
            for(i=0; i < metadata.count; i++) {
                pathsArray.push(metadata.get(i).path);
            }
            pathsIdentifier = pathsArray.join('|');
        }

        if(!enqueue) {
            applySavedPosition();
        }
        //        console.log('opened playlist', pathsIdentifier)
    }
    property bool applyingSavedPosition: false
    property int applyThisTrackPosition: -1
    onApplyThisTrackPositionChanged: {
        if(applyingSavedPosition) {
            totalPosition = currentMetaData.previousDurations + applyThisTrackPosition
        }
    }


    function applySavedPosition() {
        var position = app.state.playlistProgress[pathsIdentifier] || {position:0,index:0};
        app.playerCommands.seek(position.position, position.index);
        totalPosition = currentMetaData.previousDurations + position.position
    }

    function saveCurrentPosition(){
        var position = {
            index: playlist.currentIndex,
            position: audio.displayPosition,
            totalPosition: totalPosition,
            totalDuration: totalDuration,
            lastAccess: new Date().getTime()
        }
        if(position.index > -1 && position.totalPosition > 1) {
            //            totalPosition = position.totalPosition;
            app.state.playlistProgress[pathsIdentifier] = position;
        }
    }
    readonly property Timer reseekTimer: Timer {
        id: reSeekTimer //when seeking multiple times abruptly, audio doesn't seem to do it
        interval: 30
        onTriggered: {
            if(playlist.applyingSavedPosition) {
                audio.seek(playlist.applyThisTrackPosition);
                if(audio.position === playlist.applyThisTrackPosition) {
                    playlist.applyingSavedPosition = false;
                    playlist.applyThisTrackPosition = -1;
                } else {
                    reSeekTimer.start()
                }
            }
        }
    }

    readonly property Connections audioConnections: Connections {
        target: audio
        onSeekableChanged: {
            if(audio.seekable && playlist.applyingSavedPosition) {
                console.log("seekable applying?!")
                audio.seek(playlist.applyThisTrackPosition);
                // normally, seeking should be applied now with local tracks
                if(audio.position === playlist.applyThisTrackPosition) {
                    playlist.applyingSavedPosition = false;
                    playlist.applyThisTrackPosition = -1;
                    //                                audio.playbackRateWorkaround();
                } else { // it it doesn't, we force seeking with brute force
                    reSeekTimer.start()
                }
            } else if(audio.seekable && app.options.playbackRate !== 1.0) { // seek to force playbackRate
                console.log("seek for playbackRate");
                audio.playbackRateWorkaround(true);
            }
        }
        onDisplayPositionChanged: {
            if(!playlist.applyingSavedPosition) {
                totalPosition = currentMetaData.previousDurations + audio.displayPosition
                playlist.saveCurrentPosition()
            }
        }
        onDurationChanged: {
            if(playlist.currentIndex > -1
                    && audio.duration > 20  // account for some variance with partly loaded data and VBR… TODO: still necessary?
                    && playlist.currentMetaData.duration !== audio.duration) {
                metadata.setProperty(playlist.currentIndex, 'duration', audio.duration);
                //setDurations() directly may skew skipping, so we reuse durationListTimer:
                playlist.durationListTimer.start()
            }
        }
    }
}
