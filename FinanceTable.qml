import QtQuick 2.12

Item {
    id: rootFinancial
    anchors.fill: parent

    property string selectedPeriod: "This Month"
    property bool periodMenuOpen: false
    property var periodOptions: ["This Month", "Last Month", "This Quarter", "This Year"]

    property real menuTargetX: 0
    property real menuTargetY: 0

    function updateMenuPosition() {
        var pos = periodBtn.mapToItem(rootFinancial, 0, 0)
        menuTargetX = pos.x
        menuTargetY = pos.y + periodBtn.height + 4
    }

    readonly property color colorBg: "#f8fafc"
    readonly property color colorCardBg: "#ffffff"
    readonly property color colorBorder: "#e2e8f0"
    readonly property color colorPrimary: "#3b82f6"
    readonly property color colorPrimaryHover: "#2563eb"
    readonly property color colorTextDark: "#0f172a"
    readonly property color colorTextMuted: "#64748b"
    readonly property color colorSuccess: "#10b981"
    readonly property color colorDanger: "#ef4444"
    readonly property color colorWarning: "#f59e0b"

    property var kpiMetrics: [
        { label: "Total Revenue", value: "$48,250", change: "+12.5%", isPositive: true, accentColor: "#3b82f6" },
        { label: "Operating Costs", value: "$18,420", change: "-3.2%", isPositive: true, accentColor: "#f59e0b" },
        { label: "Net Profit", value: "$29,830", change: "+18.1%", isPositive: true, accentColor: "#10b981" },
        { label: "Pending Receivables", value: "$3,140", change: "+5.4%", isPositive: false, accentColor: "#ef4444" }
    ]

    property var monthlyData: [
        { month: "Jan", revenue: 42, expense: 20 },
        { month: "Feb", revenue: 45, expense: 22 },
        { month: "Mar", revenue: 38, expense: 19 },
        { month: "Apr", revenue: 52, expense: 25 },
        { month: "May", revenue: 48, expense: 21 },
        { month: "Jun", revenue: 58, expense: 26 },
        { month: "Jul", revenue: 54, expense: 24 },
        { month: "Aug", revenue: 61, expense: 28 },
        { month: "Sep", revenue: 56, expense: 23 },
        { month: "Oct", revenue: 64, expense: 29 },
        { month: "Nov", revenue: 59, expense: 27 },
        { month: "Dec", revenue: 68, expense: 31 }
    ]

    property var revenueStreams: [
        { title: "Membership Plans", amount: "$32,400", percent: 67, color: "#3b82f6" },
        { title: "Personal Training", amount: "$9,200", percent: 19, color: "#10b981" },
        { title: "Pro Shop & Cafe", amount: "$4,150", percent: 9, color: "#f59e0b" },
        { title: "Locker Rentals & Passes", amount: "$2,500", percent: 5, color: "#8b5cf6" }
    ]

    property var recentTransactions: [
        { id: "TX-9021", member: "Alexander Wright", type: "Annual Premium Plan", method: "Credit Card", date: "Oct 24, 2026", amount: "+$750.00", status: "Completed" },
        { id: "TX-9020", member: "Technogym Supplies", type: "Equipment Maintenance", method: "Wire Transfer", date: "Oct 23, 2026", amount: "-$1,240.00", status: "Expense" },
        { id: "TX-9019", member: "Marcus Vance", type: "10-Session PT Package", method: "Debit Card", date: "Oct 23, 2026", amount: "+$450.00", status: "Completed" },
        { id: "TX-9018", member: "Elena Rostova", type: "Monthly Recurring", method: "Direct Debit", date: "Oct 22, 2026", amount: "+$65.00", status: "Pending" },
        { id: "TX-9017", member: "CleanCare Facilities", type: "Sanitation & Janitorial", method: "Invoice", date: "Oct 21, 2026", amount: "-$680.00", status: "Expense" },
        { id: "TX-9016", member: "David Miller", type: "Locker Annual Rental", method: "Cash", date: "Oct 20, 2026", amount: "+$120.00", status: "Completed" }
    ]

    Rectangle {
        anchors.fill: parent
        color: rootFinancial.colorBg
    }

    Flickable {
        id: mainScroll
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentCol.height + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        onContentYChanged: {
            if (rootFinancial.periodMenuOpen) {
                rootFinancial.updateMenuPosition()
            }
        }

        Column {
            id: contentCol
            width: Math.min(parent.width - 64, 1280)
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
                        text: "Financial Overview"
                        font.pixelSize: 22
                        font.bold: true
                        color: rootFinancial.colorTextDark
                    }

                    Text {
                        text: "Track gym income streams, operational costs, and member debts"
                        font.pixelSize: 13
                        color: rootFinancial.colorTextMuted
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    Rectangle {
                        id: periodBtn
                        width: 140
                        height: 38
                        radius: 8
                        color: periodArea.containsMouse || rootFinancial.periodMenuOpen ? "#f1f5f9" : rootFinancial.colorCardBg
                        border.color: rootFinancial.periodMenuOpen ? rootFinancial.colorPrimary : rootFinancial.colorBorder

                        onXChanged: rootFinancial.updateMenuPosition()
                        onYChanged: rootFinancial.updateMenuPosition()
                        onWidthChanged: rootFinancial.updateMenuPosition()

                        Row {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: rootFinancial.selectedPeriod
                                font.pixelSize: 12
                                font.bold: true
                                color: rootFinancial.colorTextDark
                            }

                            Text {
                                text: rootFinancial.periodMenuOpen ? "▲" : "▼"
                                font.pixelSize: 10
                                color: rootFinancial.colorTextMuted
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            id: periodArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                rootFinancial.updateMenuPosition()
                                rootFinancial.periodMenuOpen = !rootFinancial.periodMenuOpen
                            }
                        }
                    }

                    Rectangle {
                        width: 120
                        height: 38
                        radius: 8
                        color: exportArea.containsMouse ? rootFinancial.colorPrimaryHover : rootFinancial.colorPrimary

                        MouseArea {
                            id: exportArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "Export PDF"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16

                Repeater {
                    model: rootFinancial.kpiMetrics

                    Rectangle {
                        width: (contentCol.width - (3 * 16)) / 4
                        height: 110
                        radius: 12
                        color: rootFinancial.colorCardBg
                        border.color: rootFinancial.colorBorder

                        Item {
                            anchors.fill: parent
                            anchors.margins: 16

                            Text {
                                anchors.left: parent.left
                                anchors.top: parent.top
                                text: modelData.label
                                font.pixelSize: 12
                                font.bold: true
                                color: rootFinancial.colorTextMuted
                            }

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: modelData.accentColor
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.topMargin: 4
                            }

                            Row {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                spacing: 10

                                Text {
                                    text: modelData.value
                                    font.pixelSize: 22
                                    font.bold: true
                                    color: rootFinancial.colorTextDark
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Rectangle {
                                    height: 22
                                    width: txtTag.implicitWidth + 12
                                    radius: 6
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: modelData.isPositive ? "#ecfdf5" : "#fef2f2"

                                    Text {
                                        id: txtTag
                                        anchors.centerIn: parent
                                        text: modelData.change
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: modelData.isPositive ? rootFinancial.colorSuccess : rootFinancial.colorDanger
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Row {
                width: parent.width
                height: 340
                spacing: 16

                Rectangle {
                    width: (parent.width - 16) * 0.65
                    height: parent.height
                    radius: 12
                    color: rootFinancial.colorCardBg
                    border.color: rootFinancial.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20

                        Item {
                            width: parent.width
                            height: 24

                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                text: "Revenue vs Expenses (Annual)"
                                font.pixelSize: 15
                                font.bold: true
                                color: rootFinancial.colorTextDark
                            }

                            Row {
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 16

                                Row {
                                    spacing: 6
                                    Rectangle { width: 10; height: 10; radius: 3; color: rootFinancial.colorPrimary; anchors.verticalCenter: parent.verticalCenter }
                                    Text { text: "Revenue"; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                                }
                                Row {
                                    spacing: 6
                                    Rectangle { width: 10; height: 10; radius: 3; color: "#cbd5e1"; anchors.verticalCenter: parent.verticalCenter }
                                    Text { text: "Expenses"; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                                }
                            }
                        }

                        Item {
                            width: parent.width
                            height: parent.height - 50

                            Row {
                                anchors.fill: parent

                                Repeater {
                                    model: rootFinancial.monthlyData

                                    Item {
                                        width: parent.width / 12
                                        height: parent.height

                                        Item {
                                            anchors.top: parent.top
                                            anchors.bottom: lblMonth.top
                                            anchors.bottomMargin: 8
                                            width: parent.width

                                            Item {
                                                width: 18
                                                height: parent.height
                                                anchors.horizontalCenter: parent.horizontalCenter

                                                Rectangle {
                                                    width: 7
                                                    height: Math.max(4, (modelData.revenue / 75) * parent.height)
                                                    radius: 3
                                                    color: rootFinancial.colorPrimary
                                                    anchors.bottom: parent.bottom
                                                    anchors.left: parent.left
                                                }

                                                Rectangle {
                                                    width: 7
                                                    height: Math.max(4, (modelData.expense / 75) * parent.height)
                                                    radius: 3
                                                    color: "#cbd5e1"
                                                    anchors.bottom: parent.bottom
                                                    anchors.right: parent.right
                                                }
                                            }
                                        }

                                        Text {
                                            id: lblMonth
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            text: modelData.month
                                            font.pixelSize: 11
                                            color: rootFinancial.colorTextMuted
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: (parent.width - 16) * 0.35
                    height: parent.height
                    radius: 12
                    color: rootFinancial.colorCardBg
                    border.color: rootFinancial.colorBorder

                    Column {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20

                        Text {
                            text: "Revenue Breakdown"
                            font.pixelSize: 15
                            font.bold: true
                            color: rootFinancial.colorTextDark
                        }

                        Column {
                            width: parent.width
                            spacing: 18

                            Repeater {
                                model: rootFinancial.revenueStreams

                                Column {
                                    width: parent.width
                                    spacing: 6

                                    Item {
                                        width: parent.width
                                        height: 18

                                        Text {
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: modelData.title
                                            font.pixelSize: 12
                                            font.bold: true
                                            color: rootFinancial.colorTextDark
                                        }

                                        Text {
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: modelData.amount + " (" + modelData.percent + "%)"
                                            font.pixelSize: 12
                                            color: rootFinancial.colorTextMuted
                                        }
                                    }

                                    Rectangle {
                                        width: parent.width
                                        height: 8
                                        radius: 4
                                        color: "#f1f5f9"

                                        Rectangle {
                                            width: (modelData.percent / 100) * parent.width
                                            height: parent.height
                                            radius: 4
                                            color: modelData.color
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
                height: 380
                radius: 12
                color: rootFinancial.colorCardBg
                border.color: rootFinancial.colorBorder
                clip: true

                Column {
                    anchors.fill: parent

                    Item {
                        width: parent.width
                        height: 52

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Recent Transactions"
                            font.pixelSize: 15
                            font.bold: true
                            color: rootFinancial.colorTextDark
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: rootFinancial.colorBorder
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 40
                        color: "#f8fafc"

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20
                            spacing: 12

                            Text { width: 100; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "TX ID"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 170; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Member / Payee"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 190; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Description"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 120; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Method"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 120; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Date"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 110; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Amount"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                            Text { width: 90; height: parent.height; verticalAlignment: Text.AlignVCenter; text: "Status"; font.bold: true; font.pixelSize: 12; color: rootFinancial.colorTextMuted }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: rootFinancial.colorBorder
                        }
                    }

                    ListView {
                        width: parent.width
                        height: parent.height - 92
                        clip: true
                        model: rootFinancial.recentTransactions

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 48
                            color: txHover.containsMouse ? "#f8fafc" : "#ffffff"

                            MouseArea {
                                id: txHover
                                anchors.fill: parent
                                hoverEnabled: true
                            }

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 20
                                anchors.rightMargin: 20
                                spacing: 12

                                Text { width: 100; height: parent.height; verticalAlignment: Text.AlignVCenter; text: modelData.id; font.pixelSize: 12; font.bold: true; color: rootFinancial.colorPrimary }
                                Text { width: 170; height: parent.height; verticalAlignment: Text.AlignVCenter; text: modelData.member; font.pixelSize: 13; font.bold: true; color: rootFinancial.colorTextDark }
                                Text { width: 190; height: parent.height; verticalAlignment: Text.AlignVCenter; text: modelData.type; font.pixelSize: 12; color: rootFinancial.colorTextMuted; elide: Text.ElideRight }
                                Text { width: 120; height: parent.height; verticalAlignment: Text.AlignVCenter; text: modelData.method; font.pixelSize: 12; color: rootFinancial.colorTextDark }
                                Text { width: 120; height: parent.height; verticalAlignment: Text.AlignVCenter; text: modelData.date; font.pixelSize: 12; color: rootFinancial.colorTextMuted }

                                Text {
                                    width: 110
                                    height: parent.height
                                    verticalAlignment: Text.AlignVCenter
                                    text: modelData.amount
                                    font.pixelSize: 13
                                    font.bold: true
                                    color: modelData.status === "Expense" ? rootFinancial.colorDanger : rootFinancial.colorSuccess
                                }

                                Item {
                                    width: 90
                                    height: parent.height

                                    Rectangle {
                                        width: 80
                                        height: 22
                                        radius: 6
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: modelData.status === "Completed" ? "#ecfdf5" :
                                               modelData.status === "Expense" ? "#fef2f2" : "#fffbeb"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.status
                                            font.pixelSize: 11
                                            font.bold: true
                                            color: modelData.status === "Completed" ? rootFinancial.colorSuccess :
                                                   modelData.status === "Expense" ? rootFinancial.colorDanger : rootFinancial.colorWarning
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: rootFinancial.colorBorder
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 998
        visible: rootFinancial.periodMenuOpen
        onClicked: rootFinancial.periodMenuOpen = false
    }

    Rectangle {
        id: globalPeriodMenu
        z: 999
        visible: rootFinancial.periodMenuOpen
        width: periodBtn.width
        height: rootFinancial.periodOptions.length * 36 + 8
        radius: 8
        color: rootFinancial.colorCardBg
        border.color: rootFinancial.colorBorder

        x: rootFinancial.menuTargetX
        y: rootFinancial.menuTargetY

        Column {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 0

            Repeater {
                model: rootFinancial.periodOptions

                Rectangle {
                    width: parent.width
                    height: 36
                    radius: 6
                    color: optArea.containsMouse ? "#f8fafc" :
                           (rootFinancial.selectedPeriod === modelData ? "#eff6ff" : "transparent")

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData
                        font.pixelSize: 12
                        font.bold: rootFinancial.selectedPeriod === modelData
                        color: rootFinancial.selectedPeriod === modelData ? rootFinancial.colorPrimary : rootFinancial.colorTextDark
                    }

                    MouseArea {
                        id: optArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            rootFinancial.selectedPeriod = modelData
                            rootFinancial.periodMenuOpen = false
                        }
                    }
                }
            }
        }
    }
}
