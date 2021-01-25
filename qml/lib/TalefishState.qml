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

    //some logic:
    on_LoadedChanged: {
        var keepDays = options.keepUnopenedDirectoryProgressDays, //TODO options.keepUnopenedDirectoryProgressDays
            keepMs = keepDays * 24 * 360000;
        var keepAfter = new Date().getTime() - keepMs
        var currentPlaylist = app.state.currentPlaylist;
        if(keepDays < 9999) {
            var progress = {}
            var now = new Date().getTime();
            for(var dir in playlistProgress) {
                var el = playlistProgress[dir];
                var diff = now - el.lastAccess;
                if(diff < keepMs || currentPlaylist.pathsIdentifier === dir){
                    progress[dir] = el;
                } else {
                    console.log('removing progress for ', dir);
                }
            }
            playlistProgress = progress;
        }
        if(!app.commandLineArgumentFilesToOpen || app.commandLineArgumentDoEnqueue) {
            // load previous playlist:
            app.playlist.fromJSON(currentPlaylist);
        }
        if(app.commandLineArgumentFilesToOpen) {
            app.playlist.fromJSON(app.commandLineArgumentFilesToOpen,app.commandLineArgumentDoEnqueue);
        }
    }

}
