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
import Launcher 1.0
import '../lib'
import '../components'

Dialog {
    id: page
    allowedOrientations: Orientation.All
    acceptDestinationAction: PageStackAction.Replace
    canAccept: forwardNavigation && (directoryList.selectedPaths.length > 0 || directoryList.useablePaths.length > 0)
    forwardNavigation: panel.expanded && !panel.moving
    property Launcher launcher:Launcher {id:launcher}
    onAccepted: {
        var isWholeFolder = directoryList.selectedPaths.length === 0 || directoryList.selectedPaths.length === directoryList.useablePaths.length;
        var paths = isWholeFolder ? directoryList.useablePaths : directoryList.selectedPaths
        var enqueue = directoryList.enqueue
        app.playlist.fromJSON(paths, enqueue, isWholeFolder ? (String(directoryList.sortMode) + directoryList.folderPath) : null);
        app.state.lastDirectory = directoryList.folderPath
    }

    function displayDirectory(path, instant) {
        directoryList.folder = path;
        panel.animationDuration = instant ? 0 : 500;
        panel.open = true;
        directoryList.contentY = 0;
    }

    PlacesModels {
        id: places
        launcher: page.launcher
    }


    OpacityRampEffect {
        enabled: panel.expanded // ContextMenu in children exhibit weird opacity when always enabled
        sourceItem: placesFlickable
        direction: OpacityRamp.TopToBottom
        offset: 0.8 - panel.visibleOffset
        slope: 5.0
    }
    SilicaFlickable {
        id: placesFlickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            bottomPadding: Theme.paddingLarge
            PageHeader {
                id: pageHeader
                title: qsTr('Places', 'PageHeader Text for storage folders (open file)')
            }

            Loader {
                id: quickAccess
                property alias modelContent: places.quickAccessModel
                property string modelTitle: places.quickAccessTitle
                property alias launcher: page.launcher
                source: '../components/PlacesModelComponent.qml'
                Connections { target: quickAccess.item; onPlaceClicked: page.displayDirectory(path)}
            }
            Loader {
                id: general
                property alias modelContent: places.generalModel
                property string modelTitle: places.generalTitle
                property alias launcher: page.launcher
                source: '../components/PlacesModelComponent.qml'
                Connections { target: general.item; onPlaceClicked: page.displayDirectory(path)}
            }
        }
    }

    DockedPanel {
        id: panel

        width: parent.width
        height: page.height// - pageHeader.height
        property real visibleOffset: visibleSize / height
        background: Item {}

        dock: Dock.Bottom
        PageHeader {
            id: dialogHeader
            title: {


                if(directoryList.selectedPaths.length > 0 && directoryList.selectedPaths.length !== directoryList.useablePaths.length) {
                    if(!directoryList.enqueue) {
                        //: Dialog Header (Open as Playlist): Shown when files are selected, %L1 is the number of files
                        return qsTr('Open %L1 files', 'open x files', directoryList.selectedPaths.length).arg(directoryList.selectedPaths.length)
                    }
                    //: Dialog Header (Append to Playlist): Shown when files are selected, %L1 is the number of files
                    return qsTr('Enqueue %L1 files', 'enqueue x files', directoryList.selectedPaths.length).arg(directoryList.selectedPaths.length)
                } else if(directoryList.useablePaths.length > 0) {
                    if(!directoryList.enqueue) {
                        //: Dialog Header (Open as Playlist): Shown when no (or all) files are selected – whole directory will be opened
                        return qsTr('Open all files')
                    }
                    //: Dialog Header (Append to Playlist): Shown when no (or all) files are selected – whole directory will be opened
                    return qsTr('Enqueue all files')
                } else {
                    //: Dialog Header (Open or Append): Shown when no files are available in current Directory
                    return qsTr('Select directory')
                }
            }

            //: Dialog Sub-Header: Shown when no files are but can be selected (Open all Files… or select files to open)
            description: directoryList.selectedPaths.length === 0 && directoryList.useablePaths.length > 1 ? qsTr('or select files below') : ''
//            cancelText:''
//            spacing: 0
            Behavior on height { NumberAnimation {duration: 300; easing.type: Easing.InOutCubic}}
        }

        PlacesDirectoryListView {
            id: directoryList
            anchors {
                left: parent.left
                right: parent.right
                top:dialogHeader.bottom
                bottom: parent.bottom
            }
            clip: true
        }
    }
    Component.onCompleted: {
        if(app.options.placesAutoShowRecentDirectory) {
            var lastDir = app.state.lastDirectory.replace('file://', '');
            if(lastDir !== '' && launcher.fileExists(lastDir)) {

                displayDirectory(lastDir, true)
            }

        }
    }
}
