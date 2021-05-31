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
import "../../pages"

Item {
    id: area
    width: parent.width
    height: button.height + content.height
    property alias icon: image
    property alias text: label.text
    property bool expanded: false
    property bool staticMode: page.staticMode
    default property alias els: content.data
    property OptionsPage page
    states: [
        State {
            when: area.expanded
            PropertyChanges { target: image; rotation: 90 }
            PropertyChanges { target: content; height: content.implicitHeight + Theme.paddingLarge; opacity: 1.0 }
        }
    ]
    transitions: Transition {
        to: "*"
        NumberAnimation { target: content; properties: "height, opacity"; duration: 200}
    }
    Connections {
        target: area.page
        onSetActiveArea: area.expanded = (activeAreaIndex === index);
    }
    BackgroundItem {
        id: button
        height: Theme.itemSizeMedium
        enabled: !parent.staticMode
        onClicked: page.setActiveArea(area.expanded ? -1 : index)
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
            textFormat: Text.PlainText
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
            rotation: -90
        }
    }
    Column {
        id: content
        width: parent.width
        anchors.top: button.bottom
        height: 0
        opacity: 0
        clip: true
    }
}
