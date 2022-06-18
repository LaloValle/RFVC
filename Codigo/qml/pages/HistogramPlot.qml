import QtQuick 2.0
import QtQuick.Controls 2.15
//import Qt5Compat.GraphicalEffects 6.0
import "../controls"

Rectangle {
    id: rectangle_plot
    color: "#353d4c"
    height: 20; width: 616
    border{color:"#1c1d20"; width: 2}
    clip: true

    property string plot_source : ''
    property string plot_title: ''

    function open(name){
        if(rectangle_plot.height == 20) plot_animation.running = true
        plot_title = `Histrograma de la imagen "${name}"`
    }
    function close(){
        if(rectangle_plot.height == 480) plot_animation.running = true
        plot_title = ''
    }

    Rectangle {
        id: plot_top_bar
        height: 20
        color: "#1c1d20"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        z: 1


        TopBarButton {
            id: plot_top_bar_button
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            button_size: 20
            anchors.bottomMargin: 0
            anchors.rightMargin: 0

            onClicked: plot_animation.running = true
        }

        Label {
            id: label
            color: "#c3cbdd"
            text: qsTr("VENTANA HISTOGRAMAS")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 7
            font.bold: true
            anchors.leftMargin: 15
            anchors.bottomMargin: 0
            anchors.topMargin: 0
        }
    }

    Rectangle {
        id: plot_content
        color: "#00000000"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 2
        anchors.leftMargin: 2
        anchors.bottomMargin: 2
        anchors.topMargin: 20

        // Drag Image Component
        Component {
            id: plot_placeholder
            Item {
                id: plot_placeholder_item
                anchors.fill: parent
                Image {
                    id: plot_placeholder_image
                    anchors.centerIn: parent
                    source: "../icons/histogram.png"
                    fillMode: Image.PreserveAspectFit
                    width: 80; height: 80
                    antialiasing: true
                }
                Text {
                    id: placeholder_drag_text
                    anchors { top: plot_placeholder_image.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 15}
                    font.pixelSize: 12
                    color: "#c3cbdd"
                    text: "No se ha calculado el histograma de alguna imagen"
                }
//                ColorOverlay{
//                    anchors.fill: plot_placeholder_image
//                    source: plot_placeholder_image
//                    color: "#c3cbdd"
//                    antialiasing: false
//                }
            }
        }

        Component {
            id: plot_main
            Item {
                id: plot_main_item
                anchors.fill: parent
                Image {
                    id: plot_main_image
                    anchors.centerIn: parent
                    source: plot_source
                    fillMode: Image.PreserveAspectFit
                    width: 80; height: 80
                    antialiasing: true
                    anchors.fill: parent
                }
                Text {
                    id: plot_main_title
                    text: plot_title
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 12
                    font.bold: true
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 20
                    color: "#1c1d20"
                }
                Label{
                    id: plot_main_x_label
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.italic: true
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 10
                    text: 'Valor del pixel'
                }
                Label{
                    id: plot_main_y_label
                    width: 10
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.topMargin: 0
                    rotation: -90
                    font.italic: true
                    anchors.leftMargin: 20
                    anchors.bottomMargin: 0
                    text: 'Frecuencia de aparición'
                }
            }
        }


        Loader {
            id: loader_placeholder_imagen
            anchors.fill: parent
            sourceComponent: plot_source ? plot_main : plot_placeholder
        }
    }

    // Animations
    PropertyAnimation{
        id: plot_animation
        target: rectangle_plot
        property: "height"
        to: rectangle_plot.height == 20 ? 480 : 20
        easing.type : Easing.InQuad
    }
}


