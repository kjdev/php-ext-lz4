Function Invoke-CleanupTempFiles {
    $currentSystemState = Get-ChildItem -Path "C:\Windows\Temp" -Recurse -File | Select-Object FullName
    $currentUserState = Get-ChildItem -Path $env:TEMP -Recurse -File | Select-Object FullName

    $newSystemFiles = Compare-Object -ReferenceObject $script:initialSystemState -DifferenceObject $currentSystemState -Property FullName | Where-Object {$_.SideIndicator -eq "=>"}
    $newUserFiles = Compare-Object -ReferenceObject $script:initialUserState -DifferenceObject $currentUserState -Property FullName | Where-Object {$_.SideIndicator -eq "=>"}
    $tempFiles = @($newSystemFiles) + @($newUserFiles)
    if($tempFiles.Count -gt 0) {
        Write-Host "Cleaning up temporary files"
        $tempFiles | ForEach-Object {
            Write-Host "Removing $($_.FullName)"
            try {
                Remove-Item -Path $_.FullName -Force
            } catch {
                Write-Host "Failed to remove $($_.FullName)"
            }
        }
    }
}
