# Changelog

All notable changes to this project will be documented in this file.

## [1.1.1] - 2026-11-02

### Fixed
- **Tool selection no longer resets** when the selected tool temporarily disappears from the inventory (e.g. dropped on death, moved between Backpack and Character). The choice is remembered until the user manually selects another tool.
- **Selected tool is now highlighted** in blue inside the dropdown, so it's always visible which tool is active.
- **Toggle button shows `SPAM: ON (waiting)`** when spam is enabled but the selected tool is temporarily unavailable — no more confusion between "script stopped" and "script waiting for tool".

### Changed
- `selectedToolName` is now stored outside the character lifecycle and survives respawn.
- `scanTools()` no longer clears the selection when a tool is missing; it only removes the button from the list.

## [1.1.0] - 2026-11-02

### Added
- **Anti-AFK system** — prevents 20-minute disconnection (Disconnection ID 260) via `Player.Idled` + `VirtualUser` signal. Closes roadmap item.
- **Speed Slider** — minimal drag slider inside the dropdown. Adjusts `SPAM_SPEED` in real time from `0.0001s` to `0.5s`. Quadratic curve gives finer control on the fast end. Closes roadmap item.
- **Draggable GUI group** — the whole UI (toggle button + arrow + dropdown) moves together. 10px threshold separates tap (click) from drag (move), so the button still works on mobile.
- **Object pool for tool buttons** — buttons are reused instead of destroyed/recreated every scan. Eliminates micro-freezes and FPS drops on low-end phones during hard spam.
- **Respawn-safe loops** — `generation` counter bumped on `CharacterAdded`. Stale spam loops self-terminate; GUI persists via `ResetOnSpawn = false`.

### Changed
- Tool scanning now compares current inventory against previous set instead of full clear/rebuild.
- Dropdown auto-closes after tool selection (unchanged behaviour, now smoother via pooled buttons).
- UI parent resolution: `gethui()` → `CoreGui` → `PlayerGui` fallback chain for executor compatibility (Delta, Arceus X, Codex, Fluxus).

### Fixed
- Drag no longer conflicts with click on the toggle button.
- GUI no longer disappears after death/respawn.
- Speed slider no longer blocks scrolling in the dropdown.

## [1.0.0] - 2026-11-02

### Added
- Initial release.
- Ultra-fast tool spam at `0.0001s` engine limit.
- Live inventory scanner (1s interval).
- Compact dropdown tool selector.
- Mobile-optimized draggable layout.
- Universal compatibility with any Roblox game using standard Tools.