import QtQuick
import Quickshell
import Quickshell.Io
import "./theme"
import "./components/" as Components

Components.PopupWindow {
    id: calendarPopup
    
    property date currentDate: new Date()
    property int cellSize: 40  // Fixed cell size for consistency
    
    implicitWidth: 320
    implicitHeight: mainColumn.implicitHeight + Theme.padding.medium * 2
    
    Rectangle {
        anchors.fill: parent
        color: Theme.colors.background
        border.color: Theme.colors.backgroundLight
        border.width: Theme.borders.width
        radius: Theme.borders.radius
        
        Column {
            id: mainColumn
            width: parent.width - Theme.padding.medium * 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Theme.padding.medium
            spacing: Theme.spacing.medium
            
            // Header with navigation
            Row {
                width: parent.width
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.spacing.small
                
                MouseArea {
                    width: 40
                    height: 40
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    
                    onClicked: {
                        let d = new Date(calendarPopup.currentDate)
                        d.setMonth(d.getMonth() - 1)
                        calendarPopup.currentDate = d
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: parent.containsMouse ? Theme.colors.backgroundLight : "transparent"
                        border.color: Theme.colors.backgroundLight
                        border.width: Theme.borders.width
                        radius: Theme.borders.radius
                        
                        Text {
                            text: Theme.icons.arrowLeft
                            color: Theme.colors.blue
                            font.pixelSize: Theme.fonts.size
                            anchors.centerIn: parent
                        }
                    }
                }
                
                Item {
                    width: parent.width - 90
                    height: 40
                    
                    Text {
                        text: Qt.formatDate(calendarPopup.currentDate, "MMMM yyyy")
                        color: Theme.colors.foreground
                        font.family: Theme.fonts.family
                        font.pixelSize: Theme.fonts.size + 4
                        font.bold: true
                        anchors.centerIn: parent
                    }
                }
                
                MouseArea {
                    width: 40
                    height: 40
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    
                    onClicked: {
                        let d = new Date(calendarPopup.currentDate)
                        d.setMonth(d.getMonth() + 1)
                        calendarPopup.currentDate = d
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: parent.containsMouse ? Theme.colors.backgroundLight : "transparent"
                        border.color: Theme.colors.backgroundLight
                        border.width: Theme.borders.width
                        radius: Theme.borders.radius
                        
                        Text {
                            text: Theme.icons.arrowRight
                            color: Theme.colors.blue
                            font.pixelSize: Theme.fonts.size
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            
            // Day of week headers
            Row {
                width: parent.width
                spacing: 2
                
                Repeater {
                    model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    
                    Rectangle {
                        width: (parent.width - 12) / 7
                        height: 30
                        color: "transparent"
                        
                        Text {
                            text: modelData
                            color: Theme.colors.blue
                            font.family: Theme.fonts.family
                            font.pixelSize: Theme.fonts.size - 2
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            
            // Calendar grid
            Grid {
                id: dayGrid
                width: parent.width
                columns: 7
                rowSpacing: 2
                columnSpacing: 2
                
                Repeater {
                    model: 42
                    
                    delegate: Rectangle {
                        // Fixed size for all cells
                        width: (dayGrid.width - (dayGrid.columnSpacing * 6)) / 7
                        height: calendarPopup.cellSize
                        
                        property int year: calendarPopup.currentDate.getFullYear()
                        property int month: calendarPopup.currentDate.getMonth()
                        property date firstDayOfMonth: new Date(year, month, 1)
                        property int firstDayOfWeek: firstDayOfMonth.getDay()
                        property int dayNumber: index - firstDayOfWeek + 1
                        property date cellDate: new Date(year, month, dayNumber)
                        property bool isCurrentMonth: cellDate.getMonth() === month
                        property bool isToday: {
                            let today = new Date()
                            return cellDate.getDate() === today.getDate() &&
                                   cellDate.getMonth() === today.getMonth() &&
                                   cellDate.getFullYear() === today.getFullYear()
                        }
                        
                        visible: dayNumber > 0 && isCurrentMonth
                        color: isToday ? Theme.colors.blue : "transparent"
                        radius: Theme.borders.radius
                        
                        Text {
                            text: parent.dayNumber
                            color: parent.isToday ? Theme.colors.background : Theme.colors.foreground
                            font.family: Theme.fonts.family
                            font.pixelSize: Theme.fonts.size
                            anchors.centerIn: parent
                        }
                    }
                }
            }
            
            // Today button
            MouseArea {
                width: 100
                height: 35
                anchors.horizontalCenter: parent.horizontalCenter
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                
                onClicked: calendarPopup.currentDate = new Date()
                
                Rectangle {
                    anchors.fill: parent
                    color: parent.containsMouse ? Theme.colors.backgroundLight : Theme.colors.background
                    border.color: Theme.colors.backgroundLight
                    border.width: Theme.borders.width
                    radius: Theme.borders.radius
                    
                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.spacing.small
                        
                        Text {
                            text: Theme.icons.refresh
                            color: Theme.colors.blue
                            font.family: Theme.fonts.family
                            font.pixelSize: Theme.fonts.size
                        }
                        
                        Text {
                            text: "Today"
                            color: Theme.colors.foreground
                            font.family: Theme.fonts.family
                            font.pixelSize: Theme.fonts.size
                        }
                    }
                }
            }
        }
    }
}

