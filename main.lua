# Universal Mobile Tool Spammer and Autoclicker

A lightweight, ultra-fast universal script designed for Roblox Mobile executors such as Delta, Arceus X, Codex, and Fluxus. It automatically scans the player's inventory and spams any selected tool at the maximum possible engine speed.

---

## Primary Purpose

* **Wall Clipping and Glitching**
  This script is specifically designed to help players pass through walls and solid objects (wall clip) in various Roblox games by utilizing high-speed tool equipping and unequipping mechanics.

---

## Core Features

* **Maximum Engine Speed**
  The spam interval is set to the absolute engine limit of 0.0001 seconds for instant execution and reliable glitching.

* **Live Inventory Scanner**
  The script automatically scans the backpack every second, dynamically adding new tools and removing dropped ones.

* **Dropdown Tool Selector**
  Features a highly compact user interface. Tapping the arrow expands the list to select a tool, then hides it to save screen space.

* **Mobile Optimized Layout**
  Includes smooth UI drag mechanics that do not interfere with the movement joystick or character control.

* **Universal Compatibility**
  Works flawlessly in any Roblox game that utilizes standard tools, including simulators, RPGs, and fighting games.

---

## Installation and Usage

1. Copy the source code from the `main.lua` file.
2. Paste the script into your mobile executor of choice.
3. Press Execute.
4. Tap the dropdown arrow to select a tool from your current inventory.
5. Toggle the main button to SPAM: ON.

---

## Changelog

### Version 1.1.0
* Integrated full UI library with smooth animations using `TweenService`.
* Added rounded corners (`UICorner`) to all buttons and dropdown menus for a modern mobile look.
* Optimized color indicators: text transitions between green (ON) and red (OFF).

### Version 1.0.0
* Initial release of the universal tool spammer.
* Added live inventory scanning every second (`task.wait(1)`).
* Implemented compact toggle button with expandable tool list.
* Specifically optimized for mobile executors and wall-clipping glitches.

---

## License

This project is licensed under the MIT License. You are free to modify, distribute, and build upon this code.

Developed by Noxis-spec
