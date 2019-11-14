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
SET PGBIN=C:\Program Files\PostgreSQL 1C\11\bin
SET PGHOST=localhost
SET PGPORT=5432
SET PGUSER=postgres
SET PGPASSWORD=YOUR_PASSWORD
REM Устанавливаем количество дней через которое будет происходить удаление бэкапов
SET DAYDELETE=7

REM Создаем файл со списком всех баз на нашем сервере Postgres
psql -A -t -c "select datname from pg_database">SQLDataBaseList.log

setlocal enabledelayedexpansion

ECHO ======================================================================================================
ECHO START LOOP / Начало цикла копирования баз 
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ======================================================================================================

ECHO ======================================================================================================>>%~n0.log
ECHO START LOOP / Начало цикла копирования баз>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO ======================================================================================================>>%~n0.log

REM ============================================================================================
REM Выводим список баз для бэкапа
ECHO Список баз:
ECHO Cписок баз:>>%~n0.log
ECHO.
ECHO.>>%~n0.log
REM Начало цикла
FOR /F "tokens=1,2" %%I IN (%~dp0SQLDataBaseList.log) DO (
ECHO %%I
ECHO %%I>>%~n0.log
REM Конец цикла
)
ECHO.
ECHO.>>%~n0.log
REM ============================================================================================

REM Начало цикла
FOR /F "tokens=1,2" %%I IN (%~dp0SQLDataBaseList.log) DO (
REM Формирование имени файла резервной копии и файла-отчета
ECHO =============================
ECHO Backup %%I
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO =============================
ECHO =============================>>%~n0.log
ECHO Backup %%I>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log
ECHO =============================>>%~n0.log
REM ECHO DATEDAY: !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!
REM  DUMPFILE: %%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.backup
REM  LOGFILE: %%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.log
REM  DUMPPATH: %~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!\%%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.backup
REM  LOGPATH: %~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!\%%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.log
REM  NAMEFOLDERBACKUP: %~d0\%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!

REM Создаем папку куда будем сохранять базкап
IF NOT EXIST "%~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!" MD "%~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!"
REM Выполнение бэкапа базы
REM Вот так должно выглядеть с переменными "%PGBIN%\pg_dump.exe" --format=custom --verbose --file=%DUMPPATH% 2>%LOGPATH%
"%PGBIN%\pg_dump" -d "%%I" --format=custom --verbose --file="%~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!\%%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.backup" 2>"%~dp0%~n0\!DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4!\%%I !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!.log"
REM Анализ ошибок
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.>>%~n0.log
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.>>%~n0.log

ECHO.>>%~n0.log

REM Конец цикла
Timeout 5
)

ECHO ==================================
ECHO END LOOP / Конец цикла копирования
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ==================================

ECHO ==================================>>%~n0.log
ECHO END LOOP / Конец цикла копирования>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO.==================================>>%~n0.log

ECHO.
ECHO.>>%~n0.log

REM Очистка старых бэкапов
ECHO ==================================
ECHO Удаление файлов старше %DAYDELETE% (дня/дней)
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ==================================
ECHO ==================================>>%~n0.log
ECHO Удаление файлов старше %DAYDELETE% (дня/дней)>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO ==================================>>%~n0.log
REM Удаление файлов
forfiles /P "%~dp0%~n0" /S /D -%DAYDELETE% /C "cmd /c del /f /a /q @file"
REM Удаление папок
forfiles /P "%~dp0%~n0" /d -%DAYDELETE% /C "cmd /c rd /s /q @path" 2>>%~n0.log

REM Анализ ошибок
IF NOT %ERRORLEVEL%==0 ECHO ОШИБКА: Не найдены файлы, отвечающие условиям поиска.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.>>%~n0.log

ECHO.>>%~n0.log

Timeout 60