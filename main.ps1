#this whole thing is a fun project, originally I made it to learn windows scripting, specifically powershell. lots of comments all around, AI was also used, I did review everything, kept some things, for example the section banner comments, I actually think thats very useful
#iam not a fucking windows developer, have mercy on me
#
# =====================================================================
# 0. FIX POWERSHELL DOWNLOADS
# =====================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  # used because of "The request was aborted: Could not create SSL/TLS secure channel." errors,  [] used because of .NET
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::SystemDefault # could also do this

# =====================================================================
# 1. ELEVATE TO ADMINISTRATOR & ACTIVATE WINDOWS
# =====================================================================

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit   #self elevating script, asks "are you admin? no? relaunch yourself as one", or more specifically "if you ARENT admin, relaunch)"
}

$RepoPath = $PSScriptRoot

Write-Host "Activating Windows... (will do nothing if you have active Windows already)" -ForegroundColor Yellow
& ([ScriptBlock]::Create((irm https://get.activated.win))) /HWID | Out-Null  # I did not know this existed, found it because of VM testing, sick
Write-Host " -> Windows Activated!" -ForegroundColor Green
Write-Host "`n=== Windows Dotfiles Setup ===" -ForegroundColor Cyan

# =====================================================================
# 2. CHOOSE YOUR SETUP
# =====================================================================

Write-Host "Choose the installation process. Windows de-bloating (disabling Edge, Copilot etc.), ei. tweaking the CTT is recommended." -ForegroundColor Yellow
Write-Host "[1] Full Setup (Manual CTT Debloat + Rice Stuff)"
Write-Host "[2] No CTT, Rice Only (No Debloat. Aestethics + some functionality, such as MemReduct and so on...)"
Write-Host "[3] Rice + Extra (Rice Stuff + Helium browser & Zed Editor)"
$menuChoice = Read-Host "Select an option (1/2/3)"

# define the app arrays
$RiceApps = @("Flow-Launcher.Flow-Launcher", "RamenSoftware.Windhawk", "Microsoft.PowerToys", "Microsoft.PowerShell", "ajeetdsouza.zoxide", "JanDeDobbeleer.OhMyPosh", "QL-Win.QuickLook", "AmN.yasb", "mki2067.DropShelf", "Autohotkey.Autohotkey", "Henry++.MemReduct", "BitSum.ProcessLasso", "AltSnap.AltSnap")
$FuncApps = @("ImputNet.Helium", "Zed.Zed")

$AppInstallList = @() # changing list depending on the user choice
$RunCTT = $false # implicitly false, for logic down the road

if ($menuChoice -eq '1') {
    $RunCTT = $true
    $AppInstallList = $RiceApps # acts as a safety net if missed in CTT
} elseif ($menuChoice -eq '2') {
    $AppInstallList = $RiceApps
} elseif ($menuChoice -eq '3') {
    $AppInstallList = $RiceApps + $FuncApps
} else {
    Write-Host "Invalid choice. Defaulting to Rice Only [2]." -ForegroundColor Red # change it to 3 later maybe?
    $AppInstallList = $RiceApps
}

# =====================================================================
# 3. DISPLAY INTENT & GET CONFIRMATION
# =====================================================================

Write-Host "`n=== SUMMARY OF ACTIONS ===" -ForegroundColor Cyan
if ($RunCTT) { Write-Host " -> Open Chris Titus Tool (Manual debloat & app selection)" }  # if runCTT = true
Write-Host " -> Install apps: $($AppInstallList -join ', ') | Dont panic if there is a random integer string! It's a winget ID. Check if you must."
Write-Host " -> Apply borders, Auto-hide taskbar, Hide desktop icons, Disable widgets (Win+T)"
Write-Host " -> Apply configs for YASB, FlowLauncher, Terminal, FancyZones, Windhawk"
Write-Host " -> Install JetBrainsMono Nerd Font"

Write-Host "`nHow do you want to proceed with the Winget App installations?" -ForegroundColor Yellow
$AutoMode = (Read-Host "Install all apps automatically without asking? (y/n)").ToLower() -eq 'y'

# =====================================================================
# 4. EXECUTION START
# =====================================================================

# run CTT First (if option 1)
if ($RunCTT) {
    Write-Host "`nOpening Chris Titus WinUtil..." -ForegroundColor Cyan
    Write-Host "Please run your debloat tweaks, select any extra apps you want, hit INSTALL, and CLOSE the window when finished to continue this script." -ForegroundColor DarkGray
    iex "& { $(irm christitus.com/win) }"
}

# install apps (if missed the important ones in ctt)
Write-Host "`nStarting application installs..." -ForegroundColor Yellow
foreach ($app in $AppInstallList) {
    $installThisApp = $AutoMode
    if (-not $AutoMode) {
        $installThisApp = (Read-Host "Install $app? (y/n)").ToLower() -eq 'y'
    }

    if ($installThisApp) {
        Write-Host "Installing $app..." -ForegroundColor Cyan
        winget install --id $app --accept-package-agreements --accept-source-agreements --silent
    }
}

# =====================================================================
# 5. STARTUP APPS
# =====================================================================

Write-Host "`nSetting up Startup Apps..." -ForegroundColor Yellow

Function Add-ToStartup ($AppName, $ExePath) {   #function to add programs to startup folder, with verbose print-out
    $StartupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$StartupFolder\$AppName.lnk")
    $Shortcut.TargetPath = $ExePath
    $Shortcut.Save()
    Write-Host " -> Added $AppName to Startup" -ForegroundColor Green
}

Add-ToStartup "FlowLauncher" "$env:LOCALAPPDATA\FlowLauncher\Flow.Launcher.exe"
Add-ToStartup "YASB" "$env:ProgramFiles\YASB\yasb.exe"
Add-ToStartup "MyHotkeys" "$RepoPath\AHK\dotfiles_main_scr.ahk"
Add-ToStartup "AltSnap" "$env:APPDATA\AltSnap\AltSnap.exe"
Add-ToStartup "ProcessLasso" "$env:ProgramFiles\Process Lasso\ProcessLassoLauncher.exe"
Add-ToStartup "MemReduct" "$env:ProgramFiles\Mem Reduct\memreduct.exe"

# =====================================================================
# 6. SYMLINKING CONFIGURATIONS
# =====================================================================
Write-Host "`nCreating Symbolic links for configs..." -ForegroundColor Yellow

Function Make-Link ($Target, $Link) {  #target = real file, link = fake link
    if (Test-Path $Link) { Remove-Item $Link -Recurse -Force }  #checks if something is at destination, if it is, nukes it, so it doesnt collide
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null  #dont copy, redirect, also out-null for cleaner terminal
    Write-Host "Linked $Link -> $Target" -ForegroundColor Green
}

#then a bunch of the same, for each app that custom (mine) config makes sense

# FlowLauncher
$FlowRepo = Join-Path $RepoPath "FlowLauncher\Settings"
$FlowLocal = "$env:APPDATA\FlowLauncher\Settings"
if (-not (Test-Path $env:APPDATA\FlowLauncher)) { New-Item -ItemType Directory -Path "$env:APPDATA\FlowLauncher" | Out-Null }
Make-Link $FlowRepo $FlowLocal

# YASB
$YASBRepo = Join-Path $RepoPath "YASB"
$YASBLocalDir = "$env:USERPROFILE\.config\yasb"
if (-not (Test-Path "$env:USERPROFILE\.config")) { New-Item -ItemType Directory -Path "$env:USERPROFILE\.config" | Out-Null }
Make-Link $YASBRepo $YASBLocalDir

# Windows Terminal
$TerminalRepo = Join-Path $RepoPath "WindowsTerminal\settings.json"
$TerminalLocalDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$TerminalLocalFile = "$TerminalLocalDir\settings.json"
if (-not (Test-Path $TerminalLocalDir)) { New-Item -ItemType Directory -Path $TerminalLocalDir -Force | Out-Null }
Make-Link $TerminalRepo $TerminalLocalFile

# PowerToys
Write-Host "`nSetting up PowerToys..." -ForegroundColor Yellow
$PTBaseLocal = "$env:LOCALAPPDATA\Microsoft\PowerToys"
Stop-Process -Name "PowerToys" -ErrorAction SilentlyContinue # make sure powertoys is dead before moving it around
Start-Sleep -Seconds 2 # give it a second to actually die

if (-not (Test-Path $PTBaseLocal)) {  # ensure the base local directory exists
    New-Item -ItemType Directory -Force -Path $PTBaseLocal | Out-Null
}

$FancyRepo = Join-Path $RepoPath "PowerToys\FancyZones"  # FancyZones specific
$FancyLocal = "$PTBaseLocal\FancyZones"
if (Test-Path $FancyRepo) {
    Make-Link $FancyRepo $FancyLocal
}

# Windhawk
$WindhawkRepo = Join-Path $RepoPath "Windhawk"
$WindhawkLocal = "$env:PROGRAMDATA\Windhawk"
if (Test-Path $WindhawkRepo) {
    Stop-Process -Name "windhawk" -ErrorAction SilentlyContinue
    Write-Host " -> Injecting Windhawk mods..." -ForegroundColor Cyan
    if (-not (Test-Path "$WindhawkLocal\Engine\Mods")) { New-Item -ItemType Directory -Force -Path "$WindhawkLocal\Engine\Mods" | Out-Null }
    if (-not (Test-Path "$WindhawkLocal\ModsSource")) { New-Item -ItemType Directory -Force -Path "$WindhawkLocal\ModsSource" | Out-Null }
    Copy-Item -Path "$WindhawkRepo\Mods\*" -Destination "$WindhawkLocal\Engine\Mods" -Recurse -Force
    Copy-Item -Path "$WindhawkRepo\ModsSource\*" -Destination "$WindhawkLocal\ModsSource" -Recurse -Force
}

# powershell profile
Write-Host " -> Linking powershell profile..." -ForegroundColor Cyan
$ProfileRepo = Join-Path $RepoPath "PowerShell\Microsoft.PowerShell_profile.ps1" #testing path
$ProfileDir = "$env:USERPROFILE\Documents\PowerShell"
$ProfileLocal = "$ProfileDir\Microsoft.PowerShell_profile.ps1"

# create the powershell documents folder if it doesnt exist yet
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
}

# link the profile
if (Test-Path $ProfileRepo) {
    Make-Link $ProfileRepo $ProfileLocal
}

# OMP  theme
$OMPRepo = Join-Path $RepoPath "OhMyPosh\tokyonight_storm.omp.json"
$OMPLocalDir = "$env:USERPROFILE\.config\ohmyposh"
$OMPLocalFile = "$OMPLocalDir\tokyonight_storm.omp.json"

if (-not (Test-Path $OMPLocalDir)) {
    New-Item -ItemType Directory -Path $OMPLocalDir | Out-Null
}
if (Test-Path $OMPRepo) {
    Make-Link $OMPRepo $OMPLocalFile
}

# =====================================================================
# 7. AESTHETICS (Wallpaper, Colors, TASKBAR AUTOHIDE, ICONS, WIDGETS)
# =====================================================================

Write-Host "`nApplying aesthetics..." -ForegroundColor Yellow

# dark mode and transparency
$Personalize = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
Set-ItemProperty -Path $Personalize -Name "AppsUseLightTheme" -Value 0
Set-ItemProperty -Path $Personalize -Name "SystemUsesLightTheme" -Value 0
Set-ItemProperty -Path $Personalize -Name "EnableTransparency" -Value 1 #YASB fix - doesnt seem to do shit tho

# changing to automatic accent colors
Write-Host " -> Setting borders/accent color to automatic" -ForegroundColor Cyan
$DesktopKey = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $DesktopKey -Name "AutoColorization" -Value 1
$DWM = "HKCU:\SOFTWARE\Microsoft\Windows\DWM"
Set-ItemProperty -Path $DWM -Name "ColorPrevalence" -Value 1 # apply that color to borders/taskbar
Remove-ItemProperty -Path $DWM -Name "AccentColor" -ErrorAction SilentlyContinue  # delete the hardcoded manual color so the system takes over naturally

# taskbar auto-hide
Write-Host " -> Setting taskbar to auto-hide" -ForegroundColor Cyan
$StuckRects = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
$StuckSettings = (Get-ItemProperty -Path $StuckRects -Name "Settings").Settings
$StuckSettings[8] = 3 # evil floating point bit hack
Set-ItemProperty -Path $StuckRects -Name "Settings" -Value $StuckSettings # what the fuck

# hide desktop icons
Write-Host " -> Hiding desktop icons" -ForegroundColor Cyan
$AdvancedExp = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $AdvancedExp -Name "HideIcons" -Value 1

# nuke win+t garbage
Write-Host " -> Disabling taskbar widgets" -ForegroundColor Cyan
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t REG_DWORD /d "0" /f | Out-Null

# wallpaper
# this one is all AI, turns out you need a fucking C# or whatever to change wallpaper
$WallpaperPath = Join-Path $RepoPath "Wallpapers\firewatch.jpg"
if (Test-Path $WallpaperPath) {
    Write-Host " -> Applying desktop wallpaper" -ForegroundColor Cyan
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@
    [Wallpaper]::SystemParametersInfo(0x0014, 0, $WallpaperPath, 0x01 -bor 0x02) | Out-Null
}

# Restart Explorer to apply UI tweaks immediately
Stop-Process -Name explorer -Force

# =====================================================================
# 8. NERD FONTS INSTALLATION
# =====================================================================

#again did help myself with AI on this one, it uses similar stuff from higher, but utilizes TEMP folder, also some new functions
$installFonts = $AutoMode
if (-not $AutoMode) { $installFonts = (Read-Host "`nInstall Nerd Fonts (JetBrainsMono)? (y/n)").ToLower() -eq 'y' }

if ($installFonts) {
    Write-Host "Installing Nerd Fonts..." -ForegroundColor Yellow
    $TempZip = "$env:TEMP\JetBrainsMono.zip"
    $TempFolder = "$env:TEMP\JetBrainsMono"
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -OutFile $TempZip

    if (Test-Path $TempFolder) { Remove-Item $TempFolder -Recurse -Force }
    Expand-Archive -Path $TempZip -DestinationPath $TempFolder -Force

    $Fonts = Get-ChildItem -Path $TempFolder -Filter "*.ttf" -Recurse
    $FontRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    foreach ($Font in $Fonts) {
        $TargetFile = "C:\Windows\Fonts\$($Font.Name)"
        if (-not (Test-Path $TargetFile)) {
            Copy-Item -Path $Font.FullName -Destination $TargetFile
            $FontNameReg = $Font.BaseName + " (TrueType)"
            New-ItemProperty -Path $FontRegPath -Name $FontNameReg -Value $Font.Name -PropertyType String -Force | Out-Null
        }
    }
    Write-Host " -> JetBrainsMono successfully installed!" -ForegroundColor Green
}

Write-Host "`nSetup complete! Please restart your computer." -ForegroundColor Green
Pause
