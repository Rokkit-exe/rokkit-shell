// SoundWidget
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../theme"
import "../../components" as Components
import "../../functions"

Item {
  id: audioWidget
  width: Theme.dimensions.barHeight
  height: Theme.dimensions.barHeight

  property var bar: null
  property var audioSink: Pipewire.preferredDefaultAudioSink
  property var audioSource: Pipewire.preferredDefaultAudioSource
  property real volume: audioSink?.audio.volume ?? 0
  property bool muted: audioSink?.audio.muted ?? false

  PwObjectTracker {
    objects: [audioWidget.audioSink, audioWidget.audioSource]
  }

  AudioMenu {
    id: audioMenu
    bar: audioWidget.bar
    audioSink: audioWidget.audioSink
    audioSource: audioWidget.audioSource
  }
  
  Components.MouseArea {
    id: mouseArea
    anchors.fill: parent
    
    onLeftClick: () => {
      Functions.toggleMenu(audioWidget.bar, audioMenu, mouseArea)
    }
  }
  
  Components.Text {
    text: {
      if (!audioWidget.audioSink) return Theme.icons.soundMuted
      if (audioWidget.muted) return Theme.icons.soundMuted
      
      let volPercent = Math.round(audioWidget.volume * 100)
      if (volPercent > 66) return Theme.icons.soundHigh
      if (volPercent > 33) return Theme.icons.soundMedium
      if (volPercent >= 0) return Theme.icons.soundLow
      return Theme.icons.soundMuted
    }
    font.pixelSize: Theme.fonts.size.medium
    color: audioWidget.muted ? Theme.colors.foregroundDark : Theme.colors.blue
    anchors.centerIn: parent
  }
}
