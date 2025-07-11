Invoke-WebRequest -Uri https://raw.githubusercontent.com/pierrejoye/php_zip/master/config.w32 -OutFile config.w32
$fn = @"
ADD_FLAG("LDFLAGS_ZIP", "/FORCE:MULTIPLE");
AC_DEFINE('HAVE_LIBZIP', 1);
"@
(Get-Content config.w32) | ForEach-Object { $_.Replace("AC_DEFINE('HAVE_LIBZIP', 1);", $fn) } | Set-Content config.w32
