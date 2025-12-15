import QtQuick
import "../theme"

Item {
  id: buttonItem
  
  property bool checked: false
  property string textOn: Theme.icons.on
  property string textOff: Theme.icons.off
  property color colorOn: Theme.colors.blue
  property color colorOff: Theme.colors.backgroundLight
  property var toggle: () => {}
  
  signal toggled(bool checked)
  
  width: 26 + Theme.spacing.small * 2
  height: 26 + Theme.spacing.small * 2
  
  MouseArea {
    id: buttonArea
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: {
      buttonItem.checked = !buttonItem.checked
      if (buttonItem.toggle) {
        buttonItem.toggle()
      }
      buttonItem.toggled(buttonItem.checked)
    }
    
    Rectangle {
      anchors.fill: parent
      color: "transparent"
      radius: Theme.borders.radius
      opacity: buttonArea.containsMouse ? 0.8 : 1.0
      
      Behavior on color {
        ColorAnimation { duration: 200 }
      }
      
      Behavior on opacity {
        NumberAnimation { duration: 200 }
      }
      
      Icon {
        text: buttonItem.checked ? buttonItem.textOn : buttonItem.textOff
        color: buttonItem.checked ? buttonItem.colorOn : buttonItem.colorOff
        font.pixelSize: 26
        anchors.centerIn: parent
        
        Behavior on color {
          ColorAnimation { duration: 200 }
        }
      }
    }
  }
}
