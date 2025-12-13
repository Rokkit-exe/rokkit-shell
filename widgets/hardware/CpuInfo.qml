import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components/" as Components

Components.ColumnBox {
  height: title.implicitHeight + cpuModel.implicitHeight + cpuUsage.implicitHeight + cpuTemp.implicitHeight + Theme.spacing.medium * 4 + Theme.spacing.small * 6
  width: parent.width ? parent.width - Theme.spacing.medium * 2 : Math.max(title.implicitWidth, cpuModel.implicitWidth, cpuUsage.implicitWidth, cpuTemp.implicitWidth) + Theme.spacing.medium * 2
  color: Theme.colors.backgroundLight
  spacing: Theme.spacing.small
  padding: Theme.spacing.medium

  Components.RowBox {
    id: title
    width: cpuIcon.implicitWidth + cpuText.implicitWidth + Theme.spacing.medium * 2
    height: Math.max(cpuIcon.implicitHeight, cpuText.implicitHeight) + Theme.spacing.small * 2
    padding: Theme.spacing.small

    Components.Icon {
      id: cpuIcon
      text: Theme.icons.cpu
      color: Theme.colors.red
    }

    Components.Text {
      id: cpuText

      text: "CPU"
      color: Theme.colors.red
      font.pixelSize: Theme.fonts.size.medium
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: Theme.spacing.small
    }
  }

  // CPU Model name
  Components.TextProcess {
    id: cpuModel
    name: "Model"
    value: this.result
    command: ["sh", "-c", "awk -F: '/model name/{gsub(/ [0-9]+-Core.*/,\"\"); gsub(/ CPU @.*/,\"\"); gsub(/\\(R\\)/,\"\"); gsub(/\\(TM\\)/,\"\"); print $2}' /proc/cpuinfo | head -n1 | xargs"]
    repeat: false
    padding: Theme.spacing.small
  }

  // CPU Usage %
  Components.TextProcess {
    id: cpuUsage
    name: "Usage"
    value: this.result + " %"
    command: ["sh", "-c", "awk '/cpu /{printf \"%.1f\", ($2+$4)*100/($2+$4+$5); exit}' /proc/stat"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  // CPU Temperature
  Components.TextProcess {
    id: cpuTemp
    name: "Temp"
    value: this.result + "°C"
    command: ["sh", "-c", "cat /sys/class/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 | awk '{printf \"%.0f\", $1/1000}' || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf \"%.0f\", $1/1000}' || echo \"N/A\""]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }
}

