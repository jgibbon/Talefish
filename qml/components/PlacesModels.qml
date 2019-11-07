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
import Launcher 1.0
import Sailfish.Silica 1.0

QtObject {
    id: places
    property Launcher launcher: Launcher {id:launcher}
    //: Section Header for list of favourite and last opened directories
    property string quickAccessTitle: qsTr('Quick Access')
    property var quickAccessModel: {
        var arr = [{
                       //: Menu entry: Go to most recently opened location
                       //~ Context Opens File chooser
                       name: qsTr('Recently opened'),
                       path: app.state.lastDirectory.replace('file://', ''), // Replacement: Legacy version compatibility
                       //'testpath is a bit longer testpath is a bit longer testpath is a bit longer testpath is a bit longer testpath is a bit longer testpath is a bit longer ',
                       image: 'image://theme/icon-m-backup',
                       hideIfUnavailable: false,
                       isFavourite: false
                   }];
        for(var i = 0; i < options.placesFavourites.length; i++) {
            arr.push({
                         name: options.placesFavourites[i].replace(/.*\/|\.[^.]*$/g, ''),
                         path: options.placesFavourites[i],
                         image: 'image://theme/icon-m-favorite',
                         hideIfUnavailable: false,
                         isFavourite:true
                     });
        }
        return arr
    }

    //: Section Header for list of common (home/music/…) directories on the device
    //~ Context Common Directories on device
    property string generalTitle: qsTr('Device')
    property var generalModel: {
        var arr = [
                    {
                        //: Menu entry: Go to user directory
                        //~ Context Opens File chooser
                        name: qsTr('Home'),
                        path: StandardPaths.home,
                        hidePath: true,
                        image: 'image://theme/icon-m-home',
                        hideIfUnavailable: true
                    },
                    {
                        //: Menu entry: Go to user music directory
                        //~ Context Opens File chooser
                        name: qsTr('Music'),
                        path: StandardPaths.music,
                        hidePath: true,
                        image: 'image://theme/icon-m-music',
                        hideIfUnavailable: true
                    },
                    {
                        //: Menu entry: Go to user downloads directory
                        //~ Context Opens File chooser
                        name: qsTr('Downloads'),
                        path: StandardPaths.download,
                        hidePath: true,
                        image: 'image://theme/icon-m-cloud-download',
                        hideIfUnavailable: true
                    },
                    {
                        //: Menu entry: Go to android (alien dalvik) storage directory
                        //~ Context Opens File chooser
                        name: qsTr('Android Storage'),
                        path: StandardPaths.home + '/android_storage',
                        hidePath: true,
                        image: 'image://theme/icon-m-file-apk',
                        hideIfUnavailable: true
                    },
                    {
                       //: Menu entry: Go to the root folder
                       //~ Context Opens File chooser
                       name: qsTr('Device memory'),
                       path: launcher.getRoot(),
                       image: 'image://theme/icon-m-phone',
                       hideIfUnavailable: false,
                       hidePath: true,
                       isFavourite:false
                   }];
        var mounts = launcher.getExternalVolumes()
        //: Menu entry: Go to SD card
        //~ Context Opens File chooser
        var sdCardString = qsTr('SD Card');
        //: Menu entry: Go to external storage
        //~ Context Opens File chooser
        var extStorageString = qsTr('External Storage');
        for(var i = 0; i < mounts; i++) {
            var isSDCard = mounts[i][0].indexOf('mmcblk1p1') > -1;
            arr.push({
                         name: isSDCard
                               ? sdCardString
                               : extStorageString,
                         path: mounts[i][1],
                         image: isSDCard ? 'image://theme/icon-m-sd-card' : 'image://theme/icon-m-usb',
                         hideIfUnavailable: false,
                         hidePath: false,
                         isFavourite:false
                     });
        }
        return arr;
    }
}
