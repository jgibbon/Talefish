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
import QtMultimedia 5.6

MprisPlayer {
        id: mpris
        serviceName: "talefish"

        identity: "Talefish"
        supportedUriSchemes: ["file"]
        supportedMimeTypes: ["audio/x-wav", "audio/x-vorbis+ogg", "audio/mpeg", "audio/mp4a-latm", "audio/x-aiff"]
        // Mpris2 Player Interface
        canControl: true
        canGoNext: app.playerCommands.canGoNext
        canGoPrevious: app.playerCommands.canGoPrevious
        canPlay: app.audio.playbackState !== Mpris.Playing && !!(app.audio.source || playlist.itemCount)
        canPause: app.audio.playbackState === Mpris.Playing
        canSeek: app.audio.seekable
        hasTrackList: true

        playbackStatus: {
            switch (app.audio.playbackState) {
            case Audio.PlayingState:
                return Mpris.Playing
            case Audio.PausedState:
                return Mpris.Paused
            default:
                return Mpris.Stopped
            }
        }
        loopStatus: Mpris.LoopNone
        shuffle: app.playlist ? app.playlist.playbackMode === Playlist.Random : false
        rate: app.audio.playbackRate
        volume: app.audio.muted ? 0 : app.audio.volume

        onPauseRequested: remoteControl.command("pause")
        onPlayRequested: remoteControl.command("play")
        onPlayPauseRequested: remoteControl.command("playPause")
        onStopRequested: remoteControl.command("stop")
        onNextRequested: remoteControl.command("next")
        onPreviousRequested: remoteControl.command("prev")
        onPositionRequested: position = app.audio.position

        onSetPositionRequested: {
            var trackNum = parseInt((''+trackId).replace("/talefish/track/", "0"))
            player.seek(position, trackNum)
        }
        onSeekRequested: {
            app.playerCommands.seekBy(offset)
        }

        metaData {
            url: app.audio.source
            artUrl: app.playlist.currentAlbumArtUrl
            trackId: "/talefish/track/" + (app.playlist && app.playlist.currentIndex >= 0 ? app.playlist.currentIndex : '0')
            duration: app.audio.duration
            albumTitle: app.playlist.currentAlbum
            albumArtist: [app.playlist.currentArtist || playlist.currentAlbum || '']
            contributingArtist: [app.playlist.currentArtist || playlist.currentAlbum || '']
            title: app.playlist.currentTitle
            trackNumber: app.playlist && app.playlist.currentIndex >= 0 ? app.playlist.currentIndex + 1 : null
        }
        property Item wrap: Item {
            Connections {
                target: app.playerCommands
                onSeeked: {
                    mpris.seeked(position)
                }
            }
        }
    }
