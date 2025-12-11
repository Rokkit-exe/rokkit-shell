// SystemTrayWidget.qml
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../theme"

Item {
    id: root
    implicitWidth: trayRow.implicitWidth + Theme.padding.medium
    height: Theme.dimensions.itemsHeight
    
    property var bar: null
    
    TrayMenu {
        id: customMenu
        bar: root.bar
        menuOpener: null
    }

    Rectangle {
      anchors.fill: parent
      width: trayRow.implicitWidth + Theme.padding.medium
      color: Theme.colors.backgroundLight
      border.width: Theme.borders.width
      border.color: Theme.colors.backgroundLight
      radius: Theme.borders.radius

      Row {
      anchors.verticalCenter: parent.verticalCenter
      id: trayRow
      spacing: Theme.spacing.medium
      padding: Theme.padding.medium
      
      Repeater {
          model: SystemTray.items
          
          delegate: Item {
              id: iconItem
              width: Theme.fonts.iconSize
              height: Theme.fonts.iconSize
              
              property var trayItem: modelData
              
              // QsMenuOpener for this icon
              QsMenuOpener {
                  id: opener
                  menu: iconItem.trayItem.menu ? iconItem.trayItem.menu : null
              }
              
              MouseArea {
                  id: icon
                  anchors.fill: parent
                  acceptedButtons: Qt.LeftButton | Qt.RightButton
                  cursorShape: Qt.PointingHandCursor
                  hoverEnabled: true
                  
                  onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton && iconItem.trayItem.menu) {
                      iconItem.trayItem.activate()
                    } else if (mouse.button === Qt.RightButton && iconItem.trayItem.menu) {
                      // Position menu centered on icon
                        let itemGlobal = icon.mapToGlobal(0, 0)
                        let barGlobal = root.bar.contentItem.mapToGlobal(0, 0)
                        
                        // Calculate icon's center position relative to bar
                        let iconCenterX = itemGlobal.x - barGlobal.x + (icon.width / 2)
                        
                        // Subtract half of menu width to center it
                        let relativeX = iconCenterX - (customMenu.implicitWidth / 2)
                        
                        customMenu.anchor.rect.x = relativeX
                        customMenu.trayItem = iconItem.trayItem
                        customMenu.menuOpener = opener
                        customMenu.visible = !customMenu.visible
                    }
                  }

                  Image {
                    anchors.fill: parent
                    source: {
                      if (iconItem.trayItem.title === "Input Method") {
                          visible: false
                          return ""
                      }
                      return iconItem.trayItem.icon ? iconItem.trayItem.icon : ""
                    }
                    fillMode: Image.PreserveAspectFit
                  }

                  Text {
                    anchors.fill: parent
                    text: {
                      if (iconItem.trayItem.title === "Input Method") {
                          visible: true
                          return Theme.icons.keyboard
                      }
                      return iconItem.trayItem.iconText ? iconItem.trayItem.iconText : ""
                    }
                    font.family: Theme.fonts.family
                    font.pixelSize: Theme.fonts.iconSize
                    color: Theme.colors.foreground
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                  }
              }
          }
      }
    }
  }
}
