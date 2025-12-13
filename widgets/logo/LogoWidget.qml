// LogoWidget
//
import QtQuick
import Quickshell
import "../../theme"
import "../../components" as Components

Item {
  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight
  anchors.verticalCenter: parent.verticalCenter

  Components.Icon {
    text: Theme.icons.archLogo
    font.pixelSize: Theme.fonts.size.large
    color: Theme.colors.blue
    anchors.centerIn: parent
  }
}
