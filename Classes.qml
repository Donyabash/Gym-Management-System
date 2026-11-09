import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
    id: rootClasses
    clip: true

    implicitWidth: 1000
    implicitHeight: 700


    signal createClassRequested(var classData)
    signal editClassRequested(int classId)
    signal deleteClassRequested(int classId)
    signal addTrainerRequested()


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


    property string activeDayFilter: "All"


    property var trainersModel: [
        { id: 1, name: "Reza Farhadi", specialty: "CrossFit & HIIT", activeClasses: 4, status: "Active", rating: "4.9" },
        { id: 2, name: "Sara Mohammadi", specialty: "Pilates & Core", activeClasses: 3, status: "Active", rating: "5.0" },
        { id: 3, name: "Kaveh Rad", specialty: "Bodybuilding", activeClasses: 5, status: "Active", rating: "4.8" },
        { id: 4, name: "Mina Tabrizi", specialty: "Yoga & Mobility", activeClasses: 2, status: "Active", rating: "4.9" }
    ]


    property var classesModel: [
        {
            id: 201,
            title: "Morning High-Intensity CrossFit",
            trainer: "Reza Farhadi",
            schedule: "Mon, Wed, Fri • 07:30 - 08:30",
            days: ["Mon", "Wed", "Fri"],
            location: "Studio 1 (Main Hall)",
            enrolled: 18,
            capacity: 20,
            price: "$15/session",
            colorTag: "#0284c7"
        },
        {
            id: 202,
            title: "Advanced Core Pilates",
            trainer: "Sara Mohammadi",
            schedule: "Tue, Thu • 17:00 - 18:00",
            days: ["Tue", "Thu"],
            location: "Studio 2 (Mat Room)",
            enrolled: 12,
            capacity: 12,
            price: "$18/session",
            colorTag: "#8b5cf6"
        },
        {
            id: 203,
            title: "Strength & Hypertrophy Camp",
            trainer: "Kaveh Rad",
            schedule: "Mon, Wed • 19:00 - 20:30",
            days: ["Mon", "Wed"],
            location: "Weight Lifting Zone",
            enrolled: 14,
            capacity: 16,
            price: "$20/session",
            colorTag: "#f59e0b"
        },
        {
            id: 204,
            title: "Evening Restorative Yoga",
            trainer: "Mina Tabrizi",
            schedule: "Sun, Tue • 18:30 - 19:30",
            days: ["Sun", "Tue"],
            location: "Studio 2 (Mat Room)",
            enrolled: 8,
            capacity: 15,
            price: "$12/session",
            colorTag: "#10b981"
        }
    ]

    Rectangle {
        anchors.fill: parent
        color: rootClasses.colorBg
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
            width: Math.max(parent.width - 64, 500)
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
                        text: "Classes & Trainers Management"
                        font.pixelSize: 22
                        font.bold: true
                        color: rootClasses.colorTextDark
                    }
                    Text {
                        text: "Schedule training sessions, monitor capacity, and manage fitness coaches"
                        font.pixelSize: 13
                        color: rootClasses.colorTextMuted
                    }
                }

                Rectangle {
                    width: 140
                    height: 38
                    radius: 8
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: btnAddClassMouse.pressed ? Qt.darker(rootClasses.colorPrimary, 1.15) :
                           btnAddClassMouse.containsMouse ? Qt.lighter(rootClasses.colorPrimary, 1.1) : rootClasses.colorPrimary

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            text: "+"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#ffffff"
                        }
                        Text {
                            text: "Schedule Class"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                        }
                    }

                    MouseArea {
                        id: btnAddClassMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modalCreateClass.openModal()
                    }
                }
            }


            Column {
                width: parent.width
                spacing: 12

                RowLayout {
                    width: parent.width
                    Text {
                        text: "Coaches & Trainers"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootClasses.colorTextDark
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: rootClasses.trainersModel.length + " Total Coaches"
                        font.pixelSize: 12
                        color: rootClasses.colorTextMuted
                    }
                }

                Row {
                    width: parent.width
                    spacing: 16

                    Repeater {
                        model: rootClasses.trainersModel

                        Rectangle {
                            width: (mainCol.width - 48) / 4
                            height: 110
                            radius: 12
                            color: rootClasses.colorCardBg
                            border.color: rootClasses.colorBorder

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
                                        radius: 18
                                        color: "#e0f2fe"

                                        Text {
                                            anchors.centerIn: parent
                                            text: modelData.name.charAt(0)
                                            font.pixelSize: 14
                                            font.bold: true
                                            color: rootClasses.colorPrimary
                                        }
                                    }

                                    Column {
                                        width: parent.width - 46
                                        spacing: 2

                                        Text {
                                            text: modelData.name
                                            font.pixelSize: 13
                                            font.bold: true
                                            color: rootClasses.colorTextDark
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: modelData.specialty
                                            font.pixelSize: 11
                                            color: rootClasses.colorTextMuted
                                            elide: Text.ElideRight
                                        }
                                    }
                                }

                                Row {
                                    anchors.bottom: parent.bottom
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    height: 20

                                    Text {
                                        anchors.left: parent.left
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "★ " + modelData.rating
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: rootClasses.colorWarning
                                    }

                                    Text {
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.activeClasses + " active classes"
                                        font.pixelSize: 11
                                        color: rootClasses.colorTextMuted
                                    }
                                }
                            }
                        }
                    }
                }
            }


            Rectangle {
                width: parent.width
                height: colSchedule.height + 40
                radius: 12
                color: rootClasses.colorCardBg
                border.color: rootClasses.colorBorder

                Column {
                    id: colSchedule
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
                            text: "Current Scheduled Classes"
                            font.pixelSize: 16
                            font.bold: true
                            color: rootClasses.colorTextDark
                        }


                        Row {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 6

                            Repeater {
                                model: ["All", "Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"]

                                Rectangle {
                                    width: 42
                                    height: 26
                                    radius: 6
                                    color: rootClasses.activeDayFilter === modelData ? rootClasses.colorPrimary : "#f1f5f9"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: rootClasses.activeDayFilter === modelData ? "#ffffff" : rootClasses.colorTextMuted
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: rootClasses.activeDayFilter = modelData
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: rootClasses.colorBorder
                    }


                    Column {
                        width: parent.width
                        spacing: 10

                        Repeater {
                            model: rootClasses.classesModel

                            Rectangle {
                                width: parent.width
                                height: 76
                                radius: 8
                                color: "#f8fafc"
                                border.color: rootClasses.colorBorder
                                visible: rootClasses.activeDayFilter === "All" || modelData.days.indexOf(rootClasses.activeDayFilter) !== -1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 14
                                    spacing: 16

                                    // Color Tag & Details
                                    Row {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: 44
                                        spacing: 14

                                        Rectangle {
                                            width: 4
                                            height: 44
                                            radius: 2
                                            color: modelData.colorTag
                                            anchors.verticalCenter: parent.verticalCenter
                                        }

                                        Column {
                                            anchors.verticalCenter: parent.verticalCenter
                                            spacing: 4
                                            width: parent.width - 20

                                            Text {
                                                text: modelData.title
                                                font.pixelSize: 14
                                                font.bold: true
                                                color: rootClasses.colorTextDark
                                                elide: Text.ElideRight
                                            }
                                            Row {
                                                spacing: 12
                                                Text {
                                                    text: "⏰ " + modelData.schedule
                                                    font.pixelSize: 11
                                                    color: rootClasses.colorTextMuted
                                                }
                                                Text {
                                                    text: "📍 " + modelData.location
                                                    font.pixelSize: 11
                                                    color: rootClasses.colorTextMuted
                                                }
                                            }
                                        }
                                    }


                                    Column {
                                        Layout.preferredWidth: 160
                                        spacing: 4

                                        Text {
                                            text: "Coach: " + modelData.trainer
                                            font.pixelSize: 12
                                            font.bold: true
                                            color: rootClasses.colorTextDark
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: modelData.price
                                            font.pixelSize: 11
                                            color: rootClasses.colorSuccess
                                            font.bold: true
                                        }
                                    }


                                    Column {
                                        Layout.preferredWidth: 130
                                        spacing: 4

                                        RowLayout {
                                            width: parent.width
                                            Text {
                                                text: "Enrolled"
                                                font.pixelSize: 11
                                                color: rootClasses.colorTextMuted
                                            }
                                            Item { Layout.fillWidth: true }
                                            Text {
                                                text: modelData.enrolled + "/" + modelData.capacity
                                                font.pixelSize: 11
                                                font.bold: true
                                                color: modelData.enrolled >= modelData.capacity ? rootClasses.colorDanger : rootClasses.colorTextDark
                                            }
                                        }

                                        Rectangle {
                                            width: parent.width
                                            height: 6
                                            radius: 3
                                            color: "#e2e8f0"

                                            Rectangle {
                                                width: Math.min(parent.width, (modelData.enrolled / modelData.capacity) * parent.width)
                                                height: parent.height
                                                radius: 3
                                                color: modelData.enrolled >= modelData.capacity ? rootClasses.colorDanger : rootClasses.colorPrimary
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
        id: modalCreateClass
        anchors.fill: parent
        color: "#80000000"
        visible: opacity > 0
        opacity: 0
        z: 99

        function openModal() {
            modalCreateClass.opacity = 1
        }

        function closeModal() {
            modalCreateClass.opacity = 0
        }

        Behavior on opacity { NumberAnimation { duration: 180 } }

        MouseArea {
            anchors.fill: parent
            onClicked: modalCreateClass.closeModal()
        }

        Rectangle {
            id: modalBox
            width: 480
            height: 430
            radius: 12
            color: "#ffffff"
            anchors.centerIn: parent

            MouseArea {
                anchors.fill: parent
            }

            Column {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                RowLayout {
                    width: parent.width
                    Text {
                        text: "Schedule New Class"
                        font.pixelSize: 16
                        font.bold: true
                        color: rootClasses.colorTextDark
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: "✕"
                        font.pixelSize: 14
                        color: rootClasses.colorTextMuted
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modalCreateClass.closeModal()
                        }
                    }
                }

                Rectangle { width: parent.width; height: 1; color: rootClasses.colorBorder }


                Column {
                    width: parent.width
                    spacing: 6
                    Text { text: "Class Title"; font.pixelSize: 12; font.bold: true; color: rootClasses.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 38
                        radius: 6
                        border.color: rootClasses.colorBorder
                        TextInput {
                            id: txtClassName
                            anchors.fill: parent
                            anchors.margins: 10
                            font.pixelSize: 13
                            text: "Spin & Cardio Blast"
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (parent.width - 12) * 0.65
                        spacing: 6
                        Text { text: "Coach Name"; font.pixelSize: 12; font.bold: true; color: rootClasses.colorTextMuted }
                        Rectangle {
                            width: parent.width
                            height: 38
                            radius: 6
                            border.color: rootClasses.colorBorder
                            TextInput {
                                id: txtTrainerName
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 13
                                text: "Reza Farhadi"
                                verticalAlignment: TextInput.AlignVCenter
                            }
                        }
                    }

                    Column {
                        width: (parent.width - 12) * 0.35
                        spacing: 6
                        Text { text: "Max Capacity"; font.pixelSize: 12; font.bold: true; color: rootClasses.colorTextMuted }
                        Rectangle {
                            width: parent.width
                            height: 38
                            radius: 6
                            border.color: rootClasses.colorBorder
                            TextInput {
                                id: txtCapacity
                                anchors.fill: parent
                                anchors.margins: 10
                                font.pixelSize: 13
                                text: "15"
                                verticalAlignment: TextInput.AlignVCenter
                            }
                        }
                    }
                }


                Column {
                    width: parent.width
                    spacing: 6
                    Text { text: "Time & Frequency"; font.pixelSize: 12; font.bold: true; color: rootClasses.colorTextMuted }
                    Rectangle {
                        width: parent.width
                        height: 38
                        radius: 6
                        border.color: rootClasses.colorBorder
                        TextInput {
                            id: txtSchedule
                            anchors.fill: parent
                            anchors.margins: 10
                            font.pixelSize: 13
                            text: "Sat, Mon, Wed • 18:00 - 19:30"
                            verticalAlignment: TextInput.AlignVCenter
                        }
                    }
                }


                Row {
                    anchors.right: parent.right
                    spacing: 10
                    topPadding: 10

                    Rectangle {
                        width: 90
                        height: 36
                        radius: 6
                        color: "#f1f5f9"
                        Text { anchors.centerIn: parent; text: "Cancel"; font.pixelSize: 12; color: rootClasses.colorTextMuted }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: modalCreateClass.closeModal()
                        }
                    }

                    Rectangle {
                        width: 120
                        height: 36
                        radius: 6
                        color: rootClasses.colorPrimary
                        Text { anchors.centerIn: parent; text: "Save Class"; font.pixelSize: 12; font.bold: true; color: "#ffffff" }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var payload = {
                                    title: txtClassName.text,
                                    trainer: txtTrainerName.text,
                                    capacity: parseInt(txtCapacity.text) || 10,
                                    schedule: txtSchedule.text
                                }
                                rootClasses.createClassRequested(payload)
                                modalCreateClass.closeModal()
                            }
                        }
                    }
                }
            }
        }
    }
}
