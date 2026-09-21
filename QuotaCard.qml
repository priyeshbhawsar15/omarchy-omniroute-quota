import QtQuick
import QtQuick.Layouts
import qs.Commons as Commons

Rectangle {
  id: card

  required property var modelData
  property color accent: Commons.Color.accent

  readonly property string provider: modelData && modelData.provider ? String(modelData.provider) : ""
  readonly property string name: modelData && modelData.name ? String(modelData.name) : "Provider"
  readonly property int modelCount: modelData && modelData.modelCount ? Number(modelData.modelCount) : 0
  readonly property real percent: modelData && modelData.quotaPercent !== undefined ? Number(modelData.quotaPercent) : 100
  readonly property string resetIn: modelData && modelData.resetIn ? String(modelData.resetIn) : "Active"
  readonly property string status: modelData && modelData.status ? String(modelData.status) : "active"

  readonly property color statusColor: percent <= 20 ? "#ef4444" : percent <= 50 ? "#f59e0b" : "#10b981"

  width: parent ? parent.width : 300
  height: 64
  radius: Commons.Style.space(8)
  color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.65)
  border.width: 1
  border.color: Qt.rgba(Commons.Color.foreground.r, Commons.Color.foreground.g, Commons.Color.foreground.b, 0.12)

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: Commons.Style.space(10)
    spacing: Commons.Style.space(6)

    RowLayout {
      Layout.fillWidth: true
      spacing: Commons.Style.space(8)

      Rectangle {
        width: 8
        height: 8
        radius: 4
        color: card.statusColor
      }

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
        text: card.modelCount > 0 ? (card.modelCount + " models") : ""
        color: Commons.Color.muted
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.caption
      }

      Text {
        text: card.resetIn
        color: Commons.Color.muted
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.caption
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
        width: Math.max(4, Math.min(parent.width, parent.width * (card.percent / 100)))
        color: card.statusColor
      }
    }
  }
}
