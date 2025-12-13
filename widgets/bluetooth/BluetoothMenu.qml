// BluetoothMenu
import QtQuick
import Quickshell
import Quickshell.Bluetooth
import QtQuick.Layouts
import QtQuick.Controls
import "../../theme"
import "../../components" as Components
import "../../functions"

Components.PopupWindow {
  id: bluetoothMenu
  
  implicitWidth: 400
  implicitHeight: 300

  property var adapter: null
  property bool isEnabled: adapter ? adapter.enabled : false
  property string adapterName: adapter ? adapter.adapterId : "No Adapter"
  property var enable: (value) => {
    if (adapter) {
      adapter.enabled = value
    }
  }
  property bool isDiscovering: adapter ? adapter.discovering : false
  property var toggleScan: () => {
    if (adapter) {
      adapter.discovering = !adapter.discovering
    }
  }
  property var devices: adapter ? adapter.devices : []
  property var isKnown: (device) => {
    if (!device) return false
    return device.paired || device.trusted
  }
  
  property var deviceState: (device) => {
    if (!device) return "unknown"
    if (device.state === BluetoothDeviceState.Disconnecting) return "Disconnecting"
    if (device.state === BluetoothDeviceState.Connecting) return "Connecting"
    if (device.connected) return "Connected"
    if (device.pairing) return "Pairing"
    if (device.paired || device.trusted) return "Paired"
    if (!device.connected) return "Disconnected"
    return "Unknown"
  }

  property var toggleConnection: (device) => {
    let state = bluetoothMenu.deviceState(device)
    if (state === "Connected") {
      device.disconnect()
    } else if (state === "Paired") {
      device.connect()
    } else if (state === "Disconnected" || state === "Pairing") {
      device.pair()
    } else {
      device.cancelPair()
    }
  }

  onVisibleChanged: {
    if (!visible && adapter) {
      adapter.discovering = false
    }
  }

  Components.ColumnBox {
    id: menuColumn
    width: parent.width
    height: parent.height
    color: Theme.colors.background
    padding: Theme.spacing.small
    spacing: Theme.spacing.large

    Components.RowBox {
      id: headerRow
      width: parent.width
      height: Theme.dimensions.itemsHeight + Theme.spacing.small * 4
      spacing: Theme.spacing.medium
      padding: Theme.spacing.medium

      Components.Icon {
        id: bluetoothIcon
        text: Theme.icons.bluetooth
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.blue
        anchors.verticalCenter: parent.verticalCenter
      }

      Components.Text {
        id: bluetoothText
        text: "Bluetooth"
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.blue
        anchors.verticalCenter: parent.verticalCenter
      }

      Item {
        width: bluetoothMenu.width - bluetoothIcon.width - bluetoothText.width - bluetoothToggle.width - Theme.spacing.medium * 6
        height: 1
      }

      Components.ToggleButton {
        id: bluetoothToggle
        checked: bluetoothMenu.isEnabled
        toggle: () => {
          bluetoothMenu.adapter.discovering = false
          bluetoothMenu.adapter.enabled = !bluetoothMenu.adapter.enabled
        }
      }

    }

    Components.ColumnBox {
      id: devicesSection
      width: parent.width - Theme.spacing.medium * 2
      height: parent.height - headerRow.height - Theme.spacing.large * 2
      spacing: Theme.spacing.medium
      anchors.horizontalCenter: parent.horizontalCenter
      
      Components.RowBox {
        id: devicesRow
        width: bluetoothMenu.implicitWidth - Theme.spacing.medium * 2
        height: Theme.dimensions.itemsHeight + Theme.spacing.small * 2
        padding: Theme.spacing.medium
        anchors.horizontalCenter: parent.horizontalCenter

        Components.Text {
          id: devicesLabel
          text: "Adapter: " + bluetoothMenu.adapterName 
          font.pixelSize: Theme.fonts.size.small
          color: Theme.colors.foreground
          anchors.verticalCenter: parent.verticalCenter
        }

        Item {
          width: bluetoothMenu.width - devicesLabel.width - Theme.spacing.medium * 6
          height: 1
        }

        Components.MouseArea {
          id: scanArea
          width: scanButton.width
          height: scanButton.height

          onLeftClick: () => {
            bluetoothMenu.toggleScan()
          }

          Components.Icon {
            id: scanButton
            text: Theme.icons.refresh
            font.pixelSize: Theme.fonts.size.large
            color: scanArea.containsMouse ? Theme.colors.blue : Theme.colors.foregroundDark
            anchors.verticalCenter: parent.verticalCenter

            // Continuous rotation animation
            RotationAnimator on rotation {
              id: spinAnimator
              from: 0
              to: 360
              duration: 1000
              loops: Animation.Infinite  // Spin forever
              running: bluetoothMenu.isDiscovering
            }
          }
        } 
      }

      ScrollView {
        id: devicesScrollView
        width: parent.width
        height: bluetoothMenu.implicitHeight - headerRow.height - devicesRow.height - Theme.spacing.large * 3
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded      
        
        Components.ColumnBox {
          id: deviceList
          width: parent.width
          height: bluetoothMenu.implicitHeight - headerRow.height - devicesRow.height - Theme.spacing.large * 3
          spacing: Theme.spacing.medium
          anchors.horizontalCenter: parent.horizontalCenter

          Repeater {
            model: bluetoothMenu.devices

            delegate: Components.MouseArea {
              id: mouseArea
              width: parent.width
              height: Theme.dimensions.menuItemHeight

              onLeftClick: () => bluetoothMenu.toggleConnection(modelData)

              Rectangle {
                anchors.fill: parent
                color: parent.containsMouse ? Theme.colors.backgroundLight : "transparent"
                border.color: Theme.colors.backgroundLight
                border.width: parent.containsMouse ? 1 : 0
                radius: Theme.borders.radius
                opacity: parent.enabled ? 1 : 0.5
              
                Components.RowBox {
                  id: deviceRow
                  width: deviceList.width
                  height: Theme.dimensions.menuItemHeight
                  spacing: Theme.spacing.medium
                  padding: Theme.spacing.small
                  anchors.horizontalCenter: parent.horizontalCenter

                  Components.BluetoothIcon {
                    id: deviceIcon
                    source: modelData.icon ? modelData.icon : ""
                    leftPadding: Theme.spacing.small
                  }

                  Components.Text {
                    id: deviceName
                    text: modelData.name
                    font.pixelSize: Theme.fonts.size.small
                    color: Theme.colors.foreground
                    anchors.verticalCenter: parent.verticalCenter
                  }

                  Components.Text {
                    id: deviceBattery

                    text: modelData.battery ? `${modelData.battery * 100}% ` + Functions.getBatteryIcon(modelData.battery) : ""
                    font.pixelSize: Theme.fonts.size.small
                    color: Theme.colors.foregroundDark
                    anchors.verticalCenter: parent.verticalCenter
                    visible: modelData.battery ? true : false
                  }

                  Item {
                    width: deviceRow.width - deviceIcon.width - deviceName.width - deviceBattery.width - deviceStatus.width - actionArea.width - Theme.spacing.medium * 5
                    height: 1
                  }

                  Components.Text {
                    id: deviceStatus
                    text: bluetoothMenu.deviceState(modelData)
                    font.pixelSize: Theme.fonts.size.small
                    color: modelData.connected ? Theme.colors.blue : Theme.colors.foregroundDark
                    anchors.verticalCenter: parent.verticalCenter
                    rightPadding: Theme.spacing.small
                  }

                  Components.MouseArea {
                    id: actionArea
                    width: bluetoothMenu.isKnown(modelData) ? deviceActionIcon.width + Theme.spacing.large : 0
                    height: deviceActionIcon.height
                    anchors.verticalCenter: parent.verticalCenter
                    visible: bluetoothMenu.isKnown(modelData)

                    onLeftClick: () => {
                      modelData.disconnect()
                      modelData.forget()
                      modelData.trusted = false
                    }

                    Rectangle {
                      anchors.fill: parent
                      color: parent.containsMouse ? Theme.colors.backgroundLight : "transparent"
                      border.color: Theme.colors.backgroundLight
                      border.width: parent.containsMouse ? 1 : 0
                      radius: Theme.borders.radius
                      anchors.verticalCenter: parent.verticalCenter
                    }
                    Components.Icon {
                      id: deviceActionIcon
                      text: Theme.icons.trash
                      font.pixelSize: Theme.fonts.size.medium
                      color: parent.containsMouse ? Theme.colors.red : Theme.colors.foregroundDark
                      anchors.verticalCenter: parent.verticalCenter
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  } 
}
