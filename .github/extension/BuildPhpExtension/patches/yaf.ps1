Invoke-WebRequest -Uri "https://github.com/laruence/yaf/archive/cd933d806d0016c8cadcc0c2f0996ebdc2e5d4b8.zip" -OutFile "$ENV:TEMP/yaf.zip"
Expand-Archive -Path "$ENV:TEMP/yaf.zip" -DestinationPath "$ENV:TEMP"
Copy-Item -Path $env:TEMP/yaf-cd933d806d0016c8cadcc0c2f0996ebdc2e5d4b8/* -Destination (Get-Location).Path -Recurse -Force
