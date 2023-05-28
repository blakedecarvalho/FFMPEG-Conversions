@ECHO OFF
setlocal enabledelayedexpansion
set "root=%cd%"
for /r "%cd%" %%a in (*.mp4 *.avi *.mkv *.flv) do (
    set "file=%%~dpnxa"
    set "upscaled=%%~dpa%%~na_upscaled%%~xa"
    echo "!file!" | findstr /i /c:"_upscaled" >nul && (
        echo Skipped file with "_upscaled" in its name:
        echo "!file!"
        cls
    ) || (
        if not exist "!upscaled!" (
            echo Currently working on:
            echo "!file!"
            ffmpeg -i "!file!" -vf scale=3840x2160:flags=bicubic -c:a copy "!upscaled!" -loglevel quiet
            cls
        ) else (
            echo Skipped already upscaled file:
            echo "!file!"
            cls
        )
    )
)
echo All done. Press any key to exit.
pause >nul
