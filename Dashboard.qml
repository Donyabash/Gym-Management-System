import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
    id: rootDashboard
    clip: true

    implicitWidth: 1400
    implicitHeight: 750
    anchors.centerIn: parent


    signal exportReportRequested(string format)
    signal notificationClicked(int notifId)

    Rectangle {
        anchors.fill: parent
        color: colors.colorBg
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: mainCol.height + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: mainCol
            width: Math.min(parent.width - 48, 1140)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 24
            spacing: 20


            Item {
                width: parent.width
                height: 48

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        text: "Dashboard Overview"
                        font.pixelSize: 22
                        font.bold: true
                        color: colors.colorTextDark
                    }
                    Text {
                        text: "Welcome back! Here's your club's performance summary for today."
                        font.pixelSize: 12
                        color: colors.colorTextMuted
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10


                    ExportButton {
                        text: "Export PDF"
                        icon: "📄"
                        onClicked: rootDashboard.exportReportRequested("PDF")
                    }


                    ExportButton {
                        text: "Export Excel"
                        icon: "📊"
                        onClicked: rootDashboard.exportReportRequested("Excel")
                    }
                }

            }


            Row {
                width: parent.width
                spacing: 16

                Repeater {
                    model: models.statsModel

                    Rectangle {
                        width: (parent.width - 48) / 4
                        height: 95
                        radius: 10
                        color: colors.colorCardBg
                        border.color: colors.colorBorder

                        Item {
                            anchors.fill: parent
                            anchors.margins: 14

                            RowLayout {
                                anchors.fill: parent
                                spacing: 10

                                Column {
                                    Layout.fillWidth: true
                                    spacing: 3

                                    Text {
                                        text: modelData.title
                                        font.pixelSize: 11
                                        color: colors.colorTextMuted
                                    }
                                    Text {
                                        text: modelData.value
                                        font.pixelSize: 20
                                        font.bold: true
                                        color: colors.colorTextDark
                                    }
                                    Text {
                                        text: modelData.change
                                        font.pixelSize: 10
                                        font.bold: true
                                        color: modelData.isPositive ? colors.colorSuccess : colors.colorDanger
                                    }
                                }

                                Rectangle {
                                    Layout.preferredWidth: 38
                                    Layout.preferredHeight: 38
                                    radius: 19
                                    color: Qt.lighter(modelData.color, 1.8)

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.icon
                                        font.pixelSize: 16
                                    }
                                }
                            }
                        }
                    }
                }
            }


            RowLayout {
                width: parent.width
                spacing: 16


                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 260
                    radius: 10
                    color: colors.colorCardBg
                    border.color: colors.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        RowLayout {
                            width: parent.width
                            Text {
                                text: "Weekly Member Traffic"
                                font.pixelSize: 14
                                font.bold: true
                                color: colors.colorTextDark
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "Peak: Thursday (240)"
                                font.pixelSize: 11
                                color: colors.colorTextMuted
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: colors.colorBorder }

                        Item {
                            width: parent.width
                            height: 165

                            Column {
                                anchors.fill: parent
                                spacing: 40
                                Repeater {
                                    model: 4
                                    Rectangle { width: parent.width; height: 1; color: colors.colorLightBg }
                                }
                            }

                            Row {
                                anchors.fill: parent
                                spacing: 16

                                Repeater {
                                    model: models.weeklyTrafficModel

                                    Item {
                                        width: (parent.width - (16 * 6)) / 7
                                        height: parent.height

                                        Text {
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: barRect.top
                                            anchors.bottomMargin: 4
                                            text: modelData.count
                                            font.pixelSize: 10
                                            font.bold: true
                                            color: colors.colorTextMuted
                                        }

                                        Rectangle {
                                            id: barRect
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            anchors.bottom: dayLabel.top
                                            anchors.bottomMargin: 8
                                            width: 22
                                            height: Math.max(10, (modelData.count / 260) * 115)
                                            radius: 5
                                            color: modelData.day === "Thu" ? colors.colorPrimary : Qt.lighter(colors.colorPrimary, 1.2)
                                        }

                                        Text {
                                            id: dayLabel
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.day
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: colors.colorTextDark
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


                Rectangle {
                    Layout.preferredWidth: 350
                    Layout.preferredHeight: 260
                    radius: 10
                    color: colors.colorCardBg
                    border.color: colors.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        RowLayout {
                            width: parent.width
                            Text {
                                text: "Recent Notifications"
                                font.pixelSize: 14
                                font.bold: true
                                color: colors.colorTextDark
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "Mark all read"
                                font.pixelSize: 11
                                color: colors.colorPrimary
                                font.bold: true
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: colors.colorBorder }

                        Column {
                            width: parent.width
                            spacing: 8

                            Repeater {
                                model: models.notificationsModel

                                Rectangle {
                                    width: parent.width
                                    height: 44
                                    radius: 6
                                    color: colors.colorLightBg
                                    border.color: colors.colorBorder

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 8

                                        Rectangle {
                                            Layout.preferredWidth: 7
                                            Layout.preferredHeight: 7
                                            radius: 3.5
                                            color: modelData.type === "success" ? colors.colorSuccess :
                                                   modelData.type === "warning" ? colors.colorWarning : colors.colorPrimary
                                        }

                                        Column {
                                            Layout.fillWidth: true
                                            spacing: 1
                                            Text { text: modelData.title; font.pixelSize: 11; font.bold: true; color: colors.colorTextDark; elide: Text.ElideRight }
                                            Text { text: modelData.desc; font.pixelSize: 10; color: colors.colorTextMuted; elide: Text.ElideRight }
                                        }

                                        Text { text: modelData.time; font.pixelSize: 9; color: colors.colorTextMuted }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: rootDashboard.notificationClicked(modelData.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }


            RowLayout {
                width: parent.width
                spacing: 16


                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 230
                    radius: 10
                    color: colors.colorCardBg
                    border.color: colors.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        RowLayout {
                            width: parent.width
                            Text { text: "Popular Classes (Capacity)"; font.pixelSize: 14; font.bold: true; color: colors.colorTextDark }
                            Item { Layout.fillWidth: true }
                            Text { text: "View All"; font.pixelSize: 11; font.bold: true; color: colors.colorPrimary }
                        }

                        Rectangle { width: parent.width; height: 1; color: colors.colorBorder }

                        Column {
                            width: parent.width
                            spacing: 12

                            Repeater {
                                model: models.popularClassesModel

                                Column {
                                    width: parent.width
                                    spacing: 4

                                    RowLayout {
                                        width: parent.width
                                        Text { text: modelData.name; font.pixelSize: 12; font.bold: true; color: colors.colorTextDark }
                                        Item { Layout.fillWidth: true }
                                        Text { text: modelData.count; font.pixelSize: 11; color: colors.colorTextMuted }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 7
                                        radius: 3.5
                                        color: colors.colorLightBg

                                        Rectangle {
                                            width: parent.width * (modelData.capacity / 100)
                                            height: parent.height
                                            radius: 3.5
                                            color: modelData.color
                                        }
                                    }
                                }
                            }
                        }
                    }
                }


                Rectangle {
                    Layout.preferredWidth: 350
                    Layout.preferredHeight: 230
                    radius: 10
                    color: colors.colorCardBg
                    border.color: colors.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        RowLayout {
                            width: parent.width
                            Text { text: "Membership Tiers"; font.pixelSize: 14; font.bold: true; color: colors.colorTextDark }
                            Item { Layout.fillWidth: true }
                        }

                        Rectangle { width: parent.width; height: 1; color: colors.colorBorder }

                        Column {
                            width: parent.width
                            spacing: 14

                            Repeater {
                                model: models.membershipTiersModel

                                Column {
                                    width: parent.width
                                    spacing: 6

                                    RowLayout {
                                        width: parent.width
                                        Row {
                                            spacing: 6
                                            Rectangle {
                                                width: 10; height: 10; radius: 5; color: modelData.color
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                            Text { text: modelData.title; font.pixelSize: 12; font.bold: true; color: colors.colorTextDark }
                                        }
                                        Item { Layout.fillWidth: true }
                                        Text { text: modelData.count; font.pixelSize: 11; color: colors.colorTextMuted }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 6
                                        radius: 3
                                        color: colors.colorLightBg

                                        Rectangle {
                                            width: parent.width * (modelData.percentage / 100)
                                            height: parent.height
                                            radius: 3
                                            color: modelData.color
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
