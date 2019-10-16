;Notes: #==win !==Alt ^==Ctrl +=Shift  <==left >==right

;environment
#Include Env.ahk

;just debug
::\\debug::
return

;search
#b::
Send ^c
Run https://www.baidu.com/s?wd=%clipboard%
return

#g::
Send ^c 
Run http://www.google.com/search?q=%clipboard% 
return

#t::
send ^c
Run https://translate.google.com/#view=home&op=translate&sl=en&tl=zh-CN&text=%clipboard%
return



;send current time
::\\tt::
FormatTime, now_date, %A_Now%, yyyy-MM-dd HH:mm
Send, % now_date 
return

;open notepad++
::\\np::
run, %ProgramFilesX86%\Notepad++\notepad++.exe
return

;open git-bash
::\\gb::
run, %ProgramFiles%\Git\git-bash.exe
return


;open beyond compare
::\\bc::
run, %ProgramFilesX86%\Beyond Compare 3\BCompare.exe
return

;open vscode
::\\code::
run, %LocalAppData%\Programs\Microsoft VS Code\Code.exe
return

;leader=Alt，类vim的移动
!h:: Send {Left}
!l:: Send {Right}
!k:: Send {Up}
!j:: Send {Down}



;===========================================
;

;reload ahk script
::\\ahk::
run, %USER%\Desktop\MyScript.ahk
return



;==========================================================
~lButton & LAlt::
WinGet,ProcessPath,ProcessPath,A
Run, % "explorer.exe /select," ProcessPath
return