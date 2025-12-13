// AudioMenu
import QtQuick
import Quickshell
import QtQuick.Controls
import Quickshell.Services.Pipewire
import "../../theme"
import "../../components" as Components
import "../../functions"

Components.PopupWindow {
  id: audioMenu
  
  implicitWidth: 400
  implicitHeight: 300
  
  property var audioSink: Pipewire.defaultAudioSink
  property var audioSource: Pipewire.defaultAudioSource
  property real volume: audioSink?.audio?.volume ?? 0
  property bool muted: audioSink?.audio?.muted ?? false
  property real volumeInput: audioSource?.audio?.volume ?? 0
  property bool mutedInput: audioSource?.audio?.muted ?? false
  
  // Get all audio sinks from Pipewire
  property var audioSinks: {
    let sinks = []
    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
      const node = Pipewire.nodes.values[i]
      if (node.isSink && node.audio !== null && !node.isStream) {
        sinks.push(node)
      }
    }
    return sinks
  }

  property var audioSources: {
    let sources = []
    for (let i = 0; i < Pipewire.nodes.values.length; i++) {
      const node = Pipewire.nodes.values[i]
      if (node.isSource && node.audio !== null && !node.isStream) {
        sources.push(node)
      }
    }
    return sources
  }
  
  Components.ColumnBox {
    id: menuColumn
    width: parent.width ? parent.width : 400
    height: parent.height ? parent.height : 300
    color: Theme.colors.background
    padding: Theme.spacing.small
    spacing: Theme.spacing.large

    Components.RowBox {
      id: outputRow
      width: parent.width
      height: Theme.dimensions.barHeight
      spacing: Theme.spacing.small
      padding: Theme.spacing.small

      Components.Text {
        id: outputLabel
        text: "Output: "
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
      }
      ComboBox {
        id: outputDeviceComboBox
        model: audioMenu.audioSinks.map(sink => sink.nickname)
        width: 280
        height: Theme.dimensions.barHeight
        anchors.verticalCenter: parent.verticalCenter
        currentIndex: audioMenu.audioSinks.indexOf(audioMenu.audioSink)
        onCurrentIndexChanged: {
          const selectedSink = audioMenu.audioSinks[outputDeviceComboBox.currentIndex]
          if (selectedSink) {
            Pipewire.PreferredDefaultAudioSink = selectedSink
            audioMenu.audioSink = selectedSink
          }
        }
      }
    }

    Components.RowBox {
      id: outputCtrlRow
      width: parent.width
      height: Theme.dimensions.barHeight
      spacing: Theme.spacing.large
      padding: Theme.spacing.small

      Slider {
        id: outputVolumeSlider
        width: 280
        anchors.verticalCenter: parent.verticalCenter
        from: 0
        to: 1
        stepSize: 0.01
        value: audioMenu.volume
        onMoved: {
          if (audioMenu.audioSink && audioMenu.audioSink.audio) {
            audioMenu.audioSink.audio.volume = volumeSlider.value
          }
        }
      }

      Components.ToggleButton {
        id: outputMuteToggle
        textOn: Theme.icons.soundMuted
        textOff: Theme.icons.soundHigh
        colorOn: Theme.colors.foregroundDark
        colorOff: Theme.colors.blue
        anchors.verticalCenter: parent.verticalCenter
        
        checked: audioMenu.muted
        onCheckedChanged: {
          if (audioMenu.audioSink && audioMenu.audioSink.audio) {
            audioMenu.audioSink.audio.muted = outputMuteToggle.checked
          }
        } 
      }
    }
    

    Components.RowBox {
      id: inputRow
      width: parent.width
      height: Theme.dimensions.barHeight
      spacing: Theme.spacing.small
      padding: Theme.spacing.small

      Components.Text {
        text: "Input: "
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
      }

      ComboBox {
        id: inputDeviceComboBox
        model: audioMenu.audioSources.map(source => source.nickname)
        width: 280
        height: Theme.dimensions.barHeight
        currentIndex: audioMenu.audioSources.indexOf(audioMenu.audioSource)
        onCurrentIndexChanged: {
          const selectedSource = audioMenu.audioSources[inputDeviceComboBox.currentIndex]
          if (selectedSource) {
            Pipewire.PreferredDefaultAudioSource = selectedSource
            audioMenu.audioSource = selectedSource
          }
        }
      }
    }
    Components.RowBox {
      id: inputCtrlRow
      width: parent.width
      height: Theme.dimensions.barHeight
      spacing: Theme.spacing.large
      padding: Theme.spacing.small

      Slider {
        id: inputVolumeSlider
        width: 280
        from: 0
        to: 1
        stepSize: 0.01
        value: audioMenu.volumeInput
        anchors.verticalCenter: parent.verticalCenter
        onMoved: {
          if (audioMenu.audioSource && audioMenu.audioSource.audio) {
            audioMenu.audioSource.audio.volume = inputVolumeSlider.value
          }
        }
      }

      Components.ToggleButton {
        id: inputMuteToggle
        textOn: Theme.icons.soundMuted
        textOff: Theme.icons.soundHigh
        colorOn: Theme.colors.foregroundDark
        colorOff: Theme.colors.blue
        checked: audioMenu.muted
        anchors.verticalCenter: parent.verticalCenter
        onCheckedChanged: {
          if (audioMenu.audioSource && audioMenu.audioSource.audio) {
            audioMenu.audioSource.audio.muted = inputMuteToggle.checked
          }
        }
      }
    }
    
  } 
}
