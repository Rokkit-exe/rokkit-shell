// CpuWidget
import QtQuick
import Quickshell
import "../../theme"
import "../../components" as Components

Item {
  id: hardwareItem
  anchors.verticalCenter: parent.verticalCenter
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight

  property var bar: null

  HardwareMenu {
    id: hardwareMenu
    bar: hardwareItem.bar
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    
    onClicked: {
      hardwareMenu.visible = !hardwareMenu.visible
    }

    onPressed: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        let itemGlobal = hardwareItem.mapToGlobal(0, 0)
        let barGlobal = hardwareMenu.bar.contentItem.mapToGlobal(0, 0)
        
        // Calculate icon's center position relative to bar
        let iconCenterX = itemGlobal.x - barGlobal.x + (hardwareItem.width / 2)
        
        // Subtract half of menu width to center it
        let relativeX = iconCenterX - (hardwareMenu.implicitWidth / 2)
        
        hardwareMenu.anchor.rect.x = relativeX
      }
    }
  }
    
  Components.Icon {
    text: Theme.icons.cpu
    font.pixelSize: Theme.fonts.iconSize
    anchors.centerIn: parent
  }
}
