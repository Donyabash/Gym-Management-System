import QtQuick 2.12

Item {
    id: rootSettings
    clip: true

    implicitWidth: 1000
    implicitHeight: 700

    // Signals
    signal settingsSaved(var settingsData)
    signal backupRequested()
    signal resetDefaultsRequested()

    // Theme Colors
    readonly property color colorBg: "#f8fafc"
    readonly property color colorCardBg: "#ffffff"
    readonly property color colorBorder: "#e2e8f0"
    readonly property color colorTextDark: "#0f172a"
    readonly property color colorTextMuted: "#64748b"
    readonly property color colorPrimary: "#0284c7"
    readonly property color colorSuccess: "#10b981"
    readonly property color colorDanger: "#ef4444"

    // Settings State Properties
    property string gymName: "IronFit Health & Gym Club"
    property string gymEmail: "support@ironfitclub.com"
    property string gymPhone: "+1 (555) 234-5678"
    property string currencySymbol: "$"
    property string invoicePrefix: "INV-"
    property int taxRate: 9
    property bool notifyExpiry: true
    property bool notifyPayment: true
    property bool autoRenew: false

    Rectangle {
        anchors.fill: parent
        color: rootSettings.colorBg
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: colContent.height + 60
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: colContent
            width: Math.max(parent.width - 64, 500)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 28
            spacing: 24

            // Header Toolbar
            Item {
                width: parent.width
                height: 48

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 4

                    Text {
                        text: "System Settings"
                        font.pixelSize: 22
                        font.bold: true
                        color: rootSettings.colorTextDark
                    }
                    Text {
                        text: "Configure club profile, billing defaults, notifications, and preferences"
                        font.pixelSize: 13
                        color: rootSettings.colorTextMuted
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 12

                    // Reset Button
                    Rectangle {
                        width: 120
                        height: 38
                        radius: 8
                        color: btnResetMouse.containsMouse ? "#f1f5f9" : "#ffffff"
                        border.color: rootSettings.colorBorder

                        Text {
                            anchors.centerIn: parent
                            text: "Reset Defaults"
                            font.pixelSize: 12
                            font.bold: true
                            color: rootSettings.colorTextMuted
                        }

                        MouseArea {
                            id: btnResetMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootSettings.resetDefaultsRequested()
                        }
                    }

                    // Save Button
                    Rectangle {
                        width: 130
                        height: 38
                        radius: 8
                        color: btnSaveMouse.pressed ? Qt.darker(rootSettings.colorPrimary, 1.15) :
                               btnSaveMouse.containsMouse ? Qt.lighter(rootSettings.colorPrimary, 1.1) : rootSettings.colorPrimary

                        Text {
                            anchors.centerIn: parent
                            text: "Save Changes"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }

                        MouseArea {
                            id: btnSaveMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var payload = {
                                    gymName: txtGymName.text,
                                    gymEmail: txtGymEmail.text,
                                    gymPhone: txtGymPhone.text,
                                    currency: txtCurrency.text,
                                    invoicePrefix: txtInvoicePrefix.text,
                                    taxRate: parseInt(txtTaxRate.text) || 0,
                                    notifyExpiry: switchExpiry.checked,
                                    notifyPayment: switchPayment.checked,
                                    autoRenew: switchAutoRenew.checked
                                }
                                rootSettings.settingsSaved(payload)
                                toastSaved.showToast()
                            }
                        }
                    }
                }
            }

            // Section 1: Gym Profile
            Rectangle {
                width: parent.width
                height: colProfile.height + 40
                radius: 12
                color: rootSettings.colorCardBg
                border.color: rootSettings.colorBorder

                Column {
                    id: colProfile
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "Club & Business Profile"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootSettings.colorTextDark
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootSettings.colorBorder
                    }

                    Row {
                        width: parent.width
                        spacing: 16

                        // Club Name
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Club Name"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtGymName
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.gymName
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }

                        // Support Email
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Business Email"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtGymEmail
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.gymEmail
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }
                    }

                    Row {
                        width: parent.width
                        spacing: 16

                        // Phone Number
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Contact Phone"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtGymPhone
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.gymPhone
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }

                        // Currency
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Currency Symbol"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtCurrency
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.currencySymbol
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }

            // Section 2: Financial & Invoicing Defaults
            Rectangle {
                width: parent.width
                height: colFinance.height + 40
                radius: 12
                color: rootSettings.colorCardBg
                border.color: rootSettings.colorBorder

                Column {
                    id: colFinance
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 16

                    Text {
                        text: "Invoicing & Tax Settings"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootSettings.colorTextDark
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootSettings.colorBorder
                    }

                    Row {
                        width: parent.width
                        spacing: 16

                        // Invoice Prefix
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Invoice Prefix"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtInvoicePrefix
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.invoicePrefix
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }

                        // Default Tax Rate
                        Column {
                            width: (parent.width - 16) / 2
                            spacing: 6
                            Text { text: "Default Tax Rate (%)"; font.pixelSize: 12; font.bold: true; color: rootSettings.colorTextMuted }
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                border.color: rootSettings.colorBorder
                                TextInput {
                                    id: txtTaxRate
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    font.pixelSize: 13
                                    text: rootSettings.taxRate.toString()
                                    color: rootSettings.colorTextDark
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }
                    }
                }
            }

            // Section 3: Automated Notifications & Toggles
            Rectangle {
                width: parent.width
                height: colNotifications.height + 40
                radius: 12
                color: rootSettings.colorCardBg
                border.color: rootSettings.colorBorder

                Column {
                    id: colNotifications
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20
                    spacing: 18

                    Text {
                        text: "Automations & Alerts"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootSettings.colorTextDark
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootSettings.colorBorder
                    }

                    // Toggle 1: Plan Expiry Alert
                    Item {
                        width: parent.width
                        height: 40

                        Column {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "Membership Expiration Reminders"; font.pixelSize: 13; font.bold: true; color: rootSettings.colorTextDark }
                            Text { text: "Send automated notification 3 days prior to plan expiration"; font.pixelSize: 11; color: rootSettings.colorTextMuted }
                        }

                        Rectangle {
                            id: switchExpiry
                            property bool checked: rootSettings.notifyExpiry
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 44
                            height: 24
                            radius: 12
                            color: checked ? rootSettings.colorPrimary : "#cbd5e1"

                            Rectangle {
                                width: 18
                                height: 18
                                radius: 9
                                color: "#ffffff"
                                anchors.verticalCenter: parent.verticalCenter
                                x: parent.checked ? parent.width - width - 3 : 3

                                Behavior on x { NumberAnimation { duration: 150 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Toggle 2: Payment Receipt
                    Item {
                        width: parent.width
                        height: 40

                        Column {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "Automated Payment Receipts"; font.pixelSize: 13; font.bold: true; color: rootSettings.colorTextDark }
                            Text { text: "Issue digital invoice receipts upon transaction completion"; font.pixelSize: 11; color: rootSettings.colorTextMuted }
                        }

                        Rectangle {
                            id: switchPayment
                            property bool checked: rootSettings.notifyPayment
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 44
                            height: 24
                            radius: 12
                            color: checked ? rootSettings.colorPrimary : "#cbd5e1"

                            Rectangle {
                                width: 18
                                height: 18
                                radius: 9
                                color: "#ffffff"
                                anchors.verticalCenter: parent.verticalCenter
                                x: parent.checked ? parent.width - width - 3 : 3

                                Behavior on x { NumberAnimation { duration: 150 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }

                    // Toggle 3: Auto-Renew
                    Item {
                        width: parent.width
                        height: 40

                        Column {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2
                            Text { text: "Default Auto-Renewal"; font.pixelSize: 13; font.bold: true; color: rootSettings.colorTextDark }
                            Text { text: "Enable recurring plan renewals for new members by default"; font.pixelSize: 11; color: rootSettings.colorTextMuted }
                        }

                        Rectangle {
                            id: switchAutoRenew
                            property bool checked: rootSettings.autoRenew
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 44
                            height: 24
                            radius: 12
                            color: checked ? rootSettings.colorPrimary : "#cbd5e1"

                            Rectangle {
                                width: 18
                                height: 18
                                radius: 9
                                color: "#ffffff"
                                anchors.verticalCenter: parent.verticalCenter
                                x: parent.checked ? parent.width - width - 3 : 3

                                Behavior on x { NumberAnimation { duration: 150 } }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: parent.checked = !parent.checked
                            }
                        }
                    }
                }
            }

            // Section 4: Data Management & Backup
            Rectangle {
                width: parent.width
                height: 90
                radius: 12
                color: rootSettings.colorCardBg
                border.color: rootSettings.colorBorder

                Item {
                    anchors.fill: parent
                    anchors.margins: 20

                    Column {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Text {
                            text: "Database Backup & Export"
                            font.pixelSize: 14
                            font.bold: true
                            color: rootSettings.colorTextDark
                        }
                        Text {
                            text: "Download an offline JSON/SQL backup copy of plans and financial transactions"
                            font.pixelSize: 11
                            color: rootSettings.colorTextMuted
                        }
                    }

                    Rectangle {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: 130
                        height: 36
                        radius: 8
                        color: btnBackupMouse.containsMouse ? "#f1f5f9" : "#ffffff"
                        border.color: rootSettings.colorBorder

                        Row {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: "📥"
                                font.pixelSize: 12
                            }
                            Text {
                                text: "Export Backup"
                                font.pixelSize: 12
                                font.bold: true
                                color: rootSettings.colorTextDark
                            }
                        }

                        MouseArea {
                            id: btnBackupMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootSettings.backupRequested()
                        }
                    }
                }
            }
        }
    }

    // Success Toast Notification
    Rectangle {
        id: toastSaved
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        width: 260
        height: 42
        radius: 21
        color: "#0f172a"
        opacity: 0
        visible: opacity > 0
        z: 99

        function showToast() {
            toastAnim.restart()
        }

        Row {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: "✓"
                color: rootSettings.colorSuccess
                font.bold: true
                font.pixelSize: 13
            }
            Text {
                text: "Settings saved successfully"
                color: "#ffffff"
                font.pixelSize: 12
                font.bold: true
            }
        }

        SequentialAnimation {
            id: toastAnim
            NumberAnimation { target: toastSaved; property: "opacity"; to: 1; duration: 200 }
            PauseAnimation { duration: 1800 }
            NumberAnimation { target: toastSaved; property: "opacity"; to: 0; duration: 200 }
        }
    }
}
