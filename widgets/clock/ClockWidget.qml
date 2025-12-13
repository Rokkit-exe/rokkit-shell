// ClockWidget.qml
import QtQuick
import Quickshell
import "../../theme"
import "../../functions"
import "../../components" as Components

Item {
  id: clockItem
  width: timeText.implicitWidth
  height: Theme.dimensions.itemsHeight

  property var bar: null

  CalendarMenu {
    id: calendarMenu
    bar: clockItem.bar
  }

  Components.MouseArea {
    id: clockArea
    width: timeText.implicitWidth + Theme.spacing.medium * 2
    height: Theme.dimensions.itemsHeight
    
    onLeftClick: () => Functions.toggleMenu(clockItem.bar, calendarMenu, clockArea)

    Rectangle {
      anchors.fill: parent
      color: Theme.colors.backgroundLight
      border.width: Theme.borders.width
      border.color: Theme.colors.backgroundLight
      radius: Theme.borders.radius
      
      Components.Text {
        id: timeText
        text: Time.time
        padding: Theme.spacing.medium
        anchors.centerIn: parent
      }
    }
  }
}

