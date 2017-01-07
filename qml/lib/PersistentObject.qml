import QtQuick 2.0

import QtQuick.LocalStorage 2.0
import "PersistentObjectStore.js" as Store

QtObject {
    id: settings
    objectName: "default"
    property var storeSettings: ['Talefish','1.0','Settings', objectName]
    property bool doPersist: true

    Component.onCompleted: {
        Store.initialize(storeSettings, LocalStorage);

        doPersist && Store.load(settings);
    }

    Component.onDestruction: {
        //save defaults even if !doPersist?
        save()
    }
    function save(){
        if(doPersist) {
            Store.save(settings);
            app.log('saved!', objectName)
        }
    }
}
