#Requires AutoHotkey v2.0

; =====================================================================
; GENERAL QUALITY OF LIFE
; =====================================================================
; Win + Q -> Close Active Window (Replaces Alt+F4)
#q::WinClose("A")

; Win + Enter -> Open Windows Terminal (Kills the native Narrator shortcut)
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
; '#' = Windows Key | '+' = Shift Key

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

; Win + Shift + M -> Silently Flush RAM using Mem Reduct
#+m::Run("C:\Program Files\Mem Reduct\memreduct.exe -clean", , "Hide")

; Win + W -> Helium browser
#w::Run(EnvGet("LocalAppData") "\imput\Helium\Application\chrome.exe")

; =====================================================================
; THEMES
; =====================================================================

; Win + Alt + F1 -> Switch to Purple Theme
#!F1::SwitchTheme(EnvGet("USERPROFILE") "\Desktop\Wallpapers\firewatch.jpg", "0xAC6D73")

; Win + Alt + F2 -> Switch to Green Theme
#!F2::SwitchTheme(EnvGet("USERPROFILE") "\Desktop\Wallpapers\greenery.jpg", "0x058249")

; Win + Alt + F3 -> Switch to Gray Theme
#!F3::SwitchTheme(EnvGet("USERPROFILE") "\Desktop\Wallpapers\white_lava.jpg", "0x101010")

SwitchTheme(WallpaperPath, AccentColorABGR) {
    ; 1. Change Wallpaper instantly
    DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", WallpaperPath, "UInt", 3)

    ; 2. Change Windows Window Border Accent Color
    RegWrite(AccentColorABGR, "REG_DWORD", "HKCU\Software\Microsoft\Windows\DWM", "AccentColor")

    ; 4. Restart Explorer to force Windows border colors to update
    ProcessClose("explorer.exe")
}

; =====================================================================
; YOUR SHORTCUTS
; =====================================================================
