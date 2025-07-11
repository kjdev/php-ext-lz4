Function Get-TempFiles {
    $script:initialSystemState = Get-ChildItem -Path "C:\Windows\Temp" -Recurse -File | Select-Object FullName
    $script:initialUserState = Get-ChildItem -Path $env:TEMP -Recurse -File | Select-Object FullName
}