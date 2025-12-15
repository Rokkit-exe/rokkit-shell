// singletons/PipewireManager.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "../theme"

Singleton {
    id: pipewire
    
    property var audioSink: Pipewire.preferredDefaultAudioSink
    property var audioSource: Pipewire.preferredDefaultAudioSource
    property real volume: audioSink?.audio?.volume ?? 0
    property bool muted: audioSink?.audio?.muted ?? false
    property real inputVolume: audioSource?.audio?.volume ?? 0
    property bool inputMuted: audioSource?.audio?.muted ?? false
    
    property var audioSinks: [] 
    property var audioSources: [] 
    property var audioOutputStreams: []
    
    // PwObjectTracker to keep nodes reactive
    PwObjectTracker {
      id: tracker
      objects: {
          let objs = []
          
          // Add sink and source if they exist
          if (pipewire.audioSink) objs.push(pipewire.audioSink)
          if (pipewire.audioSource) objs.push(pipewire.audioSource)
          
          // Add all devices and streams using concat
          objs = objs.concat(pipewire.audioSinks)
          objs = objs.concat(pipewire.audioSources)
          objs = objs.concat(pipewire.audioOutputStreams)
          
          return objs
      }
    }
    
    // Update when nodes change
    Connections {
        target: Pipewire.nodes
        function onValuesChanged() {
            pipewire.updateAudioDevices()
        }
    }
    
    // Update when Pipewire becomes ready
    Connections {
        target: Pipewire
        function onReadyChanged() {
            if (Pipewire.ready) {
                pipewire.updateAudioDevices()
            }
        }
    }
    
    // Watch for default device changes
    Connections {
        target: Pipewire
        function onDefaultAudioSinkChanged() {
            if (Pipewire.defaultAudioSink) {
                pipewire.audioSink = Pipewire.defaultAudioSink
            }
        }
        
        function onDefaultAudioSourceChanged() {
            if (Pipewire.defaultAudioSource) {
                pipewire.audioSource = Pipewire.defaultAudioSource
            }
        }
    }
    
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
            
            if (node.isStream) {
                if (node.isSink) streams.push(node)
            } else {
                if (node.isSink) {
                    sinks.push(node)
                } else {
                    sources.push(node)
                }
            }
        }
        
        audioSinks = sinks
        audioSources = sources
        audioOutputStreams = streams
    }
    
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
}
