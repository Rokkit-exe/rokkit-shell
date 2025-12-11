// WorkspaceWidget
//
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../components" as Components

Item {
  id: root
  implicitWidth: trayRow.implicitWidth
  height: Theme.dimensions.itemsHeight

  Rectangle {
    anchors {
      fill: parent
      verticalCenter: parent.verticalCenter
    }
    color: Theme.colors.backgroundLight
    border.width: Theme.borders.width
    border.color: Theme.colors.backgroundLight
    radius: Theme.borders.radius

    Row {
      id: trayRow
      anchors.verticalCenter: parent.verticalCenter
      spacing: Theme.spacing.small
      padding: Theme.spacing.small

      Repeater {
        model: 9

        Text {
          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

          text: isActive ? Theme.icons.square : index + 1
          color: isActive ? Theme.colors.blue : (ws ? Theme.colors.foreground : Theme.colors.foregroundDark)
          font.family: Theme.fonts.family
          font.pixelSize: Theme.fonts.size
          font.bold: true
          leftPadding: Theme.spacing.small
          rightPadding: Theme.spacing.small

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: Hyprland.dispatch("workspace " + (index + 1))
          }
        }
      }
  }
  }

  
}

