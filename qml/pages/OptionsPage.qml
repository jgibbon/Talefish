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
                onClicked:  {
                    //                    value = 1
                }
                onHighlightedChanged: {
                    if(!highlighted)
                        options.playbackRate = value
                }

                label: qsTr('Playback Speed: %1\%', 'percent').arg(Math.round(value * 100))

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

            TextSwitch {
                id:useHeadphoneCommandsSwitch
                text: qsTr('Use head phone buttons/Bluetooth to control Talefish')

                checked: options.useHeadphoneCommands
                onClicked: {
                    options.useHeadphoneCommands = checked
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

        }
    }

    Component.onDestruction: {
        //save defaults even if !doPersist?
        options.save()
    }

}
