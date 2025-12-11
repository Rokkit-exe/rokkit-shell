// CpuWidget
import QtQuick
import Quickshell
import "../../theme"
import "../../components" as Components

Item {
  id: settingsItem
  anchors.verticalCenter: parent.verticalCenter
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight

  property var settingsWindow: null

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
      settingsItem.settingsWindow.visible = !settingsItem.settingsWindow.visible
    }
  }
    
  Components.Icon {
    text: Theme.icons.settings
    anchors.centerIn: parent
  }
}
