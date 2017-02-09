import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"
import "lib"

ApplicationWindow
{
    id: app
    initialPage: Component { PlayerPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
    property var log: (options.doLog ? console.log : function(){})

    Options {
        id: options
    }
    Appstate {
        id: appstate
    }


    function formatMSeconds (duration) {
        var dur = duration / 1000,
                hours =  Math.floor(dur /3600),
                minutes =  Math.floor((dur - hours * 3600) / 60),
                seconds = Math.floor(dur - (hours * 3600) - minutes * 60);

        return (hours?(hours+':'):'')+ ("0"+minutes).slice(-2) + ':' + ("0"+seconds).slice(-2);
    }
}


