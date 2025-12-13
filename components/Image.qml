import QtQuick
import "../theme"

Item {
    id: container

    // Size properties
    property int imageWidth: Theme.fonts.size.small
    property int imageHeight: Theme.fonts.size.small
    
    width: imageWidth
    height: imageHeight
    
    // Image properties (aliases)
    property alias source: image.source
    property alias fillMode: image.fillMode
    property alias asynchronous: image.asynchronous
    
    // Icon properties (aliases)
    property alias fallback: icon.text
    property alias color: icon.color
    property alias iconSize: icon.font.pixelSize
    
    // Show icon if image has no source OR failed to load
    readonly property bool showFallback: image.source === "" || image.status === Image.Error
    
    Image {
        id: image
        anchors.fill: parent
        source: ""
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        visible: !container.showFallback
    }
    
    Text {
        id: icon
        text: Theme.icons.dot
        font.family: Theme.fonts.family
        font.pixelSize: container.imageHeight
        color: Theme.colors.foregroundDark
        anchors.centerIn: parent
        visible: container.showFallback
    }
}
