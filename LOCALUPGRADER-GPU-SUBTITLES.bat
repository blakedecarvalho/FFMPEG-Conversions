@ECHO OFF
setlocal enabledelayedexpansion
set "root=%cd%"
set total=0
set count=1
rem Building Total count
for /r "%cd%" %%a in (*.mp4 *.avi *.mkv *.flv) do (
    set "file=%%~dpnxa"
    set "upscaled=%%~dpa%%~na_upscaled%%~xa"
    echo "!file!" | findstr /i /c:"_upscaled" >nul || (
        if not exist "!upscaled!" (
            set /a total+=1
        )
    )
)

rem Doing main task
for /r "%cd%" %%a in (*.mp4 *.avi *.mkv *.flv) do (
    set "file=%%~dpnxa"
    set "upscaled=%%~dpa%%~na_upscaled%%~xa"
    echo "!file!" | findstr /i /c:"_upscaled" >nul && (
        echo Skipped file with "_upscaled" in its name:
        echo "!file!"
        cls
    ) || (
        if not exist "!upscaled!" (
            color 17
            echo Currently working on: !count!/!total!
            echo "!file!"
            ffmpeg -hwaccel cuda -i "!file!" -vf scale=3840x2160:flags=bicubic -rc constqp -qmin 17 -qmax 51 -qp 24 -preset p7 -tune hq -rc-lookahead 4 -profile:v high -bf 0 -keyint_min 1 -refs 7 -qdiff 20 -qcomp 0.9 -me_method umh -c:v h264_nvenc -async 1 -threads 4 -c:a copy "!upscaled!" -loglevel quiet
            echo Checking MP4 file size..
            timeout /t 5
            cls
            for %%F in ("!upscaled!") do (
                if %%~zF EQU 0 (
                    color 47
                    echo new file is 0KB. Skipping deletion of old.
                    del /q "!upscaled!"
                    timeout /t 5
                    cls
                ) else (
                    color 27
                    echo New file looks good.  Deleting original
                    del /q "!file!"
                    timeout /t 5
	            echo Making subtitles
                    "C:\tools\autosrt.exe" -S en -D en "!upscaled!" -o "!file!.srt"
                    cls
                )
            )
            set /a count+=1
        ) else (
            echo Skipped already upscaled file:
            echo "!file!"
            cls
        )
    )
)

color E0
echo All done. Press any key to exit.
pause >nul
