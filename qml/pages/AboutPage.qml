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
            PageHeader { title: qsTr("About Talefish", 'header') }

            Label {
                text:qsTr('Talefish is a directory based audio book player written mainly in QML. It\'s licensed under GPL2 and made by John Gibbon.')
                verticalAlignment: Text.AlignBottom


                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }


            SectionHeader {
                text: qsTr("Contribute", 'section header')
            }

            Label {
                text:qsTr('Discuss or click "thanks" at talk.maemo.org:')
                verticalAlignment: Text.AlignBottom
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
            Button {
                text: qsTr("TMO thread")
                onClicked: Qt.openUrlExternally('https://talk.maemo.org/showthread.php?p=1521577&goto=newpost')
                x: Theme.paddingLarge
            }

            Label {
                text:qsTr('Project stars, Pull requests or bug reports are welcome on GitHub:')
                verticalAlignment: Text.AlignBottom
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
            Button {
                text: qsTr("GitHub page")
                onClicked: Qt.openUrlExternally('https://github.com/jgibbon/Talefish/')
                x: Theme.paddingLarge
            }


            Label {
                text:qsTr('You can also submit translations at Transifex, if you don\'t like GitHub:')
                verticalAlignment: Text.AlignBottom
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
            Button {
                text: qsTr("Transifex page")
                onClicked: Qt.openUrlExternally('https://www.transifex.com/velocode/talefish/')
                x: Theme.paddingLarge
            }


            Label {
                text:qsTr('Or buy me a beer if you really feel like it:')
                verticalAlignment: Text.AlignBottom
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
            Button {
                text: qsTr("PayPal donation")
                onClicked: Qt.openUrlExternally('https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KXPWW647AWLWL')
                x: Theme.paddingLarge
            }


            SectionHeader {
                text: qsTr("Thanks!", "header")
            }

            Label {
                id: thanksLabel
                text: qsTr('Thanks to all users suggesting things and everyone helping me out!')
                verticalAlignment: Text.AlignBottom

                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
            Label {
                id: thanksLabel
                text: qsTr('A big thank you  translators:')
                    + 'Caballlero (es)'
                verticalAlignment: Text.AlignBottom

                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                width: parent.width - (Theme.paddingLarge * 2)
                x: Theme.paddingLarge
            }
    }

    Component.onDestruction: {
    }

}
