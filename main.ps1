#this whole thing is a fun project, originally I made it to learn windows scripting, specifically powershell. lots of comments all around, AI was also used, I did review everything, kept some things, for example the section banner/flag comments, I actually think thats very useful
#iam not a fucking windows developer, have mercy on me

#V2 changes: logging added (primitive for now, dedicated function will be added later)
# added Require-Admin function
# added opt-out of windows activation
# added Talon + Dev options
# added try-catch error handling
# numerous other small improvements, cleaner code, changes to the config files themselves


# =====================================================================
# O. RANDOM BULLSHIT THAT NEEDED ADDING
# =====================================================================
$ErrorActionPreference = "Stop"
$LogPath = "$env:USERPROFILE\Documents\RiceSetup_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
Start-Transcript -Path $LogPath -Append

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  # used because of "The request was aborted: Could not create SSL/TLS secure channel." errors,  [] used because of .NET
#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::SystemDefault # could also do this

Function Update-EnvironmentVars
{  #why? ran into issues with PATH when switching to Get-Command from hardcoded paths, classic example of if it aint broke, dont fix it
    Write-Host " -> Refreshing environment variables..." -ForegroundColor Cyan

    # yank those PATHs straight outta registry
    $SysPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $NewPath = $SysPath + ";" + $UserPath

    # apply them to the current pwsh process
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "Process")
}
# =====================================================================
# 1. ELEVATE TO ADMINISTRATOR & ACTIVATE WINDOWS
# =====================================================================

#newly rewritten as a function for easier reusability and future versions, still, calling it immediately, as more than half this script need admin rights
function Require-Admin
{
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
    {
        Write-Host "Restarting as admin..."
        #debug - checks what powershell is running
        $psExe = if ($PSVersionTable.PSVersion.Major -ge 7)
        { "pwsh"
        } else
        { "powershell"
        }
        Start-Process $psExe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

Require-Admin
$RepoPath = $PSScriptRoot

Write-Host "`n=== Windows Activation ===" -ForegroundColor Cyan
Write-Host "This will run the open-source MAS (Microsoft Activation Scripts) to HWID activate Windows." -ForegroundColor Yellow
Write-Host "It will do nothing if you are already activated. If you bought your device with Windows, hit enter or n, this option is mostly for VM testing and / or  if you know what you are doing." -ForegroundColor DarkGray

#new logic for the win activation - opt-out option added
# the capital N tells the user that hitting enter defaults to no.
# f they just hit enter, the input is blank, which does not equal y, resulting in false.
$runActivation = (Read-Host "Do you want to run the Windows Massgrave activation script? [y/N]").ToLower() -eq 'y'

if ($runActivation)
{
    try
    {
        Write-Host "Downloading and running MAS Windows activation..."
        # download first, if it doesnt - stop
        $masScript = Invoke-RestMethod -Uri "https://get.activated.win" -ErrorAction Stop

        # run silently
        & ([ScriptBlock]::Create($masScript)) /HWID | Out-Null

        Write-Host "Windows activated successfully!"
    } catch
    {
        Write-Host "Failed to run MAS Activation. Error: $_"
    }
} else
{
    Write-Host "Skipping Windows activation."
}

# =====================================================================
# 2. CHOOSE YOUR SETUP
# =====================================================================
Write-Host "This script creates a log file in your Documents folder, if something will go wrong, check that."
Write-Host "Choose the installation process. Windows de-bloating (disabling Edge, Copilot etc.), ei. tweaking the CTT is recommended." -ForegroundColor Yellow
Write-Host "[1] Full Setup (Manual CTT Debloat + Rice Stuff)"
Write-Host "[2] No CTT, Rice Only (No Debloat. Aestethics + some functionality, such as MemReduct and so on...)"
Write-Host "[3] Rice + Extra (Rice stuff +  Fastfetch, Helium browser & Zed editor)"
Write-Host "Next options are utilizing Talon, are in active developement and testing. DO NOT RUN them on your daily driver, Talon is rough. It also may interfere with the apps that this script installs. Give it a hour and research (K0 youtube, https://github.com/ravendevteam/talon), to see if that's something you want."
Write-Host "[4] Talon + Rice stuff (again, RUN ONLY ON FRESH WINDOWS INSTALL - Talon breaks a lot of stuff, deletes a lot of stuff u might actually use, like ALL MS STORE APPS! YOU WILL HAVE TO INSTALL THEM BACK MANUALLY!. This script uses it in its headless mode (v3.0)- you cannot configure it!"
Write-Host "[5] Talon + Extra"  #new for v2 - added talon config options
Write-Host "[Dev] Full Setup and Helium, which is not in CTT yet] " # new for v2
$menuChoice = Read-Host "Select an option (1/2/3/4/5/Dev)"

# define the app arrays
$RiceApps = @("Flow-Launcher.Flow-Launcher",
    "RamenSoftware.Windhawk",
    "Microsoft.PowerToys",
    "Microsoft.PowerShell",
    "ajeetdsouza.zoxide",
    "JanDeDobbeleer.OhMyPosh",
    "QL-Win.QuickLook",
    "AmN.yasb",
    "9MZPC6P14L7N", # wget ID! its dropshelf from msstore!
    "Autohotkey.Autohotkey",
    "Henry++.MemReduct",
    "BitSum.ProcessLasso",
    "AltSnap.AltSnap",
    "FxSound.FxSound")

$FuncApps = @("ImputNet.Helium",
    "ZedIndustries.Zed",
    "Fastfetch-cli.Fastfetch")

$AppInstallList = @()
$RunCTT = $false
$RunTalon = $false

if ($menuChoice -eq '1')
{
    $RunCTT = $true
    $AppInstallList = $RiceApps
} elseif ($menuChoice -eq '2')
{
    $AppInstallList = $RiceApps
} elseif ($menuChoice -eq '3')
{
    $AppInstallList = $RiceApps + $FuncApps
} elseif ($menuChoice -eq '4')
{
    $RunTalon = $true
    $AppInstallList = $RiceApps
} elseif ($menuChoice -eq '5')
{
    $RunTalon = $true
    $AppInstallList = $RiceApps + $FuncApps
} elseif ($menuChoice -eq 'Dev')
{
    $RunCTT = $true
    $AppInstallList = $RiceApps + $FuncApps
} else
{
    Write-Host "Invalid choice. Defaulting to Rice Only [2]." -ForegroundColor Red # change it to 3 maybe?
    $AppInstallList = $RiceApps
}

# =====================================================================
# 3. DISPLAY INTENT & GET CONFIRMATION
# =====================================================================

Write-Host "`n=== SUMMARY OF ACTIONS ===" -ForegroundColor Cyan
if ($RunCTT)
{ Write-Host " -> Open Chris Titus Tool (Manual debloat & app selection)"
}  # if runCTT = true
if ($RunTalon)
{ Write-Host " -> Run Talon, debloat the fuck out my PC - I HAVE READ ABOUT WHAT IT DOES"
} #if runtalon = true
Write-Host " -> Install apps: $($AppInstallList -join ', ') | Dont panic if there is a random string! It's a winget ID. Check if you must."
Write-Host " -> Apply borders, Auto-hide taskbar, Hide desktop icons, Disable widgets (Win+T)"
Write-Host " -> Apply configs for YASB, FlowLauncher, Terminal, FancyZones, Windhawk"
Write-Host " -> Install JetBrainsMono Nerd Font"

Write-Host "`nHow do you want to proceed with the Winget App installations?" -ForegroundColor Yellow
$AutoMode = (Read-Host "Install all apps automatically without asking? (y/n)").ToLower() -eq 'y'

# =====================================================================
# 4. EXECUTION START
# =====================================================================

# run CTT First (if option 1 or dev)
if ($RunCTT)
{
    Write-Host "Opening Chris Titus WinUtil..."
    Write-Host "Please run your debloat tweaks, select any extra apps you want, hit INSTALL, and CLOSE the window when finished to continue this script." -ForegroundColor DarkGray
    try
    {
        # fetch that bitch
        $cttScript = Invoke-RestMethod -Uri "https://christitus.com/win" -ErrorAction Stop
        # execute
        Invoke-Expression $cttScript
        Write-Host "CTT closed successfully."
    } catch
    {
        Write-Host "Failed to download or run CTT. Error: $_"
    }
}

# run Talon (if option 4 or 5)
if ($RunTalon)
{
    Write-Host "Running Talon Debloater..."
    Write-Host "WARNING: I HOPE YOU READ ABOUT TALON. Let it finish its process. Then it will probably pause, close the terminal window that Talon is in!." -ForegroundColor DarkGray
    try
    {
        $psExe2 = if ($PSVersionTable.PSVersion.Major -ge 7)
        { "pwsh"
        } else
        { "powershell"
        }
        # launchea talon in a separate terminal window
        Start-Process $psExe2 -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm https://debloat.win | iex`"" -Wait
        Write-Host "Talon process finished. Resuming main script..." -ForegroundColor Green
    } catch
    {
        Write-Host "Failed to download or run Talon. Error: $_"
    }
}

#error handling
if (-not (Get-Command winget -ErrorAction SilentlyContinue))
{
    Write-Host "Winget not installed"
    exit
}

# 0x8A15000F winget error fix
Write-Host "Resetting and updating Winget sources..." -ForegroundColor Cyan
winget source reset --force | Out-Null
winget source update | Out-Null

# install apps (if missed the important ones in ctt)
Write-Host "`nStarting application installs..." -ForegroundColor Yellow
foreach ($app in $AppInstallList)
{
    $installThisApp = $AutoMode
    if (-not $AutoMode)
    {
        $installThisApp = (Read-Host "Install $app? (y/n)").ToLower() -eq 'y'
    }

    if ($installThisApp)
    {
        Write-Host "Installing $app..."
        winget install --id $app --accept-package-agreements --accept-source-agreements --silent

        if ($LASTEXITCODE -eq 0)
        {
            Write-Host "$app installed successfully."
        } else
        {
            Write-Host "Failed to install $app. Winget returned exit code $LASTEXITCODE."
        }
    }
}

#fix for the buggy themeswtiching (virtual desktops) - now uses a pwsh module named VirtualDesktop, its a bit slower, but it works
Write-Host "Installing VirtualDesktop Module for theme switching..." -ForegroundColor Cyan
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction SilentlyContinue
Install-Module -Name VirtualDesktop -Scope CurrentUser -Force -AllowClobber
Write-Host "VirtualDesktop Module installed!" -ForegroundColor Green


Update-EnvironmentVars   #singular use of the function from block 0
# =====================================================================
# 5. STARTUP APPS
# =====================================================================

Write-Host "`nSetting up Startup Apps..." -ForegroundColor Yellow
#v2 improvement
Function Add-ToStartup ($AppName, $TargetOrExe)
{
    $StartupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $ActualPath = $null

    # not in PATH stuff, for example .ahk things
    if (Test-Path -LiteralPath $TargetOrExe -ErrorAction SilentlyContinue)
    {
        $ActualPath = $TargetOrExe
    }
    # PATH searching, for .exe
    else
    {
        $AppCommand = Get-Command $TargetOrExe -ErrorAction SilentlyContinue
        if ($AppCommand)
        {
            $ActualPath = $AppCommand.Source
        }
    }

    # if valid path exists -> create the shortcut
    if ($ActualPath)
    {
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$StartupFolder\$AppName.lnk")
        $Shortcut.TargetPath = $ActualPath
        $Shortcut.Save()
        Write-Host " -> Added $AppName to startup (Target: $ActualPath)" -ForegroundColor Green
    } else
    {
        Write-Host " -> Warning: Could not find target '$TargetOrExe'. Startup shortcut skipped." -ForegroundColor Yellow
    }
}

Add-ToStartup "FlowLauncher" "Flow.Launcher.exe"
Add-ToStartup "YASB" "yasb.exe"
Add-ToStartup "MyHotkeys" "$RepoPath\AHK\dotfiles_main_scr.ahk"
Add-ToStartup "AltSnap" "AltSnap.exe"
Add-ToStartup "ProcessLasso" "ProcessLassoLauncher.exe"
Add-ToStartup "MemReduct" "memreduct.exe"
Add-ToStartup "Dropshelf" "Dropshelf.exe"
#powertoys will do that themselves

# =====================================================================
# 6. SYMLINKING CONFIGURATIONS
# =====================================================================
Write-Host "`nCreating Symbolic links for configs..." -ForegroundColor Yellow
#this is an AI generated function fix, leaving it as is, including comments, cuz they are good at explaining this stuff (new logic for me)
Function Make-Link ($Target, $Link)
{
    # 1. Check if SOMETHING exists at the destination
    if (Test-Path -LiteralPath $Link)
    {

        $Item = Get-Item -LiteralPath $Link

        # 2. Is it a symlink? Safe to delete.
        if ($Item.LinkType -eq 'SymbolicLink')
        {
            Remove-Item $Link -Force
        }
        # 3. Is it a real folder/file? Abort immediately to save user data!
        else
        {
            Write-Host " -> ERROR: A real folder or file exists at $Link. Will not overwrite. Please back it up and remove it manually." -ForegroundColor Red
            return # This completely stops the function from proceeding
        }
    }

    # 4. Create the link
    New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
    Write-Host "Linked $Link -> $Target" -ForegroundColor Green
}

#then a bunch of the same, for each app that custom (mine) config makes sense

# FlowLauncher
$FlowRepo = Join-Path $RepoPath "FlowLauncher\Settings"
$FlowLocal = "$env:APPDATA\FlowLauncher\Settings"
if (-not (Test-Path $env:APPDATA\FlowLauncher))
{ New-Item -ItemType Directory -Path "$env:APPDATA\FlowLauncher" -Force| Out-Null
}
Make-Link $FlowRepo $FlowLocal

# YASB
$YASBRepo = Join-Path $RepoPath "YASB"
$YASBLocalDir = "$env:USERPROFILE\.config\yasb"
if (-not (Test-Path "$env:USERPROFILE\.config"))
{ New-Item -ItemType Directory -Path "$env:USERPROFILE\.config" -Force | Out-Null
}
Make-Link $YASBRepo $YASBLocalDir

# Windows Terminal
$TerminalRepo = Join-Path $RepoPath "WindowsTerminal\settings.json"
$TerminalLocalDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$TerminalLocalFile = "$TerminalLocalDir\settings.json"
if (-not (Test-Path $TerminalLocalDir))
{ New-Item -ItemType Directory -Path $TerminalLocalDir -Force | Out-Null
}
Make-Link $TerminalRepo $TerminalLocalFile

# PowerToys
Write-Host "`nSetting up PowerToys..." -ForegroundColor Yellow
$PTBaseLocal = "$env:LOCALAPPDATA\Microsoft\PowerToys"
Stop-Process -Name "PowerToys" -ErrorAction SilentlyContinue # make sure powertoys is dead before moving it around
Start-Sleep -Seconds 2 # give it a second to actually die

if (-not (Test-Path $PTBaseLocal))
{  # ensure the base local directory exists
    New-Item -ItemType Directory -Force -Path $PTBaseLocal | Out-Null
}

$FancyRepo = Join-Path $RepoPath "PowerToys\FancyZones"  # FancyZones specific
$FancyLocal = "$PTBaseLocal\FancyZones"
if (Test-Path $FancyRepo)
{
    Make-Link $FancyRepo $FancyLocal
}

# Windhawk
$WindhawkRepo = Join-Path $RepoPath "Windhawk"
$WindhawkLocal = "$env:PROGRAMDATA\Windhawk"
if (Test-Path $WindhawkRepo)
{
    Stop-Process -Name "windhawk" -ErrorAction SilentlyContinue
    Write-Host " -> Injecting Windhawk mods..." -ForegroundColor Cyan
    if (-not (Test-Path "$WindhawkLocal\Engine\Mods"))
    { New-Item -ItemType Directory -Force -Path "$WindhawkLocal\Engine\Mods" | Out-Null
    }
    if (-not (Test-Path "$WindhawkLocal\ModsSource"))
    { New-Item -ItemType Directory -Force -Path "$WindhawkLocal\ModsSource" | Out-Null
    }
    Copy-Item -Path "$WindhawkRepo\Mods\*" -Destination "$WindhawkLocal\Engine\Mods" -Recurse -Force
    Copy-Item -Path "$WindhawkRepo\ModsSource\*" -Destination "$WindhawkLocal\ModsSource" -Recurse -Force
}

# powershell profile
Write-Host " -> Linking powershell profile..." -ForegroundColor Cyan
$ProfileRepo = Join-Path $RepoPath "PowerShell\Microsoft.PowerShell_profile.ps1" #testing path
$ProfileDir = "$env:USERPROFILE\Documents\PowerShell"
$ProfileLocal = "$ProfileDir\Microsoft.PowerShell_profile.ps1"

# create the powershell documents folder if it doesnt exist yet
if (-not (Test-Path $ProfileDir))
{
    New-Item -ItemType Directory -Force -Path $ProfileDir | Out-Null
}

# link the profile
if (Test-Path $ProfileRepo)
{
    Make-Link $ProfileRepo $ProfileLocal
}

# OMP  theme
$OMPRepo = Join-Path $RepoPath "OhMyPosh\tokyonight_storm.omp.json"
$OMPLocalDir = "$env:USERPROFILE\.config\ohmyposh"
$OMPLocalFile = "$OMPLocalDir\tokyonight_storm.omp.json"

if (-not (Test-Path $OMPLocalDir))
{
    New-Item -ItemType Directory -Path $OMPLocalDir | Out-Null
}
if (Test-Path $OMPRepo)
{
    Make-Link $OMPRepo $OMPLocalFile
}

# =====================================================================
# 7. AESTHETICS (Wallpaper, Colors, TASKBAR AUTOHIDE, ICONS, WIDGETS)
# =====================================================================

Write-Host "`nApplying aesthetics..." -ForegroundColor Yellow
$Personalize = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"

# checks registry keys
if (-not (Test-Path $Personalize))
{
    New-Item -Path $Personalize -Force | Out-Null
    Write-Host " -> Created missing registry key: Personalize" -ForegroundColor DarkGray
}

# dark mode and transparency fix
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
if (Test-Path $WallpaperPath)
{
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

# restart explorer to apply UI tweaks immediately
Stop-Process -Name explorer -Force
Start-Process explorer
# =====================================================================
# 8. NERD FONTS INSTALLATION
# =====================================================================

#again did help myself with AI on this one, it uses similar stuff from higher, but utilizes TEMP folder, also some new functions
$installFonts = $AutoMode
if (-not $AutoMode)
{ $installFonts = (Read-Host "`nInstall Nerd Fonts (JetBrainsMono)? (y/n)").ToLower() -eq 'y'
}

if ($installFonts)
{
    Write-Host "Installing Nerd Fonts..." -ForegroundColor Yellow
    $TempZip = "$env:TEMP\JetBrainsMono.zip"
    $TempFolder = "$env:TEMP\JetBrainsMono"
    Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -OutFile $TempZip
    try
    {
        if (Test-Path $TempFolder)
        { Remove-Item $TempFolder -Recurse -Force
        }
        Expand-Archive -Path $TempZip -DestinationPath $TempFolder -Force

        $Fonts = Get-ChildItem -Path $TempFolder -Filter "*.ttf" -Recurse
        $FontRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        foreach ($Font in $Fonts)
        {
            $TargetFile = "C:\Windows\Fonts\$($Font.Name)"
            if (-not (Test-Path $TargetFile))
            {
                Copy-Item -Path $Font.FullName -Destination $TargetFile
                $FontNameReg = $Font.BaseName + " (TrueType)"
                New-ItemProperty -Path $FontRegPath -Name $FontNameReg -Value $Font.Name -PropertyType String -Force | Out-Null
            }
        }
        Write-Host " -> JetBrainsMono successfully installed!" -ForegroundColor Green
    } catch
    {
        Write-Host "Fatal error during the font installation: $_"
    }
}

Write-Host "`nSetup complete! Please restart your computer and check wiki/documentation for the remaining manual steps."-ForegroundColor Green
Stop-Transcript
Pause
