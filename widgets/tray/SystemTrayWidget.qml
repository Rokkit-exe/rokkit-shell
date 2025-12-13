// SystemTrayWidget.qml
import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import "../../theme"
import "../../components" as Components

Item {
    id: root
    implicitWidth: trayRow.implicitWidth + Theme.spacing.medium
    height: Theme.dimensions.itemsHeight
    
    property var bar: null
    
    TrayMenu {
        id: customMenu
        bar: root.bar
        menuOpener: null
    }

    Rectangle {
      anchors.fill: parent
      width: trayRow.implicitWidth + Theme.spacing.medium
      color: Theme.colors.backgroundLight
      border.width: Theme.borders.width
      border.color: Theme.colors.backgroundLight
      radius: Theme.borders.radius

      Row {
      anchors.verticalCenter: parent.verticalCenter
      id: trayRow
      spacing: Theme.spacing.medium
      padding: Theme.spacing.medium
      
      Repeater {
          model: SystemTray.items
          
          delegate: Item {
              id: iconItem
              width: Theme.fonts.size.medium
              height: Theme.fonts.size.medium
              
              property var trayItem: modelData
              
              // QsMenuOpener for this icon
              QsMenuOpener {
                  id: opener
                  menu: iconItem.trayItem.menu ? iconItem.trayItem.menu : null
              }
              
              Components.MouseArea {
                  id: icon
                  anchors.fill: parent
                  onLeftClick: () => {
                    if (iconItem.trayItem.menu) {
                      iconItem.trayItem.activate()
                    }
                  }
                  onRightClick: () => {
                    if (iconItem.trayItem.menu) {
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

                  Components.Icon {
                    anchors.fill: parent
                    text: {
                      if (iconItem.trayItem.title === "Input Method") {
                          visible: true
                          return Theme.icons.keyboard
                      }
                      return iconItem.trayItem.iconText ? iconItem.trayItem.iconText : ""
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                  }
              }
          }
      }
    }
  }
}
