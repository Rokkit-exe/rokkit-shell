import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components" as Components
import "./CpuInfo.qml"
import "./MemoryInfo.qml"
import "./GpuInfo.qml"
import "./DiskInfo.qml"

PopupWindow {
  id: customMenu
  visible: false

  property var bar: null
  
  anchor.window: bar
  anchor.rect.x: 0
  anchor.rect.y: bar.height
  color: "transparent"
  
  implicitWidth: menuContainer.width ? menuContainer.width : 100
  implicitHeight: menuContainer.height ? menuContainer.height : 200

  Components.ColumnBox {
    id: menuContainer
    width: 280 
    height: cpuInfo.height + memoryInfo.height + gpuInfo.height + diskInfo.height + Theme.spacing.medium * 2 + Theme.spacing.small * 3
    color: Theme.colors.background
    border.color: Theme.colors.backgroundLight
    border.width: Theme.borders.width
    padding: Theme.spacing.medium
    spacing: Theme.spacing.small

    CpuInfo {
      id: cpuInfo
    }
    MemoryInfo {
      id: memoryInfo
    }
    GpuInfo {
      id: gpuInfo
    }
    DiskInfo {
      id: diskInfo
    }
  }
}
