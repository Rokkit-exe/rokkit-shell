// AudioMenu
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../../theme"
import "../../components" as Components
import "../../functions"

Components.PopupWindow {
  id: audioMenu
  
  implicitWidth: 400
  implicitHeight: 610
  border.color: Theme.colors.backgroundLight
  border.width: Theme.borders.width
  
  property var audioSink: null
  property var audioSource: null
  property real volume: audioSink?.audio?.volume ?? 0
  property bool muted: audioSink?.audio?.muted ?? false
  property real volumeInput: audioSource?.audio?.volume ?? 0
  property bool mutedInput: audioSource?.audio?.muted ?? false
  property var audioSinks: null
  property var audioSources: null
  property var audioOutputStreams: null
  property var updateAudioDevices: null

  function getAppName(node) {
    if (!node) return "Unknown"
    
    const props = node.properties || {}

    if (props["application.name"] && props["application.process.binary"]) {
      return props["application.name"] + ": " + props["application.process.binary"]
    }
    return "Unknown AppName"
  }

  function getMediaName(node) {
    if (!node) return "Unknown"
    
    const props = node.properties || {}

    if (props["media.name"]) {
      return props["media.name"]
    }
    return "Unknown Media"
  }

  function getMediaDetails(node) {
    if (!node) return "Unknown"
    
    const props = node.properties || {}

    if (props["media.title"] && props["media.artist"]) {
      return props["media.title"] + " - " + props["media.artist"]
    }
    return ""
  }
  
  Components.ColumnBox {
    id: menuColumn
    width: parent.width ? parent.width : 400
    color: Theme.colors.background
    padding: Theme.spacing.medium
    spacing: Theme.spacing.large

    Components.ColumnBox {
      id: outputColumn
      width: audioMenu.width - Theme.spacing.medium * 2
      height: outputLabel.height + outputDeviceComboBox.height + outputCtrlRow.height + Theme.spacing.large * 4 
      border.color: Theme.colors.backgroundLight
      padding: Theme.spacing.medium
      spacing: Theme.spacing.large
      anchors.horizontalCenter: parent.horizontalCenter

      Components.Text {
        id: outputLabel
        text: "Output"
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
      }
      Components.ComboBox {
        id: outputDeviceComboBox
        implicitWidth: parent.width - Theme.spacing.medium * 2
        model: audioMenu.audioSinks.map(sink => sink.nickname)

        currentIndex: {
          for (let i = 0; i < audioMenu.audioSinks.length; i++) {
              if (audioMenu.audioSinks[i] === audioMenu.audioSink) {
                  return i
              }
          }
          return -1
        }
        onCurrentIndexChanged: {
          const selectedSink = audioMenu.audioSinks[outputDeviceComboBox.currentIndex]
          if (selectedSink) {
            Pipewire.preferredDefaultAudioSink = selectedSink
            audioMenu.audioSink = selectedSink
          }
        }
      }

      Components.RowBox {
        id: outputCtrlRow
        width: parent.width - Theme.spacing.medium * 2
        height: Math.max(Theme.dimensions.barHeight, outputMuteToggle.height)
        spacing: Theme.spacing.large
        padding: Theme.spacing.small

        Components.Slider {
          id: outputVolumeSlider
          implicitWidth: outputCtrlRow.width - outputMuteToggle.width - Theme.spacing.medium * 2
          anchors.verticalCenter: parent.verticalCenter
          from: 0
          to: 1
          stepSize: 0.01
          value: audioMenu.volume
          onMoved: {
            if (audioMenu.audioSink && audioMenu.audioSink.audio) {
              audioMenu.audioSink.audio.volume = outputVolumeSlider.value
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
    }
    
    Components.ColumnBox {
      id: inputColumn
      width: audioMenu.width - Theme.spacing.medium * 2
      height: inputLabel.height + inputDeviceComboBox.height + inputCtrlRow.height + Theme.spacing.large * 4 
      border.color: Theme.colors.backgroundLight
      padding: Theme.spacing.medium
      spacing: Theme.spacing.large
      anchors.horizontalCenter: parent.horizontalCenter

      Components.Text {
        id: inputLabel
        text: "Input"
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
      }

      Components.ComboBox {
        id: inputDeviceComboBox
        width: parent.width - Theme.spacing.medium * 2
        model: audioMenu.audioSources.map(source => source.nickname)

        currentIndex: {
          for (let i = 0; i < audioMenu.audioSources.length; i++) {
              if (audioMenu.audioSources[i] === audioMenu.audioSource) {
                  return i
              }
          }
          return -1
        }
        onCurrentIndexChanged: {
          const selectedSource = audioMenu.audioSources[inputDeviceComboBox.currentIndex]
          if (selectedSource) {
            Pipewire.preferredDefaultAudioSource = selectedSource
            audioMenu.audioSource = selectedSource
          }
        }
      }

      Components.RowBox {
        id: inputCtrlRow
        width: parent.width - Theme.spacing.medium * 2
        height: Math.max(Theme.dimensions.barHeight, inputMuteToggle.height)
        spacing: Theme.spacing.large
        padding: Theme.spacing.small
        anchors.horizontalCenter: parent.horizontalCenter

        Components.Slider {
          id: inputVolumeSlider
          width: inputCtrlRow.width - inputMuteToggle.width - Theme.spacing.medium * 2
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
          checked: audioMenu.mutedInput
          anchors.verticalCenter: parent.verticalCenter
          onCheckedChanged: {
            if (audioMenu.audioSource && audioMenu.audioSource.audio) {
              audioMenu.audioSource.audio.muted = inputMuteToggle.checked
            }
          }
        }
      }
    }
    

    Components.ColumnBox {
      id: streamColumn
      width: audioMenu.width - Theme.spacing.medium * 2
      height: 320
      padding: Theme.spacing.medium
      spacing: Theme.spacing.large
      anchors.horizontalCenter: parent.horizontalCenter
      border.color: Theme.colors.backgroundLight

      Components.Text {
        id: streamsLabel
        text: "Streams"
        font.pixelSize: Theme.fonts.size.medium
        color: Theme.colors.foreground
        padding: Theme.spacing.small
      }

      ScrollView {
        id: streamScrollView
        width: streamColumn.width - Theme.spacing.medium * 2
        height: streamColumn.height - streamsLabel.height - Theme.spacing.large * 2
        clip: true
        contentHeight: streamColumn.height - Theme.spacing.medium * 2
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        Components.ColumnBox {
          id: streamScrollColumn
          width: streamScrollView.width - Theme.spacing.medium * 2
          height: streamScrollView.height - Theme.spacing.medium * 2
          spacing: Theme.spacing.small
          padding: Theme.spacing.medium
          anchors.horizontalCenter: parent.horizontalCenter

          Component.onCompleted: {
              console.log("ScrollView height:", streamScrollView.height)
              console.log("Column implicitHeight:", streamScrollColumn.implicitHeight)
              console.log("Items:", audioMenu.audioOutputStreams.length)
          }

          Repeater {
            id: streamRepeater
            model: audioMenu.audioOutputStreams

            delegate: Components.ColumnBox {
              id: streamBox
              width: parent.width + Theme.spacing.medium * 2
              height: streamNameText.height + mediaNameText.height + mediaDetailsText.height + streamRow.height + Theme.spacing.large * 3
              spacing: Theme.spacing.small
              padding: Theme.spacing.medium
              border.color: Theme.colors.backgroundLight
              anchors.horizontalCenter: parent.horizontalCenter

              Components.Text {
                id: streamNameText
                width: parent.width - Theme.spacing.medium * 2
                text: audioMenu.getAppName(modelData)
                font.pixelSize: Theme.fonts.size.small
                color: Theme.colors.foreground
                wrapMode: Text.Wrap
              }
              Components.Text {
                id: mediaNameText
                width: parent.width - Theme.spacing.medium * 2
                text: audioMenu.getMediaName(modelData)
                font.pixelSize: Theme.fonts.size.small
                color: Theme.colors.foreground
                wrapMode: Text.Wrap
              }
              Components.Text {
                id: mediaDetailsText
                width: parent.width - Theme.spacing.medium * 2
                text: audioMenu.getMediaDetails(modelData)
                font.pixelSize: Theme.fonts.size.small
                color: Theme.colors.foreground
                wrapMode: Text.Wrap
              }

              Components.RowBox {
                id: streamRow
                width: streamBox.width - Theme.spacing.medium * 2
                height: Math.max(Theme.dimensions.barHeight, streamMuteToggle.height)
                spacing: Theme.spacing.large
                padding: Theme.spacing.small

                Components.Slider {
                  id: streamVolumeSlider
                  width: streamBox.width - streamMuteToggle.width - Theme.spacing.large * 3
                  from: 0
                  to: 1
                  stepSize: 0.01
                  value: modelData.audio.volume
                  anchors.verticalCenter: parent.verticalCenter
                  onMoved: {
                    if (modelData && modelData.audio) {
                      modelData.audio.volume = streamVolumeSlider.value
                    }
                  }
                }

                Components.ToggleButton {
                  id: streamMuteToggle
                  textOn: Theme.icons.soundMuted
                  textOff: Theme.icons.soundHigh
                  colorOn: Theme.colors.foregroundDark
                  colorOff: Theme.colors.blue
                  anchors.verticalCenter: parent.verticalCenter
                  
                  checked: modelData.audio.muted
                  onCheckedChanged: {
                    if (modelData && modelData.audio) {
                      modelData.audio.muted = streamMuteToggle.checked
                    }
                  } 
                }
              }
            }
          }
        }
      }
    }
  } 
}
