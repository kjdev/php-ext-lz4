$fn = @"
ARG_WITH("grpc", "grpc support", "no");
function CreateFolderIfMissing(path) {
    if (!path) return;
    if (!FSO.FolderExists(path)) {
        WScript.Echo("Creating " + path + "...");
        FSO.CreateFolder(path);
    }
}
"@
(Get-Content config.w32) | ForEach-Object { $_.Replace('base_dir+"\\ext\\grpc', 'base_dir+"') } | Set-Content config.w32
(Get-Content config.w32) | ForEach-Object { $_.Replace('FSO.CreateFolder', 'CreateFolderIfMissing') } | Set-Content config.w32
(Get-Content config.w32) | ForEach-Object { $_ -replace '/D_WIN32_WINNT=0x600', '/D_WIN32_WINNT=0x600 /FS /std:c++17' } | Set-Content config.w32
(Get-Content config.w32) | ForEach-Object { $_.Replace('ARG_WITH("grpc", "grpc support", "no");', $fn) } | Set-Content config.w32
