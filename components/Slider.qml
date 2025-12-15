// Slider.qml
import QtQuick
import QtQuick.Controls
import "../theme"

Slider {
    id: control
    
    implicitWidth: 200
    implicitHeight: Theme.dimensions.barHeight
    
    from: 0
    to: 1
    value: 0.5
    
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: Theme.colors.backgroundLight
        
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: Theme.colors.blue
            radius: 2
        }
    }
    
    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: control.pressed ? Theme.colors.blue : Theme.colors.foreground
        border.color: control.pressed ? Theme.colors.blue : Theme.colors.foreground
        border.width: 2
    }
}
