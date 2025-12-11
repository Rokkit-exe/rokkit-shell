import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"
import "../components/" as Components

Components.ColumnBox {
  spacing: Theme.spacing.small
  padding: Theme.padding.small

  Components.RowBox {
    padding: Theme.padding.medium

    Components.Icon {
      text: Theme.icons.cpu
      color: Theme.colors.green
    }

    Text {
      text: "GPU"
      color: Theme.colors.green
      font.family: Theme.fonts.family
      font.pixelSize: Theme.fonts.iconSize
      font.bold: true
      anchors.verticalCenter: parent.verticalCenter
      padding: Theme.padding.small
    }
  }

  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Model"
      value: this.result
      command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"GPU\") | .result[0].name'"]
      repeat: true
      refreshInterval: 2000
    }
  }

  Components.RowBox {
    padding: Theme.padding.medium


    Components.TextProcess {
      name: "Usage"
      value: this.result + " %"
      command: ["bash", "-c", "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 'N/A'"]
      repeat: true
      refreshInterval: 2000
    }
  }

  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Used"
      value: this.result
      command: ["bash", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_used | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
      repeat: true
      refreshInterval: 2000
    }
  }


  Components.RowBox {
    padding: Theme.padding.medium

    Components.TextProcess {
      name: "Total"
      value: this.result
      command: ["bash", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_total | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
      repeat: true
      refreshInterval: 2000
    }
  }
}
