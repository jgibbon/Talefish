import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import Launcher 1.0
import "./StringScore.js" as Score


Dialog {
    id: scanner
    property ListModel playlist
    property int scanned: 0
    property var log: function(){}
    canAccept: false
    property bool scanCoverForFilenames: false
    property var activateQueue:[]
    property var coverArray:[]
    property bool tryToUseMediaInfo: true
    Launcher {
        id: program
    }
    property var startDate: null
    Component.onCompleted: {
        var i = 0
        activateQueue = [];
        startDate = new Date();
        while(i < playlist.count){

            activateQueue.push(function(i){
                return function(){
                    //get cover first
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
                            playlist.setProperty(i,'coverImage', highestPath);
                        }

                    }
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


                    //then add media to continue
                    mediaData.index = i;
                    if(mediainfoduration !== null) {
                        playlist.setProperty(i, 'duration', mediainfoduration);
                        scanTimer.interval = 0;
                        scanTimer.start()

                    } else {
                        scanTimer.interval = 5;
                        mediaData.source = playlist.get(i).path+'';
                    }


                }

            }(i));
            i++;
        }

    }


    onAccepted: {
        log('accept scanner!');

    }



    Timer {
        id:scanTimer
        interval: 5
        running: true
        //        repeat: scanned < playlist.count
        onTriggered: {
            if(scanned < playlist.count) {
                if(typeof(activateQueue[scanned]) === 'function') {
                    activateQueue[scanned]();
                } else {
                    log('scanTimer: queue item seems to be invalid', scanned, JSON.stringify(playlist[scanned]));
                }

                scanned++;
            } else {
                log('starting accept timer');
                acceptedTimer.start()
            }
        }
    }
    Timer {
        id: acceptedTimer
        interval: 600
        onTriggered: {
            canAccept = true;
            accept();
        }
    }


    SilicaFlickable {

        id: flickable
        anchors.fill: parent

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

        MediaPlayer {
            id: mediaData
            volume: 0
            property int index: 0
            //            }
            property QtObject lastActiveFile
            onStatusChanged: {
                //                console.log(status,
                //                            MediaPlayer.UnknownStatus,
                //                            MediaPlayer.NoMedia,
                //                            MediaPlayer.Loading,//2
                //                            MediaPlayer.Loaded,
                //                            MediaPlayer.Stalled,//4
                //                            MediaPlayer.Buffering,
                //                            MediaPlayer.Buffered, //6
                //                            MediaPlayer.EndOfMedia,
                //                            MediaPlayer.InvalidMedia //8
                //                            );
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
                scanTimer.start()
            }
            onError: {
                // emu workaround: fake values
                if(errorString === 'The QMediaPlayer object does not have a valid service') {
                    playlist.setProperty(index, 'duration', -1)
                }

                scanTimer.start()
            }
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
                    width: parent.width - Theme.paddingSmall *2
                    x: Theme.paddingSmall
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
                        text: scanned > index + 1 ? (model.duration > 0 ? bgItem.formatted: qsTr('Error')) :'-'
                        font.pixelSize: Theme.fontSizeTiny
                        verticalAlignment: Text.AlignVCenter
                        anchors.right: parent.right
                    }
                }


                Component.onCompleted: {
                }
                onClicked: {

                    scanTimer.start()
                }
            }


            VerticalScrollDecorator {
                flickable: fileList
            }
        }

    }


}
