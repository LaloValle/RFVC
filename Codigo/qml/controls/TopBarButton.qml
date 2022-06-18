import QtQuick 2.15
import QtQuick.Controls 2.15
// import Qt5Compat.GraphicalEffects 6.0

Button{
    id: button_top_bar

    property url button_icon_source: "../icons/minimize_icon.png"
    property color button_color_default: "#1c1d20"
    property color button_color_mouser_over: "#23272e"
    property color button_color_clicked: "#00a1f1"
    property int button_size: 35

    QtObject{
        id: internal
        property var dynamic_color: if(button_top_bar.down){
                                    button_top_bar.down ? button_color_clicked: button_color_default
                                }else{
                                    button_top_bar.hovered ? button_color_mouser_over : button_color_default
                                }
    }

    implicitWidth: button_size; implicitHeight: button_size

    background: Rectangle{
        id: background_image
        color: internal.dynamic_color

        Image{
            id: icon_button
            source: button_icon_source
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.verticalCenter: parent.verticalCenter
            height: parseInt(button_size*0.45) ; width:parseInt(button_size*0.45)
            fillMode: Image.PreserveAspectFit
        }

//        ColorOverlay{
//            anchors.fill: icon_button
//            source: icon_button
//            color: "#ffffff"
//            antialiasing: false
//        }
    }
}


