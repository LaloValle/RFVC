import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: collapsable

    clip: true
    color: "#282c34"
    border.color: "#ffffff"
    width: 320; height: collapsable_height

    property string title: "SECCION COLAPSABLE"
    property int collapsable_height: 100

    Button {
        id: button
        height: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0

        onClicked: ()=>{ animation_collapsable.running = true; animation_icon.running = true }

        background: Rectangle{
            anchors.fill: parent
            color: "#1c1d20"
        }

        contentItem: Item{
            id: item1
            Image{
                id: icon_button
                width: 12
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 5
                source: "../icons/collapse.png"
                fillMode: Image.PreserveAspectFit
                rotation: collapsable.height == 20 ? 180 : 0
            }

            Label{
                id: label_button
                color: "#ffffff"
                text: title
                anchors.left: icon_button.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                verticalAlignment: Text.AlignVCenter
                font.italic: false
                font.weight: Font.DemiBold
                leftPadding: 10
                font.bold: true
                font.pointSize: 7
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.bottomMargin: 0
                anchors.topMargin: 0
            }
        }

        // Animations
        PropertyAnimation{
            id: animation_collapsable
            target: collapsable
            property: "height"
            to: collapsable.height == 20 ? collapsable_height : 20
            easing.type : Easing.InQuad
        }

        PropertyAnimation{
            id: animation_icon
            target: icon_button
            property: "rotation"
            to: icon_button.rotation == 0 ? 180 : 0
            easing.type: Easing.InQuad
        }
    }



}

/*##^##
Designer {
    D{i:0;formeditorZoom:2;height:50;width:320}D{i:6}D{i:7}D{i:1}
}
##^##*/
