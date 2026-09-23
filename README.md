# OmniRoute Quota Widget for Omarchy

Live OmniRoute AI provider quota, model count, and connection health HUD widget pinned to monitor DP-4.

## Features

- Pinned directly to portrait monitor `DP-4` as a desktop HUD.
- Reads OmniRoute's official Provider Limits API (`/api/usage/provider-limits`) and joins it to active connections from `/api/providers`.
- Performs an upstream live quota refresh at startup and on manual refresh; lightweight background polls read OmniRoute's cached provider-limit observations every 30 seconds.
- Shows truthful Copilot premium-interaction, Codex 5-hour/weekly, and active Antigravity Pro Gemini remaining percentages and reset intervals. Missing telemetry is shown as unavailable rather than assumed to be 100%.
- Configurable via `~/.config/omarchy/omniroute-quota.json`.
- CLI helper: `omniroute-quota {refresh|status|config}`.

## License

MIT
