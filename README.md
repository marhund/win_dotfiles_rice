# marhund's Windows dotfiles / setup

An automated Windows setup script designed for both a completely fresh and/or used Windows installation. This README is quite bare bones and more for people who know what they are doing when it comes to configuring `.json` and `.yaml` files, or are familiar with the applications listed below. Full wiki for everyone in production.

<details> 
  <summary>Core features</summary> 

  - **Debloat**: Usage of Chris Titus Winutil or Talon per users choice for Windows debloating (optional)
  - **Functionality**: Plethora of usability first (and ricing) programs and applications
  - **No Tiling windows manager**: You do not need it. Stop LARPing. If you do, you ain't reading this anyway.
  - **No Anime**: I hate weebs.
  - **NO ELECTRON APPS**: Script (unless user chooses himself in CTT) installs no bullshit RAM-hogging Electron applications, ie. no Discord, Obsidian, Spotify, VS Code..
  - **Low(er) RAM usage**: Look, Windows is never gonna be RAM friendly, but stuff like Seelen UI is crazy. This whole thing adds around 200 MB tops of idle RAM usage.
  - **Size**: Depends on your choice of mode, however its all around 1.2 GB. PowerToys is the largest program at around 400 MB. 
  - **Transparent installation**: User has full control over the script, if he chooses to.
  
</details>

## Preview

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/yasb-preview.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/lowlight-preview.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/lowlight-preview2.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/lowlight-preview3.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/lowlight-preview4.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/firewatch-preview.png)

![Preview](https://raw.githubusercontent.com/marhund/win_dotfiles_rice/assets/assets/greenery-preview.png)

## Description

The age old "just use Linux" is a valid, yet not a complete solution. Some programs just don't work on Linux, and you have to be running Windows, just like me. Setting up a Windows enviroment to not be comletely goy-garbage from scratch is tedious. These "dotfiles" aim for a clean, Flow Launcher-centric Windows enviroment. Almost the whole process is automated using PowerShell and Winget. Upon execution, the script prompts for administrative privileges and provides a menu to choose your setup level. It handles everything from HWID Windows activation (via MAS) and system debloating (via Chris Titus Tool or Talon) to installing terminal environments (PowerShell 7, Oh My Posh, Zoxide) and ricing utilities (Windhawk, YASB, Flow-Launcher). It automatically symlinks settings and configures AutoHotkey (v2) for shortcuts, text bangs and "theme" switching.

This whole thing started as a learning project. Have mercy on me, I am working on this alone in the evenings with having a full-time job.

## Getting Started

### Dependencies

- Windows 11 - not tested on anything else, W10 at your own risk
- Internet connection
- PowerShell 7 (script may be broken on legacy Windows PowerShell !!)

### Installing & Executing
You do not need to download the repository manually. You can run the entire installation process directly from PowerShell terminal.

Open PowerShell (as Administrator).

```
irm https://raw.githubusercontent.com/marhund/win_dotfiles_rice/main/install.ps1 | iex
```

The script will automatically download the latest ZIP from this repository, extract it to your Downloads folder, and launch the install.

> [!IMPORTANT]
> Not everything is automatic, check the section "Manual tweaks" to see more.
### Included ricing/functionality apps

- [**Flow Launcher**](https://www.flowlauncher.com/) config
- [**YASB**](https://github.com/amnweb/yasb) with custom styling
- [**DropShelf**](https://apps.microsoft.com/detail/9mzpc6p14l7n?hl=en-US)
- [**QuickLook**](https://github.com/QL-Win/QuickLook)
- [**AltSnap**](https://github.com/RamonUnch/AltSnap)
- [**PowerToys**](https://github.com/microsoft/PowerToys) slightly preconfigured
- [**Windhawk**](https://windhawk.net/) with the most useful stuff preinstalled
- [**Autohotkey**](https://www.autohotkey.com/) script with custom keybinds, text settings and "theme" switching
- [**Memreduct**](https://memreduct.org/2024/03/12/mem-reduct-installation-and-setup-guide/) for memory management
- [**FxSound**](https://www.fxsound.com/) for better audio experience
- [**ProcessLasso**](https://bitsum.com/download-process-lasso/) for memory management
- [**Zed**](https://zed.dev/) - in the Extra variant
- [**Helium**](https://helium.computer/) browser in the Extra variant
- [**Windows Terminal**](https://github.com/microsoft/terminal) styling
- [**PowerShell**](https://github.com/PowerShell/PowerShell) config
- [**Oh My Posh**](https://ohmyposh.net/) select themes, so far not any from me
- [**Zoxide**](https://github.com/ajeetdsouza/zoxide)
- [**Fastfetch**](https://github.com/fastfetch-cli/fastfetch) in the Extra variant

## Manual tweaks / After install

After script finishes running, restart your PC. On first boot after, give it more time to digest what just happened to it. Various things were added to the Startup folder, some will pop-up and require manual settings to start them minimized next time. These include:

- Process Lasso
- Memreduct
-  PowerToys

Then, Windhawk will have to be set-up manually. 12 mods come preinstalled, however, they have to be manually compiled and activated.

PowerToys will also require you to skim through and configure it a bit, I don't use them much, therefore the preinstalled config is very minimal and not very useful.

YASB requires your own  WeatherAPI key in the `config.yaml` file.

If you want to tweak some keybindings, themes, text bangs, you will have to edit `AHK\dotfiles_main_scr.ahk` script.

If you installed Zed, the themes that I use are `Catppuccin Espresso (Blur)` or `Carbonfox - opaque`.

> [!IMPORTANT]
> PowerToys are kinda annoying and force themselves onto the Ctrl+Alt+Space (AltGR + Space) shortcut. Disable  `PowerToysRun ` in PowerToys to not clash with FlowLauncher. Alternatively, configure your own keybind.

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
    <td>Open FlowLauncher</td>
    <td><kbd>Alt GR</kbd> + <kbd>Space</kbd></td>
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

## YASB keybindings
With the style overhaul, I also added keybindings to widgets that support it. Makes for a smoother keyboard using experience.

<table>
  <tr>
    <th>Action</th>
    <th>Shortcut</th>
  </tr>
  <tr>
    <td>Home menu</td>
    <td><kbd>Alt</kbd> + <kbd>H</kbd></td>
  </tr>
  <tr>
    <td>Media on/off</td>
    <td><kbd>Alt</kbd> + <kbd>M</kbd></td>
  </tr>
  <tr>
    <td>Resources info</td>
    <td><kbd>Alt</kbd> + <kbd>S</kbd></td>
  </tr>
  <tr>
    <td>Network traffic</td>
    <td><kbd>Alt</kbd> + <kbd>T</kbd></td>
  </tr>
  <tr>
    <td>Audio controls</td>
    <td><kbd>Alt</kbd> + <kbd>V</kbd></td>
  </tr>
  <tr>
    <td>Calendar</td>
    <td><kbd>Alt</kbd> + <kbd>C</kbd></td>
  </tr>
  <tr>
    <td>Weather</td>
    <td><kbd>Alt</kbd> + <kbd>W</kbd></td>
  </tr>
  <tr>
    <td>Keyboard language</td>
    <td><kbd>Alt</kbd> + <kbd>K</kbd></td>
  </tr>
  <tr>
    <td>Recycle bin</td>
    <td><kbd>Alt</kbd> + <kbd>B</kbd></td>
  </tr>
</table>

## Inspirations and shoutouts

> [!NOTE]
> This list is by no means exhaustive.

- [end_4](https://github.com/end-4/dots-hyprland) and his dotfiles, which I was user of on my linux laptop, and I got this whole idea in motion because of his setup
- [Raven Development Team](https://ravendevteam.org/) for Talon utility
- [ChrisTitusTech](https://github.com/christitustech) ([CTT WinUtil](https://github.com/christitustech/winutil)) for CTT utility
- [HyDE](https://github.com/HyDE-Project/HyDE?tab=readme-ov-file) sick setup
- [ashish0kumar](https://github.com/ashish0kumar/windots/tree/main) and his "windots"
- [Louis047](https://github.com/Louis047/Windows-Dots) and his setup
- [DHH](https://github.com/dhh) and Omarchy, which I am on-and-off user of
- [MAS](https://massgrave.dev/) and their activation scripts

## License

This project is licensed under the MIT License - see the LICENSE.md file for details. (Note: Third-party scripts downloaded during the setup, such as Talon or CTT, are governed by their respective licenses).

### Version History
1.0

 - Initial release & Automation setup

2.0

- Current
- Code and settings overhaul, addition of applications, addition of Talon options, added logging
