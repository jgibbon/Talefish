import QtQuick 2.0

import Sailfish.Silica 1.0

ComboBox {
    id:root
    property var jsonData:[]
    property string optionname: ''
    width: parent.width
    currentIndex: -1
    property int readIndex: 0+currentIndex

    menu: ContextMenu {
        Component.onCompleted: {
        }

        id: timeropts
        Repeater {
            model: ListModel {
                dynamicRoles: true
            }
            Component.onCompleted: {
                var i = 0;
                while(i < jsonData.length){
                    model.append(jsonData[i]);
                    i++;
                }
            }

            MenuItem {
                text: model.text ? model.text + '' : '-'

                onClicked: {
                    options[optionname] =  model.value;
                }

                Component.onCompleted: {
                    if(model.value === options[optionname]) {
                        root.currentIndex = index
                    }

                }
            }

        }
    }
}
