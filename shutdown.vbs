Set WshShell = CreateObject("WScript.Shell")

' 종료 메시지를 표시하는 작은 CMD 창 실행
WshShell.Run "cmd.exe /c echo 카페HR 서버를 종료합니다... & title 카페HR 서버 종료 & mode con: cols=50 lines=5 & echo 3초 후 종료됩니다... & timeout /t 3", 1, True

' 현재 디렉토리를 톰캣의 bin 폴더로 설정
WshShell.CurrentDirectory = "C:\Tomcat10\bin"

' 톰캣 서버 종료
WshShell.Run "cmd /c shutdown.bat", 0, True 