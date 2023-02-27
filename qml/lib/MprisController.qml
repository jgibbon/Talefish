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
import Amber.Mpris 1.0
/* This is an ugly, bad hack for harbour. Sorry, please regard this as non-existent. */

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
        loopStatus: Mpris.LoopNone
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
//            console.log('currentTitle', currentTitle)
            mpris.metaData.contributingArtist = [app.playlist.currentArtist || playlist.currentAlbum]
            mpris.metaData.title = app.playlist.currentTitle
            mpris.metaData.artUrl = app.playlist.currentAlbumArtUrl
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
                    }
                }
            }
            Timer { // workaround: data got ignored if set directly after load
                id: metadataTimer
                running: true
                interval: 400
                repeat: false
                onTriggered: mpris.updateMetaData()
            }
        }
    }
