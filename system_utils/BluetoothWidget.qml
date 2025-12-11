import QtQuick
import Quickshell
import Quickshell.Bluetooth
import QtQuick.Controls
import "../theme"

Item {
    width: Theme.dimensions.barHeight
    height: Theme.dimensions.barHeight
    
    property var adapter: Bluetooth.defaultAdapter
    
    property bool isConnected: {
        if (!adapter) return false
        for (var i = 0; i < adapter.devices.length; i++) {
            if (adapter.devices[i].connected) {
                return true
            }
        }
        return false
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            Quickshell.execDetached("omarchy-launch-bluetooth")
          }

        ToolTip {
            visible: parent.containsMouse
            text: {
                if (!adapter) return "Bluetooth adapter not found"
                if (!adapter.enabled) return "Bluetooth is off"
                if (isConnected) return "Bluetooth is connected"
                return "Bluetooth is on but not connected"
            }
            delay: 500
        }
    }
    
    Text {
        text: {
            if (!adapter) return Theme.icons.bluetoothOff
            if (!adapter.enabled) return Theme.icons.bluetoothOff
            if (isConnected) return Theme.icons.bluetoothConnected
            return Theme.icons.bluetooth
        }
        font.family: Theme.fonts.family
        font.pixelSize: Theme.fonts.iconSize
        color: {
            if (!adapter || !adapter.enabled) return Theme.colors.foregroundDark
            if (isConnected) return Theme.colors.blue
            return Theme.colors.foreground
        }
        anchors.centerIn: parent
    }
}
