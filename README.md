# marhund's Windows dotfiles / setup

An automated Windows setup script designed for both a completely fresh and/or used Windows installation. Full wiki in production.

<details> 
  <summary>Core features</summary> 

  - **Debloat**: Usage of Chris Titus Winutil or Talon per users choice for Windows debloating (optional)
  - **Functionality**: Plethora of usability first programs and applications
  - **No Tiling windows manager**: You do not need it. Stop LARPing.
  - **RAM friendly**: NO ELECTRON APPS - script (unless user chooses himself in CTT) installs no bullshit RAM-hogging Electron applications, ie. no Discord, Obsidian, VS Code..
  - **Transparent installation**: User has full control over the script, if he chooses to
  
</details>

## Description

Setting up a Windows enviroment to not be comletely goy-garbage from scratch is tedious. These "dotfiles" aim for a clean, Flow Launcher-centric Windows enviroment. Almost the whole process is automated using PowerShell and Winget. Upon execution, the script prompts for administrative privileges and provides a menu to choose your setup level. It handles everything from HWID Windows activation (via MAS) and system debloating (via Chris Titus Tool or Talon) to installing terminal environments (PowerShell 7, Oh My Posh, Zoxide) and ricing utilities (Windhawk, YASB, Flow-Launcher). It automatically symlinks settings and configures AutoHotkey (v2) for shortcuts, text bangs and "theme" switching.

This whole thing started as a learning project. Have mercy on me, I am working on this alone in the evenings with having a full-time job.

## Getting Started

### Dependencies

- Windows 11 - not tested on anything else, W10 at your own risk
- Internet connection
- PowerShell 7 (script may be broken on legacy Windows PowerShell !!)

### Installing & Executing
You do not need to download the repository manually. You can run the entire installation process directly from PowerShell terminal.

Open Windows PowerShell (as Administrator).

```
irm https://raw.githubusercontent.com/marhund/win_dotfiles_rice/main/install.ps1 | iex
```

The script will automatically download the latest ZIP from this repository, extract it to your Downloads folder, and launch the install.

> [!IMPORTANT]
> Not everything is automatic check the section "Manual tweaks" to see more.
### Included ricing/functionality apps

- **Flow Launcher** config
- **YASB** with custom styling
- **DropShelf**
- **QuickLook**
- **AltSnap**
- **PowerToys** slightly preconfigured
- **Windhawk** with the most useful stuff preinstalled
- **Autohotkey** script with custom keybinds, text settings and "theme" switching
- **Memreduct** for memory management
- **ProcessLasso** for memory management
- **Zed** - in the Extra variant
- **Helium** browser
- **Windows Terminal** styling
- **PowerShell** config
-  **Oh My Posh** select themes, so far not any from me
-  **Fastfetch** in the Extra variant

## Manual tweaks

After script finishes running, restart your PC. On first boot after, give it more time to digest what just happened to it. Various things were added to the Startup folder, some will pop-up and require manual settings to start them minimized next time. These include:
- Process Lasso
- Memreduct
-  PowerToys

Then, Windhawk will have to be set-up manually. 12 mods come preinstalled, however, they have to be manually compiled and activated.

YASB requires your own  WeatherAPI key in the config.yaml file.

If you want to tweak some keybindings, themes, text bangs, you will have to edit `AHK\dotfiles_main_scr.ahk` script.

If you installed Zed, the theme that I use is Catppuccin Espresso (Blur).

> [!IMPORTANT]
> PowerToys are kinda annoying and force themselves onto the Ctrl+Alt+Space shortcut. Disable  `PowerToysRun ` in PowerToys to not clash with FlowLauncher. Alternatively, configure your own keybind.

## Keybindings
The script introduces various new keybindings. Table for V2.
Certain vanilla keybinds are removed, such as Win+T for the bullshit widget. If not listed here, all useful keybinds (Win+Shift+L/R arrows and others) remain unchanged.

<table>
  <tr>
    <th>Action</th>
    <th>Shortcut</th>
  </tr>
  <tr>
    <td>Open Terminal</td>
    <td><kbd>Win</kbd> + <kbd>Enter</kbd></td>
  </tr>
  <tr>
    <td>Quit App / Window (alternative to Alt+F4)</td>
    <td><kbd>Win</kbd> + <kbd>Q</kbd></td>
  </tr>
  <tr>
    <td>Open browser (manual config)</td>
    <td><kbd>Win</kbd> + <kbd>W</kbd></td>
  </tr>
  <tr>
    <td>Open Zed (if installed)</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>Z</kbd></td>
  </tr>
  <tr>
    <td>Open PowerToys</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>P</kbd></td>
  </tr>
  <tr>
    <td>Open Windhawk</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>W</kbd></td>
  </tr>
  <tr>
    <td>Open/Close YASB</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>Y</kbd></td>
  </tr>
  <tr>
    <td>Flush RAM via Memreduct</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>M</kbd></td>
  </tr>
  <tr>
    <td>Theme switching</td>
    <td><kbd>Win</kbd> + <kbd>Alt</kbd>+<kbd>Function keys</kbd></td>
  </tr>
  <tr>
    <td>Advanced paste</td>
    <td><kbd>Win</kbd> + <kbd>Alt</kbd>+<kbd>V</kbd></td>
  </tr>
  <tr>
    <td>Color Picker</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>C</kbd></td>
  </tr>
  <tr>
    <td>Theme switching</td>
    <td><kbd>Win</kbd> + <kbd>Alt</kbd>+<kbd>Function keys</kbd></td>
  </tr>
  <tr>
    <td>FancyZones editor</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>F</kbd></td>
  </tr>
  <tr>
    <td>PowerToys keyboard manager (usage not recommended)</td>
    <td><kbd>Win</kbd> + <kbd>Shift</kbd>+<kbd>Q</kbd></td>
  </tr>
  <tr>
    <td>Workspace editor</td>
    <td><kbd>Win</kbd> + <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>W</kbd></td>
  </tr>
</table>

## Inspirations and shoutouts

> [!NOTE]
> This list is by no means exhaustive

- [end_4](https://github.com/end-4/dots-hyprland) and his dotfiles, which I am currently user of on my linux laptop, and I got this whole idea in motion because of his setup
- [Raven Development Team](https://ravendevteam.org/) for Talon utility
- [ChrisTitusTech](https://github.com/christitustech) ([CTT WinUtil](https://github.com/christitustech/winutil)) for CTT utility
- [HyDE](https://github.com/HyDE-Project/HyDE?tab=readme-ov-file) and their awsome dotfiles
- [ashish0kumar](https://github.com/ashish0kumar/windots/tree/main) and his "windots"
- [DHH](https://github.com/dhh) and Omarchy, which I am on-and-off user of
- [MAS](https://massgrave.dev/) and their activation scripts

## License

This project is licensed under the MIT License - see the LICENSE.md file for details. (Note: Third-party scripts downloaded during the setup, such as Talon or CTT, are governed by their respective licenses).

### Version History
1.0

 - Initial Release & Automation setup

2.0

- Current
- Code and settings overhaul, addition of applications, addition of Talon options, added logging
