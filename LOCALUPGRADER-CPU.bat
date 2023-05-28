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
            ffmpeg -hwaccel cuda -i "!file!" -vf scale=3840x2160:flags=bicubic -c:v libx264 -c:a copy "!upscaled!" -loglevel quiet
            echo Checking MP4 file size..
			timeout /t 5
			cls
            for %%F in ("!upscaled!") do (
                if %%~zF EQU 0 (
                    echo new file is 0KB. Skipping deletion of old.
					del /q "!upscaled!"
					timeout /t 5
					cls
                ) else (
                    echo New file looks good.  Deleting original
                    del /q "!file!"
                    timeout /t 5
					cls
                )
		)
        ) else (
            echo Skipped already upscaled file:
            echo "!file!"
            cls
        )
    )
)
echo All done. Press any key to exit.
pause >nul
