import QtQuick
import Quickshell
import "../theme"
import "./hardware/"
import "./settings/"
import "./network/"
import "./audio/"
import "./bluetooth/"

Item {
  id: systemCtlWidget
  implicitWidth: trayRow.implicitWidth
  height: Theme.dimensions.itemsHeight

  property var bar: null
  property var settingsWindow: null

  Rectangle {
    anchors {
      fill: parent
      right: parent.right
      verticalCenter: parent.verticalCenter
    }
    color: Theme.colors.backgroundLight
    border.width: Theme.borders.width
    border.color: Theme.colors.backgroundLight
    radius: Theme.borders.radius

    Row {
      anchors {
        right: parent.right
        verticalCenter: parent.verticalCenter
      }
      id: trayRow
      spacing: Theme.spacing.small
      padding: Theme.spacing.small

      HardwareWidget {
        bar: systemCtlWidget.bar
      }
      BluetoothWidget {
        bar: systemCtlWidget.bar
      }
      NetworkWidget {
        bar: systemCtlWidget.bar
      }
      AudioWidget {
        bar: systemCtlWidget.bar
      }
      SettingsWidget {
        settingsWindow: systemCtlWidget.settingsWindow
      }
    }
  }
}

