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

  property var audioSinks: [] 
  property var audioSources: [] 
  property var audioOutputStreams: [] 

  Component.onCompleted: {
    updateAudioDevices()
  }

  function updateAudioDevices() {
    let sinks = []
    let sources = []
    let streams = []
    
    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
      const node = Pipewire.nodes.values[i]
      if (!node.audio) continue
      
      if (node.isStream && node.isSink) {
        streams.push(node)
      } else if (node.isSink) {
        if (node.id === Pipewire.preferredDefaultAudioSink?.id) {
          sinks.unshift(node)

        } else {
          sinks.push(node)
        }
      } else {
        if (node.id === Pipewire.preferredDefaultAudioSource?.id) {
          sources.unshift(node)

        } else {
          sources.push(node)
        }
      }
    }

    audioSinks = sinks
    audioSources = sources
    audioOutputStreams = streams
  }

  PwObjectTracker {
    id: tracker
    objects: [audioWidget.audioSink, audioWidget.audioSource, ...audioWidget.audioSinks, ...audioWidget.audioSources, ...audioWidget.audioOutputStreams]
  }

  Connections {
    target: Pipewire.nodes
    function onValuesChanged() { audioWidget.updateAudioDevices() }
  }
  
  Connections {
    target: Pipewire
    function onReadyChanged() {
        if (Pipewire.ready) audioWidget.updateAudioDevices()
    }
    function onDefaultAudioSinkChanged() {
        if (Pipewire.defaultAudioSink) audioWidget.audioSink = Pipewire.defaultAudioSink
    }
  }

  AudioMenu {
    id: audioMenu
    bar: audioWidget.bar
    audioSink: audioWidget.audioSink
    audioSource: audioWidget.audioSource
    audioSinks: audioWidget.audioSinks
    audioSources: audioWidget.audioSources
    audioOutputStreams: audioWidget.audioOutputStreams
    updateAudioDevices: audioWidget.updateAudioDevices
  }
  
  Components.MouseArea {
    id: mouseArea
    anchors.fill: parent
    
    onLeftClick: () => {
      audioWidget.updateAudioDevices()
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
