import QtQuick
import Quickshell
import "../theme/"

Text {
  id: bluetoothIcon

  property string source: ""

  function mapIcon(source) {
    switch(source) {
      case "input-gaming":
        return Theme.icons.controller
      case "input-mouse":
        return Theme.icons.mouse
      case "audio-headphones":
        return Theme.icons.headphones
      case "audio-speaker":
        return Theme.icons.speaker
      case "input-keyboard":
        return Theme.icons.keyboard
      case "phone":
        return Theme.icons.phone
      default:
        return Theme.icons.bluetooth
    }
  }

  text: mapIcon(source)
  color: Theme.colors.foreground
  font.family: Theme.fonts.family
  font.pixelSize: Theme.fonts.size.medium
  anchors.verticalCenter: parent.verticalCenter
}
