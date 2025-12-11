// CpuWidget
import QtQuick
import Quickshell
import "../theme"

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
    
  Text {
      text: Theme.icons.settings
      font.family: Theme.fonts.family
      font.pixelSize: Theme.fonts.iconSize
      color: Theme.colors.foreground
      anchors.centerIn: parent
  }
}
