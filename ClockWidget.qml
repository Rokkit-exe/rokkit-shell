// ClockWidget.qml
import QtQuick
import Quickshell
import "./theme"

Item {
  id: clockItem
  width: timeText.implicitWidth
  height: Theme.dimensions.itemsHeight

  property var bar: null

  CalendarMenu {
    id: calendarMenu
    bar: clockItem.bar
  }

  MouseArea {
    id: clockArea
    width: timeText.implicitWidth + Theme.padding.medium * 2
    height: Theme.dimensions.itemsHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    
    onClicked: {
        // Position calendar relative to clock
        let clockGlobal = clockArea.mapToGlobal(0, 0)
        let barGlobal = clockItem.bar.contentItem.mapToGlobal(0, 0)
        let relativeX = clockGlobal.x - barGlobal.x
        
        calendarMenu.anchor.rect.x = relativeX - (calendarMenu.width / 2) + (clockArea.width / 2)
        calendarMenu.visible = !calendarMenu.visible
    }
    Rectangle {
      anchors.fill: parent
      color: Theme.colors.backgroundLight
      border.width: Theme.borders.width
      border.color: Theme.colors.backgroundLight
      radius: Theme.borders.radius
      
      Text {
        id: timeText
        anchors.centerIn: parent

        text: Time.time
        font.family: Theme.fonts.family 
        font.pixelSize: Theme.fonts.size
        color: Theme.colors.foreground
        padding: Theme.padding.medium
      }
    }
  }
}

