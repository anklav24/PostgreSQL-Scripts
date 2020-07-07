REM https://soft-setup.ru/administrirovanie/sozdanie-bekapa-bazy-postgresql-dlya-windows/ Описание
REM http://dl.gsu.by/doc/use/ntcmds.htm Сценарии командной строки
REM Postgres psql https://postgrespro.ru/docs/postgresql/9.6/app-psql
REM Postgres pg_dump https://postgrespro.ru/docs/postgrespro/10/app-pgdump
REM Postgres dropdb https://postgrespro.ru/docs/postgrespro/9.5/app-dropdb
REM Postgres createdb https://postgrespro.ru/docs/postgresql/9.6/app-createdb
REM Postgres pg_restore https://postgrespro.ru/docs/postgrespro/10/app-pgrestore
REM Postgres шаблоны баз данных https://postgrespro.ru/docs/postgrespro/9.5/manage-ag-templatedbs
REM Postgres Поддержка кодировок https://postgrespro.ru/docs/postgrespro/9.5/multibyte

REM ПРИМЕР УДАЛЕНИЕ БАЗ С ИМЕНАМИ СОДЕРЖАЩИМИСЯ В ФАЙЛЕ Get_SQLDataBaseList.log
REM ПОЛУЧИТЬ ФАЙЛ МОЖНО С ПОМОЩЬЮ СКРИПТА Get_SQLDataBaseList.bat

REM Вопросы можно задать сюда Anklav24@gmail.com
REM 2019

REM ПЕРЕД ВЫПОЛНЕНИЕМ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL
REM ПЕРЕД ВЫПОЛНЕНИЕМ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL
REM ПЕРЕД ВЫПОЛНЕНИЕМ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL

CLS
REM Отключаем отображение комманд в консоли
ECHO OFF
REM Установка кодировки для правильного отображения логов и сообщений msg
CHCP 1251
REM Меняем кодировку Postgres для вывода корректных логов
SET PGCLIENTENCODING=win1251
CLS
REM =============================================================================
REM Установка переменных окружения. Внимательно меняем все значения на свои до пункта setlocal
SET PGBIN=C:\Program Files\PostgreSQL\11.5-12.1C\bin
SET PGUSER=postgres
SET PGPASSWORD=YOUR_PASSWORD
SET PGPORT=5432
REM Указываем имя/ip сервера. В случае локального выполнения localhost.
SET PGHOST=localhost


REM Устанавливаем для того чтобы в цикле работало время правильно в переменных времени меняем % на !
setlocal enabledelayedexpansion

ECHO ======================================================================================================
ECHO START LOOP / Начало цикла УДАЛЕНИЯ баз 
ECHO !DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!_!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ======================================================================================================

ECHO ======================================================================================================>>%~n0.log
ECHO START LOOP / Начало цикла УДАЛЕНИЯ баз>>%~n0.log
ECHO !DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!_!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO ======================================================================================================>>%~n0.log

REM Для имен в файле SQLDataBaseList.log лежащем в текущей папке
FOR /F "tokens=1,2" %%I IN (%~dp0SQLDataBaseList.log) DO (
REM Получить имя базы переменная %%~nI
REM Получить путь до базы переменная %%I

REM Удаление баз
ECHO ===============================
ECHO DELETE BASE / Удаление базы %%~nI
ECHO ===============================

ECHO ===============================>>%~n0.log
ECHO DELETE BASE / Удаление базы %%~nI>>%~n0.log
ECHO ===============================>>%~n0.log

REM Также в конце идет команда о записи в лог. 2>>%~n0.log
"%PGBIN%\dropdb" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -e --if-exists "%%~nI" 2>>%~n0.log

IF NOT !ERRORLEVEL!==0 ECHO Ошибка. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Успешно завершено. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Ошибка. !ERRORLEVEL!>>%~n0.log
IF NOT !ERRORLEVEL!==1 ECHO Успешно завершено. !ERRORLEVEL!>>%~n0.log

ECHO.
ECHO.>>%~n0.log

Timeout 1
REM Конец цикла
)

ECHO ======================
ECHO END LOOP / Конец цикла 
ECHO !DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!_!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ======================

ECHO ======================>>%~n0.log
ECHO END LOOP / Конец цикла>>%~n0.log
ECHO !DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!_!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO.======================>>%~n0.log

ECHO.
ECHO.>>%~n0.log

Pause

