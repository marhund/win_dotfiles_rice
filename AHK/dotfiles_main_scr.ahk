#Requires AutoHotkey v2.0

; =====================================================================
; GENERAL QUALITY OF LIFE
; =====================================================================
; Win + Q -> Close active window (replaces Alt+F4)
#q::WinClose("A")

; Win + Enter -> Open Windows terminal (kills the native narrator shortcut)
#Enter::Run("wt.exe")

;Current date
::]d:: {
    Send(FormatTime(, "dd-MM-yyyy"))
}

; =====================================================================
; GIT SPEEDRUN HOTSTRINGS
; =====================================================================
; Type these anywhere and they will instantly expand and execute.

::]ga::git add .{Enter}
::]gc::git commit -m ""{Left}
::]gp::git push{Enter}
::]gpl::git pull{Enter}
::]gs::git status{Enter}
::]gl::git log --oneline{Enter}
::]gb::git branch{Enter}
::]gco::git checkout

; =====================================================================
; QUICK APP LAUNCHERS
; =====================================================================
; "#" = Windows key | "+" = Shift key | "!" = Alt key

; Win + Shift + Z -> Open Zed Editor
#+z::Run("zed.exe")

; Win + Shift + P -> Open PowerToys
#+p::Run(EnvGet("LocalAppData") "\PowerToys\PowerToys.exe")

; Win + Shift + Y -> Open YASB / Close YASB
#+y:: {
    if ProcessExist("yasb.exe")
        ProcessClose("yasb.exe")
    else
        Run("C:\Program Files\YASB\yasb.exe")
}

; Win + Shift + W -> Open Windhawk
#+w::Run("C:\Program Files\Windhawk\windhawk.exe")

; Win + Shift + M -> Flush RAM using Mem Reduct
#+m::Run("C:\Program Files\Mem Reduct\memreduct.exe -clean", , "Hide")

; Win + W -> browser   INPUT PATH TO YOUR BROSWER .EXE and uncomment
; #w::Run()

; =====================================================================
; THEMES (realistically just wallpaper and colors)
; =====================================================================

; Win + Alt + F1 -> Switch to Purple Theme
#!F1::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\firewatch.jpg")

; Win + Alt + F2 -> Switch to Green Theme
#!F2::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\greenery.jpg")

; Win + Alt + F3 -> Switch to Gray Theme
#!F3::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\white_lava.jpg")

; Win + Alt + F4 -> Switch to Indigo Theme
#!F4::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\aesthetic_deer.png")

; Win + Alt + F5 -> Switch to Brownish-Grey Theme
#!F5::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\lowlight_png")

; Win + Alt + F6 -> Switch to Grey-Purple Theme
#!F6::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\lowlight_2.png")

; Win + Alt + F7 -> Switch to Brown Theme
#!F7::SwitchTheme(EnvGet("USERPROFILE") "\Downloads\WindowsSetup\win_dotfiles_rice-main\Wallpapers\retro-room.png")

; new function replacing the old one, now imports VirtualDesktop via pwsh, so the wallpaper changes in all desktops and doesnt crash windhawk - slow but it works
SwitchTheme(WallpaperPath) {
    PSCmd := "Import-Module VirtualDesktop -DisableNameChecking; Set-AllDesktopWallpapers -Path '" WallpaperPath "'"
    RunWait('pwsh -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command "' PSCmd '"')
}

; =====================================================================
; YOUR SHORTCUTS
; =====================================================================
