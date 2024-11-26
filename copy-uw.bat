@echo off

SET MOD_NAME=CaptainOfFactory
SET MOD_TITLE=Captain of Factory
SET MOD_DEPENDENCIES="space-age >= 2.0.0"
SET MOD_AUTHOR=DeznekCZ
SET MOD_AUTHOR_CONTACT=www.facebook.com/DeznekCZ
SET MOD_HOMEAPAGE=
SET MOD_DESCRIPTION=Makes a port of the game Captain of Industry to Factorio. Unfortunetly is not able to implement all stuff, for example the vehicles, but at least we could try.

SET FACTORIO_VERSION=2.0
SET FACTORIO_VERSION_MIN=2.0.0

SET PREVIOUS_VERSION=0.0.0
SET LAST_VERSION=0.0.1

SET MOD_LOCATION=.
SET PREVIOUS_VERSION_LOCATION=%APPDATA%\Factorio\mods\%MOD_NAME%_%PREVIOUS_VERSION%
SET LAST_VERSION_LOCATION=%APPDATA%\Factorio\mods\%MOD_NAME%_%LAST_VERSION%

IF exist "%PREVIOUS_VERSION_LOCATION%\" RD /S /Q "%PREVIOUS_VERSION_LOCATION%"
IF exist "%LAST_VERSION_LOCATION%\"     RD /S /Q "%LAST_VERSION_LOCATION%"

XCOPY ".\src" "%LAST_VERSION_LOCATION%" /S /I
@rem XCOPY "%MOD_LOCATION%\graphics" "%LAST_VERSION_LOCATION%\graphics" /S /I
@rem XCOPY "%MOD_LOCATION%\migrations" "%LAST_VERSION_LOCATION%\migrations" /S /I

SET JSON=%LAST_VERSION_LOCATION%/info.json

echo {                                                                            >> %JSON%
echo   "name":             "%MOD_NAME%",                                          >> %JSON%
echo   "version":          "%LAST_VERSION%",                                      >> %JSON%
echo   "title":            "%MOD_TITLE%",                                         >> %JSON%
echo   "author":           "%MOD_AUTHOR%",                                        >> %JSON%
echo   "contact":          "%MOD_AUTHOR_CONTACT%",                                >> %JSON%
echo   "homepage":         "%MOD_HOMEAPAGE%",                                     >> %JSON%
echo   "description":      "%MOD_DESCRIPTION%",                                   >> %JSON%
echo   "factorio_version": "%FACTORIO_VERSION%",                                  >> %JSON%
@rem echo   "dependencies":     ["base >= %FACTORIO_VERSION_MIN%" ]                    >> %JSON%
echo   "dependencies":     ["base >= %FACTORIO_VERSION_MIN%", %MOD_DEPENDENCIES%] >> %JSON%
echo }                                                                            >> %JSON%

DEL %LAST_VERSION_LOCATION%.zip
"C:\Program Files\7-Zip\7z.exe" a %LAST_VERSION_LOCATION%.zip %LAST_VERSION_LOCATION%
