pragma Singleton
import QtQuick

QtObject {
    id: theme

    // Colors
    property QtObject colors: QtObject {
        id: colors
        property color background: "#1A1B26"
        property color backgroundDark: "#16161E"
        property color backgroundLight: "#292E42"
        property color foreground: "#CDD6F4"
        property color foregroundDark: "#7C7C7C"
        property color foregroundLight: "#3B4261"
        property color comment: "#565F89"
        property color dark3: "#545C7E"
        property color dark5: "#737AA2"
        property color red: "#F7768E"
        property color orange: "#FF9E64"
        property color yellow: "#E0AF68"
        property color green: "#9ECE6A"
        property color teal: "#1ABC9C"
        property color purple: "#BB9AF7"
        property color magenta: "#F7768E"
        property color cyan: "#0DB9D7"
        property color blue: "#7AA2F7"
        property color terminalBlack: "#414868"
        property color black: "#24283B"
        property color white: "#C0CAF5"
    }

    // Fonts
    property QtObject fonts: QtObject {
        id: fonts
        property string family: "JetBrainsMono Nerd Font"
        property QtObject size: QtObject {
          property int small: 12
          property int medium: 14
          property int large: 16
          property int xlarge: 20
        }
    }

    // Spacing
    property QtObject spacing: QtObject {
        id: spacing
        property int small: 4
        property int medium: 8
        property int large: 12
    }

    // Dimensions
    property QtObject dimensions: QtObject {
        id: dimensions
        property int barHeight: 24
        property int itemsHeight: 20
        property int menuItemHeight: 26
    }

    // Borders
    property QtObject borders: QtObject {
        id: borders
        property int radius: 10
        property int width: 1
        property color color: theme.colors.backgroundLight
    }

    // Icons
    property QtObject icons: QtObject {
        id: icons
        property string dot: ""
        property string square: "󱓻"
        property string arrowRight: ""
        property string arrowLeft: ""
        property string check: ""
        property string cross: ""
        property string on: ""
        property string off: ""
        property string refresh: ""
        property string settings: ""
        property string trash: ""
        property string download: ""
        property string phone: ""
        property string headphones: ""
        property string controller: "󰊗"
        property string power: ""
        property string logout: ""
        property string sleep: ""
        property string menu: "󰍜"
        property string terminal: ""
        property string file: ""
        property string home: ""
        property string search: ""
        property string edit: ""
        property string plus: ""
        property string minus: ""
        property string info: ""
        property string warning: ""
        property string question: ""
        property string lock: ""
        property string unlock: ""
        property string cpu: "󰍛"
        property string memory: ""
        property string disk: "󰋊"
        property string temperature: ""
        property string celsius: "󰔄"
        property string bluetooth: "󰂯"
        property string bluetoothConnected: "󰂰"
        property string bluetoothOff: "󰂲"
        property string keyboard: ""
        property string mouse: "󰍽"
        property string desktop: ""
        property string speaker: "󰓃"  
        property string wifi0: "󰤯"
        property string wifi1: "󰤟"
        property string wifi2: "󰤢"
        property string wifi3: "󰤥"
        property string wifi4: "󰤨"
        property string wifiOff: "󰤭"
        property string ethernet: "󰈀"
        property string tuxLogo: ""
        property string archLogo: "󰣇"
        property string arcolinuxLogo: ""
        property string manjaroLogo: ""
        property string mintLogo: "󰣭"
        property string zorinLogo: ""
        property string debianLogo: ""
        property string ubuntuLogo: ""
        property string fedoraLogo: ""
        property string soundLow: ""
        property string soundMedium: ""
        property string soundHigh: ""
        property string soundMuted: "󰖁"
        property string batteryCharging0: "󰢜"
        property string batteryCharging1: "󰂆"
        property string batteryCharging2: "󰂇"
        property string batteryCharging3: "󰂈"
        property string batteryCharging4: "󰢝"
        property string batteryCharging5: "󰂉"
        property string batteryCharging6: "󰢞"
        property string batteryCharging7: "󰂊"
        property string batteryCharging8: "󰂋"
        property string batteryCharging9: "󰂅"
        property string battery0: "󰁺"
        property string battery1: "󰁻"
        property string battery2: "󰁼"
        property string battery3: "󰁽"
        property string battery4: "󰁾"
        property string battery5: "󰁿"
        property string battery6: "󰂀"
        property string battery7: "󰂁"
        property string battery8: "󰂂"
        property string battery9: "󰁹"
    }
}

