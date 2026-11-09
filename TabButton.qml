import QtQuick 2.12

Rectangle {
            property string text: ""
            property bool isActive: false
            signal clicked()

            width: 120
            height: 38
            radius: 8
            color: isActive ? colors.colorPrimary : "transparent"

            Text {
                anchors.centerIn: parent
                text: parent.text
                font.pixelSize: 13
                font.bold: true
                color: isActive ? "#ffffff" : colors.colorTextMuted
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: parent.clicked()
            }
        }
