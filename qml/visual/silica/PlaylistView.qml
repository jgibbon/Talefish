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
import QtQml.Models 2.3
import Sailfish.Silica 1.0

SilicaListView {
    id: root
    property string userFilterString: root.headerItem.text
    property string programFilterString: userFilterString.toString().toLowerCase().trim()
    onProgramFilterStringChanged: {
        model.applyFilter();
    }
currentIndex: -1 // prevent inheriting the 'real' currentIndex; this would steal searchField focus at times

    header: SearchField {
        id: searchField
        width: parent.width
        placeholderText: qsTr("Search")
    }
    footer: Item {
        width: parent.width
        height: Theme.paddingLarge
    }

    model: DelegateModel {
        model: app.playlist.metadata
        groups: [
            DelegateModelGroup {
                name: "filterGroup"; includeByDefault: true
            }
        ]
        filterOnGroup: "filterGroup"
        function hasMatch(searchInArray) {
            for (var i = 0; i < searchInArray.length; i++) {
                if(searchInArray[i].toLowerCase().indexOf(root.programFilterString) > -1) {
                    return true;
                }
            }
            return false;
        }

        function applyFilter(){
            var numberOfEntries = app.playlist.metadata.count;
            var hasFilterString = !!root.programFilterString && root.programFilterString !== ''
            for (var i = 0; i < numberOfEntries; i++){
                if(!hasFilterString) {
                    items.addGroups(i, 1, "filterGroup");
                    continue;
                }
                var metadata = app.playlist.metadata.get(i);
                var searchInArray = [
                            String(metadata.path),
                            String(metadata.artist),
                            String(metadata.title),
                            String(metadata.album)
                        ]
                if (hasMatch(searchInArray)){items.addGroups(i, 1, "filterGroup");}
                else {items.removeGroups(i, 1, "filterGroup");}
            }
        }

        delegate: BackgroundItem {
            id: listItem
            width: parent.width
            height: Theme.itemSizeSmall

            anchors.left: parent.left
            anchors.right: parent.right

            // title (or base name)
            property string currentTitle: {
                if(model.title === '' ) { return app.js.fileName(model.path, true); }
                return model.title
            }
            // album (or directory base name)
            property string currentAlbum: {
                if(model.album === '' ) { return app.js.fileName(app.js.filePath(model.path)); }
                return model.album
            }
            property bool isActive:app.playlist.currentIndex === index
            highlighted: isActive || down
            property bool pressIsHold: false // no click on long press
            onPressed: pressIsHold = false
            onClicked: {
                if(pressIsHold || isActive) {return;}
                app.playlist.currentIndex = index
            }
            onPressAndHold: pressIsHold = true // just to prevent onClicked when holding for scroll…
            states: State {
                name: 'hovered'
                when: listItem.down
                PropertyChanges {target: nameItem; anchors.rightMargin: 0}
            }
            transitions: [
                Transition {
                    NumberAnimation {duration: 200; easing.type: Easing.InOutCubic}
                }
            ]

            Image {
                id: imgItem
                asynchronous: true
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                fillMode: Image.PreserveAspectCrop
                property url fileUrl: 'image://theme/icon-m-file-audio'
                property url coverUrl: 'image://taglib-cover-art/'+model.path+'#'+Theme.iconSizeMedium

                opacity: imgItem.status === Image.Ready ? 1.0 : 0.0
                Behavior on opacity {NumberAnimation {duration: imgItem.source === imgItem.coverUrl ? 500 : 0; easing.type: Easing.InOutQuad}}
                onStatusChanged: {
                    if(imgItem.source === imgItem.coverUrl && imgItem.status === Image.Ready && imgItem.sourceSize.width === 1) {
                        source = fileUrl
                    }
                }
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                }
                source: options.displayAlbumCoverInLists ? coverUrl : fileUrl
            }

            MarqueeLabel {
                id: nameItem
                enabled: listItem.down
                text: Theme.highlightText(listItem.currentTitle, root.userFilterString, Theme.highlightColor)
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                anchors.left: imgItem.right
                anchors.right: parent.right//sizeItem.left
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.leftMargin: Theme.paddingSmall
                anchors.top: parent.top
                Behavior on width {NumberAnimation{duration: 200; easing.type: Easing.InOutCubic}}
            }

            MarqueeLabel {
                id: folderItem
                enabled: listItem.down
                color: listItem.highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
                text: Theme.highlightText(listItem.currentAlbum, root.userFilterString, Theme.secondaryHighlightColor)
                font.pixelSize: Theme.fontSizeSmall
                anchors.left: imgItem.right
                anchors.right: sizeItem.left
                anchors.rightMargin: Theme.paddingSmall
                anchors.leftMargin: Theme.paddingSmall
                anchors.bottom: parent.bottom
                Behavior on width {NumberAnimation{duration: 200; easing: Easing.InOutCubic}}
            }
            Label {
                id: sizeItem
                text: model.duration > 0 ? app.js.formatMSeconds(model.duration) : qsTr('Error')
                font.pixelSize: Theme.fontSizeTiny
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: folderItem.verticalCenter
            }

        }
    }
    VerticalScrollDecorator {flickable: root}
}

