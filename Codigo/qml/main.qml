import QtQml 2.15
import QtQuick 2.15
import QtQuick.Window
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
//import Qt5Compat.GraphicalEffects 6.0

// Local components
import "controls"
import "pages"
// Js imports
import "../scripts/WindowsFunctions.js" as WindowFunction
import "../scripts/Miscellaneous.js" as Misc

Window {
    id: main_window

    minimumWidth: 1150
    minimumHeight: 720

    width: 1300
    height: 900
    visible: true
    color: "#00000000"

    // Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    // Color scheme
    property color red: "#ff007f"
    property color gray : "#a2aab9"
    property color green: "#00a19d"
    property color white : "#c3cbdd"
    property color light_green : "#4fbdba"
    property color dark_black : "#1c1d20"
    property color light_black_1 : "#282c34"
    property color light_black_2 : "#2c313c"
    property color light_black_3 : "#353d4c"
    property color transparent : "#00000000"

    // Configuration texts
    property string window_title_text: "RFVC Práctica 2"

    // States variables
    property int window_status: 0 // 0-Window mode; 1-Maximized mode
    property string string_pos_size: ""
    property real tiempo_accion: 0.59

    // Image Information
    property string image_source: ""
    property string image_name: "Nombre de la image"
    property string image_path: "La ruta de la imagen"
    property int image_x_size: 0
    property int image_y_size: 0
    property real scale_ratio: 0.0
    // Image Pixels
    property string image_x_pixel: "0"
    property string image_y_pixel: "0"
    property color image_pixel_rectangle_color: gray
    property string image_pixel_rgb: "(255,255,255)"
    // Image Actions
    property alias image_threshold : image_grayscale_threshold_threshold_input.text
    property string actions_status: 'Sin acciones realizadas'

    Rectangle {
        id: main_pane
        color: light_black_3
        anchors.fill: parent

        // Top bar
        Rectangle {
            id: top_bar
            height: 35
            color: dark_black
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0

            // Window's Label titles
            Label {
                id: window_title
                color: white
                text: window_title_text
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            DragHandler{
                target: window_title
                onActiveChanged: ()=>{ if(active){
                                         main_window.startSystemMove()
                                         if(window_status == 1) WindowFunction.maximize_restore()
                                     }
                                 }
            }

            // Window's actions button
            RowLayout {
                id: window_action_buttons
                x: 614
                width: 105
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                layoutDirection: Qt.LeftToRight
                spacing: 0
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0

                TopBarButton {
                    id: window_action_minimize
                    onClicked: main_window.showMinimized()
                }

                TopBarButton {
                    id: window_action_maximize
                    visible: true
                    button_icon_source: "../icons/maximize_icon.png"
                    onClicked: WindowFunction.maximize_restore()
                }

                TopBarButton {
                    id: window_action_close
                    button_icon_source: "../icons/close_icon.png"
                    button_color_clicked: red
                    onClicked: main_window.close()
                }
            }


        }

        // Side bar
        Rectangle {
            id: side_bar
            width: 320
            visible: true
            color: dark_black
            anchors.right: parent.right
            anchors.top: top_bar.bottom
            anchors.bottom: bottom_bar.top
            clip: true
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0

            DragButton {
                id: dragButton
                x: 8
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 5

                onClicked: animation_side_bar.running = true
            }

            // Open and close animation
            Rectangle {
                id: side_bar_sections
                color: light_black_1
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.rightMargin: 0
                anchors.leftMargin: 30
                anchors.bottomMargin: 0
                anchors.topMargin: 0

                ScrollView {
                    id: side_bar_scroll
                    anchors.fill: parent
                    clip: true

                    // Image Information
                    Collapsable {
                        id: collapsable_image_information
                        height: 230
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "INFORMACIÓN IMAGEN"
                        collapsable_height: 230

                        GridLayout {
                            id: grid_image_information
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            rows: 5
                            columns: 2
                            anchors.rightMargin: 0
                            anchors.leftMargin: 0
                            anchors.bottomMargin: 0
                            anchors.topMargin: 20

                            Label {
                                id: image_information_name_label
                                width: 80
                                height: 60
                                color: white
                                text: qsTr("Nombre:")
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.minimumHeight: 30
                                leftPadding: 15
                                font.bold: true
                                font.pointSize: 8
                                rightPadding: 0
                                Layout.fillHeight: true
                            }

                            Text {
                                id: image_information_name
                                width: 240
                                height: 60
                                color: white
                                text: image_name
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 8
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                wrapMode: Text.Wrap
                                Layout.minimumHeight: 30
                                leftPadding: 10
                            }

                            Label {
                                id: image_information_path_label
                                width: 80
                                height: 60
                                color: white
                                text: qsTr("Ruta:")
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.minimumHeight: 30
                                Layout.fillHeight: true
                                rightPadding: 0
                                font.pointSize: 8
                                font.bold: true
                                leftPadding: 15
                            }

                            Text {
                                id: image_information_path
                                width: 240
                                height: 60
                                color: white
                                text: image_path
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                Layout.minimumHeight: 30
                                font.pointSize: 8
                                leftPadding: 10
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }

                            Label {
                                id: image_information_size_label
                                width: 80
                                height: 60
                                color: white
                                text: qsTr("Tamaño:")
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.minimumHeight: 30
                                Layout.fillHeight: true
                                rightPadding: 0
                                font.pointSize: 8
                                font.bold: true
                                leftPadding: 15
                            }

                            Text {
                                id: image_information_size
                                width: 240
                                height: 60
                                color: white
                                text: `${image_x_size}x${image_y_size}`
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                Layout.minimumHeight: 30
                                font.pointSize: 8
                                leftPadding: 10
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }

                            Label {
                                id: image_information_scale_label
                                width: 80
                                height: 60
                                color: white
                                text: qsTr("Factor de escala:")
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                Layout.minimumHeight: 30
                                Layout.fillHeight: true
                                rightPadding: 0
                                font.pointSize: 8
                                font.bold: true
                                leftPadding: 15
                            }

                            Text {
                                id: image_information_scale
                                width: 240
                                height: 60
                                color: white
                                text: scale_ratio.toFixed(2).toString()
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                                Layout.minimumHeight: 30
                                font.pointSize: 8
                                leftPadding: 10
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }

                        ActionButton {
                            id: save_image_button
                            x: 220
                            y: -50
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            icon_width: 20
                            icon_height: 20
                            anchors.bottomMargin: 15
                            button_width: 40
                            button_height: 40
                            icon_path: "../icons/save_icon.png"
                            anchors.rightMargin: 10
                        }

                        ActionButton {
                            id: restore_last_image
                            x: 229
                            y: -49
                            anchors.right: save_image_button.left
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 10
                            icon_path: "../icons/restore_image.png"
                            anchors.bottomMargin: 15
                            icon_width: 20
                            button_width: 40
                            icon_height: 20
                            button_height: 40
                        }
                    }

                    // Image pixels
                    Collapsable {
                        id: collapsable_image_pixels
                        height: 120
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_information.bottom
                        anchors.topMargin: 0
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        collapsable_height: 120
                        title: "PIXELS"

                        GridLayout {
                            id: image_pixels_grid
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            rowSpacing: 0
                            columnSpacing: 0
                            rows: 2
                            columns: 2
                            anchors.rightMargin: 0
                            anchors.leftMargin: -1
                            anchors.bottomMargin: 0
                            anchors.topMargin: 20

                            Rectangle {
                                id: image_pixels_x_position
                                width: 200
                                height: 200
                                color: "#00000000"
                                Layout.maximumWidth: 150
                                Layout.maximumHeight: 50
                                Layout.minimumHeight: 0
                                Layout.minimumWidth: 0
                                Layout.fillWidth: true

                                Label {
                                    id: image_pixels_x_position_label
                                    color: white
                                    text: qsTr("X:")
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: image_pixels_x_position_input.left
                                    anchors.rightMargin: 10
                                    font.bold: true
                                }

                                TextEdit {
                                    id: image_pixels_x_position_input
                                    width: 70
                                    height: 20
                                    color: white
                                    text: image_x_pixel
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    font.pixelSize: 12
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.rightMargin: 0
                                }
                            }

                            Rectangle {
                                id: image_pixel_color
                                width: 80
                                height: 60
                                color: image_pixel_rectangle_color
                                Layout.bottomMargin: 10
                                Layout.topMargin: 0
                                Layout.preferredHeight: 60
                                Layout.preferredWidth: 80
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.rowSpan: 2
                                Layout.columnSpan: 1
                                Layout.maximumWidth: 80
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                Layout.maximumHeight: 60
                                Layout.minimumHeight: 0

                                Label {
                                    id: image_pixel_color_label
                                    color: white
                                    text: image_pixel_rgb
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.bottom
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    font.pointSize: 8
                                    anchors.rightMargin: 0
                                    anchors.leftMargin: 0
                                    anchors.topMargin: 5
                                }
                            }

                            Rectangle {
                                id: image_pixels_y_position
                                width: 200
                                height: 200
                                color: "#00000000"
                                Layout.fillHeight: false
                                Layout.maximumWidth: 150
                                Layout.fillWidth: true
                                Layout.minimumWidth: 0
                                Layout.maximumHeight: 50
                                Layout.minimumHeight: 0

                                Label {
                                    id: image_pixels_y_position_label
                                    color: white
                                    text: qsTr("Y:")
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: image_pixels_y_position_input.left
                                    anchors.rightMargin: 10
                                    font.bold: true
                                }

                                TextEdit {
                                    id: image_pixels_y_position_input
                                    width: 70
                                    height: 20
                                    color: white
                                    text: image_y_pixel
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    font.pixelSize: 12
                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.rightMargin: 0
                                }
                            }
                        }
                    }

                    // Image Grayscale and Thresholds
                    Collapsable {
                        id: collapsable_image_grayscale_threshold
                        height: 250
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_pixels.bottom
                        collapsable_height: 250
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "ESCALA DE GRISES Y UMBRALADO"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_grayscale_threshold_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 4
                            columns: 2

                            //
                            // Invert colors
                            //
                            Text {
                                id: image_invert
                                color: white
                                text: qsTr("Invertir colores")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                                Layout.maximumHeight: 35
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.maximumWidth: 240
                                font.bold: false
                                wrapMode: Text.WordWrap
                                Layout.minimumHeight: 30
                            }
                            ActionButton {
                                id: image_invert_button
                                Layout.leftMargin: 25
                                icon_path: "../icons/invert.png"
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.rightMargin: 20
                                button_width: 25
                                button_height: 25
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.maximumHeight: 30
                                Layout.maximumWidth: 30
                                Layout.fillHeight: false
                                Layout.fillWidth: false

                                onClicked: (backend.invert_image())
                            }

                            //
                            // Grayscale
                            //
                            Text {
                                id: image_grayscale_threshold_gray_levels
                                color: white
                                text: qsTr("Imagen en escala de grises")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                                Layout.maximumHeight: 35
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.maximumWidth: 240
                                font.bold: false
                                wrapMode: Text.WordWrap
                                Layout.minimumHeight: 30
                            }
                            ActionButton {
                                id: image_grayscale_threshold_gray_levels_button
                                Layout.leftMargin: 25
                                icon_path: "../icons/gray_level.png"
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.rightMargin: 20
                                button_width: 25
                                button_height: 25
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.maximumHeight: 30
                                Layout.maximumWidth: 30
                                Layout.fillHeight: false
                                Layout.fillWidth: false

                                onClicked: (backend.image_to_grayscale())
                            }

                            //
                            // Simple Threshold
                            //
                            Rectangle {
                                id: image_grayscale_threshold_threshold_rectangle
                                width: 200
                                height: 200
                                color: "#00000000"
                                Layout.fillWidth: true
                                Layout.minimumHeight: 30
                                Layout.maximumHeight: 35
                                Layout.maximumWidth: 240

                                Text {
                                    id: image_grayscale_threshold_threshold_label
                                    color: white
                                    text: qsTr("Umbralado Imagen")
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.leftMargin: 10
                                    anchors.bottomMargin: 0
                                    anchors.topMargin: 0
                                }

                                TextField {
                                    id: image_grayscale_threshold_threshold_input
                                    color: white
                                    text: "60"
                                    anchors.left: image_grayscale_threshold_threshold_label.right
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    anchors.topMargin: 0
                                    anchors.bottomMargin: 0
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 0

                                    background: Rectangle{
                                        color: light_black_3
                                    }
                                }
                            }
                            ActionButton {
                                id: image_grayscale_threshold_threshold_button
                                Layout.leftMargin: 25
                                icon_path: "../icons/threshold.png"
                                Layout.rightMargin: 20
                                button_width: 25
                                button_height: 25
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.fillHeight: false
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30

                                onClicked: { backend.threshold_the_image(parseInt(image_threshold)) }
                            }

                            //
                            // Kapur Threshold
                            //
                            Text {
                                id: image_grayscale_threshold_kapur_label
                                color: white
                                text: qsTr("Método de Kapur")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                                Layout.maximumHeight: 35
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.maximumWidth: 240
                                font.bold: false
                                wrapMode: Text.WordWrap
                                Layout.minimumHeight: 30
                            }
                            ActionButton {
                                id: image_grayscale_threshold_kapur_button
                                Layout.leftMargin: 25
                                icon_path: "../icons/entropy.png"
                                Layout.rightMargin: 20
                                button_width: 25
                                button_height: 25
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.fillHeight: false
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                                onClicked: { backend.automatic_thresholding('kapur') }
                            }
                            //
                            // Cheng Threshold
                            //

                            Text {
                                id: image_grayscale_threshold_cheng_label
                                color: white
                                text: qsTr("Método de Cheng")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                                Layout.maximumHeight: 35
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.maximumWidth: 240
                                font.bold: false
                                wrapMode: Text.WordWrap
                                Layout.minimumHeight: 30
                            }
                            ActionButton {
                                id: image_grayscale_threshold_cheng_button
                                Layout.leftMargin: 25
                                icon_path: "../icons/correlation.png"
                                Layout.rightMargin: 20
                                button_width: 25
                                button_height: 25
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.fillHeight: false
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                                onClicked: { backend.automatic_thresholding('cheng') }
                            }
                        }
                    }

                    // Image Objects contabilization
                    Collapsable {
                        id: collapsable_image_objects
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_grayscale_threshold.bottom
                        collapsable_height: 150
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "CONTABILIZACIÓN OBJETOS"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_objects_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 4
                            columns: 2

                            //
                            // Gaps in 1 object
                            //
                            Text {
                                id: image_objects_gaps
                                color: white
                                text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'Fira Sans Semi-Light'; font-size:10pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Número de huecos </p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:8pt; font-style:italic;\">(1 objeto)</span></p></body></html>"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                textFormat: Text.RichText
                                Layout.minimumHeight: 30
                                font.bold: false
                                leftPadding: 10
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_objects_gaps_button
                                icon_path: "../icons/gaps.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.get_image_number_gaps()
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                            //
                            // Count objects without gaps
                            //
                            Text {
                                id: image_objects_objects
                                color: white
                                text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'Fira Sans Semi-Light'; font-size:10pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Número de objetos</p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:9pt; font-style:italic;\">(sin huecos)</span></p></body></html>"
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                textFormat: Text.RichText
                                Layout.minimumHeight: 30
                                font.bold: false
                                leftPadding: 10
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_objects_objects_button
                                icon_path: "../icons/count_objects.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.get_image_number_objects()
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Round objects
                            //
                            Rectangle {
                                id: image_rect_objects_round
                                width: 200
                                color: "#00000000"
                                Layout.minimumHeight: 40

                                GridLayout {
                                    id: image_grid_objects_round
                                    anchors.fill: parent
                                    columnSpacing: 5
                                    rows: 2
                                    columns: 2

                                    Text {
                                        id: image_objects_round_label
                                        width: 190
                                        color: white
                                        text: qsTr("Numero objectos redondos")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.leftMargin: 15
                                        Layout.preferredHeight: 15
                                        Layout.preferredWidth: 0
                                        Layout.fillHeight: false
                                        Layout.minimumHeight: 15
                                        Layout.minimumWidth: 80
                                        Layout.maximumHeight: 200
                                        Layout.maximumWidth: 200
                                        font.bold: false
                                        Layout.fillWidth: true
                                        Layout.columnSpan: 2
                                        Layout.rowSpan: 1
                                    }

                                    Text {
                                        id: image_objects_round_input_label
                                        color: white
                                        text: qsTr("Umbral:")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_objects_round_input
                                        color: white
                                        text: "6"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }
                                }
                            }
                            ActionButton {
                                id: image_objects_round_button
                                icon_path: "../icons/round.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.count_round_overlapped_objects(parseInt(image_objects_round_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                        }
                    }

                    // Image Noise
                    Collapsable {
                        id: collapsable_image_noise
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_objects.bottom
                        collapsable_height: 130
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "RUIDO EN IMAGEN"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_noise_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 2
                            columns: 2

                            //
                            // Salt and pepper
                            //
                            Rectangle {
                                id: image_noise_salt_pepper
                                width: 200
                                color: "#00000000"
                                Layout.minimumHeight: 40

                                GridLayout {
                                    id: image_noise_salt_pepper_grid
                                    anchors.fill: parent
                                    columnSpacing: 5
                                    rows: 2
                                    columns: 2

                                    Text {
                                        id: image_noise_salt_pepper_label
                                        color: white
                                        text: qsTr("Sal y Pimienta")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.leftMargin: 15
                                        Layout.preferredHeight: 15
                                        Layout.preferredWidth: 0
                                        Layout.fillHeight: false
                                        Layout.minimumHeight: 15
                                        Layout.minimumWidth: 80
                                        Layout.maximumHeight: 200
                                        Layout.maximumWidth: 200
                                        font.bold: false
                                        Layout.fillWidth: true
                                        Layout.columnSpan: 2
                                        Layout.rowSpan: 1
                                    }

                                    Text {
                                        id: image_noise_salt_pepper_input_label
                                        color: white
                                        text: qsTr("l:")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_noise_salt_pepper_input
                                        color: white
                                        text: "100"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }
                                }
                            }
                            ActionButton {
                                id: image_noise_salt_pepper_button
                                icon_path: "../icons/salt_pepper.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.salt_pepper_noise(parseInt(image_noise_salt_pepper_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Gaussian
                            //
                            Rectangle {
                                id: image_noise_gaussian
                                width: 200
                                color: "#00000000"
                                Layout.minimumHeight: 40

                                GridLayout {
                                    id: image_noise_gaussian_grid
                                    anchors.fill: parent
                                    columnSpacing: 5
                                    rows: 2
                                    columns: 4

                                    Text {
                                        id: image_noise_gaussian_label
                                        color: white
                                        text: qsTr("Gausiano")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.leftMargin: 15
                                        Layout.preferredHeight: 15
                                        Layout.preferredWidth: 0
                                        Layout.fillHeight: false
                                        Layout.minimumHeight: 15
                                        Layout.minimumWidth: 80
                                        Layout.maximumHeight: 200
                                        Layout.maximumWidth: 200
                                        font.bold: false
                                        Layout.fillWidth: true
                                        Layout.columnSpan: 4
                                        Layout.rowSpan: 1
                                    }

                                    Text {
                                        id: image_noise_gaussian_mean_input_label
                                        color: white
                                        text: qsTr("μ :")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_noise_gaussian_mean_input
                                        color: white
                                        text: "0"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }

                                    Text {
                                        id: image_noise_gaussian_std_dev_input_label
                                        color: white
                                        text: qsTr("σ :")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_noise_gaussian_std_dev_input
                                        color: white
                                        text: "10"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }
                                }
                            }
                            ActionButton {
                                id: image_noise_gaussian_button
                                icon_path: "../icons/gaussian.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.gaussian_noise(parseInt(image_noise_gaussian_mean_input.text),parseInt(image_noise_gaussian_std_dev_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                        }
                    }

                    // Image Filters
                    Collapsable {
                        id: collapsable_image_filters
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_noise.bottom
                        collapsable_height: 250 //330
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "FILTRADO DE IMAGEN"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_filters_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 2
                            columns: 2

                            //
                            // N
                            //
                            Text {
                                id: image_filters_n_label
                                color: white
                                text: qsTr("Tamaño Kernel n:")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            TextField {
                                id: image_filters_n_input
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                Layout.maximumWidth: 100
                                Layout.fillWidth: true
                                Layout.maximumHeight: 30

                                color: white
                                text: "5"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                background: Rectangle {
                                    color: light_black_3
                                }
                            }

                            //
                            // Arithmetic Mean
                            //
                            Text {
                                id: image_filters_mean
                                color: white
                                text: qsTr("Filtro Media Aritmética")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_filters_mean_button
                                icon_path: "../icons/filter_mean.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.filter_image('mean',parseInt(image_filters_n_input.text),0)
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Gaussian
                            //
                            Rectangle {
                                id: image_filters_gaussian
                                width: 200
                                color: "#00000000"
                                Layout.minimumHeight: 40

                                GridLayout {
                                    id: image_filters_gaussian_grid
                                    anchors.fill: parent
                                    columnSpacing: 5
                                    rows: 2
                                    columns: 4

                                    Text {
                                        id: image_filters_gaussian_label
                                        color: white
                                        text: qsTr("Gausiano")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.leftMargin: 15
                                        Layout.preferredHeight: 15
                                        Layout.preferredWidth: 0
                                        Layout.fillHeight: false
                                        Layout.minimumHeight: 15
                                        Layout.minimumWidth: 80
                                        Layout.maximumHeight: 200
                                        Layout.maximumWidth: 200
                                        font.bold: false
                                        Layout.fillWidth: true
                                        Layout.columnSpan: 4
                                        Layout.rowSpan: 1
                                    }

                                    Text {
                                        id: image_filters_gaussian_std_dev_input_label
                                        color: white
                                        text: qsTr("σ :")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_filters_gaussian_std_dev_input
                                        color: white
                                        text: "10"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }
                                }
                            }
                            ActionButton {
                                id: image_filters_gaussian_button
                                icon_path: "../icons/filter_gaussian.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.filter_image('gaussian',parseInt(image_filters_n_input.text),parseInt(image_filters_gaussian_std_dev_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                            
//                            //
//                            // Mean Counter Harmonic
//                            //
//                            Rectangle {
//                                id: image_filters_counter_harmonic
//                                width: 200
//                                color: "#00000000"
//                                Layout.minimumHeight: 40

//                                GridLayout {
//                                    id: image_filters_counter_harmonic_grid
//                                    anchors.fill: parent
//                                    columnSpacing: 5
//                                    rows: 2
//                                    columns: 2

//                                    Text {
//                                        id: image_filters_counter_harmonic_label
//                                        color: white
//                                        text: qsTr("Medio contra armónico")
//                                        font.pixelSize: 12
//                                        horizontalAlignment: Text.AlignHCenter
//                                        verticalAlignment: Text.AlignVCenter
//                                        Layout.leftMargin: 15
//                                        Layout.preferredHeight: 15
//                                        Layout.preferredWidth: 0
//                                        Layout.fillHeight: false
//                                        Layout.minimumHeight: 15
//                                        Layout.minimumWidth: 80
//                                        Layout.maximumHeight: 200
//                                        Layout.maximumWidth: 200
//                                        font.bold: false
//                                        Layout.fillWidth: true
//                                        Layout.columnSpan: 2
//                                        Layout.rowSpan: 1
//                                    }

//                                    Text {
//                                        id: image_filters_counter_harmonic_input_label
//                                        color: white
//                                        text: qsTr("R :")
//                                        font.pixelSize: 12
//                                        horizontalAlignment: Text.AlignRight
//                                        font.italic: true
//                                        Layout.minimumWidth: 10
//                                        Layout.leftMargin: 15
//                                        Layout.fillWidth: false
//                                    }

//                                    TextField {
//                                        id: image_filters_counter_harmonic_input
//                                        color: white
//                                        text: "-5"
//                                        font.pixelSize: 11
//                                        Layout.fillWidth: true
//                                        Layout.rowSpan: 1
//                                        Layout.columnSpan: 1
//                                        background: Rectangle {
//                                            color: light_black_3
//                                        }
//                                    }
//                                }
//                            }
//                            ActionButton {
//                                id: image_filters_counter_harmonic_button
//                                icon_path: "../icons/filter_harmonic.png"
//                                Layout.fillHeight: false
//                                Layout.minimumWidth: 30
//                                button_height: 25
//                                Layout.minimumHeight: 30
//                                button_width: 25
//                                Layout.leftMargin: 25
//                                Layout.rightMargin: 20
//                                // onClicked: backend.get_image_histogram()
//                                Layout.maximumWidth: 30
//                                Layout.fillWidth: false
//                                Layout.maximumHeight: 30
//                            }


//                            //
//                            // Yp
//                            //
//                            Rectangle {
//                                id: image_filters_yp
//                                width: 200
//                                color: "#00000000"
//                                Layout.minimumHeight: 40

//                                GridLayout {
//                                    id: image_filters_yp_grid
//                                    anchors.fill: parent
//                                    columnSpacing: 5
//                                    rows: 2
//                                    columns: 2

//                                    Text {
//                                        id: image_filters_yp_label
//                                        color: white
//                                        text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'Fira Sans Semi-Light'; font-size:12pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Y<sub>p</sub></p></body></html>"
//                                        font.pixelSize: 20
//                                        horizontalAlignment: Text.AlignHCenter
//                                        verticalAlignment: Text.AlignVCenter
//                                        textFormat: Text.RichText
//                                        Layout.leftMargin: 15
//                                        Layout.preferredHeight: 20
//                                        Layout.preferredWidth: 0
//                                        Layout.fillHeight: false
//                                        Layout.minimumHeight: 15
//                                        Layout.minimumWidth: 80
//                                        Layout.maximumHeight: 200
//                                        Layout.maximumWidth: 200
//                                        font.bold: false
//                                        Layout.fillWidth: true
//                                        Layout.columnSpan: 2
//                                        Layout.rowSpan: 1
//                                    }

//                                    Text {
//                                        id: image_filters_yp_input_label
//                                        color: white
//                                        text: qsTr("p :")
//                                        font.pixelSize: 12
//                                        horizontalAlignment: Text.AlignRight
//                                        font.italic: true
//                                        Layout.minimumWidth: 10
//                                        Layout.leftMargin: 15
//                                        Layout.fillWidth: false
//                                    }

//                                    TextField {
//                                        id: image_filters_yp_input
//                                        color: white
//                                        text: "5"
//                                        font.pixelSize: 11
//                                        Layout.fillWidth: true
//                                        Layout.rowSpan: 1
//                                        Layout.columnSpan: 1
//                                        background: Rectangle {
//                                            color: light_black_3
//                                        }
//                                    }
//                                }
//                            }
//                            ActionButton {
//                                id: image_filters_yp_button
//                                icon_path: "../icons/filter_yp.png"
//                                Layout.fillHeight: false
//                                Layout.minimumWidth: 30
//                                button_height: 25
//                                Layout.minimumHeight: 30
//                                button_width: 25
//                                Layout.leftMargin: 25
//                                Layout.rightMargin: 20
//                                // onClicked: backend.get_image_histogram()
//                                Layout.maximumWidth: 30
//                                Layout.fillWidth: false
//                                Layout.maximumHeight: 30
//                            }

                            //
                            // Medium
                            //

                            Text {
                                id: image_filters_medium
                                color: white
                                text: qsTr("Filtro Mediana")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_filters_medium_button
                                icon_path: "../icons/filter_medium.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.filter_image('median',parseInt(image_filters_n_input.text),0)
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Max
                            //
                            Text {
                                id: image_filters_max
                                color: white
                                text: qsTr("Filtro Máx")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_filters_max_button
                                icon_path: "../icons/filter_max.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.filter_image('max',parseInt(image_filters_n_input.text),0)
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Min
                            //
                            Text {
                                id: image_filters_min
                                color: white
                                text: qsTr("Filtro Min")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_filters_min_button
                                icon_path: "../icons/filter_min.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.filter_image('min',parseInt(image_filters_n_input.text),0)
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                        }
                    }

                    // Image Morphological Operations
                    Collapsable {
                        id: collapsable_image_morph_op
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_filters.bottom
                        collapsable_height: 190
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "OPERACIONES MORFOLÓGICAS"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_morph_op_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 5
                            columns: 2

                            //
                            // Size
                            //
                            Text {
                                id: image_morph_op_size_label
                                color: white
                                text: qsTr("Tamaño Elemento Estructural")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            TextField {
                                id: image_morph_op_size_input
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                Layout.minimumHeight: 30
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                Layout.maximumWidth: 100
                                Layout.fillWidth: true
                                Layout.maximumHeight: 30

                                color: white
                                text: "9"
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                background: Rectangle {
                                    color: light_black_3
                                }
                            }

                            //
                            // Erosion
                            //
                            Text {
                                id: image_morph_op_erosion
                                color: white
                                text: qsTr("Erosion")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_morph_op_erosion_button
                                icon_path: "../icons/erosion.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked:backend.apply_morph_op('erosion',parseInt(image_morph_op_size_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Dilation
                            //
                            Text {
                                id: image_morph_op_dilation
                                color: white
                                text: qsTr("Dilatación")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_morph_op_erosion_dilation
                                icon_path: "../icons/dilation.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked:backend.apply_morph_op('dilation',parseInt(image_morph_op_size_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Closing
                            //
                            Text {
                                id: image_morph_op_lock
                                color: white
                                text: qsTr("Cerradura")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_morph_op_lock_button
                                icon_path: "../icons/lock.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked:backend.apply_morph_op('closing',parseInt(image_morph_op_size_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }

                            //
                            // Opening
                            //
                            Text {
                                id: image_morph_op_opening
                                color: white
                                text: qsTr("Apertura")
                                font.pixelSize: 12
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.WordWrap
                                Layout.fillHeight: true
                                Layout.minimumHeight: 30
                                leftPadding: 10
                                font.bold: false
                                Layout.maximumWidth: 240
                                Layout.fillWidth: true
                                Layout.maximumHeight: 35
                            }
                            ActionButton {
                                id: image_morph_op_apertura_button
                                icon_path: "../icons/unlock.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked:backend.apply_morph_op('opening',parseInt(image_morph_op_size_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                        }
                    }
                    
                    // Contrast
                    Collapsable {
                        id: collapsable_image_contrast
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_morph_op.bottom
                        collapsable_height: 70
                        anchors.bottomMargin: 0
                        anchors.leftMargin: 0
                        anchors.topMargin: 0
                        title: "CONTRASTADO DE IMAGEN"
                        anchors.rightMargin: 0
                        Layout.fillWidth: true

                        GridLayout {
                            id: image_contrast_grid
                            anchors.fill: parent
                            anchors.topMargin: 20
                            rows: 1
                            columns: 2

                            Rectangle {
                                id: image_contrast_rect
                                width: 200
                                color: "#00000000"
                                Layout.minimumHeight: 40

                                GridLayout {
                                    id: image_contrast_rect_grid
                                    anchors.fill: parent
                                    columnSpacing: 5
                                    rows: 2
                                    columns: 4

                                    Text {
                                        id: image_contrast_label
                                        color: white
                                        text: qsTr("Contraste")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        Layout.leftMargin: 15
                                        Layout.preferredHeight: 15
                                        Layout.preferredWidth: 0
                                        Layout.fillHeight: false
                                        Layout.minimumHeight: 15
                                        Layout.minimumWidth: 80
                                        Layout.maximumHeight: 200
                                        Layout.maximumWidth: 200
                                        font.bold: false
                                        Layout.fillWidth: true
                                        Layout.columnSpan: 4
                                        Layout.rowSpan: 1
                                    }

                                    Text {
                                        id: image_contrast_alpha_input_label
                                        color: white
                                        text: qsTr("α :")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_contrast_alpha_input
                                        color: white
                                        text: "1.5"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }

                                    Text {
                                        id: image_contrast_beta_input_label
                                        color: white
                                        text: qsTr("β :")
                                        font.pixelSize: 12
                                        horizontalAlignment: Text.AlignRight
                                        font.italic: true
                                        Layout.minimumWidth: 10
                                        Layout.leftMargin: 15
                                        Layout.fillWidth: false
                                    }

                                    TextField {
                                        id: image_contrast_beta_input
                                        color: white
                                        text: "0"
                                        font.pixelSize: 11
                                        Layout.fillWidth: true
                                        Layout.rowSpan: 1
                                        Layout.columnSpan: 1
                                        background: Rectangle {
                                            color: light_black_3
                                        }
                                    }
                                }
                            }
                            ActionButton {
                                id: image_contrast_button
                                icon_path: "../icons/contrast.png"
                                Layout.fillHeight: false
                                Layout.minimumWidth: 30
                                button_height: 25
                                Layout.minimumHeight: 30
                                button_width: 25
                                Layout.leftMargin: 25
                                Layout.rightMargin: 20
                                onClicked: backend.apply_contrast(parseFloat(image_contrast_alpha_input.text),parseFloat(image_contrast_beta_input.text))
                                Layout.maximumWidth: 30
                                Layout.fillWidth: false
                                Layout.maximumHeight: 30
                            }
                        }
                    }
                    
                    // Image miscellaneous
                    Collapsable {
                        id: collapsable_image_miscellaneous
                        height: 20
                        border.width: 0
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: collapsable_image_contrast.bottom
                        anchors.topMargin: 0
                        title: "VARIADOS"
                        anchors.leftMargin: 0
                        anchors.rightMargin: 0
                        collapsable_height: 160

                        ScrollView {
                            id: image_noise_scroll
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            clip: true
                            anchors.topMargin: 20

                            GridLayout {
                                id: image_miscellaneous_grid
                                anchors.fill: parent
                                rows: 3

                                Text {
                                    id: image_actions_histogram1
                                    color: white
                                    text: qsTr("Histograma de la imagen")
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 30
                                    leftPadding: 10
                                    font.bold: false
                                    Layout.maximumWidth: 240
                                    Layout.fillWidth: true
                                    Layout.maximumHeight: 35
                                }

                                ActionButton {
                                    id: image_actions_histogram_button1
                                    icon_path: "../icons/histogram.png"
                                    Layout.fillHeight: false
                                    Layout.minimumWidth: 30
                                    button_height: 25
                                    Layout.minimumHeight: 30
                                    button_width: 25
                                    Layout.leftMargin: 25
                                    Layout.rightMargin: 20
                                    onClicked: backend.get_image_histogram()
                                    Layout.maximumWidth: 30
                                    Layout.fillWidth: false
                                    Layout.maximumHeight: 30
                                }


                                Text {
                                    id: image_actions_connected1
                                    color: white
                                    text: qsTr("Simple/multiplemente conectado")
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 30
                                    leftPadding: 10
                                    font.bold: false
                                    Layout.maximumWidth: 240
                                    Layout.fillWidth: true
                                    Layout.maximumHeight: 35
                                }

                                ActionButton {
                                    id: image_actions_connected_button1
                                    icon_path: "../icons/connected.png"
                                    Layout.fillHeight: false
                                    Layout.minimumWidth: 30
                                    button_height: 25
                                    Layout.minimumHeight: 30
                                    button_width: 25
                                    Layout.leftMargin: 25
                                    Layout.rightMargin: 20
                                    onClicked: backend.get_image_connection()
                                    Layout.maximumWidth: 30
                                    Layout.fillWidth: false
                                    Layout.maximumHeight: 30
                                }

                                Text {
                                    id: image_actions_highlight_outline1
                                    color: white
                                    text: qsTr("Resaltar contorno")
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 30
                                    leftPadding: 10
                                    font.bold: false
                                    Layout.maximumWidth: 240
                                    Layout.fillWidth: true
                                    Layout.maximumHeight: 35
                                }

                                ActionButton {
                                    id: image_actions_highlight_outline_button1
                                    icon_path: "../icons/outline.png"
                                    Layout.fillHeight: false
                                    Layout.minimumWidth: 30
                                    button_height: 25
                                    Layout.minimumHeight: 30
                                    button_width: 25
                                    Layout.leftMargin: 25
                                    Layout.rightMargin: 20
                                    onClicked: backend.get_image_highlighted()
                                    Layout.maximumWidth: 30
                                    Layout.fillWidth: false
                                    Layout.maximumHeight: 30
                                }

                                Text {
                                    id: image_actions_classify1
                                    color: white
                                    text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'Fira Sans Semi-Light'; font-size:10pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Clasificar Imagen</p>\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:9pt; font-style:italic;\">(Sencilla/Compleja)</span></p></body></html>"
                                    font.pixelSize: 12
                                    verticalAlignment: Text.AlignVCenter
                                    wrapMode: Text.WordWrap
                                    Layout.fillHeight: true
                                    textFormat: Text.RichText
                                    Layout.minimumHeight: 30
                                    font.bold: false
                                    leftPadding: 10
                                    Layout.maximumWidth: 240
                                    Layout.fillWidth: true
                                    Layout.maximumHeight: 35
                                }

                                ActionButton {
                                    id: image_actions_classify_button1
                                    icon_path: "../icons/classify.png"
                                    Layout.fillHeight: false
                                    Layout.minimumWidth: 30
                                    button_height: 25
                                    Layout.minimumHeight: 30
                                    button_width: 25
                                    Layout.leftMargin: 25
                                    Layout.rightMargin: 20
                                    onClicked: backend.classify_image()
                                    Layout.maximumWidth: 30
                                    Layout.fillWidth: false
                                    Layout.maximumHeight: 30
                                }
                                columns: 2
                            }
                            anchors.leftMargin: 0
                            anchors.rightMargin: 0
                            anchors.bottomMargin: 0
                        }
                        Layout.fillWidth: true
                        anchors.bottomMargin: 0
                    }
                }
            }

            // Animation
            PropertyAnimation{
                id: animation_side_bar
                target: side_bar
                property: "width"
                to: side_bar.width == 30 ? 350 : 30
                easing.type: Easing.InQuad
            }




        }

        // Bottom bar
        Rectangle {
            id: bottom_bar
            height: 25
            color: light_black_1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0

            Label {
                id: actions_status_label
                color: gray
                text: actions_status
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                anchors.leftMargin: 15
                anchors.bottomMargin: 0
                anchors.topMargin: 0
            }

            Label {
                id: mouse_posicion_label
                color: gray
                text: string_pos_size
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 0
                anchors.topMargin: 0
            }

            // Resizing window
            MouseArea {
                id: resize_window

                z: 1
                width: 25
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.rightMargin: 0
                visible: window_status == 1 ? false : true
                cursorShape: Qt.SizeFDiagCursor

                DragHandler{
                    target: null
                    onActiveChanged: if(active) main_window.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                }

                Image {
                    id: resize_image

                    z: 2
                    opacity: 0.5
                    visible: window_status == 1 ? false : true
                    width: 16; height: 16
                    anchors.fill: parent
                    source: "./icons/resize_icon.png"
                    sourceSize.height: 16
                    sourceSize.width: 16
                    fillMode: Image.PreserveAspectFit
                    antialiasing: false
                }
            }
        }

        // Content pane
        Rectangle {
            id: content_pane
            color: light_black_2
            anchors.left: parent.left
            anchors.right: side_bar.left
            anchors.top: top_bar.bottom
            anchors.bottom: bottom_bar.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0
            anchors.topMargin: 0

            property int index_placeholder_image: 0
            property var placeholder_image_components: [placeholder_drag,placeholder_load,placeholder_image]

            // Image Drop Placeholder
            Rectangle {
                id: content_placeholder_image
                color: transparent
                anchors.fill: parent

                DropArea {
                    id: content_drop_area;
                    anchors.fill: parent;

                    // Events
                    onEntered: (drag)=>{
                                   if(content_pane.index_placeholder_image != 2) content_pane.index_placeholder_image = 1 // Placeholder para soltar la imágen
                                   drag.accept (Qt.LinkAction)
                               }
                    onDropped: (drop)=>{
                                   content_pane.index_placeholder_image = 2
                                   if(drop.urls[0]) image_source = drop.urls[0].toString().substring(7) // Removes a 'file://' prefix
                                   if(image_source) backend.close_image()
                                   histogram_plot.plot_source = ''
                                   histogram_plot.close()
                                   // The image is open in the backend with cv2
                                   backend.open_image(image_source)
                               }
                    onExited: { if(content_pane.index_placeholder_image != 2) content_pane.index_placeholder_image = 0 }
                }

                // Drag Image Component
                Component {
                    id: placeholder_drag
                    Item {
                        anchors.fill: parent
                        Image {
                            id: placeholder_drag_image
                            anchors.centerIn: parent
                            source: "./icons/image.png"
                            fillMode: Image.PreserveAspectFit
                            width: 100; height: 100
                            antialiasing: true
                        }
                        Text {
                            id: placeholder_drag_text
                            anchors { top: placeholder_drag_image.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 15}
                            font.pixelSize: 13
                            color: white
                            text: "Puedes arrastrar la imagen y soltarla aquí"
                        }
                    }
                }

                // Load Image Component
                Component {
                    id: placeholder_load
                    Item {
                        anchors.fill: parent
                        Image {
                            id: placeholder_load_image
                            source: "./icons/upload.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                            width: 50; height: 50
                        }
                        Text {
                            id: placeholder_load_text
                            anchors { top: placeholder_load_image.bottom; horizontalCenter: parent.horizontalCenter; topMargin: 15}
                            font.pixelSize: 13
                            color: white
                            text: "Suelta la imagen a cargar"
                        }
                    }
                }

                // Main image Component
                Component {
                    id:placeholder_image
                    Item {
                        id: placeholder_item
                        anchors.fill: parent
                        Image {
                            id: main_image
                            source: image_source
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            property int great_axis: main_image.status == Image.Ready ? (main_image.sourceSize.width > main_image.sourceSize.height ? 0 : 1) : -1
                            property real image_ratio: main_image.status == Image.Ready ? ((great_axis ? placeholder_item.height : placeholder_item.width)/(great_axis ? main_image.sourceSize.height : main_image.sourceSize.width )) : 0.0

                            width: parseInt(main_image.sourceSize.width*image_ratio); height: parseInt(main_image.sourceSize.height*image_ratio)


                            onStatusChanged: ()=>{ if(main_image.status == Image.Ready){
                                                     image_x_size = parseInt(main_image.sourceSize.width)
                                                     image_y_size = parseInt(main_image.sourceSize.height)
                                                     const processed_path = Misc.process_path(image_source)
                                                     image_name = processed_path[0]
                                                     image_path = processed_path[1]
                                                 }
                                             }
                            onImage_ratioChanged: { scale_ratio = image_ratio }
                        }

                        MouseArea{
                            id: main_image_mouse_area
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: main_image.width; height: main_image.height
                            hoverEnabled: true
                            cursorShape: Qt.CrossCursor

                            onMouseXChanged: string_pos_size = `${main_image_mouse_area.mouseX}px,${main_image_mouse_area.mouseY}px (${main_image.width}x${main_image.height})`
                            onMouseYChanged: string_pos_size = `${main_image_mouse_area.mouseX}px,${main_image_mouse_area.mouseY}px (${main_image.width}x${main_image.height})`
                            onClicked: ()=>{
                                           image_x_pixel = parseInt(main_image_mouse_area.mouseX/main_image.image_ratio)
                                           image_y_pixel = parseInt(main_image_mouse_area.mouseY/main_image.image_ratio)
                                           //Calls the slot to obtain the color of the pixel
                                           backend.get_pixel_color(image_x_pixel,image_y_pixel)
                                       }

                        }
                    }
                }

                Loader {
                    id: loader_placeholder_imagen
                    anchors.fill: parent
                    sourceComponent: content_pane.placeholder_image_components[content_pane.index_placeholder_image]

                }

                HistogramPlot {
                    id: histogram_plot
                    y: 152
                    z: 2
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                }
            }
        }
    }

    Connections{
        target: backend
        // Retrieve of a pixel color of an image
        function onPixelColor(r, g, b){
            image_pixel_rectangle_color = Qt.rgba(r/255,g/255,b/255,1.0)
            image_pixel_rgb = `(${r},${g},${b})`
        }
        function onPixelGrayscale(pixel){
            const pixel_real = pixel/255
            image_pixel_rectangle_color = Qt.rgba(pixel_real,pixel_real,pixel_real,1.0)
            image_pixel_rgb = `(${pixel},${pixel},${pixel})`
        }
        // New image
        function onNewImagePath(name,path){
            image_source = `${path}/${name}`
            image_name = name
            image_path = path
        }
        // New histogram
        function onNewPlotHistogram(name,path){
            histogram_plot.plot_source = path
            histogram_plot.open(name)
        }

        // Update of an action
        function onActionsStatus(status,message){
            let status_string = ''
            if(status < 0) status_string = 'Falló'
            else if(status == 1) status_string = 'Completado'
            else if(status == 2) status_string = 'En progreso'

            actions_status = `${status_string}(${message})`
        }
    }
}









/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}D{i:3}D{i:4}D{i:6}D{i:7}D{i:8}D{i:5}D{i:2}D{i:10}D{i:15}
D{i:16}D{i:17}D{i:18}D{i:19}D{i:20}D{i:21}D{i:22}D{i:14}D{i:23}D{i:24}D{i:13}D{i:28}
D{i:29}D{i:27}D{i:31}D{i:30}D{i:33}D{i:34}D{i:32}D{i:26}D{i:25}D{i:37}D{i:38}D{i:39}
D{i:40}D{i:42}D{i:43}D{i:41}D{i:45}D{i:46}D{i:47}D{i:48}D{i:49}D{i:36}D{i:35}D{i:52}
D{i:53}D{i:54}D{i:55}D{i:58}D{i:59}D{i:60}D{i:57}D{i:56}D{i:62}D{i:51}D{i:50}D{i:67}
D{i:68}D{i:69}D{i:66}D{i:65}D{i:71}D{i:74}D{i:75}D{i:76}D{i:78}D{i:79}D{i:73}D{i:72}
D{i:81}D{i:64}D{i:63}D{i:84}D{i:85}D{i:87}D{i:88}D{i:91}D{i:92}D{i:93}D{i:90}D{i:89}
D{i:95}D{i:96}D{i:97}D{i:98}D{i:99}D{i:100}D{i:101}D{i:83}D{i:82}D{i:104}D{i:105}
D{i:107}D{i:108}D{i:109}D{i:110}D{i:111}D{i:112}D{i:113}D{i:114}D{i:103}D{i:102}D{i:119}
D{i:120}D{i:121}D{i:123}D{i:124}D{i:118}D{i:117}D{i:126}D{i:116}D{i:115}D{i:130}D{i:131}
D{i:132}D{i:133}D{i:134}D{i:135}D{i:136}D{i:137}D{i:129}D{i:128}D{i:127}D{i:12}D{i:11}
D{i:138}D{i:9}D{i:140}D{i:141}D{i:143}D{i:144}D{i:142}D{i:139}D{i:147}D{i:148}D{i:152}
D{i:156}D{i:160}D{i:161}D{i:146}D{i:145}D{i:1}D{i:162}
}
##^##*/
