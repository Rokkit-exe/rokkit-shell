// shell.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import "./system_utils/"

ShellRoot {
  id: shellRoot

  Bar {
    settingsWindow: settingsWindow
  }

  FloatingPane {
    id: settingsWindow
  }
}
