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
/* This is an ugly, bad hack for harbour. Sorry, please regard this as non-existent. */

Item {
    id: remoteControl

    signal command(string cmd)

    property QtObject _mpris
    property QtObject _keys
    property QtObject _policy

    Component.onCompleted: {
        var mprisStr = 'import org.nemomobile.mpris 1.0
import QtQuick 2.6
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
                signal command(string cmd)
                onPauseRequested: command("pause")

                onPlayRequested: command("play")
                onPlayPauseRequested: command("playPause")
                onStopRequested: command("stop")
                onNextRequested: command("next")

                onPreviousRequested: command("prev")

                //metadata handling
                function updateMetaData(){
                    var infos = mpris.metadata;

                    infos[Mpris.metadataToString(Mpris.Artist)] = [app.playlist.currentMetaData.artist]
                    infos[Mpris.metadataToString(Mpris.Title)] = app.playlist.currentMetaData.title
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
                            }
                        }
                    }
                    Timer { // workaround: data gets ignored if set directly after load
                        id: metadataTimer
                        running: true
                        interval: 400
                        repeat: false
                        onTriggered: mpris.updateMetaData()
                    }
                }
        }';

        var keyStr = 'import Sailfish.Media 1.0
import QtQuick 2.6
Item {
        id: keysItem
        parent: remoteControl
        signal command(string cmd)

        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaTogglePlayPause; onReleased: keysItem.command("playPause")}
        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaPlay; onReleased: keysItem.command("play")}
        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaPause; onReleased: keysItem.command("pause")}
        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaStop; onReleased: keysItem.command("stop")}
        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaNext; onReleased: keysItem.command("next")}
        MediaKey {enabled: app.options.useHeadphoneCommands; key: Qt.Key_MediaPrevious; onReleased: keysItem.command("prev")}

        MediaKey {
            property bool isLongPressed: false
            enabled: app.options.useHeadphoneCommands
            key: Qt.Key_ToggleCallHangup
            onReleased: {
                hangupButtonTimer.stop()
                if(!isLongPressed) {keysItem.command(options.headphoneCallButtonDoes)}
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
                    keysItem.command(options.headphoneCallButtonLongpressDoes)
                    start()
                }
            }
        }
    }
';
        var policyStr = 'import org.nemomobile.policy 1.0; Permissions {applicationClass: "player"; enabled: app.playlist.metadata.count > 0; Resource {type: Resource.HeadsetButtons;optional: true;}}'

        try {
            _mpris = Qt.createQmlObject(mprisStr, remoteControl, 'dynamic-mpris');
            _mpris.command.connect(remoteControl.command)
        } catch (mprisError) {
            console.warn('Compatibility: connecting to mpris not possible');
        }

        try {
            _keys = Qt.createQmlObject(keyStr, remoteControl, 'dynamic-keys');
            _keys.command.connect(remoteControl.command)
        } catch (keysError) {
            console.warn('Compatibility: remote control not possible');
        }

        try {
            _policy = Qt.createQmlObject(policyStr, remoteControl, 'dynamic-policy');
        } catch (policyError) {
            console.warn('Compatibility: headphone control not possible');
        }

    }
}
