Invoke-WebRequest -Uri "https://github.com/pmjones/ext-request/archive/d55b408a1b5e465dd4e74020982edaa43a335ad3.zip" -OutFile "$ENV:TEMP/request.zip"
Expand-Archive -Path "$ENV:TEMP/request.zip" -DestinationPath "$ENV:TEMP"
Copy-Item -Path $env:TEMP/ext-request-d55b408a1b5e465dd4e74020982edaa43a335ad3/* -Destination (Get-Location).Path -Recurse -Force
