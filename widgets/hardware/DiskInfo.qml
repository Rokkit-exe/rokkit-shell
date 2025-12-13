import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"
import "../../components/" as Components

Components.ColumnBox {
  height: title.implicitHeight + model.implicitHeight + filesystem.implicitHeight + usage.implicitHeight + total.implicitHeight + Theme.spacing.medium * 4 + Theme.spacing.small * 6
  width: parent.width ? parent.width - Theme.spacing.medium * 2 : Math.max(title.implicitWidth, model.implicitWidth, filesystem.implicitWidth, usage.implicitWidth, total.implicitWidth) + Theme.spacing.medium * 2
  spacing: Theme.spacing.small
  padding: Theme.spacing.medium
  color: Theme.colors.backgroundLight

  Components.RowBox {
    id: title
    width: diskIcon.implicitWidth + diskText.implicitWidth + Theme.spacing.medium * 2
    height: Math.max(diskIcon.implicitHeight, diskText.implicitHeight) + Theme.spacing.small * 2
    padding: Theme.spacing.small

    Components.Icon {
      id: diskIcon
      text: Theme.icons.disk
      color: Theme.colors.teal
      font.pixelSize: Theme.fonts.size.medium
    }

    Components.Text {
      id: diskText
      text: "Disk"
      color: Theme.colors.teal
      font.pixelSize: Theme.fonts.size.medium
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: Theme.spacing.small
    }
  }

  Components.TextProcess {
    id: model
    name: "Model"
    value: this.result
    command: ["bash", "-c", "lsblk -dno MODEL $(findmnt | grep /boot | awk '{print $2}' | sed -E 's/(nvme[0-9]+n[0-9]+)p[0-9]+/\\1/; s/(sd[a-z]+)[0-9]+/\\1/') 2>/dev/null | xargs || echo 'N/A'"]
    repeat: false
    padding: Theme.spacing.small
  }


  Components.TextProcess {
    id: filesystem
    name: "Filesystem"
    value: this.result
    command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].filesystem'"]
    repeat: false
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: usage
    name: "Used"
    value: this.result
    command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].bytes.used' | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
    repeat: false
    refreshInterval: 2000
    padding: Theme.spacing.small
  }

  Components.TextProcess {
    id: total
    name: "Total"
    value: this.result
    command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].bytes.total' | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
    repeat: true
    refreshInterval: 2000
    padding: Theme.spacing.small
  }
}
