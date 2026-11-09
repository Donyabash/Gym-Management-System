import QtQuick 2.12

Item {
    id: rootExportBtn
    width: 115
    height: 36

    property string text: "Export"
    property string icon: "📄"

    signal clicked()

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: mouseArea.pressed ? colors.colorBorder : colors.colorLightBg
        border.color: colors.colorBorder

        Row {
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: rootExportBtn.icon
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: rootExportBtn.text
                font.pixelSize: 11
                font.bold: true
                color: colors.colorTextDark
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: rootExportBtn.clicked()
        }
    }
}
