import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"

PopupWindow {
  id: customMenu
  visible: false

  property var bar: null
  
  anchor.window: bar
  anchor.rect.x: 0
  anchor.rect.y: bar.height
  color: "transparent"
  
  implicitWidth: menuContainer.width ? menuContainer.width : 250
  implicitHeight: Math.max(50, menuColumn.implicitHeight + 8)
  
  Rectangle {
    id: menuContainer
    anchors.fill: parent
    color: Theme.colors.background
    border.color: Theme.colors.backgroundLight
    border.width: Theme.borders.width
    radius: Theme.borders.radius
    
    Column {
      id: menuColumn
      width: parent.width
      padding: Theme.spacing.medium
      spacing: Theme.spacing.small

      CpuInfo {
      }
      MemoryInfo {
      }
      GpuInfo {
      }
      DiskInfo {
      }
    }
  }
}
