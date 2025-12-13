import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Bluetooth
import "../../theme"
import "../../components" as Components
import "../../functions"

Item {
  id: bluetoothWidget
  width: Theme.dimensions.barHeight
  height: Theme.dimensions.barHeight

  property var bar: null
  property var adapter: Bluetooth.defaultAdapter
  property bool bluetoothEnabled: adapter ? adapter.enabled : false
  property var devices: adapter ? adapter.devices : []
  
  property bool isConnected: false

  Repeater {
    model: bluetoothWidget.adapter ? bluetoothWidget.adapter.devices : []
    
    delegate: Item {
      property bool deviceConnected: modelData.connected
      onDeviceConnectedChanged: {
          console.log("Bluetooth device connection changed:", deviceConnected)
          bluetoothWidget.isConnected = deviceConnected ? true : false
      }
    }
  } 

  BluetoothMenu {
    id: bluetoothMenu
    adapter: bluetoothWidget.adapter
    bar: bluetoothWidget.bar
  }
  
  Components.MouseArea {
    id: bluetoothArea
    anchors.fill: parent
    
    onRightClick: () => Quickshell.execDetached("omarchy-launch-bluetooth")
    onLeftClick: () => {
      Functions.toggleMenu(bluetoothWidget.bar, bluetoothMenu, bluetoothArea)
    }
  }
  
  Components.Text {
    text: {
      if (!bluetoothWidget.bluetoothEnabled) return Theme.icons.bluetoothOff
      if (bluetoothWidget.isConnected) return Theme.icons.bluetoothConnected
      return Theme.icons.bluetooth
    }
    font.pixelSize: Theme.fonts.size.medium
    color: {
      if (!bluetoothWidget.bluetoothEnabled) return Theme.colors.foregroundDark
      if (bluetoothWidget.isConnected) return Theme.colors.blue
      return Theme.colors.foreground
    }
    anchors.centerIn: parent
  }
}
