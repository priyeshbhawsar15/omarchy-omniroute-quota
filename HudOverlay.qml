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
  }

  margins {
    top: Commons.Style.space(48)
    right: Commons.Style.space(16)
  }

  implicitWidth: 390
  implicitHeight: hudFrame.implicitHeight
  color: "transparent"

  WlrLayershell.namespace: "omniroute-quota-hud"
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    id: hudFrame
    width: hudWindow.implicitWidth
    implicitHeight: mainCol.implicitHeight + Commons.Style.space(28)
    radius: Commons.Style.space(12)
    color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.85)
    border.width: 1
    border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.16)
    clip: true

    ColumnLayout {
      id: mainCol
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.margins: Commons.Style.space(14)
      spacing: Commons.Style.space(12)

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
            text: "OmniRoute Quota Telemetry"
            color: Commons.Color.foreground
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.body
            font.weight: Font.Bold
            elide: Text.ElideRight
            Layout.fillWidth: true
          }

          Text {
            text: hudWindow.pluginService ? (hudWindow.pluginService.totalActive + " active providers") : "Connecting…"
            color: Commons.Color.muted
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.caption
            elide: Text.ElideRight
            Layout.fillWidth: true
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

      // SECTION 1: GITHUB COPILOT (PREMIUM REQUESTS)
      ColumnLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(6)

        Text {
          text: "GITHUB COPILOT"
          color: Commons.Color.muted
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
          font.weight: Font.Bold
          font.letterSpacing: 1
        }

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: copilotCol.implicitHeight + Commons.Style.space(20)
          radius: Commons.Style.space(8)
          color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
          border.width: 1
          border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

          ColumnLayout {
            id: copilotCol
            anchors.fill: parent
            anchors.margins: Commons.Style.space(10)
            spacing: Commons.Style.space(6)

            RowLayout {
              Layout.fillWidth: true
              spacing: Commons.Style.space(8)

              Text {
                text: "󰊤"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.body
              }

              Text {
                text: "GitHub Copilot"
                color: Commons.Color.foreground
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.bodySmall
                font.weight: Font.DemiBold
                Layout.fillWidth: true
                elide: Text.ElideRight
              }

              Text {
                text: "89% Premium Quota"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                font.weight: Font.Bold
              }
            }

            RowLayout {
              Layout.fillWidth: true
              Text {
                text: "Business Seat Quota"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                elide: Text.ElideRight
                Layout.fillWidth: true
              }
              Text {
                text: "Seat License Active"
                color: Commons.Color.muted
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                elide: Text.ElideRight
              }
            }

            Rectangle {
              Layout.fillWidth: true
              height: 4
              radius: 2
              color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
              clip: true

              Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.89
                radius: 2
                color: Commons.Color.accent
              }
            }
          }
        }
      }

      // SECTION 2: OPENAI CODEX LIMITS (5h & Weekly)
      ColumnLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(6)

        Text {
          text: "OPENAI CODEX LIMITS"
          color: Commons.Color.muted
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
          font.weight: Font.Bold
          font.letterSpacing: 1
        }

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: codexCol.implicitHeight + Commons.Style.space(20)
          radius: Commons.Style.space(8)
          color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
          border.width: 1
          border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

          ColumnLayout {
            id: codexCol
            anchors.fill: parent
            anchors.margins: Commons.Style.space(10)
            spacing: Commons.Style.space(8)

            RowLayout {
              Layout.fillWidth: true
              spacing: Commons.Style.space(8)

              Text {
                text: "󰚩"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.body
              }

              Text {
                text: "OpenAI Codex"
                color: Commons.Color.foreground
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.bodySmall
                font.weight: Font.DemiBold
                Layout.fillWidth: true
                elide: Text.ElideRight
              }

              Text {
                text: "ChatGPT Plus"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                font.weight: Font.Bold
              }
            }

            // 5-Hour Limit Bar (0%)
            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              RowLayout {
                Layout.fillWidth: true
                Text {
                  text: "5-Hour Limit Window"
                  color: Commons.Color.muted
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  Layout.fillWidth: true
                  elide: Text.ElideRight
                }
                Text {
                  text: "0% Left · Limited"
                  color: Commons.Color.urgent
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  font.weight: Font.Bold
                }
              }

              Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
                clip: true

                Rectangle {
                  anchors.left: parent.left
                  anchors.top: parent.top
                  anchors.bottom: parent.bottom
                  width: 4
                  radius: 2
                  color: Commons.Color.urgent
                }
              }
            }

            // Weekly Limit Bar (12%)
            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              RowLayout {
                Layout.fillWidth: true
                Text {
                  text: "Weekly Rolling Limit"
                  color: Commons.Color.muted
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  Layout.fillWidth: true
                  elide: Text.ElideRight
                }
                Text {
                  text: "12% Left · Active"
                  color: Commons.Color.accent
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  font.weight: Font.Bold
                }
              }

              Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
                clip: true

                Rectangle {
                  anchors.left: parent.left
                  anchors.top: parent.top
                  anchors.bottom: parent.bottom
                  width: Math.max(4, parent.width * 0.12)
                  radius: 2
                  color: Commons.Color.accent
                }
              }
            }
          }
        }
      }

      // SECTION 3: GOOGLE ANTIGRAVITY (PRO ACCOUNT ONLY)
      ColumnLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(6)

        RowLayout {
          Layout.fillWidth: true
          Text {
            text: "ANTIGRAVITY (PRO ACCOUNT)"
            color: Commons.Color.muted
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.caption
            font.weight: Font.Bold
            font.letterSpacing: 1
          }
          Item { Layout.fillWidth: true }
          Text {
            text: "Google AI Pro"
            color: Commons.Color.accent
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.caption
            font.weight: Font.Bold
          }
        }

        Rectangle {
          Layout.fillWidth: true
          implicitHeight: agCol.implicitHeight + Commons.Style.space(20)
          radius: Commons.Style.space(8)
          color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
          border.width: 1
          border.color: Qt.rgba(Commons.Color.accent.r, Commons.Color.accent.g, Commons.Color.accent.b, 0.3)

          ColumnLayout {
            id: agCol
            anchors.fill: parent
            anchors.margins: Commons.Style.space(10)
            spacing: Commons.Style.space(6)

            RowLayout {
              Layout.fillWidth: true
              spacing: Commons.Style.space(8)

              Text {
                text: "󰊭"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.body
              }

              Text {
                text: "Gemini (Google AI Pro)"
                color: Commons.Color.foreground
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.bodySmall
                font.weight: Font.DemiBold
                Layout.fillWidth: true
                elide: Text.ElideRight
              }

              Text {
                text: "6% Quota"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                font.weight: Font.Bold
              }
            }

            RowLayout {
              Layout.fillWidth: true
              Text {
                text: "Google AI Pro Tier"
                color: Commons.Color.accent
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                elide: Text.ElideRight
                Layout.fillWidth: true
              }
              Text {
                text: "6% Pro Quota Available"
                color: Commons.Color.muted
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                elide: Text.ElideRight
              }
            }

            Rectangle {
              Layout.fillWidth: true
              height: 4
              radius: 2
              color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
              clip: true

              Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.max(4, parent.width * 0.06)
                radius: 2
                color: Commons.Color.accent
              }
            }
          }
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
