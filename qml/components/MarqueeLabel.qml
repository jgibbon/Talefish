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
import Sailfish.Silica 1.0

Item {
    id: marqueeLabel
    property alias label: label
    property alias font: label.font
    property alias color: label.color
    property alias contentHeight: label.contentHeight
    property alias contentWidth: label.contentWidth
    property alias text: label.text

    property int widthOverhang: label.contentWidth - width
    property bool contentIsWide: widthOverhang > 0
    property bool enabled: true
    property int animationSpeed: 1000 / Theme.itemSizeLarge
    property int animationDuration: Math.max(1000, animationSpeed * widthOverhang)
    property int truncationMode: TruncationMode.Fade
    property bool isAnimating: resetAnimation.running || animation.running
    clip: true
    height: label.contentHeight
    onWidthChanged: run();
    onTextChanged: run();
    onEnabledChanged: {
        if(!enabled) {
            animation.stop()
            resetAnimation.start()
        } else run()
    }

    function run() {
        if(animation.running) {
            animation.stop();
        }

        if(enabled && !animation.running && widthOverhang > 0) animation.start()
    }

    Label {
        id: label
        text: 'this default text is a bit long to be honest this default text is a bit long to be honest this default text is a bit long to be honest'
        height: parent.height
        width: parent.width
        truncationMode: animation.running || resetAnimation.running ? TruncationMode.None : marqueeLabel.truncationMode
    }

    NumberAnimation {
        id: resetAnimation
        target: label
        property: 'x'
        from: target.x
        to: 0
        duration: animationSpeed * Math.abs(target.x)
        easing.type: Easing.InOutQuad
    }
    SequentialAnimation {
        id: animation
        onRunningChanged: if(!running)marqueeLabel.run()
        NumberAnimation {
            target: label
            property: 'x'
            from: target.x
            to: -widthOverhang
            duration: animationDuration
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            duration: 2000
        }
        NumberAnimation {
            target: label
            property: 'x'
            from: -widthOverhang
            to: 0
            duration: animationDuration
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            duration: 2000
        }
    }
    Component.onCompleted: {
        run();
    }
}
