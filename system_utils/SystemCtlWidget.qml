import QtQuick
import Quickshell
import "../theme"

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
      padding: Theme.padding.small

      CpuWidget {
        bar: systemCtlWidget.bar
      }
      BluetoothWidget {
      }
      NetworkWidget {
      }
      SoundWidget {
      }
      SettingsWidget {
        settingsWindow: systemCtlWidget.settingsWindow
      }
    }
  }
}

