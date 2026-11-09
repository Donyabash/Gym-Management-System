import QtQuick 2.12

Item {
    id: rootMembers
    anchors.fill: parent

    readonly property color colorBg: "#f8fafc"
    readonly property color colorCardBg: "#ffffff"
    readonly property color colorBorder: "#e2e8f0"
    readonly property color colorTextDark: "#0f172a"
    readonly property color colorTextMuted: "#64748b"

    readonly property color colorPrimary: "#0284c7"
    readonly property color colorSuccess: "#10b981"
    readonly property color colorWarning: "#f59e0b"
    readonly property color colorDanger: "#ef4444"

    property string searchQuery: ""
    property string activeFilter: "All"

    property bool isFormOpen: false
    property bool isEditMode: false
    property int editingMemberId: -1
    property string selectedStatus: "Active"

    property var membersList: [
        { id: 1, name: "Ali Rezaei", number: "09121112233", plan: "VIP 30 Days", status: "Active", remainingSessions: 8, totalSessions: 12, endDate: "2026-10-25", trainerName: "Arash Rad", debtAmount: 0, lockerNumber: 104 },
        { id: 2, name: "Sara Mohammadi", number: "09352223344", plan: "Fitness Basic", status: "Active", remainingSessions: 2, totalSessions: 12, endDate: "2026-10-06", trainerName: "Mona Kazemi", debtAmount: 450000, lockerNumber: 42 },
        { id: 3, name: "Hossein Ahmadi", number: "09193334455", plan: "Bodybuilding Pro", status: "Active", remainingSessions: 11, totalSessions: 24, endDate: "2026-11-15", trainerName: "Arash Rad", debtAmount: 0, lockerNumber: 15 },
        { id: 4, name: "Maryam Ghasemi", number: "09124445566", plan: "Pilates Standard", status: "Suspended", remainingSessions: 0, totalSessions: 10, endDate: "2026-09-28", trainerName: "Neda Tehrani", debtAmount: 250000, lockerNumber: 0 },
        { id: 5, name: "Reza Karimi", number: "09105556677", plan: "Crossfit Max", status: "Active", remainingSessions: 1, totalSessions: 16, endDate: "2026-10-04", trainerName: "Kamran Salimi", debtAmount: 1200000, lockerNumber: 88 },
        { id: 6, name: "Niloofar Danesh", number: "09306667788", plan: "Yoga Group", status: "Pending", remainingSessions: 12, totalSessions: 12, endDate: "2026-11-01", trainerName: "Neda Tehrani", debtAmount: 0, lockerNumber: 12 }
    ]

    property var filteredMembers: {
        var query = searchQuery.toLowerCase().trim();
        var filter = activeFilter;
        return membersList.filter(function(item) {
            var matchesSearch = (item.name.toLowerCase().indexOf(query) !== -1) ||
                                (item.number.indexOf(query) !== -1) ||
                                (item.lockerNumber.toString().indexOf(query) !== -1);
            if (!matchesSearch) return false;

            if (filter === "Active") return item.status === "Active";
            if (filter === "Expiring") return item.remainingSessions <= 2 && item.remainingSessions > 0;
            if (filter === "Debtors") return item.debtAmount > 0;
            return true;
        });
    }

    function checkInMember(memberId) {
        var updated = [];
        for (var i = 0; i < membersList.length; i++) {
            var m = membersList[i];
            if (m.id === memberId && m.remainingSessions > 0) {
                m.remainingSessions -= 1;
            }
            updated.push(m);
        }
        membersList = updated;
    }

    function settleDebt(memberId) {
        var updated = [];
        for (var i = 0; i < membersList.length; i++) {
            var m = membersList[i];
            if (m.id === memberId) {
                m.debtAmount = 0;
            }
            updated.push(m);
        }
        membersList = updated;
    }

    function deleteMember(memberId) {
        var updated = [];
        for (var i = 0; i < membersList.length; i++) {
            if (membersList[i].id !== memberId) {
                updated.push(membersList[i]);
            }
        }
        membersList = updated;
    }

    function openAddModal() {
        isEditMode = false;
        editingMemberId = -1;
        fldName.text = "";
        fldNumber.text = "";
        fldPlan.text = "VIP 30 Days";
        fldTrainer.text = "Arash Rad";
        fldTotalSessions.text = "12";
        fldRemainingSessions.text = "12";
        fldLocker.text = "101";
        fldDebt.text = "0";
        selectedStatus = "Active";
        isFormOpen = true;
    }

    function openEditModal(member) {
        isEditMode = true;
        editingMemberId = member.id;
        fldName.text = member.name;
        fldNumber.text = member.number;
        fldPlan.text = member.plan;
        fldTrainer.text = member.trainerName ? member.trainerName : "";
        fldTotalSessions.text = member.totalSessions.toString();
        fldRemainingSessions.text = member.remainingSessions.toString();
        fldLocker.text = member.lockerNumber.toString();
        fldDebt.text = member.debtAmount.toString();
        selectedStatus = member.status;
        isFormOpen = true;
    }

    function saveMemberData() {
        if (fldName.text.trim() === "") return;

        var total = parseInt(fldTotalSessions.text) || 12;
        var remaining = parseInt(fldRemainingSessions.text);
        if (isNaN(remaining)) remaining = total;
        var locker = parseInt(fldLocker.text) || 0;
        var debt = parseInt(fldDebt.text) || 0;

        if (isEditMode) {
            var updated = [];
            for (var i = 0; i < membersList.length; i++) {
                var m = membersList[i];
                if (m.id === editingMemberId) {
                    m.name = fldName.text.trim();
                    m.number = fldNumber.text.trim();
                    m.plan = fldPlan.text.trim();
                    m.trainerName = fldTrainer.text.trim();
                    m.totalSessions = total;
                    m.remainingSessions = remaining;
                    m.lockerNumber = locker;
                    m.debtAmount = debt;
                    m.status = selectedStatus;
                }
                updated.push(m);
            }
            membersList = updated;
        } else {
            var maxId = 0;
            for (var j = 0; j < membersList.length; j++) {
                if (membersList[j].id > maxId) {
                    maxId = membersList[j].id;
                }
            }
            var newId = maxId + 1;
            var newObj = {
                id: newId,
                name: fldName.text.trim(),
                number: fldNumber.text.trim(),
                plan: fldPlan.text.trim(),
                status: selectedStatus,
                remainingSessions: remaining,
                totalSessions: total,
                endDate: "2026-11-01",
                trainerName: fldTrainer.text.trim(),
                debtAmount: debt,
                lockerNumber: locker
            };

            var listCopy = [newObj].concat(membersList);
            membersList = listCopy;
        }

        isFormOpen = false;
    }

    Rectangle {
        anchors.fill: parent
        color: rootMembers.colorBg
    }

    Column {
        id: topSection
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 14

        Row {
            width: parent.width
            height: 44
            spacing: 14

            Rectangle {
                width: 220
                height: parent.height
                radius: 10
                color: rootMembers.colorCardBg
                border.color: rootMembers.colorBorder

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Rectangle { width: 10; height: 10; radius: 5; color: rootMembers.colorSuccess; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Active Members: " + membersList.filter(function(m){ return m.status === 'Active'; }).length; font.pixelSize: 13; font.bold: true; color: rootMembers.colorTextDark }
                }
            }

            Rectangle {
                width: 220
                height: parent.height
                radius: 10
                color: rootMembers.colorCardBg
                border.color: rootMembers.colorBorder

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Rectangle { width: 10; height: 10; radius: 5; color: rootMembers.colorWarning; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Expiring Soon: " + membersList.filter(function(m){ return m.remainingSessions <= 2 && m.remainingSessions > 0; }).length; font.pixelSize: 13; font.bold: true; color: rootMembers.colorTextDark }
                }
            }

            Rectangle {
                width: 220
                height: parent.height
                radius: 10
                color: rootMembers.colorCardBg
                border.color: rootMembers.colorBorder

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Rectangle { width: 10; height: 10; radius: 5; color: rootMembers.colorDanger; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Outstanding Debts: " + membersList.filter(function(m){ return m.debtAmount > 0; }).length; font.pixelSize: 13; font.bold: true; color: rootMembers.colorTextDark }
                }
            }
        }

        Item {
            width: parent.width
            height: 40

            Rectangle {
                id: searchBox
                width: 300
                height: parent.height
                radius: 8
                color: rootMembers.colorCardBg
                border.color: inputSearch.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder

                TextInput {
                    id: inputSearch
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    verticalAlignment: TextInput.AlignVCenter
                    font.pixelSize: 13
                    color: rootMembers.colorTextDark
                    clip: true
                    onTextChanged: rootMembers.searchQuery = text

                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Search name, phone, locker..."
                        font.pixelSize: 13
                        color: "#94a3b8"
                        visible: !inputSearch.text && !inputSearch.activeFocus
                    }
                }
            }

            Row {
                anchors.left: searchBox.right
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Repeater {
                    model: ["All", "Active", "Expiring", "Debtors"]

                    Rectangle {
                        width: txtFilter.implicitWidth + 22
                        height: 34
                        radius: 17
                        color: rootMembers.activeFilter === modelData ? rootMembers.colorTextDark : rootMembers.colorCardBg
                        border.color: rootMembers.activeFilter === modelData ? rootMembers.colorTextDark : rootMembers.colorBorder

                        Text {
                            id: txtFilter
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 12
                            font.bold: true
                            color: rootMembers.activeFilter === modelData ? "#ffffff" : rootMembers.colorTextMuted
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootMembers.activeFilter = modelData
                        }
                    }
                }
            }

            Rectangle {
                width: 135
                height: parent.height
                radius: 8
                anchors.right: parent.right
                color: rootMembers.colorPrimary

                Text {
                    anchors.centerIn: parent
                    text: "+ Add Member"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#ffffff"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: rootMembers.openAddModal()
                }
            }
        }
    }

    Rectangle {
        id: tableContainer
        anchors.top: topSection.bottom
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.bottomMargin: 20
        radius: 12
        color: rootMembers.colorCardBg
        border.color: rootMembers.colorBorder
        clip: true

        readonly property real tablePadding: 16
        readonly property real availWidth: Math.max(700, width - (tablePadding * 2))

        readonly property real colMemberWidth: Math.max(160, availWidth * 0.18)
        readonly property real colPlanWidth: Math.max(110, availWidth * 0.12)
        readonly property real colStatusWidth: Math.max(85, availWidth * 0.08)
        readonly property real colProgressWidth: Math.max(130, availWidth * 0.14)
        readonly property real colTrainerWidth: Math.max(110, availWidth * 0.12)
        readonly property real colDebtWidth: Math.max(95, availWidth * 0.10)
        readonly property real colLockerWidth: Math.max(65, availWidth * 0.06)
        readonly property real colActionsWidth: Math.max(180, availWidth * 0.20)

        Column {
            anchors.fill: parent

            Rectangle {
                width: parent.width
                height: 42
                color: "#f8fafc"

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    x: tableContainer.tablePadding
                    width: parent.width - (tableContainer.tablePadding * 2)

                    Text { width: tableContainer.colMemberWidth; text: "Member"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colPlanWidth; text: "Plan"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colStatusWidth; text: "Status"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colProgressWidth; text: "Sessions Left"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colTrainerWidth; text: "Trainer"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colDebtWidth; text: "Debt Balance"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colLockerWidth; text: "Locker"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                    Text { width: tableContainer.colActionsWidth; text: "Actions"; font.bold: true; font.pixelSize: 12; color: rootMembers.colorTextMuted }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: rootMembers.colorBorder
                }
            }

            ListView {
                width: parent.width
                height: parent.height - 42
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                model: rootMembers.filteredMembers

                delegate: Rectangle {
                    id: rowCard
                    width: parent.width
                    height: 54
                    color: itemHover.containsMouse ? "#f8fafc" : "#ffffff"

                    MouseArea {
                        id: itemHover
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        x: tableContainer.tablePadding
                        width: parent.width - (tableContainer.tablePadding * 2)

                        Column {
                            width: tableContainer.colMemberWidth
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            Text {
                                text: modelData.name
                                font.pixelSize: 13
                                font.bold: true
                                color: rootMembers.colorTextDark
                                elide: Text.ElideRight
                                width: parent.width - 10
                            }
                            Text {
                                text: modelData.number
                                font.pixelSize: 11
                                color: rootMembers.colorTextMuted
                            }
                        }

                        Text {
                            width: tableContainer.colPlanWidth
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.plan
                            font.pixelSize: 12
                            color: rootMembers.colorTextDark
                            elide: Text.ElideRight
                        }

                        Item {
                            width: tableContainer.colStatusWidth
                            height: 24
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                width: 70
                                height: 22
                                radius: 11
                                anchors.verticalCenter: parent.verticalCenter
                                color: modelData.status === "Active" ? "#ecfdf5" :
                                       modelData.status === "Pending" ? "#fffbeb" : "#fef2f2"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.status
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: modelData.status === "Active" ? rootMembers.colorSuccess :
                                           modelData.status === "Pending" ? rootMembers.colorWarning : rootMembers.colorDanger
                                }
                            }
                        }

                        Column {
                            width: tableContainer.colProgressWidth
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 3

                            Text {
                                text: modelData.remainingSessions + " / " + modelData.totalSessions + " left"
                                font.pixelSize: 11
                                font.bold: true
                                color: modelData.remainingSessions <= 2 ? rootMembers.colorWarning : rootMembers.colorTextDark
                            }

                            Rectangle {
                                width: Math.min(120, parent.width - 20)
                                height: 4
                                radius: 2
                                color: "#e2e8f0"

                                Rectangle {
                                    width: Math.min(parent.width, (modelData.remainingSessions / Math.max(1, modelData.totalSessions)) * parent.width)
                                    height: parent.height
                                    radius: 2
                                    color: modelData.remainingSessions <= 2 ? rootMembers.colorWarning : rootMembers.colorSuccess
                                }
                            }
                        }

                        Text {
                            width: tableContainer.colTrainerWidth
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.trainerName ? modelData.trainerName : "None"
                            font.pixelSize: 12
                            color: rootMembers.colorTextMuted
                            elide: Text.ElideRight
                        }

                        Item {
                            width: tableContainer.colDebtWidth
                            height: 24
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.debtAmount > 0 ? Number(modelData.debtAmount).toLocaleString(Qt.locale(), "f", 0) + " T" : "Paid"
                                font.pixelSize: 12
                                font.bold: modelData.debtAmount > 0
                                color: modelData.debtAmount > 0 ? rootMembers.colorDanger : rootMembers.colorSuccess
                            }
                        }

                        Text {
                            width: tableContainer.colLockerWidth
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.lockerNumber > 0 ? "#" + modelData.lockerNumber : "-"
                            font.pixelSize: 12
                            color: rootMembers.colorTextMuted
                        }

                        Row {
                            width: tableContainer.colActionsWidth
                            height: 28
                            spacing: 5
                            anchors.verticalCenter: parent.verticalCenter

                            Rectangle {
                                width: 52
                                height: 26
                                radius: 5
                                color: modelData.remainingSessions > 0 ? "#f0fdf4" : "#f1f5f9"
                                border.color: modelData.remainingSessions > 0 ? rootMembers.colorSuccess : "#cbd5e1"

                                Text {
                                    anchors.centerIn: parent
                                    text: "Check-in"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: modelData.remainingSessions > 0 ? rootMembers.colorSuccess : "#94a3b8"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: modelData.remainingSessions > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    enabled: modelData.remainingSessions > 0
                                    onClicked: rootMembers.checkInMember(modelData.id)
                                }
                            }

                            Rectangle {
                                width: 42
                                height: 26
                                radius: 5
                                color: modelData.debtAmount > 0 ? "#fef2f2" : "#f8fafc"
                                border.color: modelData.debtAmount > 0 ? rootMembers.colorDanger : rootMembers.colorBorder

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.debtAmount > 0 ? "Settle" : "Paid"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: modelData.debtAmount > 0 ? rootMembers.colorDanger : rootMembers.colorTextMuted
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: modelData.debtAmount > 0 ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    enabled: modelData.debtAmount > 0
                                    onClicked: rootMembers.settleDebt(modelData.id)
                                }
                            }

                            Rectangle {
                                width: 36
                                height: 26
                                radius: 5
                                color: "#f0f9ff"
                                border.color: rootMembers.colorPrimary

                                Text {
                                    anchors.centerIn: parent
                                    text: "Edit"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: rootMembers.colorPrimary
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: rootMembers.openEditModal(modelData)
                                }
                            }

                            Rectangle {
                                width: 36
                                height: 26
                                radius: 5
                                color: "#fef2f2"
                                border.color: rootMembers.colorDanger

                                Text {
                                    anchors.centerIn: parent
                                    text: "Del"
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: rootMembers.colorDanger
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: rootMembers.deleteMember(modelData.id)
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: rootMembers.colorBorder
                    }
                }
            }
        }
    }

    Rectangle {
        id: modalOverlay
        anchors.fill: parent
        color: "#75000000"
        visible: rootMembers.isFormOpen
        z: 999

        MouseArea {
            anchors.fill: parent
            onClicked: rootMembers.isFormOpen = false
        }

        Rectangle {
            id: modalBox
            width: 480
            implicitHeight: modalColumn.implicitHeight + 44
            radius: 14
            color: rootMembers.colorCardBg
            anchors.centerIn: parent

            MouseArea {
                anchors.fill: parent
            }

            Column {
                id: modalColumn
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 22
                spacing: 12

                Item {
                    width: parent.width
                    height: 28

                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: rootMembers.isEditMode ? "Edit Member Details" : "Add New Member"
                        font.pixelSize: 17
                        font.bold: true
                        color: rootMembers.colorTextDark
                    }

                    Rectangle {
                        width: 28
                        height: 28
                        radius: 14
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        color: btnCloseMouse.containsMouse ? "#f1f5f9" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            font.pixelSize: 14
                            color: rootMembers.colorTextMuted
                        }

                        MouseArea {
                            id: btnCloseMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootMembers.isFormOpen = false
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: rootMembers.colorBorder
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Full Name"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldName.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldName
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Phone Number"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldNumber.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldNumber
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Plan"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldPlan.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldPlan
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Trainer"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldTrainer.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldTrainer
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Total Sessions"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldTotalSessions.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldTotalSessions
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Remaining Sessions"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldRemainingSessions.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldRemainingSessions
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Locker Number"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldLocker.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldLocker
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }

                    Column {
                        width: (parent.width - 12) / 2
                        spacing: 4
                        Text { text: "Debt Amount (T)"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                        Rectangle {
                            width: parent.width
                            height: 36
                            radius: 6
                            border.color: fldDebt.activeFocus ? rootMembers.colorPrimary : rootMembers.colorBorder
                            clip: true
                            TextInput {
                                id: fldDebt
                                anchors.fill: parent
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10
                                verticalAlignment: TextInput.AlignVCenter
                                font.pixelSize: 13
                                color: rootMembers.colorTextDark
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 6
                    Text { text: "Account Status"; font.pixelSize: 11; font.bold: true; color: rootMembers.colorTextDark }
                    Row {
                        spacing: 8
                        Repeater {
                            model: ["Active", "Pending", "Suspended"]
                            Rectangle {
                                width: 90
                                height: 32
                                radius: 16
                                color: rootMembers.selectedStatus === modelData ? rootMembers.colorTextDark : "#f1f5f9"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 12
                                    font.bold: true
                                    color: rootMembers.selectedStatus === modelData ? "#ffffff" : rootMembers.colorTextMuted
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: rootMembers.selectedStatus = modelData
                                }
                            }
                        }
                    }
                }

                Item {
                    width: parent.width
                    height: 6
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 38
                        radius: 8
                        color: "#f1f5f9"
                        border.color: rootMembers.colorBorder

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            font.pixelSize: 13
                            color: rootMembers.colorTextMuted
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootMembers.isFormOpen = false
                        }
                    }

                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 38
                        radius: 8
                        color: rootMembers.colorPrimary

                        Text {
                            anchors.centerIn: parent
                            text: rootMembers.isEditMode ? "Save Changes" : "Create Member"
                            font.pixelSize: 13
                            font.bold: true
                            color: "#ffffff"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rootMembers.saveMemberData()
                        }
                    }
                }
            }
        }
    }
}
