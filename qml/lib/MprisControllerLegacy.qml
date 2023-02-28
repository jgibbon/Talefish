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
import org.nemomobile.mpris 1.0

MprisPlayer {
    id: mpris
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
    volume: 1.0
    onPauseRequested: remoteControl.command("pause")

    onPlayRequested: remoteControl.command("play")
    onPlayPauseRequested: remoteControl.command("playPause")
    onStopRequested: remoteControl.command("stop")
    onNextRequested: remoteControl.command("next")

    onPreviousRequested: remoteControl.command("prev")

    //metadata handling
    function updateMetaData(){
        var infos = mpris.metadata;
        infos[Mpris.metadataToString(Mpris.Artist)] = [app.playlist.currentArtist || playlist.currentAlbum || '']
        infos[Mpris.metadataToString(Mpris.Title)] = app.playlist.currentTitle
        mpris.metadata = infos;
    }
    property Item wrap: Item {
        Connections {
            target: app.audio
            onIsPlayingChanged: {
                if(app.audio.isPlaying) {
                    mpris.playbackStatus = Mpris.Playing
                } else {
                    mpris.playbackStatus = Mpris.Paused
                }
            }
        }
        Connections {
            target: app.playlist
            onCurrentMetaDataChanged: {
                if(!metadataTimer.running) {
                    mpris.updateMetaData();
                } else {
                    metadataTimer.restart();
                }
            }
            onCurrentAlbumArtUrlChanged: {
                infos[Mpris.metadataToString(Mpris.ArtUrl)] = app.playlist.currentAlbumArtUrl
            }
        }
        Timer { // workaround: data gets ignored if set directly after load. Also used as a throttle.
            id: metadataTimer
            running: true
            interval: 400
            repeat: false
            onTriggered: mpris.updateMetaData()
        }
    }
}
