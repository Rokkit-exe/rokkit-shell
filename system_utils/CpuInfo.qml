import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"
import "../components/" as Components

Components.ColumnBox {
  Components.RowBox {
    padding: Theme.padding.medium

    Components.Icon {
      text: Theme.icons.cpu
      color: Theme.colors.red
    }

    Text {
      id: cpuText

      text: "CPU"
      color: Theme.colors.red
      font.family: Theme.fonts.family
      font.bold: true
      font.pixelSize: Theme.fonts.iconSize
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: Theme.padding.small
    }
  }

  // CPU Model name
  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Model"
      value: this.result
      command: ["sh", "-c", "awk -F: '/model name/{gsub(/ [0-9]+-Core.*/,\"\"); gsub(/ CPU @.*/,\"\"); gsub(/\\(R\\)/,\"\"); gsub(/\\(TM\\)/,\"\"); print $2}' /proc/cpuinfo | head -n1 | xargs"]
      repeat: false
    }
  }

  // CPU Usage %
  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Usage"
      value: this.result + " %"
      command: ["sh", "-c", "awk '/cpu /{printf \"%.1f\", ($2+$4)*100/($2+$4+$5); exit}' /proc/stat"]
      repeat: true
      refreshInterval: 2000
    }
  }

  // CPU Temperature
  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Temp"
      value: this.result + "°C"
      command: ["sh", "-c", "cat /sys/class/hwmon/hwmon*/temp1_input 2>/dev/null | head -n1 | awk '{printf \"%.0f\", $1/1000}' || cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{printf \"%.0f\", $1/1000}' || echo \"N/A\""]
      repeat: true
      refreshInterval: 2000
    }
  }
}

