import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components/" as Components

Components.ColumnBox {
  spacing: Theme.spacing.small
  padding: Theme.spacing.small

  Components.RowBox {
    padding: Theme.spacing.medium

    Components.Icon {
      text: Theme.icons.memory
      color: Theme.colors.purple
    }

    Components.Text {
      text: "Memory"
      color: Theme.colors.purple
      font.pixelSize: Theme.fonts.iconSize
      anchors.verticalCenter: parent.verticalCenter
      padding: Theme.spacing.small
    }
  }

  Components.RowBox {
    padding: Theme.spacing.medium

    Components.TextProcess {
      name: "Usage"
      value: this.result + " %"
      command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1f\", (t-a)/1024/1024}' /proc/meminfo"]
      repeat: true
      refreshInterval: 2000
    }
  }

  Components.RowBox {
    padding: Theme.spacing.medium
    Components.TextProcess {
      name: "Used"
      value: this.result
      command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1fGB\", (t-a)/1024/1024}' /proc/meminfo"]
      repeat: true
      refreshInterval: 2000
    }
  }


  Components.RowBox {
    padding: Theme.spacing.medium
    Components.TextProcess {
      name: "Total"
      value: this.result
      command: ["bash", "-c", "awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf \"%.1fGB\", t/1024/1024}' /proc/meminfo"]
      repeat: true
      refreshInterval: 2000
    }
  }
}
