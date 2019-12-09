/*

Talefish Audiobook Player
Copyright (C) 2016-2019  John Gibbon

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

*/
import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

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
            //: Dialog Header: About Program
            PageHeader { title: qsTr("About Talefish", "header") }
            spacing: Theme.paddingLarge

            anchors {
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin

            }
            Label {
                //: Short License Line. %1 will be replaced by the current year.
                text:qsTr("Talefish audio book player, Copyright (C) 2016-%1 John Gibbon").arg(new Date().getFullYear())
                width: parent.width
                color: Theme.highlightColor
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                textFormat: Text.PlainText
            }
            Button {
                //: Button: Display more license info
                text: !licenseColumn.extended ? qsTr("View license information")
                     //: Button: Hide license info
                                              : qsTr("Hide license information")
                onClicked: licenseColumn.extended = !licenseColumn.extended
            }
            Column {
                id: licenseColumn
                property bool extended: false
                width: parent.width
                height: extended ? implicitHeight : 0
                clip: true
                opacity: extended ? 1.0 : 0.0
                spacing: Theme.paddingLarge
                Behavior on height {NumberAnimation {duration: 300; easing.type: Easing.InOutCubic}}
                Behavior on opacity {NumberAnimation {duration: 300; easing.type: Easing.InOutCubic}}

                Label {
                    //: Longer License Line. If you're in the least unsure about translation, leave it in english. Below it will be a Link to the full license text.
                    text:qsTr("Talefish comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome to redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. See the GNU General Public License for more details:")
                    width: parent.width
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    textFormat: Text.PlainText
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                }
                Label {
                    property url link:'https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html'
                    text: '<a href="'+link+'">'+link+'</a>'
                    width: parent.width
                    linkColor: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                }
                Label {
                    //: License information for LGPL libraries used. If you're in the least unsure about translation, leave it in english.
                    text: qsTr("This Program uses and includes unmodified or modified versions of the following software components under the terms of the LGPL 2.1 license:")
                    width: parent.width
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    font.pixelSize: Theme.fontSizeExtraSmall
                    textFormat: Text.PlainText
                    color: Theme.highlightColor
                }
                Label {
                    text: ' - <a href="https://taglib.org/">Taglib</a><br /> - <a href="https://code.qt.io/cgit/qt/qtdeclarative.git/tree/src/imports/folderlistmodel?h=5.6">Qt Folderlistmodel</a>'
                    width: parent.width
                    linkColor: Theme.primaryColor
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                }

                Label {
                    //: Label: introduction for "GNU Lesser General Public License" link
                    text: qsTr('See the GNU Lesser General Public License for more details:')
                    width: parent.width
                    linkColor: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: Theme.highlightColor
                    textFormat: Text.PlainText
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                }
                Label {
                    property url link:'http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html'
                    text: '<a href="'+link+'">'+link+'</a>'
                    width: parent.width
                    linkColor: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeExtraSmall
                    wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                }
            }



            SectionHeader {
                //: Section Header: How to contribute to this program
                text: qsTr("Contribute", "section header")
            }

            Label {
                //: Label: introduction for "TMO" link
                text:qsTr("Discuss or click \"thanks\" at talk.maemo.org:")
                verticalAlignment: Text.AlignBottom
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.PlainText
            }
            Button {
                //: Button: Linking to "talk.maemo.org" thread
                text: qsTr("TMO thread")
                onClicked: Qt.openUrlExternally("https://talk.maemo.org/showthread.php?p=1521577&goto=newpost")
            }

            Label {
                //: Label: introduction for github link
                text:qsTr("Project stars, pull requests or bug reports are welcome on GitHub:")
                verticalAlignment: Text.AlignBottom
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.PlainText
            }
            Button {
                //: Button: Linking to github repository
                text: qsTr("GitHub page")
                onClicked: Qt.openUrlExternally("https://github.com/jgibbon/Talefish/")
            }


            Label {
                //: Label: introduction for translation link
                text:qsTr("You can also submit translations at Transifex, if you don't like GitHub:")
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.PlainText
            }
            Button {
                //: Button: Linking to transifex for translation
                text: qsTr("Transifex page")
                onClicked: Qt.openUrlExternally("https://www.transifex.com/velocode/talefish/")
            }


            Label {
                //: Label: introduction for paypal link
                text:qsTr("Or buy me a beer if you really feel like it:")
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                textFormat: Text.PlainText
            }

            Button {
                //: Button: Linking to paypal donation page
                text: qsTr("PayPal donation")
                onClicked: Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KXPWW647AWLWL")
            }


            SectionHeader {
                //: Section Header: Translators (Thank you! Really!)
                text: qsTr("Translators", "header")
            }
            Label {
                //: Label: Thank you for translators. Yes, that's you! Followed by list of Translators. IMPORTANT: I may forget to include people. If you're missing from the list and you'd like to be mentioned inside the application, please let me know your desired user name!
                text: qsTr("A big thank you to the translators:")
                      + '<br /> eson (sv)'
                      + '<br /> carmenfdezb (es)'
                      + '<br /> Ancelad + Laphilis (ru)'
                      + '<br /> marmistrz (pl)'
                      + '<br /> pljmn (nl + nl_BE)'
                      + '<br /> leoka (hu)'
                      + '<br /> sponka (sl)'
                      + '<br /> rui kon + 天苯 (zh_CN)'
                      + '<br /> fravaccaro (it_IT)'
                width: parent.width
                wrapMode: 'WrapAtWordBoundaryOrAnywhere'

                color: Theme.highlightColor
            }
        }
    }

}
