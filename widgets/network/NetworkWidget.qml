import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "../../theme"
import "../../components" as Components
import "../../functions"

Item {
    id: networkWidget
    width: Theme.dimensions.barHeight
    height: Theme.dimensions.barHeight

    property var bar: null
    property string connectionStatus: "disconnected"
    property string currentInterfaces: []
    property string wirelessInterface: ""
    property string ssid: ""
    property var networks: []
    property int signalStrength: 0
    property var refreshNetworks: () => {
      scanProcess.running = true
    }
    property var connectToNetwork: (ssid, password) => {
      console.log("Connecting to network:", ssid)
      connectProcess.command = ["sh", "-c", `iwctl --passphrase ${password} station ${networkWidget.wirelessInterface} connect '${ssid}'`]
      connectProcess.running = true
    }

    function updateCurrentInterfaces(n) {
      currentInterfaces = n
      networkMenu.currentInterfaces = n
    }

    // In NetworkMenu.qml
    

    NetworkMenu {
      id: networkMenu
      bar: networkWidget.bar
      connectionStatus: networkWidget.connectionStatus
      currentInterfaces: networkWidget.currentInterfaces
      wirelessInterface: networkWidget.wirelessInterface
      networks: networkWidget.networks
      refreshNetworks: networkWidget.refreshNetworks
      isScanning: scanProcess.running
      connectToNetwork: networkWidget.connectToNetwork
    }
    HyprlandFocusGrab {
      id: focusGrab
      active: networkMenu.visible
      windows: [networkMenu]
    }
    Component.onCompleted: {
      ethernetCheck.running = true
      wirelessInterface.running = true
      scanProcess.running = networkMenu.visible
    }

    // Check for device status
    Process {
      id: ethernetCheck
      running: true
      
      command: ["bash", "-c", "ip link show | grep 'state UP' | awk -F': ' '{print $2}'"]
      
      stdout: StdioCollector {
        onStreamFinished: {
          let lines = this.text.trim().split("\n")
          let interfaces = []
          let hasEthernet = false
          let hasWifi = false
          
          for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim()
              
            // Skip empty lines
            if (!line || line === "") continue
            let type = ""

            if (line.includes("en") || line.includes("eth")) {
                type = "ethernet"
                hasEthernet = true
            } else if (line.includes("wl") || line.includes("wi")) {
                type = "wifi"
                hasWifi = true
            } else {
                // Skip loopback and other interfaces
                continue
            }

            let inter = new Object()
            inter.name = line
            inter.type = type
            console.log(`Detected active interface: ${inter.name} (${inter.type})`)
            interfaces.push(inter)
          }
          
          // ✅ Set connection status AFTER checking all interfaces
          if (hasEthernet) {
              networkWidget.connectionStatus = "ethernet"
          } else if (hasWifi) {
              networkWidget.connectionStatus = "wifi"
          } else {
              networkWidget.connectionStatus = "disconnected"
          }
          
          // ✅ Set interfaces at the end
          networkWidget.updateCurrentInterfaces(interfaces)
          console.log("Current interfaces:", networkWidget.currentInterfaces.length)
        }
      }
    }
    // Get signal strength
    Process {
      id: signalCheck
      running: false
      
      command: ["bash", "-c", "iwctl station wlan0 get-networks | grep '" + networkWidget.ssid + "'"]
      
      stdout: StdioCollector {
        onStreamFinished: {
          let output = this.text.trim()
          console.log("Signal check output:", output)
          // Extract signal bars (typically shows as asterisks)
          let match = output.match(/(\*+)/)
          if (match) {
              networkWidget.signalStrength = (match[1].length / 4) * 100
          }
        }
      }
    }
    Process {
      id: wirelessInterface
      running: true
      command: ["bash", "-c", "iw dev | grep Interface | awk '{print $2}'"]

      stdout: StdioCollector {
        onStreamFinished: {
          networkWidget.wirelessInterface = this.text.trim()
        }
      }
    }

    Process {
      id: scanProcess
      running: false
      command: {
        if (!networkWidget.wirelessInterface) {
            console.log("No wireless interface found, skipping scan.")
            return ["echo", "No wireless interface"]
        }
        return ["sh", "-c", `iwctl station ${networkMenu.wirelessInterface} scan && sleep 5 && iwctl station ${networkMenu.wirelessInterface} get-networks | tail -n +5`]
      }
      
      
      stdout: StdioCollector {
        onStreamFinished: {
          let tempNetworks = []
          function stripAnsi(text, replaceWith = '') {
            return text.replace(/\x1b\[[0-9;]*m/g, replaceWith)
          }
          function removeLeadingAnsi(text) {
              return text.replace(/^\x1b\[0m/, '')
          }
          function findStrength(text) {
            const parts = stripAnsi(text, ':').split(':')
            return parts[0].length / 4
          }
          const lines = this.text.trim().split("\n")

          for (let i = 0; i < lines.length; i++) {
            const line = removeLeadingAnsi(lines[i].trim())
            if (line === "") continue
            
            // Remove leading > (indicates connected network)
            const active = line.startsWith(">")
            const cleanLine = line.replace(/^>\s*/, '').trim()
            
            // Split by multiple spaces (2 or more)
            const parts = cleanLine.split(/\s{2,}/)
            
            if (parts.length >= 2) {
              const ssid = stripAnsi(parts[0]).trim()
              const security = parts[1] ? stripAnsi(parts[1].trim()) : ""
              const signal = parts[2] ? findStrength(parts[2].trim()) : 0

              console.log(`Found network - SSID: ${ssid}, Security: ${security}, Signal: ${signal}, Active: ${active}`)
              tempNetworks.push({
                  ssid: ssid,
                  security: security,
                  signal: signal,
                  active: active
              })
            }
          }
          networkWidget.networks = tempNetworks
          console.log("Finished parsing networks. Total found:", networkWidget.networks.length)
        }
      }
    }

    Process {
      id: connectProcess
      running: false
      command: []
      stdout: StdioCollector {
        onStreamFinished: {
          connectionStatus = connectProcess.exitCode === 0 ? "wifi" : "disconnected"
          ethernetCheck.running = true
          scanProcess.running = true
        }
      }
    }

    Process {
      id: disconnectProcess
      running: false
      command: ["sh", "-c", `iwctl station ${networkMenu.wirelessInterface} disconnect`]
      stdout: StdioCollector {
        onStreamFinished: {
          connectionStatus = "disconnected"
          ethernetCheck.running = true
          scanProcess.running = true
        }
      }
    }

    Process {
      id: ethernetIpProcess
      running: false
      command: ["sh", "-c", `ip addr show ${networkWidget.ethernetInterface} | grep "inet " | awk '{print $2}' | awk -F '/' '{print $1}'`]

      stdout: StdioCollector {
        onStreamFinished: {
          let ip = this.text.trim()
          console.log("Ethernet IP Address:", ip)
        }
      }
    }

    Process {
      id: wifiIpProcess
      running: false
      command: ["sh", "-c", `ip addr show ${networkMenu.wirelessInterface} | grep "inet " | awk '{print $2}' | awk -F '/' '{print $1}'`]
      stdout: StdioCollector {
        onStreamFinished: {
          let ip = this.text.trim()
          console.log("WiFi IP Address:", ip)
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
    
    Components.MouseArea {
      id: mouseArea
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor

      onLeftClick: () => Functions.toggleMenu(networkWidget.bar, networkMenu, mouseArea)
      onRightClick: () => Quickshell.execDetached("omarchy-launch-wifi")
    }
    
    Components.Text {
        text: {
            if (networkWidget.connectionStatus === "ethernet") {
                return Theme.icons.ethernet
            } else if (networkWidget.connectionStatus === "wifi") {
                if (networkWidget.signalStrength > 75) return Theme.icons.wifi4
                if (networkWidget.signalStrength > 50) return Theme.icons.wifi3
                if (networkWidget.signalStrength > 25) return Theme.icons.wifi2
                if (networkWidget.signalStrength > 0) return Theme.icons.wifi1
                return Theme.icons.wifi0
            }
            return Theme.icons.wifiOff
        }
        font.pixelSize: Theme.fonts.size.medium
        color: networkWidget.connectionStatus === "disconnected" ? Theme.colors.foregroundDark : Theme.colors.blue
        anchors.centerIn: parent
    }
}
