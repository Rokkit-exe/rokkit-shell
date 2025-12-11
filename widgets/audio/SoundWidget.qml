// SoundWidget
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../theme"
import "../../components" as Components

Item {
    id: soundItem
    width: Theme.dimensions.barHeight
    height: Theme.dimensions.barHeight
    
    property var audioSink: Pipewire.preferredDefaultAudioSink
    property real volume: audioSink?.audio.volume ?? 0
    property bool muted: audioSink?.audio.muted ?? false

    PwObjectTracker {
        objects: [soundItem.audioSink]
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
          Quickshell.execDetached("omarchy-launch-or-focus-tui wiremix")
        }
        
        ToolTip {
            visible: mouseArea.containsMouse
            text: soundItem.muted ? "Muted" : Math.round(soundItem.volume * 100) + "%"
            delay: 500
        }
    }
    
    Components.Text {
      text: {
          if (!soundItem.audioSink) return Theme.icons.soundMuted
          if (soundItem.muted) return Theme.icons.soundMuted
          
          let volPercent = Math.round(soundItem.volume * 100)
          if (volPercent > 66) return Theme.icons.soundHigh
          if (volPercent > 33) return Theme.icons.soundMedium
          if (volPercent >= 0) return Theme.icons.soundLow
          return Theme.icons.soundMuted
      }
      font.pixelSize: Theme.fonts.iconSize
      color: soundItem.muted ? Theme.colors.foregroundDark : Theme.colors.blue
      anchors.centerIn: parent
    }
}
