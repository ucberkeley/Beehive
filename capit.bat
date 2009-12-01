@echo off
if not "%nocls%"=="1" cls
setlocal
set nocls=1
set task=%1

if "%task%"=="" goto :help
goto :%task%
if not %errorlevel%==0 goto :help

goto :end

:deploy
echo Deploying...
call cap deploy
goto :next

:update
echo Updating...
call cap deploy:update
goto :next

:start_solr
echo Starting solr...
call cap invoke COMMAND="cd /mnt/app/current;rake solr:stop;nohup rake solr:start > /dev/null 2>&1 &"
goto :next

:migrate
echo Migrating...
call cap deploy:migrate
goto :next

:do_everything
%0 update then migrate then start_solr then deploy
goto :end

:then
goto :next

:next
%0 %2 %3 %4 %5 %6 %7 %8 %9 end
goto :end

:help
echo %~n0
echo.
echo Runs multiple cap commands in a row.
echo Syntax: %~n0 [command1 [THEN command2 [THEN command3 ... ] ] ]
echo.
echo Supported commands: deploy, update, start_solr, migrate, do_everything
echo do_everything = update then migrate then start_solr then deploy
echo.
goto :end

:end
echo.
rem msg %username% "Finished capping."
endlocal