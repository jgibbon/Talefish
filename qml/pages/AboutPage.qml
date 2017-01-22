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
        anchors.bottomMargin: Theme.paddingLarge
        contentHeight: mainColumn.height

        Column {
            width: parent.width
            id: mainColumn
            PageHeader { title: qsTr("About Talefish", "header") }
            spacing: Theme.paddingSmall

            anchors {
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin

            }
            Label {
                text:qsTr("Talefish is a directory based audio book player written mainly in QML. It's licensed under GPL2 and made by John Gibbon with the help of the community.")
                verticalAlignment: Text.AlignBottom
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }


            SectionHeader {
                text: qsTr("Contribute", "section header")
            }

            Label {
                text:qsTr("Discuss or click \"thanks\" at talk.maemo.org:")
                verticalAlignment: Text.AlignBottom
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }
            Button {
                text: qsTr("TMO thread")
                onClicked: Qt.openUrlExternally("https://talk.maemo.org/showthread.php?p=1521577&goto=newpost")
            }

            Label {
                text:qsTr("Project stars, pull requests or bug reports are welcome on GitHub:")
                verticalAlignment: Text.AlignBottom
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }
            Button {
                text: qsTr("GitHub page")
                onClicked: Qt.openUrlExternally("https://github.com/jgibbon/Talefish/")
            }


            Label {
                text:qsTr("You can also submit translations at Transifex, if you don't like GitHub:")
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }
            Button {
                text: qsTr("Transifex page")
                onClicked: Qt.openUrlExternally("https://www.transifex.com/velocode/talefish/")
            }


            Label {
                text:qsTr("Or buy me a beer if you really feel like it:")
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }
            Button {
                text: qsTr("PayPal donation")
                onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KXPWW647AWLWL")
            }


            SectionHeader {
                text: qsTr("Thanks!", "header")
            }

            Label {
                text: qsTr("Thanks to all users suggesting things and everyone helping me out!")
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
            }
            SectionHeader {
                text: qsTr("Translators", "header")
            }

            Label {
                text: qsTr("A big thank you to the translators:")
                      + '<br />eson (sv)'
                      + '<br />Caballlero (es)'
                      + '<br />Ancelad (ru)'
                      + '<br />marmistrz (pl)'
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'

            }
        }
    }

}
