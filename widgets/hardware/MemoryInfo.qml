import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components/" as Components

Components.ColumnBox {
  height: title.implicitHeight + usage.implicitHeight + used.implicitHeight + total.implicitHeight + Theme.spacing.medium * 4 + Theme.spacing.small * 6
  width: parent.width ? parent.width - Theme.spacing.medium * 2 : Math.max(title.implicitWidth, usage.implicitWidth, used.implicitWidth, total.implicitWidth) + Theme.spacing.medium * 2
  spacing: Theme.spacing.small
  padding: Theme.spacing.medium
  color: Theme.colors.backgroundLight

  Components.RowBox {
    id: title
    width: memoryIcon.implicitWidth + memoryText.implicitWidth + Theme.spacing.medium * 2
    height: Math.max(memoryIcon.implicitHeight, memoryText.implicitHeight) + Theme.spacing.small * 2
    padding: Theme.spacing.small

    Components.Icon {
      id: memoryIcon
      text: Theme.icons.memory
      color: Theme.colors.purple
    }

    Components.Text {
      id: memoryText
      text: "Memory"
      color: Theme.colors.purple
      font.pixelSize: Theme.fonts.size.medium
      leftPadding: Theme.spacing.small
    }
  }

  Components.TextProcess {
    id: usage
    name: "Usage"
    value: this.result + " %"
    command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1f\", (t-a)/1024/1024}' /proc/meminfo"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: used
    name: "Used"
    value: this.result
    command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1fGB\", (t-a)/1024/1024}' /proc/meminfo"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: total
    name: "Total"
    value: this.result
    command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1fGB\", t/1024/1024}' /proc/meminfo"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }
}
