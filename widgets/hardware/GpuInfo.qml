import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components/" as Components

Components.ColumnBox {
  height: title.implicitHeight + model.implicitHeight + usage.implicitHeight + used.implicitHeight + total.implicitHeight + Theme.spacing.medium * 4 + Theme.spacing.small * 6
  width: parent ? parent.width - Theme.spacing.medium * 2 : Math.max(title.implicitWidth, model.implicitWidth, usage.implicitWidth, used.implicitWidth, total.implicitWidth) + Theme.spacing.medium * 2 
  spacing: Theme.spacing.small
  padding: Theme.spacing.medium
  color: Theme.colors.backgroundLight

  Components.RowBox {
    id: title
    width: gpuIcon.implicitWidth + gpuText.implicitWidth + Theme.spacing.medium * 2
    height: Math.max(gpuIcon.implicitHeight, gpuText.implicitHeight) + Theme.spacing.small * 2
    spacing: Theme.spacing.small
    padding: Theme.spacing.small

    Components.Icon {
      id: gpuIcon
      text: Theme.icons.cpu
      color: Theme.colors.green
    }

    Components.Text {
      id: gpuText
      text: "GPU"
      color: Theme.colors.green
      font.pixelSize: Theme.fonts.size.medium
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: Theme.spacing.small
    }
  }

  Components.TextProcess {
    id: model
    name: "Model"
    value: this.result
    command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"GPU\") | .result[0].name'"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: usage
    name: "Usage"
    value: this.result + " %"
    command: ["bash", "-c", "cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null || echo 'N/A'"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: used
    name: "Used"
    value: this.result
    command: ["bash", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_used | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }



  Components.TextProcess {
    id: total
    name: "Total"
    value: this.result
    command: ["bash", "-c", "cat /sys/class/drm/card1/device/mem_info_vram_total | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }
}
