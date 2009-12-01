@echo off
if not "%nocls%"=="1" cls
setlocal
set nocls=1
set task=%1

if "%task%"=="" goto :help
goto :%task%
if not %errorlevel%==0 goto :help

goto :end

:notify
msg %username% "hi"
goto :next

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
call cap invoke COMMAND="cd /mnt/app/current;rake solr:stop RAILS_ENV=production;nohup rake solr:start RAILS_ENV=production > /dev/null 2>&1 &"
goto :next

:migrate
echo Migrating...
call cap deploy:migrate
goto :next

:reindex
echo Reindexing solr (remember, it needs to be started first!)...
call cap invoke COMMAND="cd /mnt/app/current;rake solr:reindex RAILS_ENV=production"
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
echo Supported commands: deploy, update, start_solr, migrate, do_everything, notify
echo do_everything = update then migrate then start_solr then deploy
echo notify gives you a nice notify. Use it like '%~n0 update then notify'
echo.
goto :end

:end
echo.
endlocal