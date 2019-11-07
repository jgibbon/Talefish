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
