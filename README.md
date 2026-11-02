# Universal Mobile Tool Spammer and Autoclicker

A lightweight, ultra-fast universal script designed for Roblox Mobile executors such as Delta, Arceus X, Codex, and Fluxus. It automatically scans the player's inventory and spams any selected tool at the maximum possible engine speed.

---

## Primary Purpose

- **Wall Clipping and Glitching** — This script is specifically designed to help players pass through walls and solid objects (wall clip) in various Roblox games by utilizing high-speed tool equipping and unequipping mechanics.

---

## Core Features

- **Maximum Engine Speed** — The spam interval is set to the absolute engine limit of `0.0001` seconds for instant execution and reliable glitching. Adjustable via in-GUI slider from `0.0001s` to `0.5s`.
- **Live Inventory Scanner** — The script automatically scans the backpack every second, dynamically adding new tools and removing dropped ones. Uses an object pool — no button recreation, no micro-freezes.
- **Dropdown Tool Selector** — Highly compact UI. Tapping the arrow expands the list to select a tool, then hides it to save screen space.
- **Mobile Optimized Layout** — Smooth UI drag mechanics (whole GUI group moves together) that do not interfere with the movement joystick or character control. 10px threshold separates tap from drag.
- **Speed Slider** — Real-time spam delay adjustment directly from the dropdown. Quadratic curve for precision on the fast end.
- **Anti-AFK** — Background `Player.Idled` handler prevents 20-minute disconnection (Disconnection ID 260).
- **Respawn-Safe** — GUI persists through death and respawn. Spam loops restart cleanly on `CharacterAdded`.
- **Universal Compatibility** — Works flawlessly in any Roblox game that utilizes standard tools, including simulators, RPGs, and fighting games.

---

## Installation and Usage

1. Copy the source code from the `main.lua` file.
2. Paste the script into your mobile executor of choice.
3. Press Execute.
4. Tap the dropdown arrow to select a tool from your current inventory.
5. Toggle the main button to `SPAM: ON`.
6. (Optional) Drag the slider inside the dropdown to adjust spam speed.
7. (Optional) Drag the whole GUI by holding the toggle or arrow button and moving — tap without moving still works as a click.

**Quick load:**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/universal-tool-spam/main/main.lua"))()