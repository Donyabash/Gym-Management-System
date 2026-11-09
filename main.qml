import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Window {
    id: root
    title: qsTr("Hello World")
    property string activeButtonName: "Dashboard"
    color: colors.colorBg

    width: 1920
    height: 1080
    visible: true

    GeneralColors { id: colors }
    Models { id: models }

    Item {
        id: rootTabMenu
        width: parent.width
        height: 800

        property int currentTab: 0

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: colors.colorCardBg
                border.color: colors.colorBorder

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 24
                    spacing: 12

                    TabButton {
                        text: "📊 Dashboard"
                        isActive: rootTabMenu.currentTab === 0
                        onClicked: rootTabMenu.currentTab = 0
                    }

                    TabButton {
                        text: "🏋️ Classes"
                        isActive: rootTabMenu.currentTab === 1
                        onClicked: rootTabMenu.currentTab = 1
                    }

                    TabButton {
                        text: "👥 Members"
                        isActive: rootTabMenu.currentTab === 2
                        onClicked: rootTabMenu.currentTab = 2
                    }

                    TabButton {
                        text: "📋 Plans"
                        isActive: rootTabMenu.currentTab === 3
                        onClicked: rootTabMenu.currentTab = 3
                    }

                    TabButton {
                        text: "💰 Financial"
                        isActive: rootTabMenu.currentTab === 4
                        onClicked: rootTabMenu.currentTab = 4
                    }

                    TabButton {
                        text: "⚙️ Settings"
                        isActive: rootTabMenu.currentTab === 5
                        onClicked: rootTabMenu.currentTab = 5
                    }
                }
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: rootTabMenu.currentTab

                Item {
                    Dashboard {
                        anchors.fill: parent
                    }
                }

                Item {
                    Classes {
                        anchors.fill: parent
                    }
                }

                Item {
                    Table {
                        anchors.fill: parent
                    }
                }

                Item {
                    Plans {
                        anchors.fill: parent
                    }
                }

                Item {
                    FinanceTable {
                        anchors.fill: parent
                    }
                }

                Item {
                    Setting {
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
