import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0


import "../lib/"


import harbour.talefish.folderlistmodel 1.0
//import Qt.labs.folderlistmodel 1.0

Page {
    id: page
    property var options
    property var state
    property var firstPage




    allowedOrientations: firstPage.allowedOrientations
    orientation: firstPage.orientation


    SilicaFlickable {
        id: listView

        VerticalScrollDecorator{

        }

        anchors.fill: parent
        contentHeight: mainColumn.height


        PullDownMenu {
            id: pulleyTop

            MenuItem {
                text: qsTr('About', 'pulley')
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"), {options:options,appstate:appstate, firstPage:page});
                }
            }
        }


        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: qsTr("Options", 'header') }

            SectionHeader {
                text: qsTr("Playback", 'section header')
            }



            Slider {
                width: parent.width
                minimumValue: 0.8
                maximumValue: 1.2
                value: options.playbackRate
                stepSize: 0.01
                property bool isLongPressed: false

                label: qsTr('Playback Speed: %1\%', 'percent').arg(Math.round(value * 100))

                onPressed: {
                    isLongPressed = false
                }

                onPressAndHold: {
                    options.playbackRate = value = 1
                    isLongPressed = true
                }
                onReleased: {
                    if(!isLongPressed) {
                        options.playbackRate = value
                    }
                    else {
                        value = 1
                    }
                }
                onValueChanged: {
                    if(isLongPressed) {
                        value = 1
                    }
                }
            }


            TextSwitch {
                id:playNextFileEnabledSwitch
                text: qsTr('Play next Track automatically')
                property bool playNextFile: options.playNextFile
                onPlayNextFileChanged: {
                    checked = playNextFile
                }

                checked: playNextFile
                onClicked: {
                    options.playNextFile = checked
                }
            }




            OptionComboBox {
                optionname: 'skipDurationSmall'
                label:qsTr('Short Skip duration')
                jsonData: [{text:'10s', value: 10000}, {text:'20s', value: 20000}, {text:'30s', value: 30000}, ]
            }


            OptionComboBox {
                optionname: 'skipDurationNormal'
                label:qsTr('Long Skip duration')
                jsonData: [{text:'30s', value: 30000}, {text:'45s', value: 45000}, {text:'60s', value: 60000},{text:'120s', value: 120000}, ]
            }

            OptionComboBox {
//                visible: options.useHeadphoneCommands
                optionname: 'externalCommandSkipDuration'
                label: qsTr('External Commands skip')
                description: qsTr('External Commands are those executed from the lock screen or via headsets/bluetooth.')
                jsonData: [
                    {text: qsTr('to track beginning'), value: '0'},
                    {text: qsTr('Short Skip duration'), value: 'small'},
                    {text: qsTr('Long Skip duration'), value: 'normal'},
                ]
            }

            property var secondaryCoverActionCommands : [{text: qsTr('Hidden'), value: ''}, {text:qsTr('Skip forward'), value: 'next'}, {text:qsTr('Skip backward'), value: 'prev'}, {text:qsTr('Skip backward and forward'), value: 'both'} ]
            OptionComboBox {
                description: qsTr('App-Cover Actions are external Commands, as well.')
                optionname: 'secondaryCoverAction'
                label:qsTr("Additional App-Cover Actions")
                jsonData: parent.secondaryCoverActionCommands
            }


            SectionHeader {
                text: qsTr("Open Files", 'section header')
            }

            TextSwitch {
                id:scanCoverEnabledSwitch
                text: qsTr('Search best cover image for each file')
                checked: options.scanCoverForFilenames
                onClicked: {
                    options.scanCoverForFilenames = checked
                }
            }

            TextSwitch {
                id:resortNaturallySwitch
                text: qsTr('Sort directory naturally while scanning')
                description: qsTr('Enable if you have files numbered without leading zeroes. Only applicable when sorted by name.')
                checked: options.resortNaturally
                onClicked: {
                    options.resortNaturally = checked
                }
            }


            TextSwitch {
                id:showEnqueuePulleySwitch
                text: qsTr('Show "Enqueue" Pulley')
                checked: options.showEnqueuePulley
                onClicked: {
                    options.showEnqueuePulley = checked
                }
            }


            SectionHeader {
                text: qsTr("Tape Animations", 'section header')
            }


            TextSwitch {
                id:useAnimationEnabledSwitch
                text: qsTr('Do Animations')
                checked: options.useAnimations
                onClicked: {
                    options.useAnimations = checked
                }
            }
            TextSwitch {
                visible: useAnimationEnabledSwitch.checked
                id: playerAnimationEnabledSwitch
                text: qsTr('Player Page Animation')

                checked: options.usePlayerAnimations
                onClicked: {
                    options.usePlayerAnimations = checked
                }

            }

            TextSwitch {
                visible: useAnimationEnabledSwitch.checked
                id:coverAnimationEnabledSwitch
                text: qsTr('App-Cover Animation')

                checked: options.useCoverAnimations
                onClicked: {
                    options.useCoverAnimations = checked
                }

            }


            SectionHeader {
                text: qsTr("Player Page", 'section header')
            }


            TextSwitch {
                id:playerDirectoryEnabledSwitch
                text: qsTr('Display directory name')

                checked: options.playerDisplayDirectoryName
                onClicked: {
                    options.playerDisplayDirectoryName = checked
                }

            }
            TextSwitch {
                id:playerDirectoryProgressEnabledSwitch
                text: qsTr('Display playlist progress')

                checked: options.playerDisplayDirectoryProgress
                onClicked: {
                    options.playerDisplayDirectoryProgress = checked
                }

            }
            TextSwitch {
                id:playerSwipeNextPrevEnabledSwitch
                text: qsTr('Swipe Cover (or above Title) to skip Tracks')

                checked: options.playerSwipeForNextPrev
                onClicked: {
                    options.playerSwipeForNextPrev = checked
                }

            }

            OptionComboBox {
                optionname: 'cassetteUseDirectoryDurationProgress'
                label:qsTr("Cassette shows progress of")
                jsonData: [{text:qsTr('track'), value: false}, {text:qsTr('directory'), value: true} ]
            }


            SectionHeader {
                text: qsTr("Miscellaneous", 'section header')
            }

            Button {
                text: qsTr('External sleep timer integration')
                width: parent.width - Theme.horizontalPageMargin*2
                x: Theme.horizontalPageMargin
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("OptionsPage_SleepTimer.qml"), {options:options,appstate:appstate, firstPage:page, log: log});
                }
            }

            TextSwitch {
                id:useHeadphoneCommandsSwitch
                text: qsTr('Use head phone buttons/Bluetooth to control Talefish')

                checked: options.useHeadphoneCommands
                onClicked: {
                    options.useHeadphoneCommands = checked
                }

            }
            Column {
                id: headPhoneButtonColumn

                opacity: 0
                height: 0
                states: State {
                    name: "active"; when: options.useHeadphoneCommands
                    PropertyChanges { target: headPhoneButtonColumn; height: headPhoneButtonColumn.implicitHeight; opacity: 1 }
                }

                transitions: Transition {
                    NumberAnimation { properties: "height,opacity"; easing.type: Easing.InOutQuad }
                }
//                property bool active: options.useHeadphoneCommands
                width: parent.width - Theme.horizontalPageMargin - x
                x: Theme.horizontalPageMargin * 2

                Label {
                    wrapMode: Text.Wrap
                    x: Theme.horizontalPageMargin
                    width: parent.width - Theme.horizontalPageMargin * 2
                    font.pixelSize: Theme.fontSizeTiny
                    text: qsTr('You can choose the action you prefer to be executed when pressing the "Call/Hangup" button, which often is the only button on a headset:')
                }

                property var headPhonesCommands : [{text: qsTr('Do nothing'), value: 'nothing'}, {text:qsTr('Play/Pause'), value: 'playPause'}, {text:qsTr('Skip forward'), value: 'next'}, {text:qsTr('Skip backward'), value: 'prev'} ]
                OptionComboBox {
//                    visible: options.useHeadphoneCommands
                    optionname: 'headphoneCallButtonDoes'
                    label:qsTr("Button Press:")
                    jsonData: parent.headPhonesCommands
                }

                OptionComboBox {
//                    visible: options.useHeadphoneCommands
                    optionname: 'headphoneCallButtonLongpressDoes'
                    label:qsTr("Long press:")
                    jsonData: parent.headPhonesCommands
                }
            }
            TextSwitch {
                id:saveProgressPeriodicallySwitch
                text: qsTr('Save progress periodically')
                description: qsTr('If disabled, the current playback state will only be saved when the app cleanly exits. Otherwise, It will save the progress every few seconds.')

                checked: options.saveProgressPeriodically
                onClicked: {
                    options.saveProgressPeriodically = checked
                }

            }

            TextSwitch {
                id:doLogSwitch
                text: qsTr('Verbose logging enabled')
                description: qsTr('Outputs a lot of things in the Background, can get a bit slower. View output by opening Talefish via Terminal.')

                checked: options.doLog
                onClicked: {
                    options.doLog = checked
                }

            }

            OptionComboBox {
                optionname: 'keepUnopenedDirectoryProgressDays'
                label:qsTr("Keep directory progress")
                description: qsTr('To prevent cached data for old or even deleted directories to accumulate over time, Talefish will check for old entries at application start. This will not affect the currently loaded directory.')
                jsonData: [
                    {text:qsTr('for %1 day(s)', 'keep progress for x days', 1).arg(1), value: 1},
                    {text:qsTr('for %1 day(s)', 'keep progress for x days', 10).arg(10), value: 10},
                    {text:qsTr('for %1 day(s)', 'keep progress for x days', 30).arg(30), value: 30},
                    {text:qsTr('for %1 day(s)', 'keep progress for x days', 50).arg(50), value: 50},
                    {text:qsTr('for %1 day(s)', 'keep progress for x days', 100).arg(100), value: 100},
                    {text:qsTr('forever', 'keep progress forever'), value: 9999}
                ]
            }
        }
    }

    Component.onDestruction: {
        //save defaults even if !doPersist?
        options.save()
    }

}
