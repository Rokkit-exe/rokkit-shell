// ComboBox.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import "../theme"

ComboBox {
  id: control
  
  implicitWidth: 280
  implicitHeight: Theme.dimensions.barHeight
  
  font.pixelSize: Theme.fonts.size.small
  font.family: Theme.fonts.family
  
  contentItem: Text {
    leftPadding: Theme.spacing.medium
    rightPadding: control.indicator.width + control.spacing
    
    text: control.displayText
    font.pixelSize: Theme.fonts.size.small
    font.family: Theme.fonts.family
    font.bold: true
    color: control.enabled ? Theme.colors.foreground : Theme.colors.foregroundDark
    verticalAlignment: Text.AlignVCenter
  }
  
  background: Rectangle {
    implicitWidth: control.implicitWidth
    implicitHeight: control.implicitHeight
    color: Theme.colors.backgroundLight
    border.color: control.activeFocus ? Theme.colors.blue : Theme.colors.backgroundLight
    border.width: Theme.borders.width
    radius: Theme.borders.radius
  }
  
  indicator: Icon {
    text: Theme.icons.arrowDown
    font.pixelSize: Theme.fonts.size.medium
    color: Theme.colors.foreground
    x: control.width - width - Theme.spacing.medium
    y: control.topPadding + (control.availableHeight - height) / 2
  }
  
  popup: Popup {
    y: control.height + Theme.spacing.small
    width: control.width
    implicitHeight: contentItem.implicitHeight + Theme.spacing.small * 2
    padding: Theme.spacing.small
    
    contentItem: ListView {
      clip: true
      implicitHeight: contentHeight
      model: control.popup.visible ? control.delegateModel : null
      currentIndex: control.highlightedIndex
    }
    
    background: Rectangle {
      color: Theme.colors.background
      border.color: Theme.colors.backgroundLight
      border.width: Theme.borders.width
      radius: Theme.borders.radius
    }
  }
  
  delegate: ItemDelegate {
    width: control.popup.width - control.popup.padding * 2
    height: Theme.dimensions.itemsHeight + Theme.spacing.small * 2
    padding: Theme.spacing.medium
    
    contentItem: Text {
        text: modelData
        color: highlighted ? Theme.colors.blue : Theme.colors.foreground
        font.family: Theme.fonts.family
        font.pixelSize: Theme.fonts.size.small
        font.bold: true
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        padding: Theme.spacing.small
    }
    
    background: Rectangle {
      color: {
          if (highlighted) return Theme.colors.backgroundLight
          if (hovered) return Theme.colors.backgroundLight
          return "transparent"
      }
      radius: Theme.borders.radius
    }
    
    highlighted: control.highlightedIndex === index
    hoverEnabled: true
  }
}
