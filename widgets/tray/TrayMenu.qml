import QtQuick
import Quickshell
import "../../theme"
import "../../components" as Components

PopupWindow {
    id: customMenu

    property var bar: null
    property var trayItem: null
    property var menuOpener: null
    
    anchor.window: bar
    anchor.rect.x: 0
    anchor.rect.y: bar.height
    color: "transparent"
    
    implicitWidth: menuContainer.width ? menuContainer.width : 250
    implicitHeight: Math.max(50, menuColumn.implicitHeight + 8)
    visible: false
    
    Rectangle {
        id: menuContainer
        anchors.fill: parent
        color: Theme.colors.background
        border.color: Theme.colors.backgroundLight
        border.width: Theme.borders.width
        radius: Theme.borders.radius
        
        Column {
            id: menuColumn
            width: parent.width
            padding: Theme.spacing.small
            spacing: Theme.spacing.small
            
            Repeater {
              model: customMenu.menuOpener ? customMenu.menuOpener.children : null
              
              delegate: Item {
                  id: menuItem
                  width: menuColumn.width - 8
                  height: Theme.dimensions.menuItemHeight
                  
                  property var entry: modelData

                  visible: !entry.isSeparator
                  
                  // Listen for the triggered signal
                  Connections {
                      target: menuItem.entry
                      
                      function onTriggered(type) {
                          customMenu.visible = false
                      }
                  }
                  
                  Components.MouseArea {
                      id: menuItemArea
                      anchors.fill: parent
                      enabled: menuItem.entry.enabled

                      property bool isAction: menuItem.entry.triggered !== undefined
                      property bool isKeyboard: customMenu.trayItem.title === "Input Method"

                      onLeftClick: () => menuItem.entry.triggered()

                      Rectangle {
                        anchors.fill: parent
                        color: parent.containsMouse ? Theme.colors.backgroundLight : "transparent"
                        border.color: Theme.colors.backgroundLight
                        border.width: parent.containsMouse ? 1 : 0
                        radius: Theme.borders.radius
                        opacity: parent.enabled ? 1 : 0.5
                      }
                      
                      Row {
                        anchors.fill: parent
                        anchors.leftMargin: Theme.spacing.medium
                        spacing: Theme.spacing.medium
                        Image {
                          anchors.verticalCenter: parent.verticalCenter
                          source: {
                            if (menuItemArea.isKeyboard || !menuItem.entry.icon || menuItem.entry.icon === "") {
                                visible: false
                                return ""
                            }
                            return menuItem.entry.icon ? menuItem.entry.icon : ""
                          }
                          width: menuItemArea.isKeyboard || !menuItem.entry.icon ? 0 : Theme.fonts.size.large
                          height: menuItemArea.isKeyboard || !menuItem.entry.icon ? 0 : Theme.fonts.size.large
                          fillMode: Image.PreserveAspectFit
                        }
                        Components.Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: {
                              if (menuItemArea.isKeyboard || !menuItem.entry.icon) {
                                  // For keyboard layouts, show the layout name
                                  return Theme.icons.dot + " " + menuItem.entry.text
                              }
                              return menuItem.entry.text
                            }
                        }
                      }
                      
                  }
              }
          }
        }
    }
}
