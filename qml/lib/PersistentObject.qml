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

import QtQuick.LocalStorage 2.0
import "PersistentObjectStore.js" as Store

QtObject {
    id: persistentObject
    objectName: "default"
    readonly property var storeSettings: ['Talefish','1.0','Settings', objectName]
    property bool doPersist: true
    property bool _loaded: false

    Component.onCompleted: {
        Store.initialize(storeSettings, LocalStorage);

        doPersist && Store.load(persistentObject);

        console.log('loaded DB', objectName)
    }

    Component.onDestruction: {
        //save defaults even if !doPersist?
        if(doPersist) {
            save()
        }
    }
    function save(keys) {
        if(doPersist && _loaded) {
            Store.save(persistentObject, keys);
        }
    }
    function saveKey(key) { // fewer checks and loops
        if(doPersist && _loaded) {
            Store.saveKey(persistentObject, key);
        }
    }

    function reset() {
        doPersist = false
        Store.reset()
    }
}
