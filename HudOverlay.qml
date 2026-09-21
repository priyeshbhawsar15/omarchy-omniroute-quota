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

  implicitWidth: 380
  implicitHeight: hudFrame.implicitHeight
  color: "transparent"

  WlrLayershell.namespace: "omniroute-quota-hud"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    id: hudFrame
    width: hudWindow.implicitWidth
    implicitHeight: mainCol.implicitHeight + Commons.Style.space(28)
    radius: Commons.Style.space(12)
    color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.88)
    border.width: 1
    border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.18)
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
          }

          Text {
            text: hudWindow.pluginService ? (hudWindow.pluginService.totalActive + " active providers") : "Connecting…"
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

      // SECTION 1: GITHUB COPILOT (PREMIUM REQUESTS)
      ColumnLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(6)

        Text {
          text: "GITHUB COPILOT (PREMIUM REQUESTS)"
          color: Commons.Color.muted
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
          font.weight: Font.Bold
          font.letterSpacing: 1
        }

        Rectangle {
          Layout.fillWidth: true
          height: 72
          radius: Commons.Style.space(8)
          color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
          border.width: 1
          border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: Commons.Style.space(10)
            spacing: Commons.Style.space(6)

            RowLayout {
              Layout.fillWidth: true
              spacing: Commons.Style.space(8)

              Text {
                text: "󰊤"
                color: "#10b981"
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.title
              }

              ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                Text {
                  text: "GitHub Copilot"
                  color: Commons.Color.foreground
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.bodySmall
                  font.weight: Font.DemiBold
                }
                Text {
                  text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.plan || "Business Seat Quota") : "Business Seat Quota"
                  color: "#38bdf8"
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                }
              }

              ColumnLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 1
                Text {
                  Layout.alignment: Qt.AlignRight
                  text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.quotaText || "89% Premium Quota Left") : "89% Premium Quota Left"
                  color: "#10b981"
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  font.weight: Font.Bold
                }
                Text {
                  Layout.alignment: Qt.AlignRight
                  text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.detail || "Seat License Active") : "Seat License Active"
                  color: Commons.Color.muted
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                }
              }
            }

            Rectangle {
              Layout.fillWidth: true
              height: 4
              radius: 2
              color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
              Rectangle {
                height: parent.height
                radius: 2
                width: parent.width * 0.89
                color: "#10b981"
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
          height: 104
          radius: Commons.Style.space(8)
          color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
          border.width: 1
          border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: Commons.Style.space(10)
            spacing: Commons.Style.space(8)

            RowLayout {
              Layout.fillWidth: true
              Text {
                text: "󰚩  OpenAI Codex"
                color: Commons.Color.foreground
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.bodySmall
                font.weight: Font.DemiBold
              }
              Item { Layout.fillWidth: true }
              Text {
                text: hudWindow.pluginService && hudWindow.pluginService.codexData ? String(hudWindow.pluginService.codexData.plan || "ChatGPT Plus") : "ChatGPT Plus"
                color: "#38bdf8"
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
                  text: "5-Hour Window Limit"
                  color: Commons.Color.muted
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                }
                Item { Layout.fillWidth: true }
                Text {
                  text: hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.fiveHour ? String(hudWindow.pluginService.codexData.fiveHour.text || "0% Available (Limit Reached)") : "0% Available (Limit Reached)"
                  color: "#f43f5e"
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
                Rectangle {
                  height: parent.height
                  radius: 2
                  width: 4
                  color: "#f43f5e"
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
                }
                Item { Layout.fillWidth: true }
                Text {
                  text: hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.weekly ? String(hudWindow.pluginService.codexData.weekly.text || "12% Available (Weekly Rolling)") : "12% Available (Weekly Rolling)"
                  color: "#f59e0b"
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
                Rectangle {
                  height: parent.height
                  radius: 2
                  width: parent.width * 0.12
                  color: "#f59e0b"
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
            text: hudWindow.pluginService && hudWindow.pluginService.antigravityProData ? String(hudWindow.pluginService.antigravityProData.quotaText || "6% Pro Quota Left") : "6% Pro Quota Left"
            color: "#f59e0b"
            font.family: Commons.Style.font.family
            font.pixelSize: Commons.Style.font.caption
            font.weight: Font.Bold
          }
        }

        Repeater {
          model: hudWindow.pluginService && hudWindow.pluginService.antigravityProData ? hudWindow.pluginService.antigravityProData.models : []
          delegate: Rectangle {
            id: proModelCard
            required property var modelData
            Layout.fillWidth: true
            height: 64
            radius: Commons.Style.space(8)
            color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
            border.width: 1
            border.color: Qt.rgba(245, 158, 11, 0.3)

            ColumnLayout {
              anchors.fill: parent
              anchors.margins: Commons.Style.space(10)
              spacing: Commons.Style.space(6)

              RowLayout {
                Layout.fillWidth: true
                spacing: Commons.Style.space(6)

                Text {
                  text: "󰊭"
                  color: "#f59e0b"
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.body
                }

                Text {
                  text: modelData ? String(modelData.name || "Gemini (Google AI Pro)") : "Gemini (Google AI Pro)"
                  color: Commons.Color.foreground
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.bodySmall
                  font.weight: Font.DemiBold
                  Layout.fillWidth: true
                  elide: Text.ElideRight
                }

                Text {
                  text: "6% Quota"
                  color: "#f59e0b"
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  font.weight: Font.Bold
                }
              }

              RowLayout {
                Layout.fillWidth: true
                Text {
                  text: modelData ? String(modelData.detail || "6% Pro Quota Available") : "6% Pro Quota Available"
                  color: Commons.Color.muted
                  font.family: Commons.Style.font.family
                  font.pixelSize: Commons.Style.font.caption
                  Layout.fillWidth: true
                  elide: Text.ElideRight
                }
              }

              Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
                Rectangle {
                  height: parent.height
                  radius: 2
                  width: Math.max(4, parent.width * 0.06)
                  color: "#f59e0b"
                }
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
