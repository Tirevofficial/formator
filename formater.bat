@echo off




::graphical security warning

powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"This app is NOT licensed.`nUse at your own risk.\", \"Security Warning\", 'OK', 'Warning')"




powershell.exe -ExecutionPolicy Bypass -File formater.ps1

powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show(\"Your device was succesfully formatted.\", \"The format has completed! Thank you for using me!\", 'OK', 'Information')"


pause