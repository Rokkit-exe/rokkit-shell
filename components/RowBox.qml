import QtQuick
import Quickshell
import "../theme"

Rectangle {
  id: box

  default property alias content: row.children
  property int padding: 0
  property int spacing: 0

  width: parent.width
  height: Theme.dimensions.itemsHeight
  color: "transparent"
  border.color: "transparent"
  border.width: Theme.borders.width
  radius: Theme.borders.radius

  Row {
    id: row
    spacing: box.spacing
    padding: box.padding
  }
}
