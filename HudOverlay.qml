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
    bottom: true
  }

  margins {
    top: Commons.Style.space(48)
    right: Commons.Style.space(16)
    bottom: Commons.Style.space(48)
  }

  implicitWidth: 380
  color: "transparent"

  WlrLayershell.namespace: "omniroute-quota-hud"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  Rectangle {
    id: hudFrame
    anchors.fill: parent
    radius: Commons.Style.space(12)
    color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.88)
    border.width: 1
    border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.18)
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

      // Scrollable Content
      Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentWidth: width
        contentHeight: mainCol.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ColumnLayout {
          id: mainCol
          width: parent.width
          spacing: Commons.Style.space(12)

          // SECTION 1: GITHUB COPILOT PREMIUM REQUESTS
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
                      text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.plan || "Business Seat") : "Business Seat"
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
                      text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.quotaText || "Unlimited Premium") : "Unlimited Premium"
                      color: "#10b981"
                      font.family: Commons.Style.font.family
                      font.pixelSize: Commons.Style.font.caption
                      font.weight: Font.Bold
                    }
                    Text {
                      Layout.alignment: Qt.AlignRight
                      text: hudWindow.pluginService && hudWindow.pluginService.copilotData ? String(hudWindow.pluginService.copilotData.detail || "Seat Quota Active") : "Seat Quota Active"
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
                    width: parent.width
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

                // 5-Hour Limit Bar
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
                      text: hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.fiveHour ? String(hudWindow.pluginService.codexData.fiveHour.text || "Active") : "Active"
                      color: (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.fiveHour && hudWindow.pluginService.codexData.fiveHour.status === "exhausted") ? "#f43f5e" : "#10b981"
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
                      width: parent.width * (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.fiveHour ? (Number(hudWindow.pluginService.codexData.fiveHour.percent) / 100) : 1)
                      color: (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.fiveHour && hudWindow.pluginService.codexData.fiveHour.status === "exhausted") ? "#f43f5e" : "#10b981"
                    }
                  }
                }

                // Weekly Limit Bar
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
                      text: hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.weekly ? String(hudWindow.pluginService.codexData.weekly.text || "Active") : "Active"
                      color: (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.weekly && hudWindow.pluginService.codexData.weekly.status === "exhausted") ? "#f43f5e" : "#10b981"
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
                      width: parent.width * (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.weekly ? (Number(hudWindow.pluginService.codexData.weekly.percent) / 100) : 1)
                      color: (hudWindow.pluginService && hudWindow.pluginService.codexData && hudWindow.pluginService.codexData.weekly && hudWindow.pluginService.codexData.weekly.status === "exhausted") ? "#f43f5e" : "#10b981"
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
                text: hudWindow.pluginService && hudWindow.pluginService.antigravityData ? String(hudWindow.pluginService.antigravityData.tier || "Google AI Pro") : "Google AI Pro"
                color: "#a855f7"
                font.family: Commons.Style.font.family
                font.pixelSize: Commons.Style.font.caption
                font.weight: Font.Bold
              }
            }

            Repeater {
              model: hudWindow.pluginService && hudWindow.pluginService.antigravityData ? hudWindow.pluginService.antigravityData.models : []
              delegate: Rectangle {
                id: geminiCard
                required property var modelData
                Layout.fillWidth: true
                height: 64
                radius: Commons.Style.space(8)
                color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
                border.width: 1
                border.color: (modelData && modelData.status === "exhausted") ? Qt.rgba(244, 63, 94, 0.4) : Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

                readonly property color barColor: (modelData && modelData.percent <= 20) ? "#f43f5e" : ((modelData && modelData.percent <= 50) ? "#f59e0b" : "#10b981")

                ColumnLayout {
                  anchors.fill: parent
                  anchors.margins: Commons.Style.space(10)
                  spacing: Commons.Style.space(6)

                  RowLayout {
                    Layout.fillWidth: true
                    spacing: Commons.Style.space(6)

                    Text {
                      text: modelData ? String(modelData.icon || "󰊭") : "󰊭"
                      color: geminiCard.barColor
                      font.family: Commons.Style.font.family
                      font.pixelSize: Commons.Style.font.body
                    }

                    Text {
                      text: modelData ? String(modelData.name || "") : ""
                      color: Commons.Color.foreground
                      font.family: Commons.Style.font.family
                      font.pixelSize: Commons.Style.font.bodySmall
                      font.weight: Font.DemiBold
                      Layout.fillWidth: true
                      elide: Text.ElideRight
                    }

                    Text {
                      text: modelData ? (modelData.percent + "% Pro Quota") : ""
                      color: geminiCard.barColor
                      font.family: Commons.Style.font.family
                      font.pixelSize: Commons.Style.font.caption
                      font.weight: Font.Bold
                    }
                  }

                  // Detail / Reset Time
                  RowLayout {
                    Layout.fillWidth: true
                    Text {
                      text: modelData ? String(modelData.detail || "") : ""
                      color: (modelData && modelData.status !== "active") ? "#fca5a5" : Commons.Color.muted
                      font.family: Commons.Style.font.family
                      font.pixelSize: Commons.Style.font.caption
                      Layout.fillWidth: true
                      elide: Text.ElideRight
                    }
                  }

                  // Progress bar
                  Rectangle {
                    Layout.fillWidth: true
                    height: 4
                    radius: 2
                    color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)
                    Rectangle {
                      height: parent.height
                      radius: 2
                      width: Math.max(4, parent.width * ((modelData ? Number(modelData.percent) : 100) / 100))
                      color: geminiCard.barColor
                    }
                  }
                }
              }
            }
          }

          // SECTION 4: OTHER CONNECTED GATEWAYS
          ColumnLayout {
            Layout.fillWidth: true
            spacing: Commons.Style.space(6)

            Text {
              text: "OTHER AI GATEWAYS"
              color: Commons.Color.muted
              font.family: Commons.Style.font.family
              font.pixelSize: Commons.Style.font.caption
              font.weight: Font.Bold
              font.letterSpacing: 1
            }

            Repeater {
              model: hudWindow.pluginService ? hudWindow.pluginService.otherProviders : []
              delegate: Rectangle {
                id: otherCard
                required property var modelData
                Layout.fillWidth: true
                height: 52
                radius: Commons.Style.space(8)
                color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
                border.width: 1
                border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

                readonly property color cardStatusColor: (modelData && modelData.status === "disabled") ? "#64748b" : "#10b981"

                RowLayout {
                  anchors.fill: parent
                  anchors.margins: Commons.Style.space(10)
                  spacing: Commons.Style.space(8)

                  Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: otherCard.cardStatusColor
                  }

                  Text {
                    text: modelData ? String(modelData.name || "") : ""
                    color: Commons.Color.foreground
                    font.family: Commons.Style.font.family
                    font.pixelSize: Commons.Style.font.bodySmall
                    font.weight: Font.DemiBold
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                  }

                  Text {
                    text: modelData ? String(modelData.detail || "") : ""
                    color: otherCard.cardStatusColor
                    font.family: Commons.Style.font.family
                    font.pixelSize: Commons.Style.font.caption
                  }
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
