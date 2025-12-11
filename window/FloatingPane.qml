// FloatingWindow
import QtQuick
import Quickshell
import Quickshell.Wayland
import "../theme"
import "../components" as Components

FloatingWindow {
  id: toplevel
  title: "Settings"


  implicitWidth: 600
  implicitHeight: 600
  visible: false

  Rectangle {
    anchors.fill: parent
    color: Theme.colors.background
    border.color: Theme.colors.blue
    border.width: Theme.borders.width
    radius: Theme.borders.radius

    Components.Text {
      anchors.centerIn: parent
      text: "Settings Window"
    }
  }
}
