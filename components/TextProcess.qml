import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Row {
  id: row
  property string result: ""
  property string name: ""
  property string value: ""
  property list<string> command: []
  property bool repeat: false
  property int refreshInterval: 2000

  Text {
    text: row.name + ": "
    color: Theme.colors.foregroundDark
    font.pixelSize: Theme.fonts.size
    font.family: Theme.fonts.family
    anchors.verticalCenter: parent.verticalCenter
  }

  Text {
    id: textItem
    

    Process {
      id: textProcess
      running: false
      
      command: row.command
      
      stdout: StdioCollector {
          onStreamFinished: {
              row.result = this.text.trim()
          }
      }
    }

    Component.onCompleted: {
      textProcess.running = true 
    }

    Timer {
      interval: row.refreshInterval
      running: row.repeat
      repeat: true
      onTriggered: {
          textProcess.running = true
      }
    }

    text: row.value
    color: Theme.colors.foreground
    font.pixelSize: Theme.fonts.size
    font.family: Theme.fonts.family
    font.bold: true
    anchors.verticalCenter: parent.verticalCenter
  }
}
