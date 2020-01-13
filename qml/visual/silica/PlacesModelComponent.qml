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

Column {
    id: placesModelComponent
    width: page.width
    signal placeClicked(string path)
    SectionHeader {
        text: modelTitle
    }

    Flow {
        id: placesFlow
        width: parent.width
        spacing: Theme.paddingSmall
        Behavior on height {PropertyAnimation {duration: 300; easing.type: Easing.InOutQuad}}
        property bool halfWidth: modelContent && modelContent.length > 1 && (Screen.sizeCategory >= Screen.Large || page.isLandscape)
        Repeater {
            model: modelContent
            delegate: Item {
                id: placeItem
                height: placeBackground.height + removeFavouriteMenu.height
                visible: placeBackground.pathExists || !modelData.hideIfUnavailable
                width: placesFlow.halfWidth ? (parent.width / 2)-placesFlow.spacing : parent.width

                BackgroundItem {
                    id: placeBackground
                    height: Theme.itemSizeSmall
                    width: parent.width
                    property bool pathExists: modelData.path !== '' && app.launcher.folderExists(modelData.path)
                    property string textColor: highlighted && (pathExists || removeFavouriteMenu.active) ? Theme.highlightColor : Theme.primaryColor
                    property string secondaryTextColor: highlighted && pathExists ? Theme.secondaryHighlightColor : Theme.secondaryColor
                    enabled: pathExists || !!modelData.isFavourite
                    highlighted: down || removeFavouriteMenu.active
                    opacity: pathExists || removeFavouriteMenu.active ? 1 : 0.5
                    onPressAndHold: {
                        if(modelData.isFavourite) {
                            removeFavouriteMenu.open(placeItem)
                        }
                    }
                    onClicked: {
                        if(pathExists) {
                            placesModelComponent.placeClicked(modelData.path)
                        } else if(modelData.isFavourite) {
                            removeFavouriteMenu.open(placeItem)
                        }
                    }

                    HighlightImage {
                        id: placeImage
                        source: modelData.image
                        width: Theme.iconSizeMedium
                        height: Theme.iconSizeMedium
                        highlighted: placeBackground.highlighted
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            rightMargin: Theme.paddingLarge
                            leftMargin: Theme.horizontalPageMargin
                        }
                    }

                    Label {
                        id: placeName
                        anchors {
                            left: placeImage.right
                            leftMargin: Theme.paddingMedium
                            top: parent.top
                            bottom: placePath.top
                            right: parent.right
                            rightMargin: placesFlow.halfWidth && (index % 2 === 0) ? 0 : Theme.horizontalPageMargin
                        }
                        truncationMode: TruncationMode.Elide // TODO: Fade crashes the whole application?!
                        verticalAlignment: Text.AlignVCenter
                        textFormat: Text.PlainText
                        text: modelData.name
                        color: placeBackground.textColor
                    }
                    Label {
                        id: placePath
                        height: text !== '' ? contentHeight + Theme.paddingSmall : 0
                        anchors {
                            left: placeImage.right
                            leftMargin: Theme.paddingMedium
                            bottom: parent.bottom
                            right: parent.right
                            rightMargin: placesFlow.halfWidth && (index % 2 === 0) ? 0 : Theme.horizontalPageMargin
                        }
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: !modelData.hidePath ? modelData.path : ''
                        truncationMode: TruncationMode.Fade
                        color: placeBackground.secondaryTextColor
                        textFormat: Text.PlainText

                        function setAlignment(){
                            horizontalAlignment = contentWidth < width ? Text.AlignLeft : Text.AlignRight
                        }
                        onWidthChanged: setAlignment()
                        Component.onCompleted: setAlignment()
                    }
                }
                ContextMenu {
                    id: removeFavouriteMenu

                    MenuItem {
                        //: Menu entry: Remove currently selected (long pressed) Directory from favourites
                        text: qsTr('Remove from favourites')
                        onClicked: {
                            removeFavouriteAnimation.start()
                        }
                    }

                    NumberAnimation {
                        id: removeFavouriteAnimation; target: placeBackground; properties: "opacity,height"; to: 0; duration: 300; easing.type: Easing.InOutQuad
                        onStopped: {
                            options.placesFavourites = options.placesFavourites.filter(function(el){return el !== modelData.path});
                        }
                    }
                }
            }
        }
    }
}
