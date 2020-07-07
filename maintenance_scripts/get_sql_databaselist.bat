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

setlocal enabledelayedexpansion

REM Если дата на пк формата dd.mm.yyyy
REM set DateNow=!DATE:~6,4!-!DATE:~3,2!-!DATE:~0,2!
REM set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!

REM Если дата на пк формата yyyy-mm-dd
set DateNow=!DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!
set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
REM Боремся с нулем который пропадает после полуночи
set TimeNow=!TimeNow: =0!

REM Создаем файл со списком всех баз на нашем сервере Postgres:
REM ECHO !DateNow!_!TimeNow!>>SQLDataBaseList.log
REM ECHO Удали на всякий из списка описание с датой.>>SQLDataBaseList.log
REM ECHO Оставь пустую строку c начала, а то в ней какой-то символ скрытый.>>SQLDataBaseList.log
REM ECHO Cписок баз:>>SQLDataBaseList.log
REM ECHO.>>SQLDataBaseList.log
"!PGBIN!\psql" -A -t -c "SELECT datname from pg_database WHERE NOT datname IN ('postgres', 'template0', 'template1');">SQLDataBaseList.log
REM ECHO.>>SQLDataBaseList.log