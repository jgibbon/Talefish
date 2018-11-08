import QtQuick 2.0

import Sailfish.Silica 1.0

MouseArea {
    property alias icon: image
    property bool down: pressed && containsMouse
    property bool highlighted: down
    property bool _showPress: highlighted || pressTimer.running

    onPressedChanged: {
        if (pressed) {
            pressTimer.start()
        }
    }
    onCanceled: pressTimer.stop()

    width: Theme.itemSizeSmall; height: Theme.itemSizeSmall

    Image {
        id: image

        anchors.centerIn: parent
        opacity: parent.enabled ? 1.0 : 0.4
        layer.effect: ShaderEffect {
            property color color: _showPress ? Theme.highlightColor : Theme.primaryColor

            fragmentShader: "
                        varying mediump vec2 qt_TexCoord0;
                        uniform highp float qt_Opacity;
                        uniform lowp sampler2D source;
                        uniform highp vec4 color;
                        void main() {
                            highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                            gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                        }
                    "
        }
        layer.enabled: true
        layer.samplerName: "source"
    }
    Timer {
        id: pressTimer
        interval: Theme.minimumPressHighlightTime
    }
}
