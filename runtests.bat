@echo off

rem #####
rem # Flagrantly copied from runtests.sh
rem # See that file for more inspiration.
rem #####

rem #####
rem # Type Analysis

setlocal
set ANA=dart_analyzer --enable_type_checks --fatal-type-errors --extended-exit-code --type-checks-for-inferred-types 

echo 
echo Type Analysis, running dart_analyzer...

set EXITSTATUS=0

rem ####
rem # test files one at a time
rem #

SET ROOT=src\site\articles


FOR /F "DELIMS==" %%d in ('DIR "%ROOT%" /AD /B') DO ( 
  if exist "%ROOT%\%%d\code\*.dart" (
    FOR /F "DELIMS==" %%f in ('DIR "%ROOT%\%%d\code\*.dart" /B') DO (
      if exist "%ROOT%\%%d\code\%%f" (
        call %ANA% "%ROOT%\%%d\code\%%f"
        rem TODO: Capture output 
        rem TODO: Determine success or failure
        rem TODO: Modify exitstatus accordingly.
      )
    )
  )
)  

exit /b EXITSTATUS