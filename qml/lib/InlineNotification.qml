import QtQuick 2.0
import Sailfish.Silica 1.0

MouseArea {
    id: inlineNotification
    property bool isvisible: false
    property alias text: inlineNotificationLabel.text
    property alias radius: inlineNotificationRectangle.radius

    //property alias color: inlineNotificationLabel.color
    property bool highlighted: true
    property color highlightedColor: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity) //if one of those isn't allowed: use a proxy BackgroundItem
    opacity: isvisible ? 1 : 0
    height: isvisible ? Theme.ItemSizeSmall : 0


    width: parent ? parent.width : Screen.width
    implicitHeight: Theme.itemSizeSmall

    Rectangle {
        id: inlineNotificationRectangle
        color: parent.highlightedColor
        anchors.fill: parent
    }
    Label {
        id: inlineNotificationLabel
        color: highlighted ? Theme.highlightColor: Theme.primaryColor
        text: ''
        anchors.centerIn: parent
    }

    Timer {
        repeat: false
        running: false
        id:inlineNotificationTimer
        onTriggered: {
            inlineNotification.hide()
        }
    }

    function show(duration){
        isvisible = true
        if(duration){
            inlineNotificationTimer.interval = duration;
            inlineNotificationTimer.start();
        }
    }
    function hide(){
        isvisible = false
    }
    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}
    Behavior on height { NumberAnimation { easing.type: Easing.OutCubic ; duration: 500 }}
}
