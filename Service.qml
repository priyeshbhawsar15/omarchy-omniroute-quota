pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
  id: root

  property var manifest: null
  property var shell: null

  readonly property string homeDir: Quickshell.env("HOME") || ""
  readonly property string helperBin: (manifest && manifest.__sourceDir)
    ? (manifest.__sourceDir + "/bin/omniroute-quota")
    : (homeDir + "/.config/omarchy/plugins/priyesh.omniroute-quota/bin/omniroute-quota")
  readonly property string stateFilePath: homeDir + "/.local/state/omarchy/omniroute-quota/state.json"

  property var copilotData: ({})
  property var codexData: ({})
  property var antigravityProData: ({})
  property int totalActive: 3
  property string lastUpdatedText: ""
  property bool hudVisible: true

  function formatTime(timestamp) {
    if (!timestamp) return ""
    var d = new Date(timestamp * 1000)
    var h = d.getHours()
    var m = d.getMinutes()
    var s = d.getSeconds()
    return (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s)
  }

  function handleState(jsonText) {
    if (!jsonText || jsonText.length === 0) return
    try {
      var data = JSON.parse(jsonText)
      if (data.copilot) root.copilotData = data.copilot
      if (data.codex) root.codexData = data.codex
      if (data.antigravityPro) root.antigravityProData = data.antigravityPro
      if (data.totalActive !== undefined) root.totalActive = data.totalActive
      if (data.lastUpdated) root.lastUpdatedText = formatTime(data.lastUpdated)
    } catch (e) {
      console.warn("omniroute-quota: parse error", e)
    }
  }

  function refresh() {
    if (fetchProc.running) fetchProc.running = false
    fetchProc.command = ["python3", root.helperBin, "refresh"]
    fetchProc.running = true
  }

  function toggle() {
    root.hudVisible = !root.hudVisible
  }

  FileView {
    id: stateWatcher
    path: root.stateFilePath
    printErrors: false
    watchChanges: true
    onLoaded: {
      root.handleState(stateWatcher.text())
    }
  }

  Process {
    id: fetchProc
    command: ["python3", root.helperBin, "refresh"]
    stdout: StdioCollector {
      id: fetchOut
      waitForEnd: true
      onStreamFinished: {
        root.handleState(fetchOut.text)
      }
    }
    onExited: function(exitCode, exitStatus) {
      if (exitCode === 0 && fetchOut.text.length > 0) {
        root.handleState(fetchOut.text)
      }
    }
  }

  Timer {
    id: autoRefreshTimer
    interval: 30000
    running: true
    repeat: true
    onTriggered: root.refresh()
  }

  Component.onCompleted: {
    if (stateWatcher.loaded) {
      root.handleState(stateWatcher.text())
    }
    root.refresh()
  }

  HudOverlay {
    id: hudWindow
    pluginService: root
    visible: root.hudVisible
  }

  IpcHandler {
    target: "priyesh.omniroute-quota"

    function refresh(): void { root.refresh() }
    function toggle(): void { root.toggle() }
    function show(): void { root.hudVisible = true }
    function hide(): void { root.hudVisible = false }
  }
}
