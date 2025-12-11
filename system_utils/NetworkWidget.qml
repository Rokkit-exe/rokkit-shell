import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Item {
    id: root
    width: Theme.dimensions.barHeight
    height: Theme.dimensions.barHeight
    
    property string connectionStatus: "disconnected"
    property string ssid: ""
    property int signalStrength: 0
    
    
    // Check for device status
    Process {
      id: ethernetCheck
      running: true
      
      command: ["bash", "-c", "ip link show | grep 'state UP'"]
      
      stdout: StdioCollector {
        onStreamFinished: {
          let output = this.text.trim()
          if (output.includes("eth0") || output.includes("enp") || output.includes("eno")) {
              root.connectionStatus = "ethernet"
            } else if (output.includes("wlan0") || output.includes("wl")) {
              root.connectionStatus = "wifi"
            } else {
              root.connectionStatus = "disconnected"
            }
        }
      }
    }
    // Get signal strength
    Process {
        id: signalCheck
        running: false
        
        command: ["bash", "-c", "iwctl station wlan0 get-networks | grep '" + root.ssid + "'"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let output = this.text.trim()
                // Extract signal bars (typically shows as asterisks)
                let match = output.match(/(\*+)/)
                if (match) {
                    root.signalStrength = (match[1].length / 4) * 100
                }
            }
        }
    }
    
    
    
    // Refresh every 5 seconds
    Timer {
        running: true
        repeat: true
        interval: 5000
        onTriggered: {
            ethernetCheck.running = true
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            // Launch terminal with iwctl
            Quickshell.execDetached("omarchy-launch-wifi")
        }
    }
    
    Text {
        text: {
            if (root.connectionStatus === "ethernet") {
                return Theme.icons.ethernet
            } else if (root.connectionStatus === "wifi") {
                if (root.signalStrength > 75) return Theme.icons.wifi4
                if (root.signalStrength > 50) return Theme.icons.wifi3
                if (root.signalStrength > 25) return Theme.icons.wifi2
                if (root.signalStrength > 0) return Theme.icons.wifi1
                return Theme.icons.wifi0
            }
            return Theme.icons.wifiOff
        }
        
        font.family: Theme.fonts.family
        font.pixelSize: Theme.fonts.iconSize
        color: root.connectionStatus === "disconnected" ? Theme.colors.foregroundDark : Theme.colors.blue
        anchors.centerIn: parent
    }
}
