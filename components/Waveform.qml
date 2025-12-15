// components/SpectrumBars.qml
import QtQuick

Item {
    id: root
    
    property real volume: 0.5
    property bool active: true
    property color activeColor: "#4CAF50"
    property color inactiveColor: "#333333"
    
    width: 100
    height: 30
    
    Row {
        anchors.fill: parent
        spacing: 1
        
        Repeater {
            model: 16
            
            Rectangle {
                width: (parent.width - 15) / 16
                height: parent.height
                color: root.inactiveColor
                radius: 1
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: {
                        if (!root.active) return 0
                        
                        // Random variation for each bar
                        const baseHeight = root.volume * parent.height
                        const randomOffset = Math.random() * 0.3
                        return baseHeight * (0.7 + randomOffset)
                    }
                    
                    color: root.activeColor
                    radius: parent.radius
                    
                    Behavior on height {
                        NumberAnimation {
                            duration: 80 + Math.random() * 40
                            easing.type: Easing.OutCubic
                        }
                    }
                }
                
                // Animate continuously when active
                Timer {
                    running: root.active && root.volume > 0.01
                    interval: 100 + index * 10
                    repeat: true
                    onTriggered: parent.children[0].height = parent.children[0].height  // Force re-evaluation
                }
            }
        }
    }
}
