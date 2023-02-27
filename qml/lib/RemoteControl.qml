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

    property QtObject _mpris:mprisLoader.item
    property QtObject _keys
    property QtObject _policy
    property bool tryToReaquire

    property Loader mprisLoader: Loader {
        source: (app.launcher.sf_major < 4 || (app.launcher.sf_major === 4 && app.launcher.sf_minor < 3))
                ? './MprisControllerLegacy.qml'
                : './MprisController.qml';
    }

    Component.onCompleted: {

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
        var policyStr = 'import Nemo.Policy 1.0; Permissions {applicationClass: "player"; enabled: !!remoteControl._mpris.currentService && app.playlist.metadata.count > 0; Resource {type: Resource.HeadsetButtons;optional: false; required: true; onAcquiredChanged:{console.log("permission acquired changed", acquired)}}}'

        try {
            // policy is already handled in sfos 4.2
            if(app.launcher.sf_major < 4 || (app.launcher.sf_major === 4 && app.launcher.sf_minor < 2)) {
                _policy = Qt.createQmlObject(policyStr, remoteControl, 'dynamic-policy');
                // Permission gets revoked on call or by another player…
                // workaround: request again when app is put in foreground or background
                _policy.granted.connect(function(){
                    console.log('policy: granted')
                    remoteControl.tryToReaquire = false
                });
                _policy.lost.connect(function(){
                    console.log('policy: lost')
                    remoteControl.tryToReaquire = true
                });
                _policy.released.connect(function(){
                    console.log('policy: released')
                    remoteControl.tryToReaquire = true
                });
                _policy.releasedByManager.connect(function(){
                    console.log('policy: releasedByManager')
                    remoteControl.tryToReaquire = true
                });
                app.activeChanged.connect(function(){
                    if(remoteControl.tryToReaquire) {
                        _policy.enabled = false;
                        _policy.enabled = Qt.binding(function(){return app.playlist.metadata.count > 0;})
                    }
                });
            }
        } catch (policyError) {
            console.warn('Compatibility: headphone control not possible');
        }
        try {
            _keys = Qt.createQmlObject(keyStr, remoteControl, 'dynamic-keys');
            _keys.command.connect(remoteControl.command)
        } catch (keysError) {
            console.warn('Compatibility: remote control not possible');
        }


    }
}
