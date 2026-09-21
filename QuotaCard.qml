import QtQuick
import QtQuick.Layouts
import qs.Commons as Commons

Rectangle {
  id: card

  property var modelData: null

  readonly property string provider: modelData && modelData.provider ? String(modelData.provider) : ""
  readonly property string name: modelData && modelData.name ? String(modelData.name) : "Provider"
  readonly property string plan: modelData && modelData.plan ? String(modelData.plan) : ""
  readonly property int percent: modelData && modelData.quotaPercent !== undefined ? Number(modelData.quotaPercent) : 100
  readonly property string resetIn: modelData && modelData.resetIn ? String(modelData.resetIn) : "Active"
  readonly property string status: modelData && modelData.status ? String(modelData.status) : "active"

  readonly property bool isExhausted: status === "exhausted" || percent <= 0
  readonly property bool isDisabled: status === "disabled"
  readonly property color statusColor: isDisabled ? "#64748b" : (isExhausted ? "#f43f5e" : (percent <= 50 ? "#f59e0b" : "#10b981"))

  readonly property string providerGlyph: {
    if (provider.indexOf("github") >= 0) return "󰊤"
    if (provider.indexOf("codex") >= 0 || provider.indexOf("chatgpt") >= 0 || provider.indexOf("openai") >= 0) return "󰚩"
    if (provider.indexOf("antigravity") >= 0 || provider.indexOf("google") >= 0 || provider.indexOf("gemini") >= 0) return "󰊭"
    if (provider.indexOf("openrouter") >= 0) return "󱂛"
    if (provider.indexOf("horde") >= 0) return "󰮔"
    return "󰧑"
  }

  width: parent ? parent.width : 320
  height: 72
  radius: Commons.Style.space(8)
  color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.70)
  border.width: 1
  border.color: isExhausted ? Qt.rgba(244, 63, 94, 0.4) : Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Commons.Style.space(10)
    spacing: Commons.Style.space(6)

    RowLayout {
      Layout.fillWidth: true
      spacing: Commons.Style.space(8)

      // Provider Icon
      Text {
        text: card.providerGlyph
        color: card.statusColor
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.title
      }

      ColumnLayout {
        Layout.fillWidth: true
        spacing: 1

        Text {
          text: card.name
          color: Commons.Color.foreground
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.bodySmall
          font.weight: Font.DemiBold
          Layout.fillWidth: true
          elide: Text.ElideRight
        }

        Text {
          text: card.plan.length > 0 ? card.plan : (card.isDisabled ? "Disabled" : "Active connection")
          color: Commons.Color.muted
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
          Layout.fillWidth: true
          elide: Text.ElideRight
        }
      }

      // Quota & Time Readout
      ColumnLayout {
        Layout.alignment: Qt.AlignRight
        spacing: 1

        Text {
          Layout.alignment: Qt.AlignRight
          text: card.isDisabled ? "0% Quota" : (card.isExhausted ? "Quota Exhausted" : (card.percent + "% Quota"))
          color: card.statusColor
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
          font.weight: Font.Bold
        }

        Text {
          Layout.alignment: Qt.AlignRight
          text: card.resetIn
          color: card.isExhausted ? "#fda4af" : Commons.Color.muted
          font.family: Commons.Style.font.family
          font.pixelSize: Commons.Style.font.caption
        }
      }
    }

    // Quota Progress Bar
    Rectangle {
      Layout.fillWidth: true
      height: 4
      radius: 2
      color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.10)

      Rectangle {
        height: parent.height
        radius: 2
        width: Math.max(4, Math.min(parent.width, parent.width * (Math.max(0, card.percent) / 100)))
        color: card.statusColor
      }
    }
  }
}
