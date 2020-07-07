REM ОБСЛУЖИВАНИЕ БАЗ 1С
REM https://soft-setup.ru/administrirovanie/sozdanie-bekapa-bazy-postgresql-dlya-windows/ Описание
REM http://dl.gsu.by/doc/use/ntcmds.htm Сценарии командной строки
REM Postgres psql https://postgrespro.ru/docs/postgresql/9.6/app-psql
REM Postgres reindexdb.exe https://postgrespro.ru/docs/postgresql/11/app-reindexdb
REM Postgres vacuumdb.exe https://postgrespro.ru/docs/postgresql/11/app-vacuumdb
REM Postgres шаблоны баз данных https://postgrespro.ru/docs/postgrespro/9.5/manage-ag-templatedbs
REM Postgres Поддержка кодировок https://postgrespro.ru/docs/postgrespro/9.5/multibyte
REm Postgres Переменные окружения https://postgrespro.ru/docs/postgresql/11/libpq-envars

REM ПРИМЕР СОЗДАНИЯ РЕЗЕРВНОЙ КОПИИ ВСЕХ БАЗЫ ДАННЫХ НА СЕРВЕРЕ POSTGRESQL

REM ПУТЬ ДО СКРИПТА НЕ ДОЛЖЕН СОДЕРЖАТЬ ПРОБЕЛОВ!!!

REM Вопросы можно задать сюда Anklav24@gmail.com
REM 2019

REM Очищаем экран
CLS
ECHO OFF
REM Установка кодировки для правильного отображения логов и сообщений msg
CHCP 1251
CLS
REM Установка переменных окружения
SET PGBIN=C:\Program Files\PostgreSQL\11.5-12.1C\bin
SET PGHOST=localhost
SET PGPORT=5432
SET PGUSER=postgres
SET PGPASSWORD=YOUR_PASSWORD
REM Устанавливаем количество дней через которое будет происходить удаление бэкапов
SET DAYDELETE=183

REM Устанавливаем для того чтобы в цикле работало время правильно в переменных времени меняем % на !
setlocal enabledelayedexpansion

REM Если дата на пк формата dd.mm.yyyy
REM set DateNow=!DATE:~6,4!-!DATE:~3,2!-!DATE:~0,2!
REM set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!

REM Если дата на пк формата yyyy-mm-dd
set DateNow=!DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!
set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
REM Боремся с нулем который пропадает после полуночи
set TimeNow=!TimeNow: =0!

REM Создаем папку куда будем сохранять бакап если она не существует
IF NOT EXIST "%~dp0%~n0_logs\!DateNow!" MD "%~dp0%~n0_logs\!DateNow!"

REM Создаем файл со списком всех баз на нашем сервере Postgres
"%PGBIN%\psql" -A -t -c "SELECT datname from pg_database WHERE NOT datname IN ('postgres', 'template0', 'template1');">%~dp0%~n0_logs\!DateNow!\SQLDataBaseList_!DateNow!.log

REM Начало цикла
FOR /F "tokens=1,2" %%I IN (%~dp0%~n0_logs\!DateNow!\SQLDataBaseList_!DateNow!.log) DO (

REM Создаем папку куда будем сохранять бакап если она не существует
IF NOT EXIST "%~dp0%~n0_logs\!DateNow!" MD "%~dp0%~n0_logs\!DateNow!"

REM Если дата на пк формата dd.mm.yyyy
REM set DateNow=!DATE:~6,4!-!DATE:~3,2!-!DATE:~0,2!
REM set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!

REM Если дата на пк формата yyyy-mm-dd
set DateNow=!DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!
set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
REM Боремся с нулем который пропадает после полуночи
set TimeNow=!TimeNow: =0!

ECHO ANALYZE %%I
ECHO ANALYZE %%I>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log
ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log

REM ANALYZE
"%PGBIN%\vacuumdb.exe" --dbname %%I --analyze-only --echo --verbose 2>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log

ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log

ECHO.>>%~dp0%~n0_logs\!DateNow!\%%I_!DateNow!_!TimeNow!.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO ANALYZE %%I_!DateNow!_!TimeNow! - Error. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO ANALYZE %%I_!DateNow!_!TimeNow! - Successfully completed. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO.
Timeout 1
ECHO.
)
REM Конец цикла

REM Очистка старых логов
ECHO ==================================
ECHO Deleting files older than that %DAYDELETE% (day/days)
ECHO %DateNow%_%TimeNow%
ECHO ==================================
ECHO ==================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO Deleting files older than that %DAYDELETE% (day/days)>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO %DateNow%_%TimeNow%>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO ==================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Удаление папок
forfiles /P "%~dp0%~n0_logs" /d -%DAYDELETE% /C "cmd /c RMDIR /s /q @path" 2>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%
IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
