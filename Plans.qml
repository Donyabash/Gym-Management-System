import QtQuick 2.12
import QtQuick.Layouts 1.12
Item {
    id: rootPlans
    clip: true

    implicitWidth: 1000
    implicitHeight: 700


    signal planCreated(string name, real basePrice, int discountPercent, int durationDays)
    signal planUpdated(int planId, string name, real basePrice, int discountPercent, int durationDays)
    signal planDeleted(int planId)


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

    property var editingPlan: null
    property var planToDelete: null
    property bool isCreatingMode: false

    property var plansModel: [
        {
            id: 1,
            name: "Basic Starter",
            duration: "30 Days",
            durationDays: 30,
            basePrice: 45.0,
            discountPercent: 0,
            activeMembers: 142,
            isPopular: false,
            features: ["Gym floor access", "Locker room", "Free water refills"]
        },
        {
            id: 2,
            name: "Pro Athlete",
            duration: "90 Days",
            durationDays: 90,
            basePrice: 120.0,
            discountPercent: 15,
            activeMembers: 310,
            isPopular: true,
            features: ["All Gym access", "Sauna & Jacuzzi", "2 PT Consultation", "Locker included"]
        },
        {
            id: 3,
            name: "VIP Elite",
            duration: "365 Days",
            durationDays: 365,
            basePrice: 450.0,
            discountPercent: 20,
            activeMembers: 84,
            isPopular: false,
            features: ["Unlimited 24/7 access", "Dedicated VIP Locker", "Free Towel Service", "Unlimited Sauna/Pool", "Monthly body composition"]
        },
        {
            id: 4,
            name: "Weekend Warrior",
            duration: "30 Days",
            durationDays: 30,
            basePrice: 30.0,
            discountPercent: 5,
            activeMembers: 65,
            isPopular: false,
            features: ["Thu & Fri Full Access", "Standard Locker", "Shower Access"]
        }
    ]

    function calculateFinalPrice(base, discount) {
        if (discount <= 0) return Number(base).toFixed(2);
        return (base - (base * (discount / 100.0))).toFixed(2);
    }

    function removePlanById(id) {
        var updated = []
        for (var i = 0; i < rootPlans.plansModel.length; i++) {
            if (rootPlans.plansModel[i].id !== id) {
                updated.push(rootPlans.plansModel[i])
            }
        }
        rootPlans.plansModel = updated
        rootPlans.planDeleted(id)
    }

    Rectangle {
        anchors.fill: parent
        color: rootPlans.colorBg
    }

    Flickable {
        id: mainFlick
        anchors.fill: parent
        contentWidth: width
        contentHeight: colContent.height + 40
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: colContent
            width: Math.max(parent.width - 48, 380)
            anchors.horizontalCenter: parent.horizontalCenter
            y: 20
            spacing: 18


            Item {
                width: parent.width
                height: 42

                Column {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: "Membership Plans"
                        font.pixelSize: 20
                        font.bold: true
                        color: rootPlans.colorTextDark
                    }
                    Text {
                        text: "Manage membership tiers, configure pricing, and apply seasonal discounts"
                        font.pixelSize: 12
                        color: rootPlans.colorTextMuted
                    }
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 130
                    height: 34
                    radius: 7
                    color: btnNewMouse.pressed ? Qt.darker(rootPlans.colorPrimary, 1.15) :
                           btnNewMouse.containsMouse ? Qt.lighter(rootPlans.colorPrimary, 1.1) : rootPlans.colorPrimary

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            text: "+"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Text {
                            text: "Create Plan"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }
                    }

                    MouseArea {
                        id: btnNewMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            rootPlans.isCreatingMode = true
                            rootPlans.editingPlan = null
                            txtEditName.text = ""
                            txtEditPrice.text = ""
                            txtEditDiscount.text = "0"
                            txtEditDuration.text = "30"
                            editModal.visible = true
                        }
                    }
                }
            }


            Row {
                width: parent.width
                spacing: 12

                Repeater {
                    model: [
                        { label: "Total Active Plans", value: rootPlans.plansModel.length.toString(), color: rootPlans.colorPrimary },
                        { label: "Active Subscribers", value: "601 Members", color: rootPlans.colorSuccess },
                        { label: "Discounted Plans", value: "3 Active Offers", color: rootPlans.colorWarning }
                    ]

                    Rectangle {
                        width: (colContent.width - 24) / 3
                        height: 72
                        radius: 10
                        color: rootPlans.colorCardBg
                        border.color: rootPlans.colorBorder

                        Column {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 4

                            Text {
                                text: modelData.label
                                font.pixelSize: 12
                                font.bold: true
                                color: rootPlans.colorTextMuted
                            }
                            Text {
                                text: modelData.value
                                font.pixelSize: 17
                                font.bold: true
                                color: modelData.color
                            }
                        }
                    }
                }
            }


            Flow {
                width: parent.width
                spacing: 14

                readonly property int columnsCount: colContent.width >= 960 ? 3 : 2
                readonly property real cardCalculatedWidth: (colContent.width - ((columnsCount - 1) * spacing)) / columnsCount

                Repeater {
                    model: rootPlans.plansModel

                    Rectangle {
                        id: planCard
                        width: parent.cardCalculatedWidth
                        height: 270
                        radius: 10
                        color: rootPlans.colorCardBg
                        border.color: modelData.isPopular ? rootPlans.colorPrimary : rootPlans.colorBorder
                        border.width: modelData.isPopular ? 2 : 1


                        Rectangle {
                            visible: modelData.isPopular
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.topMargin: 10
                            anchors.rightMargin: 10
                            height: 22
                            width: 90
                            radius: 5
                            color: "#e0f2fe"

                            Text {
                                anchors.centerIn: parent
                                text: "Most Popular"
                                font.pixelSize: 12
                                font.bold: true
                                color: rootPlans.colorPrimary
                            }
                        }

                        Item {
                            anchors.fill: parent
                            anchors.margins: 14

                            Column {
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 10

                                Column {
                                    spacing: 3
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: 15
                                        font.bold: true
                                        color: rootPlans.colorTextDark
                                        elide: Text.ElideRight
                                        width: modelData.isPopular ? parent.width - 94 : parent.width
                                    }

                                    Row {
                                        spacing: 6
                                        Text {
                                            text: "Validity: " + modelData.duration
                                            font.pixelSize: 12
                                            color: rootPlans.colorTextMuted
                                        }
                                        Text {
                                            text: "•"
                                            font.pixelSize: 12
                                            color: rootPlans.colorTextMuted
                                        }
                                        Text {
                                            text: modelData.activeMembers + " Subscribed"
                                            font.pixelSize: 12
                                            font.bold: true
                                            color: rootPlans.colorSuccess
                                        }
                                    }
                                }

                                Row {
                                    spacing: 6
                                    Text {
                                        text: "$" + rootPlans.calculateFinalPrice(modelData.basePrice, modelData.discountPercent)
                                        font.pixelSize: 21
                                        font.bold: true
                                        color: rootPlans.colorTextDark
                                    }

                                    Column {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: modelData.discountPercent > 0
                                        spacing: 1

                                        Text {
                                            text: "$" + Number(modelData.basePrice).toFixed(2)
                                            font.pixelSize: 12
                                            font.strikeout: true
                                            color: rootPlans.colorTextMuted
                                        }

                                        Rectangle {
                                            height: 18
                                            width: 56
                                            radius: 3
                                            color: "#fef3c7"

                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData.discountPercent + "% OFF"
                                                font.pixelSize: 12
                                                font.bold: true
                                                color: rootPlans.colorWarning
                                            }
                                        }
                                    }
                                }

                                Rectangle {
                                    width: parent.width
                                    height: 1
                                    color: rootPlans.colorBorder
                                }

                                Column {
                                    width: parent.width
                                    spacing: 4

                                    Repeater {
                                        model: modelData.features.slice(0, 3)

                                        Row {
                                            spacing: 6
                                            Text {
                                                text: "✓"
                                                font.pixelSize: 12
                                                font.bold: true
                                                color: rootPlans.colorSuccess
                                            }
                                            Text {
                                                text: modelData
                                                font.pixelSize: 12
                                                color: rootPlans.colorTextDark
                                                elide: Text.ElideRight
                                                width: planCard.width - 50
                                            }
                                        }
                                    }
                                }
                            }


                            Row {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 32
                                spacing: 6


                                Rectangle {
                                    width: parent.width - 38
                                    height: 32
                                    radius: 6
                                    color: btnEditMouse.containsMouse ? "#f1f5f9" : "transparent"
                                    border.color: rootPlans.colorBorder

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Edit Plan & Discount"
                                        font.pixelSize: 12
                                        font.bold: true
                                        color: rootPlans.colorTextDark
                                    }

                                    MouseArea {
                                        id: btnEditMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            rootPlans.isCreatingMode = false
                                            rootPlans.editingPlan = modelData
                                            txtEditName.text = modelData.name
                                            txtEditPrice.text = modelData.basePrice.toString()
                                            txtEditDiscount.text = modelData.discountPercent.toString()
                                            txtEditDuration.text = modelData.durationDays.toString()
                                            editModal.visible = true
                                        }
                                    }
                                }


                                Rectangle {
                                    width: 32
                                    height: 32
                                    radius: 6
                                    color: btnCardDeleteMouse.containsMouse ? "#fee2e2" : "#f8fafc"
                                    border.color: btnCardDeleteMouse.containsMouse ? rootPlans.colorDanger : rootPlans.colorBorder

                                    Text {
                                        anchors.centerIn: parent
                                        text: "🗑"
                                        font.pixelSize: 13
                                        color: btnCardDeleteMouse.containsMouse ? rootPlans.colorDanger : rootPlans.colorTextMuted
                                    }

                                    MouseArea {
                                        id: btnCardDeleteMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            rootPlans.planToDelete = modelData
                                            confirmDeleteModal.visible = true
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
        id: editModal
        visible: false
        anchors.fill: parent
        color: "#660f172a"
        z: 99

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Rectangle {
            width: 420
            height: 440
            radius: 12
            color: rootPlans.colorCardBg
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                Text {
                    text: rootPlans.isCreatingMode ? "Create New Plan" : "Edit Plan Details & Discounts"
                    font.pixelSize: 16
                    font.bold: true
                    color: rootPlans.colorTextDark
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: rootPlans.colorBorder
                }


                Column {
                    width: parent.width
                    spacing: 4
                    Text { text: "Plan Name"; font.pixelSize: 12; font.bold: true; color: rootPlans.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 36
                        radius: 6
                        border.color: rootPlans.colorBorder
                        TextInput {
                            id: txtEditName
                            anchors.fill: parent
                            anchors.margins: 8
                            font.pixelSize: 12
                            color: rootPlans.colorTextDark
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Column {
                    width: parent.width
                    spacing: 4
                    Text { text: "Duration (Days)"; font.pixelSize: 12; font.bold: true; color: rootPlans.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 36
                        radius: 6
                        border.color: rootPlans.colorBorder
                        TextInput {
                            id: txtEditDuration
                            anchors.fill: parent
                            anchors.margins: 8
                            font.pixelSize: 12
                            color: rootPlans.colorTextDark
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Column {
                    width: parent.width
                    spacing: 4
                    Text { text: "Base Price ($)"; font.pixelSize: 12; font.bold: true; color: rootPlans.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 36
                        radius: 6
                        border.color: rootPlans.colorBorder
                        TextInput {
                            id: txtEditPrice
                            anchors.fill: parent
                            anchors.margins: 8
                            font.pixelSize: 12
                            color: rootPlans.colorTextDark
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Column {
                    width: parent.width
                    spacing: 4
                    Text { text: "Discount Percentage (0 - 100%)"; font.pixelSize: 12; font.bold: true; color: rootPlans.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 36
                        radius: 6
                        border.color: rootPlans.colorBorder
                        TextInput {
                            id: txtEditDiscount
                            anchors.fill: parent
                            anchors.margins: 8
                            font.pixelSize: 12
                            color: rootPlans.colorTextDark
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Item {
                    width: parent.width
                    height: 36

                    Rectangle {
                        visible: !rootPlans.isCreatingMode
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        width: 75
                        height: 36
                        radius: 6
                        color: btnModalDelMouse.containsMouse ? "#fee2e2" : "#fef2f2"
                        border.color: btnModalDelMouse.containsMouse ? rootPlans.colorDanger : "#fecaca"

                        Text {
                            anchors.centerIn: parent
                            text: "Delete"
                            font.pixelSize: 12
                            font.bold: true
                            color: rootPlans.colorDanger
                        }

                        MouseArea {
                            id: btnModalDelMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                editModal.visible = false
                                rootPlans.planToDelete = rootPlans.editingPlan
                                confirmDeleteModal.visible = true
                            }
                        }
                    }

                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Rectangle {
                            width: 80
                            height: 36
                            radius: 6
                            color: "#f1f5f9"
                            Text {
                                anchors.centerIn: parent
                                text: "Cancel"
                                font.pixelSize: 12
                                font.bold: true
                                color: rootPlans.colorTextDark
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: editModal.visible = false
                            }
                        }

                        Rectangle {
                            width: 105
                            height: 36
                            radius: 6
                            color: rootPlans.colorPrimary
                            Text {
                                anchors.centerIn: parent
                                text: rootPlans.isCreatingMode ? "Create Plan" : "Save Changes"
                                font.pixelSize: 12
                                font.bold: true
                                color: "#ffffff"
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    var name = txtEditName.text.trim()
                                    if (name === "") return

                                    var price = parseFloat(txtEditPrice.text) || 0.0
                                    var discount = parseInt(txtEditDiscount.text) || 0
                                    var duration = parseInt(txtEditDuration.text) || 30

                                    var list = []
                                    for (var i = 0; i < rootPlans.plansModel.length; i++) {
                                        list.push(rootPlans.plansModel[i])
                                    }

                                    if (rootPlans.isCreatingMode) {
                                        var newPlan = {
                                            id: Date.now(),
                                            name: name,
                                            duration: duration + " Days",
                                            durationDays: duration,
                                            basePrice: price,
                                            discountPercent: discount,
                                            activeMembers: 0,
                                            isPopular: false,
                                            features: ["Gym floor access", "Locker room"]
                                        }
                                        list.push(newPlan)
                                        rootPlans.plansModel = list
                                        rootPlans.planCreated(name, price, discount, duration)
                                    } else if (rootPlans.editingPlan) {
                                        for (var j = 0; j < list.length; j++) {
                                            if (list[j].id === rootPlans.editingPlan.id) {
                                                list[j].name = name
                                                list[j].basePrice = price
                                                list[j].discountPercent = discount
                                                list[j].durationDays = duration
                                                list[j].duration = duration + " Days"
                                                break
                                            }
                                        }
                                        rootPlans.plansModel = list
                                        rootPlans.planUpdated(rootPlans.editingPlan.id, name, price, discount, duration)
                                    }

                                    editModal.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }


    Rectangle {
        id: confirmDeleteModal
        visible: false
        anchors.fill: parent
        color: "#660f172a"
        z: 100

        MouseArea {
            anchors.fill: parent
            onClicked: {}
        }

        Rectangle {
            width: 360
            height: 175
            radius: 12
            color: rootPlans.colorCardBg
            anchors.centerIn: parent

            Column {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 12

                Text {
                    text: "Delete Membership Plan"
                    font.pixelSize: 16
                    font.bold: true
                    color: rootPlans.colorDanger
                }

                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: "Are you sure you want to delete \"" + (rootPlans.planToDelete ? rootPlans.planToDelete.name : "") + "\"? This action cannot be undone."
                    font.pixelSize: 12
                    color: rootPlans.colorTextMuted
                }

                Item {
                    width: parent.width
                    height: 6
                }

                Row {
                    anchors.right: parent.right
                    spacing: 8

                    Rectangle {
                        width: 75
                        height: 34
                        radius: 6
                        color: "#f1f5f9"

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            font.pixelSize: 12
                            font.bold: true
                            color: rootPlans.colorTextDark
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                confirmDeleteModal.visible = false
                                rootPlans.planToDelete = null
                            }
                        }
                    }

                    Rectangle {
                        width: 95
                        height: 34
                        radius: 6
                        color: rootPlans.colorDanger

                        Text {
                            anchors.centerIn: parent
                            text: "Delete Plan"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (rootPlans.planToDelete) {
                                    rootPlans.removePlanById(rootPlans.planToDelete.id)
                                    rootPlans.planToDelete = null
                                }
                                confirmDeleteModal.visible = false
                            }
                        }
                    }
                }
            }
        }
    }
}
