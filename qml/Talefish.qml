import QtQuick 2.0
import Sailfish.Silica 1.0
import Launcher 1.0
import "pages"
import "lib"

ApplicationWindow
{
    id: app
    initialPage: Component { PlayerPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
    property Launcher launcher: launcher
    property var log: (options.doLog ? console.log : function(){})
    function isBetweenTimes(start, end) {
        var current = new Date();
        current.setFullYear(1970);
        current.setMonth(0,1);

        start.setFullYear(1970);
        start.setMonth(0,1);
        end.setFullYear(1970);
        end.setMonth(0,1);
        var timeIsRight;
        if(end < start) {
            //assume 'before' is next day
            timeIsRight = current > start || current < end
        } else {
            timeIsRight = current > start && current < end
        }
        app.log('Are we in the time frame for starting slumber?', timeIsRight)
        return timeIsRight;
    }

    Options {
        id: options
        Component.onCompleted: {
            if(autoStartSlumber && launcher.fileExists('/usr/bin/harbour-slumber')
                    && (!autoStartSlumberInTimeframe || isBetweenTimes(autoStartSlumberAfterTime, autoStartSlumberBeforeTime))) {
                if(launcher.launch('ps -C harbour-slumber').indexOf('harbour-slumber') === -1) {
                    console.log('slumber does not seem to be running');
                    launcher.launchAndForget('/usr/bin/harbour-slumber', []);
                    if(autoStartSlumberAndRefocusTalefish) {
                        reactivateTimer.start();
                    }
                } else {
                    console.log('slumber already running');
                }

            }
        }
    }

    Timer {
        id: reactivateTimer
        interval: 50
        onTriggered: {
            if(Qt.application.state == Qt.ApplicationActive) {
                reactivateTimer.restart()
            } else {
                app.activate()
            }
        }
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
    Launcher {
        id: launcher
    }

}


