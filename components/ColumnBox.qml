import QtQuick
import Quickshell
import "../theme"

Rectangle {
  id: box
  
  default property alias content: column.children
  property int padding: 0
  property int spacing: 0

  width: parent.width - Theme.padding.medium * 2
  height: column.implicitHeight + Theme.padding.small * 2
  color: Theme.colors.backgroundLight
  border.color: Theme.colors.backgroundLight
  border.width: Theme.borders.width
  radius: Theme.borders.radius

  Column {
    id: column
    width: parent.width
    padding: box.padding
    leftPadding: box.leftPadding
    rightPadding: box.rightPadding
    topPadding: box.topPadding
    bottomPadding: box.bottomPadding
    spacing: box.spacing
  }
}
