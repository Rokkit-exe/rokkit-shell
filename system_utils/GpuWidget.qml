// GpuWidget
import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Item {
    id: gpuWidget
    width: gpuText.width
    height: Theme.dimensions.barHeight
    
    property string usage: ""
    
    // GPU Usage
    Process {
        id: usageProc
        running: false
        command: ["bash", "/home/frank/.config/quickshell/scripts/gpu-usage.sh"]
        
        stdout: StdioCollector {
          onStreamFinished: {
            gpuWidget.usage = this.text.trim()
          }
        }
        // Add error handling
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "") {
                    console.error("GPU Script Error:", this.text)
                }
            }
        }
      }
              
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
          usageProc.running = true
        }
    }
    
    Component.onCompleted: {
      usageProc.running = true
    }
    
    Text {
      id: gpuText
      text: gpuWidget.usage
      font.family: Theme.fonts.family
      font.pixelSize: Theme.fonts.size
      font.bold: true
      color: Theme.colors.foreground
      anchors.centerIn: parent
    }
}
