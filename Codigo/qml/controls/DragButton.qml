import QtQuick 2.15
import QtQuick.Controls 2.15

Button{
    id: button_top_bar
    //opacity: 0.5

    property url button_icon_source: button_top_bar.hovered ? "../icons/drag_hover.png" : "../icons/drag.png"
    property color button_color_default: "#1c1d20"

    implicitWidth: 20; implicitHeight: 20

    background: Rectangle{
        id: background_icon
        color: button_color_default

        Image{
            id: icon_button
            anchors.fill: parent
            source: button_icon_source
            fillMode: Image.PreserveAspectFit
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:4}
}
##^##*/
