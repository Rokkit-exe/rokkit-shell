import QtQuick
import Quickshell
import "../theme"

Rectangle {
  id: box
  
  default property alias content: column.children
  property int padding: 0
  property int spacing: 0

  width: parent.width - Theme.spacing.medium * 2
  height: parent.height - Theme.spacing.medium * 2
  color: "transparent"
  border.color: "transparent"
  border.width: Theme.borders.width
  radius: Theme.borders.radius

  Column {
    id: column
    width: parent.width
    height: parent.height
    padding: box.padding
    spacing: box.spacing
  }
}
