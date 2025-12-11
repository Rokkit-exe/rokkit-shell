// CpuWidget
import QtQuick
import Quickshell
import "../theme"

Item {
  id: cpuItem
  anchors.verticalCenter: parent.verticalCenter
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight

  property var bar: null

  HardwareMenu {
    id: cpuMenu
    bar: cpuItem.bar
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
      cpuMenu.visible = !cpuMenu.visible
    }

    onPressed: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        let itemGlobal = cpuItem.mapToGlobal(0, 0)
        let barGlobal = cpuMenu.bar.contentItem.mapToGlobal(0, 0)
        
        // Calculate icon's center position relative to bar
        let iconCenterX = itemGlobal.x - barGlobal.x + (cpuItem.width / 2)
        
        // Subtract half of menu width to center it
        let relativeX = iconCenterX - (cpuMenu.implicitWidth / 2)
        
        cpuMenu.anchor.rect.x = relativeX
      }
    }
  }
    
  Text {
      text: Theme.icons.cpu
      font.family: Theme.fonts.family
      font.pixelSize: Theme.fonts.iconSize
      color: Theme.colors.foreground
      anchors.centerIn: parent
  }
}
