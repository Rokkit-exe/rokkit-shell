import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "../../theme"        
import "../../functions"
import "../../components" as Components


Components.PopupWindow {
  id: networkMenu
  implicitWidth: 400
  implicitHeight: 400

  property var connectionStatus: "disconnected"
  property var currentInterfaces: []
  property var wirelessInterface: ""
  property bool isScanning: false
  property var networks: []
  property var refreshNetworks: null
  property bool isFocused: false
  property var connectToNetwork: null
  
  Components.ColumnBox {
    id: networkColumn
    width: parent.width
    height: parent.height
    spacing: Theme.spacing.large

    Components.RowBox {
      id: headerRow
      width: parent.width
      height: Theme.dimensions.menuItemHeight
      padding: Theme.spacing.medium
      spacing: Theme.spacing.medium

      Components.Icon {
        id: headerIcon
        text: Theme.icons.wifi4
        color: Theme.colors.blue
        font.pixelSize: Theme.fonts.size.large
        anchors.verticalCenter: parent.verticalCenter
      }

      Components.Text {
        id: headerText
        text: "Network"
        color: Theme.colors.blue
        font.pixelSize: Theme.fonts.size.large
        anchors.verticalCenter: parent.verticalCenter
      }

      Item {
        width: networkMenu.width - headerIcon.width - headerText.width - networkToggle.width - Theme.spacing.medium * 5
        height: 1
      }

      Components.ToggleButton {
        id: networkToggle
        checked: networkMenu.connectionStatus !== "disconnected"
        toggle: () => {
          if (networkMenu.connectionStatus === "disconnected") {
            Quickshell.execDetached("omarchy-launch-wifi")
          } else {
            Quickshell.execDetached("nmcli radio wifi off")
          }
        }
      }
    }
    
    Components.ColumnBox {
      id: interfaceColumn
      width: parent.width - Theme.spacing.medium * 2
      height: Theme.dimensions.menuItemHeight * networkMenu.currentInterfaces.length + Theme.spacing.small * (networkMenu.currentInterfaces.length - 1) + Theme.spacing.medium * 2
      spacing: Theme.spacing.small
      padding: Theme.spacing.medium

      Repeater {
        model: networkMenu.currentInterfaces || []
        delegate: Components.RowBox {
          width: parent.width - Theme.spacing.medium * 2
          height: Math.max(Theme.dimensions.menuItemHeight, statusLabel.implicitHeight, statusValue.implicitHeight)
          spacing: Theme.spacing.medium
          padding: Theme.spacing.medium


          Components.Text {
            id: statusLabel
            text: modelData.name + ":"
            font.pixelSize: Theme.fonts.size.medium
          }

          Components.Icon {
            id: statusText
            text: {
              switch (modelData.type) {
                case "ethernet":
                  return Theme.icons.ethernet
                case "wifi":
                  return Theme.icons.wifi4
                default:
                  console.log("Unknown network type:", modelData.type)
                  return Theme.icons.wifiOff
              }
            }
            font.pixelSize: Theme.fonts.size.medium
          }

          Components.Text {
            id: statusValue
            text: {
              switch (modelData.type) {
                case "ethernet":
                  return "Connected"
                case "wifi":
                  return "Connected"
                default:
                  return "Disconnected"
              } 
            }
            font.pixelSize: Theme.fonts.size.medium
          }
        }
      }
    }
    

    Components.RowBox {
      id: networksHeaderRow
      width: parent.width
      height: Theme.dimensions.barHeight
      spacing: Theme.spacing.medium
      padding: Theme.spacing.medium

      Components.Text {
        id: networksHeaderText
        text: "Available Networks"
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
        anchors.verticalCenter: parent.verticalCenter
      }

      Item {
        width: networksHeaderRow.width - networksHeaderText.width - scanButton.width - Theme.spacing.medium * 4
        height: 1
      }

      Components.MouseArea {
        id: scanArea
        width: scanButton.width
        height: scanButton.height

        onLeftClick: () => {
          if (!networkMenu.isScanning) {
            if (networkMenu.refreshNetworks) {
              networkMenu.refreshNetworks()
            }
          }
        }

        Components.Icon {
          id: scanButton
          text: Theme.icons.refresh
          font.pixelSize: Theme.fonts.size.xlarge
          color: scanArea.containsMouse ? Theme.colors.blue : Theme.colors.foregroundDark
          anchors.verticalCenter: parent.verticalCenter

          // Continuous rotation animation
          RotationAnimator on rotation {
            id: spinAnimator
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite  // Spin forever
            running: networkMenu.isScanning
          }
        }
      }
    }
    ScrollView {
      id: networksScrollView
      width: parent.width - Theme.spacing.medium * 2
      height: networkMenu.height - headerRow.height - networksHeaderRow.height - interfaceColumn.height - Theme.spacing.large * 3
      clip: true
      contentHeight: networkMenu.height - headerRow.height - networksHeaderRow.height - interfaceColumn.height - Theme.spacing.large * 8
      ScrollBar.vertical.policy: ScrollBar.AsNeeded

      focus: false

      Components.ColumnBox {
        id: networksList
        width: parent.width - Theme.spacing.medium * 2
        height: parent.height - headerRow.height - networksHeaderRow.height - Theme.spacing.large * 2
        spacing: Theme.spacing.medium
        padding: Theme.spacing.medium

        Repeater {
          model: networkMenu.networks
          delegate: Components.MouseArea {
            id: mouseArea
            width: parent.width
            height: Theme.dimensions.menuItemHeight
            onLeftClick: () => {
              networkRow.visible = false
              passwordRow.visible = true
              Quickshell.execDetached(`iwctl station ${networkMenu.wirelessInterface} connect "${modelData.ssid}"`)
            }
            Components.RowBox {
              id: passwordRow
              width: parent.width
              height: Theme.dimensions.menuItemHeight
              visible: false

              Components.Text {
                id: activeIndicator
                text: "Enter Password:"
                font.pixelSize: Theme.fonts.size.small
                color: Theme.colors.blue
                anchors.verticalCenter: parent.verticalCenter
              }
              
                Rectangle {
                  width: networksList.width - activeIndicator.width - Theme.spacing.medium * 4
                  height: Theme.dimensions.menuItemHeight
                  color: Theme.colors.backgroundLight
                  border.color: Theme.colors.border
                  radius: Theme.borders.radius
                  FocusScope {
                    id: passwordFocusScope
                    width: networksList.width - activeIndicator.width - Theme.spacing.medium * 4
                    height: Theme.dimensions.menuItemHeight
                    focus: passwordRow.visible
                    TextInput {
                      id: passwordInput
                      anchors.fill: parent
                      anchors.margins: Theme.spacing.medium
                      
                      echoMode: TextInput.Password  // ✅ This hides the password
                      passwordCharacter: "•"         // Optional: change bullet character
                      
                      font.pixelSize: Theme.fonts.size.medium
                      color: Theme.colors.foreground
                      verticalAlignment: TextInput.AlignVCenter
                      focus: true
                      
                      // Placeholder text (manual implementation)
                      Text {
                        text: "Password"
                        font: passwordInput.font
                        color: Theme.colors.foreground
                        visible: !passwordInput.text && !passwordInput.activeFocus
                        anchors.verticalCenter: parent.verticalCenter
                      }
                      
                      // ✅ Handle Enter key - connect to network
                      Keys.onReturnPressed: {
                          // Connect with password
                          if (networkMenu.connectToNetwork) {
                              networkMenu.connectToNetwork(modelData.ssid, passwordInput.text)
                          }
                          // Hide password row and clear
                          passwordRow.visible = false
                          networkRow.visible = true
                          passwordInput.text = ""
                      }
                      
                      // ✅ Handle Escape key - cancel
                      Keys.onEscapePressed: {
                          passwordInput.text = ""
                          passwordRow.visible = false
                          networkRow.visible = true
                      }
                      
                      // ✅ Auto-focus when component is ready
                      Component.onCompleted: {
                          if (passwordRow.visible) {
                              forceActiveFocus()
                          }
                      }
                    }
                }
              }
            }
            Components.RowBox {
              id: networkRow
              width: parent.width
              height: Theme.dimensions.menuItemHeight
              spacing: Theme.spacing.medium
              padding: Theme.spacing.small
              color: containsMouse ? Theme.colors.backgroundLight : Theme.colors.background

              Components.Text {
                id: ssidText
                text: modelData.ssid
                font.pixelSize: Theme.fonts.size.medium
                color: Theme.colors.foreground
                anchors.verticalCenter: parent.verticalCenter
              }

              Components.Text {
                id: securityText
                text: modelData.security
                font.pixelSize: Theme.fonts.size.medium
                color: Theme.colors.foregroundDark
                anchors.verticalCenter: parent.verticalCenter
              }

              Item {
                width: networksList.width - ssidText.width - securityText.width - signalText.width - Theme.spacing.medium * 5
                height: 1
              }

              Components.Icon {
                id: signalText
                text: Functions.getSignalIcon(modelData.signal)
                font.pixelSize: Theme.fonts.size.medium
                color: Theme.colors.foreground
                anchors.verticalCenter: parent.verticalCenter
              }
            }
          }
        }
      }
    }
  }
}

