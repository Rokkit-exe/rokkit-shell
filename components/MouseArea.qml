// MouseArea
import QtQuick
import Quickshell
import "../theme/"

MouseArea {
  id: mouseArea

  property var onLeftClick: () => {}
  property var onRightClick: () => {}
  property var onHover: () => {}

  width: Theme.dimensions.itemsHeight
  height: Theme.dimensions.itemsHeight
  cursorShape: Qt.PointingHandCursor
  acceptedButtons: Qt.LeftButton | Qt.RightButton
  hoverEnabled: true
  
  onClicked: (mouse) => {
    if (mouse.button === Qt.LeftButton && onLeftClick) {
      console.log("Left click detected");
      onLeftClick();
    } else if (mouse.button === Qt.RightButton && onRightClick) {
      console.log("Right click detected");
      onRightClick();
    }
  }

  onEntered: {
    if (onHover) {
      onHover();
    }
  }
}
