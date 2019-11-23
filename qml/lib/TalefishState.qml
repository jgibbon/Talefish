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

PersistentObject {
    objectName: 'appstate'
    //js representation of current playlist
    property var currentPlaylist: ({})

    //all saved progresses
    property var playlistProgress: ({})
    property string lastDirectory: ''

    // TODO remove legacy compatibility:
    property real currentPosition:0
    property string coverActionCommand: ''
    property var playlistJS: []
    property int playlistIndex:-1
    property var savedDirectoryProgress: ({})

    //some logic:
    on_LoadedChanged: {
        var keepDays = options.keepUnopenedDirectoryProgressDays, //TODO options.keepUnopenedDirectoryProgressDays
            keepMs = keepDays * 24 * 360000;
        var keepAfter = new Date().getTime() - keepMs
        // legacy progress import
//        console.log('LEGACY PROGRESS', JSON.stringify(savedDirectoryProgress));
        for(var legacyProgressDirectory in savedDirectoryProgress) {
//            console.log('legacy progress', legacyProgressDirectory);
            // 1: normal sort prefix
            if(!('1'+legacyProgressDirectory in playlistProgress)) {
//                console.log('save…')
                playlistProgress['1'+legacyProgressDirectory] = {
                    index: savedDirectoryProgress[legacyProgressDirectory].index,
                    position: savedDirectoryProgress[legacyProgressDirectory].position,
                    lastAccess: savedDirectoryProgress[legacyProgressDirectory].lastAccess,
                    // totalPosition/totalDuration are only for slider display purposes
                    // so we can get away with this hack:
                    totalPosition: savedDirectoryProgress[legacyProgressDirectory].percent,
                    totalDuration: 100
                };
                //hack: for single files just duplicate it
                playlistProgress[legacyProgressDirectory] = playlistProgress['1'+legacyProgressDirectory];
//                console.log(JSON.stringify(playlistProgress[legacyProgressDirectory]));
            }
        }
        // remove everything
        savedDirectoryProgress = ({});
        // end legacy progress import

        if(keepDays < 9999) {
            var progress = {}
            var now = new Date().getTime();
            for(var dir in playlistProgress) {
                var el = playlistProgress[dir];
                if(!el.lastAccess) { //compatibility with older versions. remove at some point.
                    console.log('progress: last access not saved, setting to now', dir);
                    el.lastAccess = now;
                }
                var diff = now - el.lastAccess;
                if(diff < keepMs){
//                    console.log('keeping progress for ', dir);
                    progress[dir] = el;
                } else {
                    console.log('removing progress for ', dir);
                }
            }
            playlistProgress = progress;
        }
//        console.log(JSON.stringify(playlistProgress));
        if(!app.commandLineArgumentFilesToOpen || app.commandLineArgumentDoEnqueue) {
            // load previous playlist:
            app.playlist.fromJSON(app.state.currentPlaylist);

            // legacy version state import
            var legacyPlaylist = typeof playlistJS === 'string'
                    ? JSON.parse(playlistJS)
                    : playlistJS;
            if(legacyPlaylist.length > 0) {
                app.playlist.fromJSON(legacyPlaylist.map(function(el){return el.path;}));
                app.playerCommands.seek(currentPosition, playlistIndex);
                //kill the old playlist data
                playlistJS = [];
            }
        }
        if(app.commandLineArgumentFilesToOpen) {
            app.playlist.fromJSON(app.commandLineArgumentFilesToOpen,app.commandLineArgumentDoEnqueue);
        }


    }

}
