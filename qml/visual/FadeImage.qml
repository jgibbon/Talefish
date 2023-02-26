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
Item {
    property alias asynchronous: primaryImage.asynchronous
    property alias autoTransform: primaryImage.autoTransform
    property alias cache: primaryImage.cache
    property alias fillMode: primaryImage.fillMode
    property alias horizontalAlignment: primaryImage.horizontalAlignment
    property alias mipmap: primaryImage.mipmap
    property alias mirror: primaryImage.mirror
    property alias source: primaryImage.source
    property alias verticalAlignment: primaryImage.verticalAlignment
    property alias sourceSize: primaryImage.sourceSize
    property alias status: primaryImage.status

    property alias primaryImage: primaryImage
    property alias secondaryImage: secondaryImage

    layer.enabled: true

    Image {
        id: primaryImage
        property string previousSource
        anchors.fill: parent
        onSourceChanged: {
            if(previousSource){
                secondaryImage.source = previousSource;
                secondaryImage.opacity = 1;
            }
            opacity = 0;
            fadeImageAnimation.start();

            previousSource = source
        }
        SequentialAnimation {
            id: fadeImageAnimation
            NumberAnimation {
                target: primaryImage
                property: 'opacity'
                from: 0
                to: 1
                duration: 500
            }
            ScriptAction { script: secondaryImage.opacity = 0; }

        }
    }
    Image {
        id: secondaryImage
        anchors.fill: parent
        asynchronous: primaryImage.asynchronous
        autoTransform: primaryImage.autoTransform
        cache: primaryImage.cache
        fillMode: primaryImage.fillMode
        horizontalAlignment: primaryImage.horizontalAlignment
        mipmap:primaryImage.mipmap
        mirror: primaryImage.mirror

        verticalAlignment: primaryImage.verticalAlignment
        opacity: 0
        z:-1
    }
}
