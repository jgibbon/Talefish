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
    id: area
    width: parent.width
    height: button.height + content.height
//    property int targetHeight: button.height + expand + content.implicitHeight //for scrolling
    property alias icon: image
    property alias text: label.text
    property bool expanded: false
    property bool staticMode: false
    default property alias els: content.data
//    readonly property color _color: enabled ? highlighted ? Theme.highlightColor : Theme.primaryColor : Theme.secondaryColor

    data: [
        BackgroundItem {
            id: button
            height: Theme.itemSizeMedium
            enabled: !parent.staticMode
            onClicked: parent.expanded = !parent.expanded
            Rectangle {
                visible: !area.staticMode
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.rgba(Theme.highlightBackgroundColor, 0.15) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            Label {
                id: label
                anchors {
                    left: parent.left
                    right: image.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Theme.horizontalPageMargin + Theme.paddingLarge
                    rightMargin: area.staticMode ? 0 : Theme.paddingMedium
                }
                horizontalAlignment: Text.AlignRight
                truncationMode: TruncationMode.Fade
                font.pixelSize: area.staticMode ? Theme.fontSizeSmall : Theme.fontSizeMedium
                color: button.highlighted || area.staticMode ? Theme.highlightColor : Theme.primaryColor
            }
            HighlightImage {
                id: image
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Theme.horizontalPageMargin
                }
                visible: !area.staticMode
                width: visible ? Theme.iconSizeMedium : 0
                highlighted: parent.highlighted
                source: "image://theme/icon-m-right"
                rotation: area.expanded ? -90 : 90
            }
        },
        Column {
            id: content
            width: parent.width
            anchors.top: button.bottom
            height: parent.expanded ? implicitHeight + Theme.paddingMedium : 0
            opacity: parent.expanded ? 1.0 : 0
            clip: true
            Behavior on height {NumberAnimation {duration: 300; easing.type: Easing.InOutCubic}}
            Behavior on opacity {NumberAnimation {duration: 300; easing.type: Easing.InOutCubic}}
        }
    ]

}
