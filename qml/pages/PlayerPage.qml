

/*
TODO:
    - make options page awesome
        - use indexer and directorychooserdialog
        - move 'skip to file' to FirstPage pulley menu
        - sub page for timer
            - disable screen blank option
        - sub page for playback
            - pause between tracks
            - playbackspeed
            - skip ranges
            - show total progress
        - clear all settings
    - cover image
        - fallback?
    - app cover
        - durations, positions, basenames, cover image



*/
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import QtGraphicalEffects 1.0
//import QtSystemInfo 5.0


import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All

    function formatMSeconds (duration, debug) {
        var dur = duration / 1000,
                hours =  Math.floor(dur /3600),
                minutes =  Math.floor((dur - hours * 3600) / 60),
                seconds = Math.floor(dur - (hours * 3600) - minutes * 60);
        if(debug) {
            console.log('formatting duration', duration);
            console.log(dur);
            console.log(hours + 'h');
            console.log(minutes, ' -> ', ("0"+minutes).slice(-2));
            console.log(seconds, ' -> ', ("0"+seconds).slice(-2));
        }
        return (hours?(hours+':'):'')+ ("0"+minutes).slice(-2) + ':' + ("0"+seconds).slice(-2);
        //return;
    }

    property Audio playback: appstate.player
    property int directoryDuration : appstate.playlistDuration
    property bool isplaying: false //should i be playing? (regardless of actual playback state)
    property bool isPlaying: playback.isPlaying

    onDirectoryDurationChanged: {
        page.readDurations();
    }


    function readDurations (){
        //        return;
        var l = appstate.playlist.count,
                i = 0,
                currentIndex = -1,
                previousDuration = 0,
                totalDuration = 0;
        log('readdurations', l);
        //page.fileCount = l;
        while(i<l){
            if('file://'+appstate.playlist.get(i).path === playback.source.toString()){
                currentIndex = i;
                //console.log('currentIndex', i);
            }
            if(currentIndex === -1) {
                previousDuration = previousDuration + appstate.playlist.get(i).duration;
            }
            totalDuration = totalDuration + appstate.playlist.get(i).duration;

            i++;
        }

        totalPosition.previousDuration = previousDuration;
    }



    SilicaFlickable {
        anchors.fill: parent
        id: mainFlickable
        PullDownMenu {
            id: pulleyTop
            OpenPlaylistButton {
                id: opnBtn
                visible: false
            }

            OpenPlaylistButton {
                id: enqueueBtn
                visible: false
                enqueue: true
            }

            MenuItem {
                text: qsTr('Options', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("OptionsPage.qml"), {options:options,appstate:appstate, firstPage:page, log: log});
                }
            }
            MenuItem {
                //                enabled: options.directoryDuration !== playback.duration
                visible: appstate.playlist.count > 0
                text: qsTr('Playlist', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("PlaylistPage.qml"), {options:options,appstate:appstate, firstPage:page, log: log});
                }
            }

            MenuItem {
                text: qsTr("Enqueue", 'pulley')
                visible: appstate.playlist.count > 0 && options.showEnqueuePulley
                onClicked:
                    enqueueBtn.openDirectoryDialog() //pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
            MenuItem {
                text: qsTr("Open", 'pulley')
                onClicked:
                    opnBtn.openDirectoryDialog() //pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }

        }
        Item {

            width: parent.width // + parent.maxDrag*2
            anchors.top: pulleyTop.top
            anchors.bottom: cassette.verticalCenter // mainPageHeader.bottom
            z:-3
            opacity: 0.15
            Rectangle{
                id: cassetteBgRect
                anchors.fill: parent
                color: Qt.rgba(Theme.highlightBackgroundColor.r, Theme.highlightBackgroundColor.g, Theme.highlightBackgroundColor.b, coverMouseArea.sideTriggerActive ? 1 : 1)
            }

            OpacityRampEffect {
                sourceItem: cassetteBgRect
                offset: 0.5//-0.5 * coverMouseArea.dragFactor
                slope: 2 //coverMouseArea.sideTriggerActive ? 1.0 : 1.0

                direction: OpacityRamp.TopToBottom
            }

        }

        PageHeader {
            //title: 'Talefish'

            width: parent.width - ( page.isLandscape ? Theme.itemSizeLarge + Theme.paddingMedium : 0)

            id: mainPageHeader
            Label {
                id: headerText
                // Don't allow the label to extend over the page stack indicator
                width: Math.min(implicitWidth, parent.width - Theme.pageStackIndicatorWidth * _depth - 2*Theme.paddingLarge)
                text: 'Talefish'//+appstate.currentPosition;
                truncationMode: TruncationMode.Fade
                color: Theme.highlightColor
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    //                        rightMargin: sleepTimerWidget.visible ? sleepTimerWidget.width + Theme.paddingMedium * 2 : Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                }
                font {
                    pixelSize: Theme.fontSizeLarge
                    family: Theme.fontFamilyHeading
                }
            }
        }

        Item {
            id: backgroundCoverContainer
            anchors.fill: coverImageContainer
            z:-3
            Image {
                id: coverDisplayImage
                source: coverImage.source
                height: coverImage.paintedHeight
                width: coverImage.paintedWidth
                anchors.centerIn: parent
                opacity: 0.3
                y: coverImageContainer.y
            }

            OpacityRampEffect {
                id: effectBackground
                slope: 3 //the more, the shorter
                offset: 0.55
                sourceItem: coverDisplayImage
                direction: OpacityRamp.TopToBottom
                clampMax: 0.9
                clampMin: 0.0
            }

        }


        ProgressCassette {
            id:cassette
            width: Math.min( page.width, page.height) * 2
            height: width
            x: -width / 2
            y: appstate.playlistActive && (appstate.playlistActive.coverImage != '') ? x : x/2
            z: -2
            opacity: 0.6
            maximumValue: options.cassetteUseDirectoryDurationProgress ? totalPosition.maximumValue: appstate.playlistIndex > -1 ? appstate.playlist.get(appstate.playlistIndex).duration: 0
            value: options.cassetteUseDirectoryDurationProgress ? totalPosition.value: appstate.currentPosition
            running: options.useAnimations && options.usePlayerAnimations && isPlaying
            //tapeColor: Theme.highlightColor

        }
        Item {
            id: coverImageContainer

            width: parent.width - (page.isLandscape ? Theme.itemSizeLarge + Theme.paddingMedium : 0)

            y:page.isPortrait ? mainPageHeader.height : 0
            height: parent.height - infoColumn.height - (page.isPortrait ? controlPanel.height + mainPageHeader.height : 0) + fileNameLabel.height + fileFolderLabel.height//Theme.itemSizeSmall / 3

            Image {
                id: coverImage
                source: appstate.playlistActive && appstate.playlistIndex > -1 ? appstate.playlistActive.coverImage:''
                property string previousSource
                anchors.fill: parent

                onSourceChanged: {
                    if(previousSource){
                        coverImageFadeout.source = previousSource;
                        coverImageFadeout.opacity = coverImage.opacity;
                        opacity = 0;
                        createAnimation.start();
                        destroyAnimation.start();
                    }

                    previousSource = source
                }

                fillMode: Image.PreserveAspectFit
                opacity: 0.8
                z:-1

                NumberAnimation on opacity {
                    id: createAnimation
                    from: 0
                    to: 0.8
                    duration: 500
                }
            }

            Image {
                id: coverImageFadeout
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                opacity: 0
                z:-1

                visible:appstate.playlistIndex > -1
                NumberAnimation on opacity {
                    id: destroyAnimation
                    to: 0
                    duration: 500
                }


            }

            NumberAnimation on x {
                id: animateCoverContainerXBack0
                to: 0
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }


        OpacityRampEffect {
            id: effect
            slope: 1 //the more, the shorter
            offset: 0
            sourceItem: coverImageContainer
            direction: OpacityRamp.TopToBottom
            clampMax: 0.9
            clampMin: 0.15
        }

        Label {
            anchors.fill: coverImageContainer
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: Theme.highlightColor
            text:qsTr('[No Cover]')
            font.pixelSize: Theme.fontSizeLarge
            opacity: coverImage.source ? 0 : 0.6
            visible:appstate.playlistIndex > -1
            Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}

            clip:true
        }

        Label {
            anchors.fill: coverImageContainer
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text:qsTr('Nothing to play')
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.highlightColor
            visible:appstate.playlistIndex == -1 || !appstate.playlist.count
            Text {
                text: qsTr('Open Files by pulling down.')
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Theme.fontSizeSmall
                anchors.fill: parent
                anchors.topMargin: Theme.itemSizeSmall
                color: Theme.secondaryColor
            }
        }



        MouseArea {
            id: coverMouseArea


            visible: options.playerSwipeForNextPrev && (appstate.playlist.count > 1 || appstate.currentPosition > options.skipBackTrackThreshold)
            property bool sideTriggerActive: false
            property alias target: coverImageContainer
            anchors.fill: target
            onClicked: {
                //                    sleepTimer.restart();
            }
            onPressed: {
                //                console.log('onpressed')
            }
            onMouseXChanged: {
                var m = mouse, act = sideTriggerActive;
                act = false;
                if(target.x !== 0){

                    switch(target.x){
                    case drag.maximumX:
                        act = true;
                        break;
                    case drag.minimumX:
                        act = true;
                        break;
                    default:

                    }
                }
                if(act !== sideTriggerActive){
                    sideTriggerActive = act;
                }
            }

            drag.target: target
            drag.axis: Drag.XAxis
            drag.threshold: 15
            property int maxDrag: 100
            drag.minimumX: appstate.playlistIndex < appstate.playlist.count-1 ? maxDrag*-1 : 0 //next
            drag.maximumX: appstate.playlistIndex > 0 || appstate.currentPosition > options.skipBackTrackThreshold ? maxDrag:0 //prev

            onReleased: {
                animateCoverContainerXBack0.duration =  (dragValue / maxDrag) * 400
                animateCoverContainerXBack0.start()
                if(sideTriggerActive){
                    app.log('Player Page: Slided to skip' )


                    sideTriggerActive = false;
                    if(target.x < 0){//next
                        if(appstate.playlistIndex < appstate.playlist.count - 1){
                            appstate.tplayer.playIndex(appstate.playlistIndex + 1, {isPlaying: appstate.tplayer.isplaying});

                        } else {

                            appstate.tplayer.playIndex(0, {isPlaying: appstate.tplayer.isplaying});
                        }

                    } else if(target.x > 0) {//prev
                        if(appstate.currentPosition > options.skipBackTrackThreshold) {
                            appstate.currentPosition = 0;
                            appstate.player.seek(0)
                        } else {
                            appstate.tplayer.playIndex(appstate.playlistIndex - 1, {isPlaying: appstate.tplayer.isplaying});
                        }
                    }
                }
            }
            onSideTriggerActiveChanged: {
                if(_ngfEffect) {
                    _ngfEffect.play()
                }
            }
            property QtObject _ngfEffect
            Component.onCompleted: {
                _ngfEffect = Qt.createQmlObject("import org.nemomobile.ngf 1.0; NonGraphicalFeedback { event: 'pulldown_highlight' }",
                                   coverMouseArea, 'NonGraphicalFeedback');
            }

            property int dragValue: Math.abs(target.x)
            property real dragFactor: maxDrag / dragValue
            Item {
                id: coverDraggedLabelContainer
                height: parent.height
                width: parent.width

                visible: coverMouseArea.dragValue > coverMouseArea.maxDrag * 0.5
                opacity: coverMouseArea.sideTriggerActive ? 1.0:0.0

                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}

                Rectangle{
                    id: coverDragRect
                    color: Qt.rgba(Theme.highlightDimmerColor.r, Theme.highlightDimmerColor.g, Theme.highlightDimmerColor.b, 0.85)
                    height: parent.height
                    width: parent.width // + parent.maxDrag*2
                    x:( -coverMouseArea.target.x )
                }

                OpacityRampEffect {
                    sourceItem: coverDragRect
                    offset: 0.0//-0.5 * coverMouseArea.dragFactor
                    slope: parent.opacity * 0.8//coverMouseArea.sideTriggerActive ? 1.0 : 1.0

                    direction: coverMouseArea.target.x > 0 ? OpacityRamp.RightToLeft: OpacityRamp.LeftToRight
                }


                Label {
                    text: coverMouseArea.target.x > 0 ? (appstate.currentPosition > options.skipBackTrackThreshold? qsTr('Rewind Track'): qsTr('Previous Track')): qsTr('Next Track')
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    horizontalAlignment: coverMouseArea.target.x > 0 ? Text.AlignRight: Text.AlignLeft // Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: Theme.highlightColor
                    x:( -coverMouseArea.target.x ) + Theme.paddingSmall
                    width: parent.width - (Theme.paddingSmall * 2)
                    height: parent.height
                }
            }
            Item {
                id: draggableContainer
                x: -coverMouseArea.target.x

                width: parent.width// + (coverMouseArea.drag.maximumX  ) + (-coverMouseArea.drag.minimumX)
                height: parent.height
                clip:true
                Item {
                    id: maxItem
                    height: parent.height
                    width:  coverMouseArea.dragValue*2 + coverMouseArea.maxDrag * 0.1
                    visible: coverMouseArea.target.x < 0
                    anchors.right: parent.right
                    Rectangle{
                        id: maxBg
                        color: Qt.rgba(Theme.highlightBackgroundColor.r, Theme.highlightBackgroundColor.g, Theme.highlightBackgroundColor.b, coverMouseArea.sideTriggerActive ? 0.7 : 0.4)
                        width: parent.width
                        height: parent.height

                    }
                    OpacityRampEffect {
                        sourceItem: maxBg
                        offset: 0//-0.5 * coverMouseArea.dragFactor
                        slope: coverMouseArea.sideTriggerActive ? 1.0 : 1.0

                        direction: OpacityRamp.RightToLeft
                    }
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        //                        anchors.right: parent.right
                        x: parent.width-width + (coverMouseArea.maxDrag - coverMouseArea.dragValue) *2
                        opacity: coverMouseArea.sideTriggerActive ? 1.0 : 0.3
                        source: 'image://theme/icon-m-next?'+(coverMouseArea.sideTriggerActive ? Theme.highlightColor : Theme.primaryColor)
                    }
                }

                Item {
                    id: minItem
                    height: parent.height
                    width:  coverMouseArea.dragValue*2 + coverMouseArea.maxDrag * 0.1
                    visible: coverMouseArea.target.x > 0
                    anchors.left: parent.left
                    Rectangle{
                        id: minBg
                        color: Qt.rgba(Theme.highlightBackgroundColor.r, Theme.highlightBackgroundColor.g, Theme.highlightBackgroundColor.b, coverMouseArea.sideTriggerActive ? 0.7 : 0.4)
                        width: parent.width
                        height: parent.height
                        anchors.right: parent.right
                    }
                    OpacityRampEffect {
                        sourceItem: minBg
                        offset: 0//-0.5 * coverMouseArea.dragFactor
                        slope: coverMouseArea.sideTriggerActive ? 1.0 : 1.0

                        direction: OpacityRamp.LeftToRight
                    }
                    Image {
                        anchors.verticalCenter: parent.verticalCenter

                        x: -(coverMouseArea.maxDrag - coverMouseArea.dragValue) *2
                        //                        anchors.right: parent.right
                        opacity: coverMouseArea.sideTriggerActive ? 1.0 : 0.3
                        source: 'image://theme/icon-m-previous?'+(coverMouseArea.sideTriggerActive ? Theme.highlightColor : Theme.primaryColor)
                    }
                }
            }

        }

        Item {
            id: column
            anchors.fill: parent

            anchors.rightMargin: page.isLandscape ? Theme.itemSizeLarge + Theme.paddingMedium : 0

            Column {
                id: infoColumn
                width: parent.width


//                spacing: Theme.paddingLarge
                anchors.bottom: parent.bottom
                anchors.bottomMargin: page.isPortrait? controlPanel.height : Theme.paddingMedium
                    Label {
                        width: parent.width - Theme.paddingSmall * 2
                        x: Theme.paddingSmall
                        id: fileNameLabel
                        text: appstate.playlistActive ? appstate.playlistActive.baseName :''
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Theme.highlightColor
                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        layer.enabled: Theme.colorScheme //is it light?
                        layer.effect: DropShadow {
                            color: '#ffffff33'
                        }
                    }

                    Label {
                        width: parent.width - Theme.paddingSmall * 2
                        x: Theme.paddingSmall
                        id: fileFolderLabel
                        property string displayPath:appstate.playlistActive && appstate.playlistActive.folderName ? appstate.playlistActive.folderName:''
                        visible: displayPath !== '' && options.playerDisplayDirectoryName
                        text: displayPath
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeExtraSmall
                        wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                        layer.enabled: Theme.colorScheme //is it light?
                        layer.effect: DropShadow {
                            color: '#ffffff33'
                        }
                    }

                    Slider {
                        id: currentPositionSlider
                        value: Math.max( realvalue, appstate.currentPosition)
                        property real realvalue: playback.position
                        function applyValue(){

                            if(value + 100 >= appstate.playlistActive.duration){//does not quite set it at the end, so skipping gets confused.
                                value = appstate.playlistActive.duration - 100;
                            }
                            appstate.currentPosition = value;
                            //also does not update state?!
                            playback.seek(value);
                        }

                        onRealvalueChanged: {
                            if(!down) {
                                value = Math.max( realvalue, appstate.currentPosition)
                            }
                        }
                        onDownChanged: {
                            if(!down) applyValue()
                        }

                        height: totalPositionWrapper.visible ? Theme.itemSizeExtraSmall : implicitHeight
                        minimumValue: 0
                        maximumValue: appstate.playlistActive && appstate.playlistActive.duration > 0? appstate.playlistActive.duration:0.0001
                        width: parent.width
                        visible: appstate.playlistIndex != -1
                        label: formatMSeconds( value)+" / "+formatMSeconds(maximumValue) +' ('+ (Math.floor(( currentPositionSlider.value / currentPositionSlider.maximumValue) * 1000 ) / 10)+'%)'

                        onClicked: {

                        }
                    }

                    Item {
                        id: totalPositionWrapper
                        width: parent.width
                        height: totalPosition.height
                        visible: appstate.playlistIndex > -1 && appstate.playlist.count > 1

                        Slider {
                            id: totalPosition
                            property int previousDuration: appstate.playlistActive.playlistOffset
                            value: (appstate.playlistActive ? appstate.playlistActive.playlistOffset:0) + currentPositionSlider.value
                            visible: options.playerDisplayDirectoryProgress && appstate.playlistIndex > -1 && appstate.playlist.count > 1// options.directoryFiles && options.directoryFiles.length > 1// && appstate.playlistIndex !== -1
                            opacity: totalDurationNotification.isvisible ? 0 : 0.5
                            minimumValue: 0
                            height: Theme.itemSizeSmall

                            maximumValue: appstate.playlist.duration
                            enabled: false
                            width: parent.width
                            handleVisible: false
                            Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}

                            Label {
                                color: Theme.secondaryColor
                                width: parent.width
                                height: Theme.itemSizeSmall  - Theme.paddingLarge
                                opacity: 0.8
                                horizontalAlignment: Text.AlignHCenter
                                anchors.bottom: parent.bottom
                                verticalAlignment: Text.AlignBottom
                                font.pixelSize: Theme.fontSizeExtraSmall
                                text:  qsTr('%1 / %2 (File %L3 of %L4)', 'formatted file/directory durations, then file number/count )').arg(formatMSeconds( totalPosition.value)).arg(formatMSeconds(totalPosition.maximumValue)).arg(appstate.playlistIndex+1).arg(appstate.playlist.count)
                            }

                        }

                        MouseArea {
                            anchors.fill: totalPosition
                            anchors.topMargin: Theme.paddingLarge
                            onClicked: {

                                totalDurationNotification.show(2000)
                            }

                            InlineNotification {
                                id: totalDurationNotification
                                anchors.centerIn: parent
                                height:isvisible ? parent.height : 0
                                width: totalPosition.width
                                property int totalperc: totalPosition.maximumValue ? (Math.floor(( totalPosition.value / totalPosition.maximumValue) * 1000 ) / 10) : 0
                                text: qsTr('%1% played in Total', 'directory progress', totalperc).arg(totalperc)
                            }
                        }
                    }


//                }



            }


        }

        //control panel

        Item {
            id: controlPanel
            // visibleSize: Theme.itemSizeLarge
            width: page.isPortrait ? parent.width : Theme.itemSizeLarge + Theme.paddingLarge
            height: page.isPortrait ? Theme.itemSizeLarge + Theme.paddingLarge : parent.height
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            Flow {
                height: page.isLandscape ? sizeOfEntries : (Theme.itemSizeLarge - Theme.paddingLarge)
                width: page.isPortrait ? sizeOfEntries : Theme.itemSizeLarge
                anchors.centerIn: parent

                spacing: 20
                id:iconButtons


                property int numberOfEntries: 5 //todo: make model/repeater with json
                property int sizeOfEntries: (Theme.itemSizeSmall + spacing) * numberOfEntries - spacing;

                property bool isPlaying: appstate.tplayer.isplaying

                ColorIconButton {
                    icon.source: "../icon-l-frwd.png"
                    enabled: totalPosition.value > options.skipDurationNormal
                    onClicked: {
                        appstate.tplayer.seek(0 - options.skipDurationNormal)
                    }
                }
                ColorIconButton {
                    enabled: totalPosition.value > options.skipDurationSmall
                    icon.source: "../icon-l-rwd.png"
                    onClicked: {
                        appstate.tplayer.seek(0 - options.skipDurationSmall)
                    }
                }
                IconButton {
                    id: play
                    enabled: appstate.playlistIndex > -1 && appstate.playlist.count > 0
                    icon.source: playback.playbackState == Audio.PlayingState ? "image://theme/icon-l-pause": "image://theme/icon-l-play"
                    onClicked: appstate.tplayer.playPause()
                }
                ColorIconButton {
                    icon.source: "../icon-l-fwd.png"
                    enabled: totalPosition.maximumValue - totalPosition.value > options.skipDurationSmall
                    onClicked: {
                        appstate.tplayer.seek(options.skipDurationSmall)
                    }
                }
                ColorIconButton {
                    icon.source: "../icon-l-ffwd.png"
                    enabled: totalPosition.maximumValue - totalPosition.value > options.skipDurationNormal
                    onClicked: {
                        appstate.tplayer.seek( options.skipDurationNormal)
                    }
                }
            }
        }
    }
}
