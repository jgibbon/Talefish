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

ListItem {
    id: listItem
    contentHeight: Theme.itemSizeSmall
    highlighted: down
    property bool pressIsHold: false // no click on long press
    onPressed: pressIsHold = false

    onClicked: {
        if(pressIsHold) {return;}
        listView.folder = filePath
    }
    onPressAndHold: pressIsHold = true // just to prevent onClicked when holding for scroll…
    HighlightImage {
        id: fileIcon
        fillMode: Image.PreserveAspectFit
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
        }
        asynchronous: true
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        property url folderUrl: filePath in places.generalModelIcons
                                ? places.generalModelIcons[filePath]
                                : 'image://theme/icon-m-file-folder'
        source: folderUrl
    }

    HighlightImage {
        id: favouriteIcon
        anchors {
            left: fileIcon.left
            verticalCenter: fileIcon.verticalCenter
        }
        fillMode: Image.PreserveAspectFit
        height: Theme.iconSizeExtraSmall
        width: height
        asynchronous: true
        visible: app.options.placesFavourites.indexOf(filePath) > -1
        source: visible ? 'image://theme/icon-s-favorite' : ''

    }
    OpacityRampEffect {
        sourceItem: fileIcon
        direction: OpacityRamp.RightToLeft
        offset: favouriteIcon.visible ? 0.5 : 1.0
    }


    Item {
        id: centerContainer
        height: mainLabel.height
        anchors {
            left: fileIcon.right
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }

        MarqueeLabel {
            id: mainLabel
            text: fileName
            color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            enabled: listItem.down
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: Theme.paddingMedium
                rightMargin: enabled ? -Theme.horizontalPageMargin : 0
            }
        }

        PlacesDirectoryProgressBar {
            path: String(listView.sortMode) + filePath
            highlighted: listItem.highlighted
            anchors {
                left: mainLabel.left
                right: parent.right
                verticalCenter: mainLabel.bottom
            }
            leftMargin: 0
            rightMargin: 0
        }
    }
}
