// shell.qml
import QtQuick
import QtQuick.Controls
import Quickshell

ShellRoot {
  id: shellRoot

  Bar {
    settingsWindow: settingsWindow
  }

  // FloatingPane {
  //   id: settingsWindow
  // }
}
