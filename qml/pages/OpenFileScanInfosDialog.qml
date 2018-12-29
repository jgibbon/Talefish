import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import Launcher 1.0
import "../lib"
import "../lib/StringScore.js" as Score

import TaglibPlugin 1.0


Dialog {
    id: scanner
    property Playlist playlist: Playlist{durationScanActive:false}
    property int scanned: 0
    property var log: function(){}
    canAccept: false

    //auto-accept as soon as possible:
    property bool canAcceptAndPageStackReady: !pageStack.busy && canAccept
    onCanAcceptAndPageStackReadyChanged: {
        if(canAcceptAndPageStackReady) {
            //!pageStack.busy does not mean it's not transitioning: race condition if run synchronously.
            // so we need to go async with a timer hack:
            acceptedTimer.start()
        }
    }
    Timer {
        id: acceptedTimer
        interval: 2
        onTriggered: {
            accept();
        }
    }

    property bool scanCoverForFilenames: options.scanCoverForFilenames
    property var activateQueue:[] // scan tasks, populated from scan()
    property var coverArray:[] //set from OpenFileDialog
    property bool tryToUseMediaInfo: false
    property string defaultCoverUrl: '' //set from OpenFileDialog
    property bool enqueue
    property var currentProgress: ({percent:0, index:0, position:0})
    Launcher {
        id: program
    }
    property var startDate: null
    property var scan: function(){
        var i = 0
        activateQueue = [];
        startDate = new Date();
        while(i < playlist.count){

            activateQueue.push(function(i){
                return function(){

                    //get cover first

                    playlist.setProperty(i,'coverImage', defaultCoverUrl);
                    app.log('default cover', defaultCoverUrl, scanCoverForFilenames)
                    if(scanCoverForFilenames && coverArray.length > 1){
                        var coveri = 0, highestScore=0, highestPath='';
                        log('getting cover for ', playlist.get(i).name);
                        while(coveri < coverArray.length){
                            var score = Score.calc(coverArray[coveri].baseName, playlist.get(i).baseName, true)
                            log(coveri, coverArray[coveri].baseName, playlist.get(i).baseName, score)
                            if(score >= highestScore){
                                highestScore = score;
                                highestPath = coverArray[coveri].path;
                            }

                            coveri++;
                        }
                        if(highestPath && highestScore > 0){
                            app.log('custom cover', highestPath);
                            playlist.setProperty(i,'coverImage', highestPath);
                        }

                    }

                    // optimum case: duration was already scanned in directory dialog (via c++ TaglibPlugin):
                    // if so, do nothing else ;)

                    scanTimer.interval = 0;
                    if(playlist.get(i).duration > 0) {
                        app.log('start timer 1 - current duration: ', playlist.get(i).duration, ' i:', i, scanned)
                        scanTimer.start()
                        return;
                    }

                    //fallback one: try c++ taglib again (directory dialog accepted too fast)
                    if(!taglibplugin.hadError) {
                        taglibplugin.i = i;
                        app.log('get via taglibplugin!', i, scanned);
                        taglibplugin.getFileTagInfos(playlist.get(i).path);
                        return;
                    }
                    app.log('fallback two')
                    //fallback two: if no duration from taglib: try external mediainfo executable
                    var mediainfo = null
                    var mediainfoduration = null
                    if(tryToUseMediaInfo) {
                        var info = program.launch('mediainfo --Output=JSON "'+playlist.get(i).path+'"')
                        if(info !== '') {
                            try {
                                mediainfo = JSON.parse(info);
                                mediainfoduration = parseFloat(mediainfo.media.track[0].Duration) * 1000;
                            } catch (error) {
                                log('error getting values from mediainfo, trying slow way')
                            }
                        }
                    }

                    mediaData.index = i;
                    if(mediainfoduration !== null) { // mediainfo successful
                        playlist.setProperty(i, 'duration', mediainfoduration);
                        scanTimer.interval = 5;

                        app.log('start timer 2')
                        scanTimer.start()
                    } else {

                        app.log('fallback three')
                        // fallback three: use infinitely slow qml player.
                        scanTimer.interval = 5;
                        mediaData.source = playlist.get(i).path+'';
                    }

                    taglibplugin.hadError = false;
                };

            }(i));
            i++;
        }
        interfaceLoader.active = true;
        scanTimer.start();
    }


    onAccepted: {
        app.log('accepted scanner!');
        appstate.player.pause();

        appstate.playlist.fromJSON(playlist.toJSON(), enqueue);

        if(appstate.playlist.count > 0){

            app.log('current progress', currentProgress.index, currentProgress.position)
            if(currentProgress && currentProgress.index > -1 && currentProgress.position > 0){
                app.log('setting progress to saved')
                appstate.playlistIndex = currentProgress.index;
                appstate.currentPosition = currentProgress.position;
                playOffset.start();
            }else {
                if(!currentProgress ){
                    app.log('currentprogress unset, setting to 0');
                    currentProgress = {percent:0, index:0, position:0};
                }
                app.log('setting progress to 0')
                appstate.currentPosition = 0;
                currentProgress.index = 0;
                currentProgress.position = 0;


                appstate.playlistIndex = 0;
                appstate.currentPosition = 0;

                playOffset.start();
            }
        } else {
            app.log('empty pl');
            appstate.playlistIndex = -1;
            appstate.currentPosition = 0;

            currentProgress.position = 0;
            currentProgress.index = -1;
        }
        appstate.player.seek(currentProgress.position);
    }

    Timer {
        id: playOffset
        interval: 200
        onTriggered: {
            if(currentProgress && currentProgress.index > -1 && currentProgress.position) {
                app.log('play offset…', currentProgress.position)
                appstate.tplayer.playPause();
                appstate.tplayer.playPause();
            }
        }
    }

    TaglibPlugin {
        id: taglibplugin
        property bool hadError: false
        property int i:0
        onTagInfos: {
            if(duration > 0) {
                playlist.setProperty(i, 'duration', duration);
                if(artist !== '')
                    playlist.setProperty(i, 'artist', artist);
                if(album !== '')
                    playlist.setProperty(i, 'album', album);
                if(track !== 0)
                    playlist.setProperty(i, 'track', track);
                if(duration !== 0)
                    playlist.setProperty(i, 'duration', duration);
                if(title !== '')
                    playlist.setProperty(i, 'title', title);

            }
            else { // rescan this entry without taglib
                scanned--;
                hadError = true
            }

            app.log('start timer 3')
            scanTimer.start();
        }
    }

    Timer {
        id:scanTimer
        interval: 5
        running: false
        //        repeat: scanned < playlist.count
        onTriggered: {
            app.log('scanTimer triggered', scanned);
            if(scanned < playlist.count) {
                if(typeof(activateQueue[scanned]) === 'function') {
                    activateQueue[scanned]();
                } else {
                    app.log('scanTimer: queue item seems to be invalid', scanned, JSON.stringify(playlist[scanned]));
                }
                scanned++;
            } else {
                canAccept = true;
            }
        }
    }

    MediaPlayer { //slow fallback to get durations
        id: mediaData
        volume: 0
        property int index: 0
        //            }
        property QtObject lastActiveFile
        onStatusChanged: {
            switch(status){
            case MediaPlayer.Buffered:
            case MediaPlayer.Loaded:
                log('scanned file status', status)
                play();
                break;
            default:
                break;
            }
        }
        onSourceChanged: {

            log('scanned file source', source);
            play();
            //                pause();
        }
        onAvailabilityChanged: {
            log('scanned file availability', availability);
        }
        onDurationChanged: {
            pause()
            log('scanned file duration', duration);
            playlist.setProperty(index, 'duration', duration);
            lastActiveFile = playlist.get(index)

            app.log('start timer 4')
            scanTimer.start()
        }
        onError: {
            // emu workaround: fake values
            if(errorString === 'The QMediaPlayer object does not have a valid service') {
                playlist.setProperty(index, 'duration', -1)
            }

            app.log('start timer 5')
            scanTimer.start()
        }
    }
    Loader {
        id: interfaceLoader
        active: false //playlist && playlist.count
        sourceComponent: visibleInterfaceComponent

        anchors.fill: parent
        onActiveChanged: {
            app.log('loader active changed:', active);
        }
    }

    Component {
        id: visibleInterfaceComponent
    SilicaFlickable {

        id: flickable
//        anchors.fill: parent

        PageHeader {
            id: headertext
            title: qsTr('%1 Files', 'header', playlist.count).arg(playlist.count)
            width: parent.width
            anchors.top: parent.top
            anchors.left: parent.left
        }

        Label {
            font.pixelSize: Theme.fontSizeTiny
            anchors.horizontalCenter: parent.Center
            anchors.bottom: headertext.bottom
            anchors.leftMargin: Theme.horizontalPageMargin
            anchors.left: parent.left
            text: ((scanCoverForFilenames && coverArray.length > 1) ? qsTr('Reading Durations and matching Cover files') : qsTr('Reading Durations'))
                  + '<br />'+  scanned + '/' +playlist.count + ' ' + (!!mediaData.lastActiveFile && mediaData.lastActiveFile.name ? mediaData.lastActiveFile.name + ' '+ app.formatMSeconds(mediaData.lastActiveFile.duration):'')
            horizontalAlignment: Text.horizontalCenter
        }

        ProgressBar {
            minimumValue: 0
            maximumValue: playlist.count - 1
            value: scanned
            width: parent.width
            anchors.verticalCenter: headertext.bottom
        }



        SilicaListView {
            id: fileList
            model: playlist
            anchors.top: headertext.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Theme.paddingSmall

            clip: true
            function rescan() {
                //let delegate's oncompleted scan the data
            }

            delegate: BackgroundItem {
                property var mediainfo
                width: parent.width
                height: Theme.itemSizeSmall
                id: bgItem

                anchors.left: parent.left
                anchors.right: parent.right
                property var format: app.formatMSeconds
                property string formatted: {
                    return model.duration > 0 ? format(model.duration) : qsTr('no Duration', 'if file duration < 1; instead of duration')
                }
                property bool hasCoverChanged: false
                property string cover: model.coverImage
                onCoverChanged: {
                    if(cover !== ''){
                        hasCoverChanged = true
                    }
                }

                Item {
                    width: parent.width - Theme.horizontalPageMargin *2
                    x: Theme.horizontalPageMargin
                    height: parent.height

                    Image {
                        id: imgItem
                        source: model.coverImage
                        width: model.coverImage !== '' ? parent.height : 0
                        height: parent.height
                        opacity: bgItem.hasCoverChanged ? 1.0 : 0.5
                    }

                    Label {
                        id: nameItem
                        height: Theme.itemSizeSmall
                        text: model.name
                        font.pixelSize: Theme.fontSizeTiny
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: imgItem.right
                        anchors.right: sizeItem.left
                        anchors.rightMargin: Theme.paddingSmall
                        anchors.leftMargin: Theme.paddingSmall
                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    }

                    Label {
                        id: sizeItem
                        height: Theme.itemSizeSmall
                        text: scanned > index ? (model.duration > 0 ? bgItem.formatted: qsTr('Error')) :'-'
                        font.pixelSize: Theme.fontSizeTiny
                        verticalAlignment: Text.AlignVCenter
                        anchors.right: parent.right
                    }
                }


                Component.onCompleted: {
                }
                onClicked: {

                    app.log('start timer 666')
                    scanTimer.start()
                }
            }


            VerticalScrollDecorator {
                flickable: fileList
            }
        }

    }
    }


}
