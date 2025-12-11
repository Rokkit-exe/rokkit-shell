import QtQuick
import QtQuick.Controls
import Quickshell
import "../theme"

PopupWindow {
  id: customMenu

  property var bar: null
  default property alias content: menuContainer.children
  
  anchor.window: bar
  anchor.rect.x: 0
  anchor.rect.y: bar.height
  color: "transparent"
  visible: false
  
  implicitWidth: menuContainer.width ? menuContainer.width : 250
  implicitHeight: Math.max(50, menuContainer.implicitHeight + 8)
  
  Rectangle {
    id: menuContainer
    anchors.fill: parent
    color: Theme.colors.background
    border.color: Theme.colors.backgroundLight
    border.width: Theme.borders.width
    radius: Theme.borders.radius
  }
}
