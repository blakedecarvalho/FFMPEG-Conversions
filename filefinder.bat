@echo off
setlocal

set "search_dir=%cd%"

set "media_found=0"

for /r "%search_dir%" %%F in (*.flv *.mov *.mp4 *.avi) do (
    if %%~zF EQU 0 (
        echo Found 0 KB file: "%%~dpF%%~nxF"
        set "media_found=1"
    ) else (
        set "media_found=1"
    )
)

if %media_found% EQU 0 (
    echo No media files found within the specified extensions.
)

for /r "%search_dir%" /d %%D in (*) do (
    set "has_media=0"
    for /r "%%D" %%F in (*.flv *.mov *.mp4 *.avi) do (
        set "has_media=1"
        exit /b
    )
    if "%has_media%"=="0" echo %%~nxD does not contain any media files.
)

echo ALL DONE
pause

endlocal
