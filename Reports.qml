import QtQuick 2.12

Item {
    id: rootReports
    clip: true

    implicitWidth: 1000
    implicitHeight: 700

    signal exportReportRequested(string reportType, string fileFormat)
    signal notificationActionTriggered(int notificationId, string actionType)
    signal markAllNotificationsRead()

    readonly property color colorBg: "#f8fafc"
    readonly property color colorCardBg: "#ffffff"
    readonly property color colorBorder: "#e2e8f0"
    readonly property color colorTextDark: "#0f172a"
    readonly property color colorTextMuted: "#64748b"

    readonly property color colorPrimary: "#0284c7"
    readonly property color colorSuccess: "#10b981"
    readonly property color colorWarning: "#f59e0b"
    readonly property color colorDanger: "#ef4444"
    readonly property color colorPurple: "#8b5cf6"

    property string selectedFilter: "All"

    property var notificationsModel: [
        {
            id: 101,
            title: "Plan Expiring Soon",
            message: "Sara Ahmadi's 'Pro Athlete' plan expires in 2 days.",
            time: "10 mins ago",
            type: "warning",
            category: "Expiring Soon",
            isRead: false,
            actionLabel: "Send Reminder"
        },
        {
            id: 102,
            title: "Payment Received",
            message: "Online renewal payment of $102.00 received from Ali Rezaei.",
            time: "1 hour ago",
            type: "success",
            category: "Payments",
            isRead: false,
            actionLabel: "View Invoice"
        },
        {
            id: 103,
            title: "Discount Campaign Active",
            message: "VIP Elite 20% discount offer generated 8 new subscriptions today.",
            time: "4 hours ago",
            type: "info",
            category: "Promotions",
            isRead: true,
            actionLabel: "View Details"
        },
        {
            id: 104,
            title: "Failed Auto-Renewal",
            message: "Credit card auto-charge failed for member #1084 (Mohsen K.).",
            time: "Yesterday",
            type: "danger",
            category: "Payments",
            isRead: true,
            actionLabel: "Retry Charge"
        }
    ]

    property var reportsList: [
        {
            id: "financial_monthly",
            title: "Financial & Revenue Summary",
            description: "Breakdown of membership sales, VAT tax collected, and payment gateway fees.",
            icon: "📊",
            period: "Current Month"
        },
        {
            id: "memberships_expiring",
            title: "Membership Status & Churn",
            description: "Active, expiring, and lapsed memberships with renewal conversion rates.",
            icon: "👥",
            period: "Last 30 Days"
        },
        {
            id: "plans_performance",
            title: "Plan Sales & Discount Impact",
            description: "Comparison of popularity, discounted volume, and revenue per plan tier.",
            icon: "🏷️",
            period: "Quarter to Date"
        },
        {
            id: "attendance_peak",
            title: "Club Usage & Peak Hours",
            description: "Daily check-in traffic density, locker room usage, and peak hour trends.",
            icon: "⏱️",
            period: "Weekly"
        }
    ]

    function getUnreadCount() {
        var count = 0;
        for (var i = 0; i < notificationsModel.length; i++) {
            if (!notificationsModel[i].isRead) count++;
        }
        return count;
    }

    Rectangle {
        anchors.fill: parent
        color: rootReports.colorBg
    }

    Flickable {
        id: mainFlick
        anchors.fill: parent
        contentWidth: width
        contentHeight: colContent.height + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: colContent
            width: Math.max(parent.width - 64, 450)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 28
            spacing: 24

            Item {
                width: parent.width
                height: 48

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        text: "Reports & Notification Center"
                        font.pixelSize: 22
                        font.bold: true
                        color: rootReports.colorTextDark
                    }
                    Text {
                        text: "Generate audit-ready reports and review real-time operations alerts"
                        font.pixelSize: 13
                        color: rootReports.colorTextMuted
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                    height: 38
                    radius: 8
                    color: btnMasterExportMouse.pressed ? Qt.darker(rootReports.colorPrimary, 1.15) :
                           btnMasterExportMouse.containsMouse ? Qt.lighter(rootReports.colorPrimary, 1.1) : rootReports.colorPrimary

                    Row {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "📥"
                            font.pixelSize: 13
                        }
                        Text {
                            text: "Export All Data"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }
                    }

                    MouseArea {
                        id: btnMasterExportMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            rootReports.exportReportRequested("all_combined", "ZIP")
                            toastAction.show("Full audit dataset export started...")
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16

                Repeater {
                    model: [
                        { label: "Unread Notifications", value: rootReports.getUnreadCount() + " Alerts", color: rootReports.colorWarning },
                        { label: "Expiring Memberships", value: "14 Members", color: rootReports.colorDanger },
                        { label: "Monthly Gross Revenue", value: "$18,450.00", color: rootReports.colorSuccess },
                        { label: "Generated Reports", value: "32 Files", color: rootReports.colorPrimary }
                    ]

                    Rectangle {
                        width: (colContent.width - 48) / 4
                        height: 80
                        radius: 12
                        color: rootReports.colorCardBg
                        border.color: rootReports.colorBorder

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 6

                            Text {
                                text: modelData.label
                                font.pixelSize: 11
                                font.bold: true
                                color: rootReports.colorTextMuted
                            }
                            Text {
                                text: modelData.value
                                font.pixelSize: 18
                                font.bold: true
                                color: modelData.color
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: colReportsSection.height + 40
                radius: 12
                color: rootReports.colorCardBg
                border.color: rootReports.colorBorder

                Column {
                    id: colReportsSection
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "Key Business & Financial Reports"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootReports.colorTextDark
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootReports.colorBorder
                    }

                    Flow {
                        width: parent.width
                        spacing: 16

                        Repeater {
                            model: rootReports.reportsList

                            Rectangle {
                                width: (colReportsSection.width - 16) / 2
                                height: 130
                                radius: 10
                                color: "#f8fafc"
                                border.color: rootReports.colorBorder

                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 14

                                    Row {
                                        anchors.top: parent.top
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        spacing: 10

                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: 8
                                            color: "#ffffff"
                                            border.color: rootReports.colorBorder

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.icon
                                                font.pixelSize: 16
                                            }
                                        }

                                        Column {
                                            width: parent.width - 46
                                            spacing: 2

                                            Text {
                                                text: modelData.title
                                                font.pixelSize: 13
                                                font.bold: true
                                                color: rootReports.colorTextDark
                                            }
                                            Text {
                                                width: parent.width
                                                text: modelData.description
                                                font.pixelSize: 11
                                                color: rootReports.colorTextMuted
                                                wrapMode: Text.WordWrap
                                                maximumLineCount: 2
                                                elide: Text.ElideRight
                                            }
                                        }
                                    }

                                    Row {
                                        anchors.bottom: parent.bottom
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        height: 28

                                        Text {
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: "Period: " + modelData.period
                                            font.pixelSize: 11
                                            color: rootReports.colorTextMuted
                                        }

                                        Row {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 6

                                            Rectangle {
                                                width: 58
                                                height: 26
                                                radius: 5
                                                color: btnPdfMouse.containsMouse ? "#fee2e2" : "#ffffff"
                                                border.color: btnPdfMouse.containsMouse ? rootReports.colorDanger : rootReports.colorBorder

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "PDF"
                                                    font.pixelSize: 11
                                                    font.bold: true
                                                    color: rootReports.colorDanger
                                                }

                                                MouseArea {
                                                    id: btnPdfMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        rootReports.exportReportRequested(modelData.id, "PDF")
                                                        toastAction.show("Generating PDF: " + modelData.title)
                                                    }
                                                }
                                            }

                                            Rectangle {
                                                width: 58
                                                height: 26
                                                radius: 5
                                                color: btnExcelMouse.containsMouse ? "#dcfce7" : "#ffffff"
                                                border.color: btnExcelMouse.containsMouse ? rootReports.colorSuccess : rootReports.colorBorder

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Excel"
                                                    font.pixelSize: 11
                                                    font.bold: true
                                                    color: rootReports.colorSuccess
                                                }

                                                MouseArea {
                                                    id: btnExcelMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        rootReports.exportReportRequested(modelData.id, "XLSX")
                                                        toastAction.show("Exporting Excel: " + modelData.title)
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

            Rectangle {
                width: parent.width
                height: colNotifSection.height + 40
                radius: 12
                color: rootReports.colorCardBg
                border.color: rootReports.colorBorder

                Column {
                    id: colNotifSection
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 16

                    Item {
                        width: parent.width
                        height: 32

                        Text {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Activity & Alert Notifications"
                            font.pixelSize: 16
                            font.bold: true
                            color: rootReports.colorTextDark
                        }

                        Row {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 8

                            Rectangle {
                                width: 110
                                height: 28
                                radius: 6
                                color: btnMarkReadMouse.containsMouse ? "#f1f5f9" : "transparent"
                                border.color: rootReports.colorBorder

                                Text {
                                    anchors.centerIn: parent
                                    text: "Mark all as read"
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: rootReports.colorTextMuted
                                }

                                MouseArea {
                                    id: btnMarkReadMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        var updated = []
                                        for (var i = 0; i < rootReports.notificationsModel.length; i++) {
                                            var item = rootReports.notificationsModel[i]
                                            item.isRead = true
                                            updated.push(item)
                                        }
                                        rootReports.notificationsModel = updated
                                        rootReports.markAllNotificationsRead()
                                        toastAction.show("All notifications marked as read")
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootReports.colorBorder
                    }

                    Column {
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: rootReports.notificationsModel

                            Rectangle {
                                width: parent.width
                                height: 68
                                radius: 8
                                color: modelData.isRead ? "#ffffff" : "#f0fdf4"
                                border.color: modelData.isRead ? rootReports.colorBorder : "#bbf7d0"

                                Item {
                                    anchors.fill: parent
                                    anchors.margins: 12

                                    Rectangle {
                                        id: dotIndicator
                                        width: 8
                                        height: 8
                                        radius: 4
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: modelData.type === "danger" ? rootReports.colorDanger :
                                               modelData.type === "warning" ? rootReports.colorWarning :
                                               modelData.type === "success" ? rootReports.colorSuccess : rootReports.colorPrimary
                                    }

                                    Column {
                                        anchors.left: dotIndicator.right
                                        anchors.leftMargin: 12
                                        anchors.right: btnActionArea.left
                                        anchors.rightMargin: 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        spacing: 3

                                        Row {
                                            spacing: 8
                                            Text {
                                                text: modelData.title
                                                font.pixelSize: 13
                                                font.bold: true
                                                color: rootReports.colorTextDark
                                            }
                                            Text {
                                                text: "•  " + modelData.time
                                                font.pixelSize: 11
                                                color: rootReports.colorTextMuted
                                            }
                                        }

                                        Text {
                                            width: parent.width
                                            text: modelData.message
                                            font.pixelSize: 12
                                            color: rootReports.colorTextMuted
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Rectangle {
                                        id: btnActionArea
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 110
                                        height: 30
                                        radius: 6
                                        color: btnItemActionMouse.containsMouse ? "#f1f5f9" : "#ffffff"
                                        border.color: rootReports.colorBorder

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.actionLabel
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: rootReports.colorPrimary
                                        }

                                        MouseArea {
                                            id: btnItemActionMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                                rootReports.notificationActionTriggered(modelData.id, modelData.actionLabel)
                                                toastAction.show("Action executed: " + modelData.actionLabel)
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

    Rectangle {
        id: toastAction
        property string message: ""
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.max(lblToastText.width + 48, 240)
        height: 42
        radius: 21
        color: "#0f172a"
        opacity: 0
        visible: opacity > 0
        z: 99

        function show(msg) {
            message = msg
            toastActionAnim.restart()
        }

        Row {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "ℹ️"
                font.pixelSize: 12
            }

            Text {
                id: lblToastText
                text: toastAction.message
                color: "#ffffff"
                font.pixelSize: 12
                font.bold: true
            }
        }

        SequentialAnimation {
            id: toastActionAnim
            NumberAnimation { target: toastAction; property: "opacity"; to: 1; duration: 180 }
            PauseAnimation { duration: 2000 }
            NumberAnimation { target: toastAction; property: "opacity"; to: 0; duration: 180 }
        }
    }
}
