import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.Commons as Commons

PanelWindow {
  id: hudWindow

  property var pluginService: null
  property string targetScreenName: "DP-4"

  // Automatically find screen matching targetScreenName or fall back to secondary
  screen: {
    const list = Quickshell.screens || []
    for (let i = 0; i < list.length; i++) {
      if (list[i] && list[i].name === targetScreenName) return list[i]
    }
    return list.length > 1 ? list[1] : (list.length > 0 ? list[0] : null)
  }

  anchors {
    top: true
    right: true
    bottom: true
  }

  margins {
    top: Commons.Style.space(48)
    right: Commons.Style.space(16)
    bottom: Commons.Style.space(48)
  }

  implicitWidth: 350
  color: "transparent"

  WlrLayershell.namespace: "omniroute-quota-hud"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    id: hudFrame
    anchors.fill: parent
    radius: Commons.Style.space(12)
    color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.80)
    border.width: 1
    border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.16)
    clip: true

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Commons.Style.space(14)
      spacing: Commons.Style.space(10)

      // Header
      RowLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(8)

        Text {
          text: "󰚩"
          color: Commons.Color.accent
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.title
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 1

          Text {
            text: "OmniRoute Quota"
            color: Commons.Color.foreground
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.body
            font.weight: Font.Bold
          }

          Text {
            text: hudWindow.pluginService ? (hudWindow.pluginService.totalActive + " active connections") : "Connecting…"
            color: Commons.Color.muted
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.caption
          }
        }

        Rectangle {
          width: Commons.Style.space(28)
          height: Commons.Style.space(28)
          radius: Commons.Style.space(14)
          color: refreshHover.hovered ? Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.18) : Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.08)

          Text {
            anchors.centerIn: parent
            text: "󰑐"
            color: Commons.Color.foreground
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.bodySmall
          }

          HoverHandler { id: refreshHover }
          TapHandler {
            onTapped: {
              if (hudWindow.pluginService && typeof hudWindow.pluginService.refresh === "function") {
                hudWindow.pluginService.refresh()
              }
            }
          }
        }
      }

      // Provider List
      ListView {
        id: providerList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: Commons.Style.space(8)
        model: hudWindow.pluginService ? hudWindow.pluginService.providers : []

        delegate: QuotaCard {
          modelData: modelData
          width: providerList.width
        }
      }

      // Footer: Last updated
      Text {
        Layout.alignment: Qt.AlignRight
        text: hudWindow.pluginService && hudWindow.pluginService.lastUpdatedText.length > 0
          ? ("Updated " + hudWindow.pluginService.lastUpdatedText) : ""
        color: Commons.Color.muted
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.caption
      }
    }
  }
}
