pragma Singleton
import QtQuick
import Quickshell.Bluetooth
import "../theme"

QtObject {
  id: functions

  function toggleMenu(bar, menu, mouseArea) {
    // let areaGlobal = mouseArea.mapToGlobal(0, 0)
    // let barGlobal = bar.contentItem.mapToGlobal(0, 0)
    // let relativeX = areaGlobal.x - barGlobal.x
    //
    // menu.anchor.rect.x = relativeX - (menu.width / 2) + (mouseArea.width / 2)
    menu.visible = !menu.visible
  }

  function getBatteryIcon(value) {
    // Assuming value is between 0.0 and 1.0
    if (value > 0.9) return Theme.icons.battery9
    if (value > 0.8) return Theme.icons.battery8
    if (value > 0.7) return Theme.icons.battery7
    if (value > 0.6) return Theme.icons.battery6
    if (value > 0.5) return Theme.icons.battery5
    if (value > 0.4) return Theme.icons.battery4
    if (value > 0.3) return Theme.icons.battery3
    if (value > 0.2) return Theme.icons.battery2
    if (value > 0.1) return Theme.icons.battery1
    return Theme.icons.battery0
  }

  function getBatteryChargingIcon(value) {
    // Assuming value is between 0.0 and 1.0
    if (value > 0.9) return Theme.icons.batteryCharging9
    if (value > 0.8) return Theme.icons.batteryCharging8
    if (value > 0.7) return Theme.icons.batteryCharging7
    if (value > 0.6) return Theme.icons.batteryCharging6
    if (value > 0.5) return Theme.icons.batteryCharging5
    if (value > 0.4) return Theme.icons.batteryCharging4
    if (value > 0.3) return Theme.icons.batteryCharging3
    if (value > 0.2) return Theme.icons.batteryCharging2
    if (value > 0.1) return Theme.icons.batteryCharging1
    return Theme.icons.batteryCharging0
  }

  function getBatteryColor(value) {
    // Assuming value is between 0.0 and 1.0
    if (value > 0.35) return Theme.colors.blue
    if (value > 0.15) return Theme.colors.yellow
    return Theme.colors.red
  }

  function getSignalIcon(strength) {
    // strength is between 0.0 and 1.0
    if (strength > 0.75) return Theme.icons.wifi4
    if (strength > 0.5) return Theme.icons.wifi3
    if (strength > 0.25) return Theme.icons.wifi2
    if (strength > 0.0) return Theme.icons.wifi1
    return Theme.icons.wifi0
  }
}

