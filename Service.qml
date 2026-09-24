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
  readonly property string settingsFilePath: homeDir + "/.local/state/omarchy/omniroute-quota/settings.json"

  property var copilotData: ({})
  property var codexData: ({})
  property var antigravityProData: ({})
  property int totalActive: 3
  property string lastUpdatedText: ""
  property bool hudVisible: true
  property bool isPinned: false
  property bool autohideEnabled: false

  function loadSettings(jsonText) {
    if (!jsonText || jsonText.length === 0) return
    try {
      var s = JSON.parse(jsonText)
      if (s.isPinned !== undefined) root.isPinned = (s.isPinned === true)
      if (s.autohideEnabled !== undefined) root.autohideEnabled = (s.autohideEnabled === true)
    } catch (e) {}
  }

  function saveSettings() {
    saveSettingsProc.command = [
      "python3", "-c",
      "import json, os, sys; p = sys.argv[1]; os.makedirs(os.path.dirname(p), exist_ok=True); open(p, 'w').write(json.dumps({'isPinned': sys.argv[2] == '1', 'autohideEnabled': sys.argv[3] == '1'}))",
      root.settingsFilePath, root.isPinned ? "1" : "0", root.autohideEnabled ? "1" : "0"
    ]
    saveSettingsProc.running = true
  }

  function togglePin() {
    root.isPinned = !root.isPinned
    root.saveSettings()
  }

  function toggleAutohide() {
    root.autohideEnabled = !root.autohideEnabled
    root.saveSettings()
  }

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

  function refresh(forceLive) {
    if (fetchProc.running) return
    fetchProc.command = ["python3", root.helperBin, forceLive === true ? "refresh" : "fetch"]
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

  FileView {
    id: settingsWatcher
    path: root.settingsFilePath
    printErrors: false
    watchChanges: true
    onLoaded: root.loadSettings(settingsWatcher.text())
    onTextChanged: root.loadSettings(settingsWatcher.text())
  }

  Process {
    id: saveSettingsProc
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
    onTriggered: root.refresh(false)
  }

  Component.onCompleted: {
    if (settingsWatcher.loaded) {
      root.loadSettings(settingsWatcher.text())
    }
    if (stateWatcher.loaded) {
      root.handleState(stateWatcher.text())
    }
    root.refresh(true)
  }

  HudOverlay {
    id: hudWindow
    pluginService: root
    visible: root.hudVisible
  }

  IpcHandler {
    target: "priyesh.omniroute-quota"

    function refresh(): void { root.refresh(true) }
    function toggle(): void { root.toggle() }
    function show(): void { root.hudVisible = true }
    function hide(): void { root.hudVisible = false }
    function togglePin(): void { root.togglePin() }
    function toggleAutohide(): void { root.toggleAutohide() }
  }
}
