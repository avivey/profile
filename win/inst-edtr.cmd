reg add HKEY_CLASSES_ROOT\editor -v "URL Protocol"
reg add HKEY_CLASSES_ROOT\editor\shell\open\command -d "C:\Users\Aviv\AppData\Local\Microsoft\WindowsApps\python.exe \"%USERPROFILE%\profile\win\editor.py\" \"%%1\""
