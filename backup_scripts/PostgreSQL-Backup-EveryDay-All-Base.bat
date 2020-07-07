REM https://soft-setup.ru/administrirovanie/sozdanie-bekapa-bazy-postgresql-dlya-windows/ Описание
REM http://dl.gsu.by/doc/use/ntcmds.htm Сценарии командной строки
REM Postgres psql https://postgrespro.ru/docs/postgresql/9.6/app-psql
REM Postgres pg_dump https://postgrespro.ru/docs/postgrespro/10/app-pgdump
REM Postgres dropdb https://postgrespro.ru/docs/postgrespro/9.5/app-dropdb
REM Postgres createdb https://postgrespro.ru/docs/postgresql/9.6/app-createdb
REM Postgres pg_restore https://postgrespro.ru/docs/postgrespro/10/app-pgrestore
REM Postgres шаблоны баз данных https://postgrespro.ru/docs/postgrespro/9.5/manage-ag-templatedbs
REM Postgres Поддержка кодировок https://postgrespro.ru/docs/postgrespro/9.5/multibyte

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
SET DAYDELETE=32

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

SET SRV=gv01-srv
SET BACKUPFOLDER=\\!SRV!\PostgreSQL_1C_Database_backup\%~n0\!DateNow!

REM Создаем папку куда будем сохранять бакап если она не существует
IF NOT EXIST "!BACKUPFOLDER!" MD "!BACKUPFOLDER!"

REM Создаем файл со списком всех баз на нашем сервере Postgres
"%PGBIN%\psql" -A -t -c "SELECT datname from pg_database WHERE NOT datname IN ('postgres', 'template0', 'template1');">!BACKUPFOLDER!\SQLDataBaseList_!DateNow!.log

ECHO ======================================================================================================
ECHO START LOOP / Начало цикла копирования баз 
ECHO !DateNow!_!TimeNow!
ECHO ======================================================================================================

ECHO ======================================================================================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO START LOOP / Начало цикла копирования баз>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO ======================================================================================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM ============================================================================================
REM Выводим список баз для бэкапа
ECHO Список баз:
ECHO Cписок баз:>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO.
ECHO.>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Начало цикла

FOR /F "tokens=1,2" %%I IN (!BACKUPFOLDER!\SQLDataBaseList_!DateNow!.log) DO (
ECHO %%I
ECHO %%I>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
REM Конец цикла
)

ECHO.
ECHO.>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
REM ============================================================================================

REM Начало цикла
FOR /F "tokens=1,2" %%I IN (!BACKUPFOLDER!\SQLDataBaseList_!DateNow!.log) DO (

REM Если дата на пк формата dd.mm.yyyy
REM set DateNow=!DATE:~6,4!-!DATE:~3,2!-!DATE:~0,2!
REM set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!

REM Если дата на пк формата yyyy-mm-dd
set DateNow=!DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!
set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
REM Боремся с нулем который пропадает после полуночи
set TimeNow=!TimeNow: =0!

REM Формирование имени файла резервной копии и файла-отчета
ECHO =============================
ECHO Backup %%I
ECHO !DateNow!_!TimeNow!
ECHO =============================
ECHO =============================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO Backup %%I>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO =============================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Выполнение бэкапа базы
REM Вот так должно выглядеть с переменными "%PGBIN%\pg_dump.exe" --format=custom --verbose --file=%DUMPPATH% 2>%LOGPATH%
"%PGBIN%\pg_dump" -d "%%I" --format=custom --verbose --file="!BACKUPFOLDER!\%%I_!DateNow!_!TimeNow!.backup" 2>"!BACKUPFOLDER!\%%I_!DateNow!_!TimeNow!.log"

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

ECHO.>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

Timeout 1
)
REM Конец цикла

ECHO ==================================
ECHO END LOOP / Конец цикла копирования
ECHO !DateNow!_!TimeNow!
ECHO ==================================

ECHO ==================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO END LOOP / Конец цикла копирования>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO.==================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

ECHO.
ECHO.>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Очистка старых бэкапов
ECHO ==================================
ECHO Deleting files older than that %DAYDELETE% (day/days)
ECHO %DateNow%_%TimeNow%
ECHO ==================================
ECHO ==================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO Deleting files older than that %DAYDELETE% (day/days)>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO %DateNow%_%TimeNow%>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
ECHO ==================================>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Подключи как сетевой диск папку для того чтобы работало удаление
net use X: \\!SRV!\PostgreSQL_1C_Database_backup

REM Удаление папок
forfiles /P "X:\%~n0" /d -%DAYDELETE% /C "cmd /c RMDIR /s /q @path" 2>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%
IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Удаление файлов
REM forfiles /P "X:\%~n0" /S /D -%DAYDELETE% /C "cmd /c del /f /a /q @file" 2>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM Анализ ошибок
REM IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%
REM IF NOT !ERRORLEVEL!==0 ECHO Error: No files matching the search terms have been found. %ERRORLEVEL%>>!BACKUPFOLDER!\ShortLog_!DateNow!.log
REM IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%
REM IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. %ERRORLEVEL%>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

REM ECHO.>>!BACKUPFOLDER!\ShortLog_!DateNow!.log

Timeout 60