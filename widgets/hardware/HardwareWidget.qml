// CpuWidget
import QtQuick
import Quickshell
import "../../theme"
import "../../components" as Components
import "../../functions/"
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

  Components.MouseArea {
    id: hardwareArea
    anchors.fill: parent

    onLeftClick: () => {
      Functions.toggleMenu(hardwareItem.bar, hardwareMenu, hardwareArea)
    }
  }
    
  Components.Icon {
    text: Theme.icons.cpu
    font.pixelSize: Theme.fonts.size.medium
    anchors.centerIn: parent
  }
}
