@ECHO OFF
setlocal enabledelayedexpansion
set "root=%cd%"
for /r "%cd%" %%a in (*.mov) do (
    set "file=%%~dpnxa"
    set "upscaled=%%~dpa%%~na_upscaled%%~xa"
    echo "!file!" | findstr /i /c:"_upscaled" >nul && (
        echo Skipped file with "_upscaled" in its name:
        echo "!file!"
        cls
    ) || (
        if "%%~xa"==".mov" (
            set "mp4file=%%~dpna.mp4"
			echo "!file!"
            echo Transcoding from mov to mp4
            ffmpeg -i "!file!" -c:v h264 -c:a aac -strict experimental "!mp4file!" -loglevel quiet
			timeout /t 5
            echo Checking MP4 file size
            for %%F in ("!mp4file!") do (
                if %%~zF EQU 0 (
                    echo MP4 file is 0KB. Skipping deletion.
                ) else (
                    echo Deleting original mov
                    del /q "!file!"
                    timeout /t 5
                )
            )
        ) else (
            echo Doing nothing
            timeout /t 5
        )
        cls
    )
)
echo All done. Press any key to exit.
pause >nul
