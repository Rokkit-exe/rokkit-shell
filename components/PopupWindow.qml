import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "../theme"

PanelWindow {
  id: customMenu

  property var bar: null
  default property alias content: menuContainer.children
  property alias border: menuContainer.border
  property string title: ""
  property bool focusable: true

  anchors.top: true
  anchors.right: true
  margins.right: Theme.spacing.small
  margins.top: Theme.spacing.small 

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
