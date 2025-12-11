// LogoWidget
//
import QtQuick
import Quickshell
import "./theme"

Item {
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight
  anchors.verticalCenter: parent.verticalCenter

  Text {
    text: Theme.icons.archLogo
    font.family: Theme.fonts.family
    font.pixelSize: Theme.fonts.logoSize
    color: Theme.colors.blue
    anchors.centerIn: parent
  }
}
