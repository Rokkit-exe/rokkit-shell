// MemoryWidget
import QtQuick
import Quickshell
import "../theme"

Item {
  id: memoryItem
  anchors.verticalCenter: parent.verticalCenter
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight
    
  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
      Quickshell.execDetached("omarchy-launch-bluetooth")
    }
  }
    
  Text {
      text: Theme.icons.memory
      font.family: Theme.fonts.family
      font.pixelSize: Theme.fonts.iconSize
      color: Theme.colors.foreground
      anchors.centerIn: parent
  }
}
