import QtQuick 2.12

// MenuButtons.qml
Rectangle {
    id: rootBtn
    property string src
    property string txt

    property bool isExpanded: false

    width: isExpanded ? 160 : 50
    height: 50
    radius: 50
    color: colors.cardBackGround

    Behavior on width { NumberAnimation { duration: 200 } }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        x: 50
        font.pixelSize: 14
        text: isExpanded ? txt : ""
        color: "#333"
    }

    Image {
        x: 15
        anchors.verticalCenter: parent.verticalCenter
        source: src
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            activeButtonName = txt
        }
    }
}
