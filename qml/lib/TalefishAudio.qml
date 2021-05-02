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

Audio {
    audioRole: Audio.MusicRole
    autoLoad: true
    playbackRate: app.options.playbackRate
    onPlaybackRateChanged: if(isPlaying) seek(position - 0.01);
    readonly property bool isPlaying: playbackState === Audio.PlayingState
    readonly property int displayPosition: playlist.applyingSavedPosition ? playlist.applyThisTrackPosition : position
    readonly property bool errorVisible: audio.error > 0 && (audio.status === Audio.NoMedia || audio.status === Audio.InvalidMedia || audio.status === Audio.UnknownStatus)
    onStatusChanged: {
        if(status === Audio.EndOfMedia && !app.options.playNextFile) {
            pause();
            playlist.next()
            playbackRate = app.options.playbackRate
        }
    }

    function playPause() {
        if(!isPlaying) {
            playbackRate = app.options.playbackRate
            play();
        } else {
            pause();
        }
    }
}
