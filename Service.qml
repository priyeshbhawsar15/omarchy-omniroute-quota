import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
  id: root

  property var manifest: null
  property var shell: null

  readonly property string homeDir: Quickshell.env("HOME") || ""
  readonly property string helperBin: (manifest && manifest.__sourceDir)
    ? (manifest.__sourceDir + "/bin/omniroute-quota")
    : (homeDir + "/.config/omarchy/plugins/priyesh.omniroute-quota/bin/omniroute-quota")

  property var providers: []
  property int totalActive: 0
  property string authNotice: ""
  property string lastUpdatedText: ""
  property bool hudVisible: true

  property var hudInstance: null

  function formatTime(timestamp) {
    if (!timestamp) return ""
    var d = new Date(timestamp * 1000)
    var h = d.getHours()
    var m = d.getMinutes()
    return (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m)
  }

  function handleState(jsonText) {
    try {
      var data = JSON.parse(jsonText)
      if (data.providers) root.providers = data.providers
      if (data.totalActive !== undefined) root.totalActive = data.totalActive
      root.authNotice = data.authNotice || ""
      if (data.lastUpdated) root.lastUpdatedText = formatTime(data.lastUpdated)
    } catch (e) {
      console.warn("omniroute-quota: parse error", e)
    }
  }

  function refresh() {
    fetchProc.running = true
  }

  function toggle() {
    root.hudVisible = !root.hudVisible
    if (root.hudInstance) root.hudInstance.visible = root.hudVisible
  }

  Process {
    id: fetchProc
    command: ["python3", root.helperBin, "refresh"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        root.handleState(text)
      }
    }
  }

  Timer {
    id: autoRefreshTimer
    interval: 60000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Component.onCompleted: {
    root.refresh()
    Qt.callLater(function() {
      var comp = Qt.createComponent(Qt.resolvedUrl("HudOverlay.qml"))
      if (comp.status === Component.Ready) {
        root.hudInstance = comp.createObject(root, { pluginService: root, visible: root.hudVisible })
      } else {
        console.warn("omniroute-quota: failed to load HudOverlay", comp.errorString())
      }
    })
  }

  Component.onDestruction: {
    if (root.hudInstance) {
      root.hudInstance.destroy()
      root.hudInstance = null
    }
  }

  IpcHandler {
    target: "priyesh.omniroute-quota"

    function refresh(): void { root.refresh() }
    function toggle(): void { root.toggle() }
    function show(): void { root.hudVisible = true; if (root.hudInstance) root.hudInstance.visible = true }
    function hide(): void { root.hudVisible = false; if (root.hudInstance) root.hudInstance.visible = false }
  }
}
