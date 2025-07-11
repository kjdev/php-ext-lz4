$fn = @"
ARG_ENABLE("raphf", "for raphf support", "no");

base_dir = get_define('BUILD_DIR');
WScript.Echo("Creating " + base_dir + "\\src" + "...");
FSO.CreateFolder(base_dir+"\\src");
"@

(Get-Content config.w32) | ForEach-Object { $_.Replace('ARG_ENABLE("raphf", "for raphf support", "no");', $fn) } | Set-Content config.w32
(Get-Content config.w32) | ForEach-Object { $_.Replace('ADD_SOURCES', '//ADD_SOURCES') } | Set-Content config.w32