// Bar.qml
import Quickshell
import QtQuick
import "./theme"
import "./widgets/logo"
import "./widgets/workspace"
import "./widgets/clock"
import "./widgets/tray"
import "./widgets"
import "./window"

Scope {
  id: barScope
  required property var settingsWindow

  Variants {
    id: barVariants
    model: Quickshell.screens

    PanelWindow {
      id: bar
      
      required property var modelData
      
      // theme properties

      screen: modelData

      color: Theme.colors.background

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: Theme.dimensions.barHeight + 2

      Row {
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
          leftMargin: Theme.spacing.medium
        }
        spacing: Theme.spacing.medium 
        LogoWidget {
        }
        WorkspaceWidget {
        }
      }

      Row {
        anchors {
          centerIn: parent
          verticalCenter: parent.verticalCenter
        }

        ClockWidget {
          bar: bar
        }
      }

      Row {
        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
          rightMargin: Theme.spacing.small
        }
        spacing: Theme.spacing.medium
        SystemTrayWidget {
          bar: bar
        }
        SystemCtlWidget { 
          bar: bar
          settingsWindow: barScope.settingsWindow
        }
      }
    }
  }
}
