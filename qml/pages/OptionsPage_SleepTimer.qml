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
            PageHeader { title: qsTr("Sleep Timer", 'header') }

            Label {
                visible: !autoStartSlumberSwitch.enabled
                text: qsTr('Install the slumber sleep timer application to enable these options')
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                width: parent.width - Theme.horizontalPageMargin*2
                x: Theme.horizontalPageMargin
            }

            TextSwitch {
                id:autoStartSlumberSwitch
                enabled: app.launcher.fileExists('/usr/bin/harbour-slumber')


                text: qsTr('Launch sleep timer automatically')

                checked: options.autoStartSlumber
                onClicked: {
                    options.autoStartSlumber = checked
                }
                description: qsTr('Launch the slumber sleep timer application automatically when starting Talefish.')
            }
            TextSwitch {
                id:autoStartSlumberAndRefocusTalefishSwitch
                enabled: autoStartSlumberSwitch.enabled && autoStartSlumberSwitch.checked

                text: qsTr('Bring Talefish to foreground again after launching slumber')

                checked: options.autoStartSlumberAndRefocusTalefish
                onClicked: {
                    options.autoStartSlumberAndRefocusTalefish = checked
                }
            }

            TextSwitch {
                id: autoStartSlumberInTimeframeSwitch
                text: qsTr('Only launch slumber at certain times')
                enabled: autoStartSlumberSwitch.enabled && autoStartSlumberSwitch.checked
                checked: options.autoStartSlumberInTimeframe
                onClicked: {
                    options.autoStartSlumberInTimeframe = checked
                }
            }
            Column {
                id: launchTimesColum
                width: parent.width

                states: [
                    State {
                        name: 'visible'
                        when: autoStartSlumberInTimeframeSwitch.checked
                        PropertyChanges { target: launchTimesColum; height: launchAfterSwitch.height + launchBeforeSwitch.height ; opacity:1 }
                    },
                    State {
                        name: 'hidden'
                        when: !autoStartSlumberInTimeframeSwitch.checked
                        PropertyChanges { target: launchTimesColum; height: 0; opacity:0 }
                    }

                ]
                transitions: Transition {
                    PropertyAnimation { properties: "height,opacity"; easing.type: Easing.InOutQuad }
                }


                ValueButton {
                    id: launchAfterSwitch
                    label: qsTr("Launch slumber after")
                    enabled: autoStartSlumberSwitch.checked
                    value: Format.formatDate(options.autoStartSlumberAfterTime, Formatter.TimeValue)
                    onClicked: {
                        console.log( options.autoStartSlumberAfterTime.getHours(), options.autoStartSlumberAfterTime.getMinutes());
                        var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                        hour: options.autoStartSlumberAfterTime.getHours(),
                                                        minute: options.autoStartSlumberAfterTime.getMinutes()
                                                    })
                        dialog.accepted.connect(function() {
                            options.autoStartSlumberAfterTime = dialog.time;
                        })
                    }
                }

                ValueButton {
                    id: launchBeforeSwitch
                    label: qsTr("Launch slumber before")
                    enabled: autoStartSlumberSwitch.checked
                    value: Format.formatDate(options.autoStartSlumberBeforeTime, Formatter.TimeValue)
                    onClicked: {
                        var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog", {
                                                        hour: options.autoStartSlumberBeforeTime.getHours(),
                                                        minute: options.autoStartSlumberBeforeTime.getMinutes()
                                                    })
                        dialog.accepted.connect(function() {
                            options.autoStartSlumberBeforeTime = dialog.time;
                        })
                    }
                }
            }


        }
    }
}
