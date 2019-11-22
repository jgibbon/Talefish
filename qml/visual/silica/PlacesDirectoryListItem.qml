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
import TaglibPlugin 1.0

ListItem {
    id: listItem
    contentHeight: Theme.itemSizeSmall
    highlighted: down || listView.selectedPaths.indexOf(filePath) > -1
    property bool pressIsHold: false // no click on long press
    onPressed: pressIsHold = false

    onClicked: {
        if(pressIsHold) {return;}
        // add file to selected.
        listView.togglePathSelection(filePath);

    }
    onPressAndHold: pressIsHold = true // just to prevent onClicked when holding for scroll…

    TaglibPlugin {
        id: metaData
        Component.onCompleted: {
            metaData.getFileTagInfos(filePath)
        }
    }
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
        property url fileUrl: 'image://theme/icon-m-file-audio'
        property url coverUrl: 'image://taglib-cover-art/'+filePath+'#'+Theme.iconSizeMedium
        source: options.displayAlbumCoverInLists ? coverUrl : fileUrl
        opacity: fileIcon.status === Image.Ready ? 1.0 : 0.0
        Behavior on opacity {NumberAnimation {duration: fileIcon.source === fileIcon.coverUrl ? 500 : 0; easing.type: Easing.InOutQuad}}
        onStatusChanged: {
            if(fileIcon.source === fileIcon.coverUrl && fileIcon.status === Image.Ready && fileIcon.sourceSize.width === 1) {
                source = fileUrl
            }
        }
    }

    Item {
        id: centerContainer
        height: mainLabel.height +subLabel.height
        property bool fileMetaDataAvailable: metaData.loaded && metaData.title != ''
        states: [
            State {
                name: 'big'
                when: page.isLandscape

                PropertyChanges {
                    target: durationLabel
                    width: Theme.itemSizeLarge
                    height: centerContainer.height
                    fontSizeMode: Text.HorizontalFit
                    font.pixelSize: Theme.fontSizeExtraLarge
                    anchors.rightMargin: Theme.paddingMedium
                }
                AnchorChanges {
                    target: durationLabel
                    anchors.top: centerContainer.top
                }

                PropertyChanges {
                    target: durationLabel
                }
                AnchorChanges {
                    target: mainLabel
                    anchors.left: durationLabel.right
                }
            }

        ]
        anchors {
            left: fileIcon.right
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }

        MarqueeLabel {
            id: mainLabel
            text: parent.fileMetaDataAvailable ? metaData.title + ' - ' + metaData.album : fileName
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
            path: filePath
            highlighted: listItem.highlighted
            anchors {
                left: mainLabel.left
                right: parent.right
                verticalCenter: mainLabel.bottom
            }
            leftMargin: 0
            rightMargin: 0
        }

        Label {
            id: durationLabel
            text: metaData.loaded ? app.js.formatMSeconds(metaData.duration) : ''
            width: implicitWidth
            anchors {
                top: mainLabel.bottom
                left: centerContainer.left
                leftMargin: Theme.paddingMedium
            }

            font.pixelSize: Theme.fontSizeExtraSmall
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        }

        MarqueeLabel {
            id: subLabel
            text: parent.fileMetaDataAvailable ? fileName : ''
            color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
            height: text === '' ? 0 : contentHeight
            font.pixelSize: Theme.fontSizeExtraSmall
            enabled: listItem.down
            anchors {
                left: durationLabel.right
                leftMargin: Theme.paddingMedium
                right: parent.right
                top: mainLabel.bottom
            }
        }
    }
}
