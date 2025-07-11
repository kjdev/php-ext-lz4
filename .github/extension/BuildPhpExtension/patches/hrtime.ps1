Invoke-WebRequest -Uri "https://github.com/php/pecl-datetime-hrtime/archive/53fed8cf2cf57f5df8c22e9b0bb50a44a75571c2.zip" -OutFile "$ENV:TEMP/hrtime.zip"
Expand-Archive -Path "$ENV:TEMP/hrtime.zip" -DestinationPath "$ENV:TEMP"
Copy-Item -Path $env:TEMP/pecl-datetime-hrtime-53fed8cf2cf57f5df8c22e9b0bb50a44a75571c2/* -Destination (Get-Location).Path -Recurse -Force
