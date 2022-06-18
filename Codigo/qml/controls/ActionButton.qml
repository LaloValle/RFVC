import QtQuick 2.15
import QtQuick.Controls 2.15
//import Qt5Compat.GraphicalEffects 6.0

Button {
    id: action_button

    property url icon_path: "../icons/play.png"
    property color default_color : "#282c34"
    property color hover_color : "#353d4c"
    property color click_color: "#00a1f1"


    property int button_width: 30
    property int button_height: 30
    property int icon_width: 18
    property int icon_height: 18

    implicitWidth: button_width; implicitHeight: button_height

    QtObject{
        id: internal
        property var dynamic_color: if(action_button.down) action_button.down ? click_color: default_color
                                    else action_button.hovered ? hover_color : default_color
    }

    background: Rectangle {
        id: background

        radius: 5
        color: internal.dynamic_color

        Image{
            id: button_icon
            source: icon_path
            anchors.horizontalCenter: parent.horizontalCenter; anchors.verticalCenter: parent.verticalCenter
            height: icon_height; width: icon_width
            fillMode: Image.PreserveAspectFit
        }
    }
}
/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:2;height:30;width:30}D{i:1}
}
##^##*/
