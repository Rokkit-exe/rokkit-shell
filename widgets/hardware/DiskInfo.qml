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
      text: Theme.icons.disk
      color: Theme.colors.teal
      font.pixelSize: Theme.fonts.iconSize
    }

    Components.Text {
      text: "Disk"
      color: Theme.colors.teal
      font.pixelSize: Theme.fonts.iconSize
      anchors.verticalCenter: parent.verticalCenter
      padding: Theme.spacing.small
      bottomPadding: Theme.spacing.small
    }
  }

  Components.RowBox {
    padding: Theme.spacing.medium

    Components.TextProcess {
      name: "Model"
      value: this.result
      command: ["bash", "-c", "lsblk -dno MODEL $(findmnt | grep /boot | awk '{print $2}' | sed -E 's/(nvme[0-9]+n[0-9]+)p[0-9]+/\\1/; s/(sd[a-z]+)[0-9]+/\\1/') 2>/dev/null | xargs || echo 'N/A'"]
      repeat: false
    }
  }

  Components.RowBox {
    padding: Theme.spacing.medium

    Components.TextProcess {
      name: "Filesystem"
      value: this.result
      command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].filesystem'"]
      repeat: false
    }
  }

  Components.RowBox {
    padding: Theme.spacing.medium
    Components.TextProcess {
      name: "Used"
      value: this.result
      command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].bytes.used' | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
      repeat: false
      refreshInterval: 2000
    }
  }


  Components.RowBox {
    padding: Theme.spacing.medium
    Components.TextProcess {
      name: "Total"
      value: this.result
      command: ["bash", "-c", "fastfetch -j | jq -r '.[] | select(.type == \"Disk\") | .result[0].bytes.total' | awk '{printf \"%.1f GB\", $1/1024/1024/1024}'"]
      repeat: true
      refreshInterval: 2000
    }
  }
}
