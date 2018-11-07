reg add HKEY_CLASSES_ROOT\editor -v "URL Protocol"
reg add HKEY_CLASSES_ROOT\editor\shell\open\command -d "wscript \"%USERPROFILE%\profile\win\editor.wsf\" \"%%1\""
