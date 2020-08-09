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
import harbour.talefish.folderlistmodel 1.0

SilicaListView {
    id: listView
    property bool enqueue: app.options.placesRememberEnqueue && app.options.placesEnqueue
    // folder can't be alias; model sometimes 'forgets' change signal.
    // especially when sorting by modified time.
    property alias folder: folderModel.folder //'file://'+StandardPaths.home// url, set here;
    property alias folderPath: folderModel.path // path, automatically filled
    onFolderChanged: selectedPaths = [];
    property int sortMode: app.options.placesRememberSort ? app.options.placesSort : FolderListModel.Name
    property bool sortReversed: app.options.placesRememberSort ? app.options.placesSortReversed : false
    property var selectedPaths:[]
    property var useablePaths:[] // gets used if available and selectedPaths.length === 0
    model: folderModel
    populate: Transition {
        AddAnimation {}
    }
    function togglePathSelection(path) {
        var index = selectedPaths.indexOf(path);
        if(index > -1) {
            selectedPaths.splice(index, 1);
        } else {
            selectedPaths.push(path);
        }

        selectedPathsChanged();
    }

    VerticalScrollDecorator { flickable: listView }
    footer: Component {
        Item {height: Theme.paddingLarge; width: parent.width}
    }

    header: Component {
        Item {
            width: parent.width
            height: currentFolderItem.height + folderUpItem.height + settingsMenu.height

            Item {
                id: currentFolderItem
                width: parent.width
                height: Theme.itemSizeSmall

                IconButton {
                    id: favouriteButton
                    width: Theme.itemSizeSmall
                    height: Theme.itemSizeSmall
                    icon.source: isFavourite ? 'image://theme/icon-m-favorite-selected' : 'image://theme/icon-m-favorite'
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    property bool isFavourite: app.options.placesFavourites.indexOf(folderModel.path) > -1
                    onClicked: {
                        if(isFavourite) {
                            app.options.placesFavourites.splice(app.options.placesFavourites.indexOf(folderModel.path), 1);
                        } else {
                            app.options.placesFavourites.push(folderModel.path);
                        }
                        app.options.placesFavouritesChanged();
                    }
                }
                Label {
                    id: folderNameLabel
                    text: folderModel.folderName || '/'
                    anchors {
                        left: favouriteButton.right
                        leftMargin: Theme.paddingMedium
                        right: settingsButton.left
                        rightMargin: Theme.paddingMedium
                        top: parent.top
                        bottom: folderPathLabel.top
                    }
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeMedium
                    textFormat: Text.PlainText
                    truncationMode: TruncationMode.Fade
                    color: Theme.highlightColor

                }
                PlacesDirectoryProgressBar {
                    path: String(listView.sortMode)+(listView.sortReversed?'rev':'')+listView.folderPath
                    highlighted: true
                    anchors {
                        left: folderNameLabel.left
                        right: folderNameLabel.right
                        verticalCenter: folderNameLabel.bottom
                    }
                    leftMargin: 0
                    rightMargin: 0
                }
                Label {
                    id: folderPathLabel
                    property bool isShown: text !== '' && text !== '/'
                    height: isShown ? contentHeight + Theme.paddingSmall : 0
                    anchors {
                        left: favouriteButton.right
                        leftMargin: Theme.paddingMedium
                        right: settingsButton.left
                        rightMargin: Theme.paddingMedium
                        bottom: parent.bottom
                    }
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: folderModel.path
                    truncationMode: TruncationMode.Fade
                    color: Theme.secondaryHighlightColor
                    textFormat: Text.PlainText
                    function setAlignment(){
                        horizontalAlignment = contentWidth < width ? Text.AlignLeft : Text.AlignRight
                    }
                    opacity: isShown ? 1 : 0
                    onTextChanged: setAlignment()
                    onWidthChanged: setAlignment()
                    Component.onCompleted: setAlignment()
                    Behavior on opacity {NumberAnimation {duration: 300}}
                    Behavior on height {NumberAnimation {duration: 300}}
                }
                IconButton {
                    id: settingsButton
                    width: Theme.itemSizeSmall
                    height: Theme.itemSizeSmall
                    icon.source: 'image://theme/icon-s-setting'
                    anchors {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    onClicked: {
                        settingsMenu.open(currentFolderItem.parent);
                    }
                    HighlightImage {
                        highlighted: parent.highlighted
                        visible: listView.enqueue
                        source: 'image://theme/icon-s-clear-opaque-cross'
                        rotation: 45
                        opacity: 0.7
                        anchors {
                            left: parent.left
                            leftMargin: -Theme.paddingSmall
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                        }
                    } // icon-s-low-importance

                    HighlightImage {
                        highlighted: parent.highlighted
                        visible: listView.sortReversed
                        opacity: 0.7
                        rotation: 180
                        source: 'image://theme/icon-s-low-importance'
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                        }
                    }
                    HighlightImage {
                        highlighted: parent.highlighted
                        visible: listView.sortMode === FolderListModel.Time
                        opacity: 0.7
                        source: 'image://theme/icon-s-time'
                        anchors {
                            right: parent.right
                            rightMargin: -Theme.paddingSmall
                            bottom: parent.bottom
                            bottomMargin: -Theme.paddingSmall
                        }
                    }
                }
                ContextMenu {
                    id: settingsMenu

                    MenuItem {
                        color: down || highlighted || current ? Theme.highlightColor : Theme.primaryColor
                        property bool current: !listView.enqueue
                        //: MenuItem: Open (replace currently open items) current files
                        text: qsTr('Open')
                           onClicked: {
                            listView.enqueue = false
                            app.options.placesEnqueue = listView.enqueue
                        }
                    }
                    MenuItem {
                        color: down || highlighted || current ? Theme.highlightColor : Theme.primaryColor
                        property bool current: listView.enqueue
                        //: MenuItem: Enqueue (add after currently open items) current files
                        text: qsTr('Enqueue')
                           onClicked: {
                            listView.enqueue = true
                            app.options.placesEnqueue = listView.enqueue
                        }
                    }
                    MenuItem {
                        enabled: false
                        height: Theme.paddingSmall
                        text: ''
                        Separator {
                            width: parent.width
                            color: Theme.primaryColor
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                        }
                    }
                    MenuItem {
                        color: down || highlighted || current ? Theme.highlightColor : Theme.primaryColor
                        property bool current: listView.sortMode === FolderListModel.Name
                        //: MenuItem: Sort directory content by name
                        text: qsTr("Sort by Name") + (current && listView.sortReversed ? ' ↑' : '');
                        onClicked: {
                            if(current) {
                                listView.sortReversed = !listView.sortReversed
                            } else {
                                listView.sortReversed = false
                            }

                            app.options.placesSortReversed = listView.sortReversed

                            listView.sortMode = FolderListModel.Name
                            app.options.placesSort = listView.sortMode
                        }
                    }

                    MenuItem {
                        color: down || highlighted || current ? Theme.highlightColor : Theme.primaryColor
                        property bool current: listView.sortMode === FolderListModel.Time
                        //: MenuItem: Sort directory content by modification date
                        text: qsTr("Sort by Last Modified") + (current && listView.sortReversed ? ' ↑' : '');
                        onClicked: {
                            if(current) {
                                listView.sortReversed = !listView.sortReversed
                            } else {
                                listView.sortReversed = false
                            }

                            app.options.placesSortReversed = listView.sortReversed

                            listView.sortMode = FolderListModel.Time
                            app.options.placesSort = listView.sortMode
                        }
                    }

                    MenuItem {
                        enabled: false
                        height: Theme.paddingSmall
                        text: ''
                        Separator {
                            width: parent.width
                            color: Theme.primaryColor
                            horizontalAlignment: Qt.AlignHCenter
                            anchors.centerIn: parent
                        }
                    }

                    MenuItem {
                        //: MenuItem: display options page for file handling and saved directory progress
                        text: qsTr("More Options");
                        onClicked: {
                            pageStack.push(Qt.resolvedUrl("../../pages/OptionsPage.qml"), { loadComponents:['OptionsFiles']});
                        }
                    }

                }
            }

            ListItem {
                id: folderUpItem
                width: parent.width
                height: enabled ? Theme.itemSizeSmall : 0
                enabled: listView.folder !== folderModel.parentFolder
                opacity: enabled ? 1.0 : 0.0
                onClicked: listView.folder = folderModel.parentFolder
                anchors {
                    top: currentFolderItem.bottom
                }

                HighlightImage {
                    id: folderUpImage
                    source: 'image://theme/icon-m-file-folder'
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin

                        verticalCenter: parent.verticalCenter
                    }
                    HighlightImage {
                        anchors.centerIn: parent
                        rotation: 180
                        source: 'image://theme/icon-s-unfocused-down'

                    }
                }
                Label {
                    textFormat: Text.PlainText
                    anchors {
                        left: folderUpImage.right
                        leftMargin: Theme.paddingMedium
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    //: Menu entry: Go up one Folder/Directory
                    text: qsTr('Parent Directory')
                }
            }
        }
    }
    Component {
        id: directoryComponent
        PlacesDirectoryListItemDirectory {}
    }
    Component {
        id: fileComponent
        PlacesDirectoryListItem {}
    }

    delegate: Component {
        Loader {
            width: listView.width
            property string filePath: model.filePath
            property string fileName: model.fileName
            sourceComponent: model.fileIsDir ? directoryComponent : fileComponent
        }
    }
        //PlacesDirectoryListItem {}

    FolderListModel {
        id: folderModel
        showOnlyReadable: true
        showDirsFirst: true
        sortField: listView.sortMode
//        folder: listView.folder

        sortReversed: listView.sortReversed
        nameFilters: {
            var cis=[];
            app.allowedFileExtensions.forEach(function(ext){
                cis.push('*.'+ext);
                cis.push('*.'+ext.toUpperCase());
            });
            return cis;
        }
        property string path: String(listView.folder).replace('file://', '')
        property string folderName: app.js.fileName(path)

        onCountChanged: {
//            console.log(count)
            var files = []
            var i = 0;
            while(i < count) {
                if(!folderModel.isFolder(i)){
                    files.push(folderModel.get(i, 'filePath'));
                }
//                console.log('file', folderModel.get(i, 'filePath'), 'folder?', folderModel.isFolder(i))
                i++;
            }
//            console.log(files.length, JSON.stringify(files));
            listView.useablePaths = files;
        }
    }
}
