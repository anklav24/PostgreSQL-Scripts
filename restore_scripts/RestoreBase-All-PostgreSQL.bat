REM https://soft-setup.ru/administrirovanie/sozdanie-bekapa-bazy-postgresql-dlya-windows/ Описание
REM http://dl.gsu.by/doc/use/ntcmds.htm Сценарии командной строки
REM Postgres psql https://postgrespro.ru/docs/postgresql/9.6/app-psql
REM Postgres pg_dump https://postgrespro.ru/docs/postgrespro/10/app-pgdump
REM Postgres dropdb https://postgrespro.ru/docs/postgrespro/9.5/app-dropdb
REM Postgres createdb https://postgrespro.ru/docs/postgresql/9.6/app-createdb
REM Postgres pg_restore https://postgrespro.ru/docs/postgrespro/10/app-pgrestore
REM Postgres шаблоны баз данных https://postgrespro.ru/docs/postgrespro/9.5/manage-ag-templatedbs
REM Postgres Поддержка кодировок https://postgrespro.ru/docs/postgrespro/9.5/multibyte

REM ПРИМЕР ВОССТАНОВЛЕНИЯ РЕЗЕРВНОЙ КОПИИ ВСЕХ БАЗ ДАННЫХ POSTGRESQL В УКАЗАННОЙ ПАПКЕ

REM Вопросы можно задать сюда Anklav24@gmail.com
REM 2019

REM ПЕРЕД ВЫВОЛНЕНИЕ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL
REM ПЕРЕД ВЫВОЛНЕНИЕ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL
REM ПЕРЕД ВЫВОЛНЕНИЕ СКРИПТА ЗАКРЫВАЕМ ВСЕ СЕАНСЫ И ДИСКОНЕКТИМ БАЗЫ, ТАК ЖЕ МОЖНО ПЕРЕЗАПУСТИТЬ СЛУЖБУ POSTGRESQL

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
REM Рекомендую вручную создать пустую базу удалить из нее схемы очистить её через clean и дать имя (напр. template1c) и указать здесь такое же
REM Эта база станет нашим чистым шаблоном. Можно оставить все как есть и указать здесь template1. ПРОВЕВЯЙТЕ У СЕБЯ ЗАРАНЕЕ ЭТУ ФИШКУ НЕ ВСЕГДА РАБОТАЕТ
REM SET template=template1c

REM ================================================================================
REM Указываем имя папки с бэкапами. Сам скрипт должен находиться на каталог выше!!!.
REM ================================================================================
SET backupfoldername=restore

REM =============================================================================
SET backupfolderpatch=%~dp0%backupfoldername%

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

ECHO ======================================================================================================
ECHO START LOOP / Начало цикла восстановления баз 
ECHO !DateNow!_!TimeNow!
ECHO ======================================================================================================

ECHO ======================================================================================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO START LOOP / Начало цикла восстановления баз>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO ======================================================================================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Для переменной %%I в папке (Путь) с расширениями .backup выполняем дальнейшие действия до конца скрита.
FOR %%I IN (%backupfolderpatch%\*.backup) DO (
REM Получить имя базы переменная %%~nI
REM Получить путь до базы переменная %%I

REM Если дата на пк формата dd.mm.yyyy
REM set DateNow=!DATE:~6,4!-!DATE:~3,2!-!DATE:~0,2!
REM set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!

REM Если дата на пк формата yyyy-mm-dd
set DateNow=!DATE:~0,4!-!DATE:~5,2!-!DATE:~8,2!
set TimeNow=!TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
REM Боремся с нулем который пропадает после полуночи
set TimeNow=!TimeNow: =0!

REM ==================================
REM Этапы восстановления базы postgres
REM ==================================

ECHO ================================================
ECHO START RECOVERY BASE / Начало восстановления базы 
ECHO %%~nI
ECHO !DateNow!_!TimeNow!
ECHO ================================================

ECHO ================================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO START RECOVERY BASE / Начало восстановления базы>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO %%~nI>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO ================================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Удаление баз для корректного восстановления
ECHO ===============================
ECHO 1 - DELETE BASE / Удаление базы %%~nI
ECHO ===============================

ECHO ===============================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO 1 - DELETE BASE / Удаление базы %%~nI>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO ===============================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Также в конце идет команда о записи в лог. 2>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
"%PGBIN%\dropdb" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -e "%%~nI" 2>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO ============================================
ECHO 2 - CREATE EMPTY BASE / Создание пустой базы %%~nI
ECHO ============================================

ECHO ============================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO 2 - CREATE EMPTY BASE / Создание пустой базы %%~nI>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO ============================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Создание пустых баз для корректного восстановления
"%PGBIN%\createdb" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -e "%%~nI" 2>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
REM -T %template% добавить если хочеться создавать на основе темплейта
REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO =======================================
ECHO 3 - RECOVERY BASE / Восстановление базы %%~nI
ECHO =======================================

ECHO =======================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO 3 - RECOVERY BASE / Восстановление базы %%~nI>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO =======================================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

REM Восстановление баз из файлов бэкапов. Добавить ключ -v если нужны подробные логи
REM Подробные логи выводим в отдельные файлы так как достаточно много весят

ECHO ===============================>>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log
ECHO %%~nI>>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log
ECHO !DateNow!_!TimeNow!>>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log
ECHO ===============================>>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log

"%PGBIN%\pg_restore" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -v --dbname "%%~nI" "%%I" 2>>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log

REM Анализ ошибок
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!
IF NOT !ERRORLEVEL!==0 ECHO Error. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
IF NOT !ERRORLEVEL!==1 ECHO Successfully completed. !ERRORLEVEL!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO. >>%~dp0%~n0_logs\!DateNow!\%%~nI_!DateNow!_!TimeNow!_detail.log

ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

Timeout 1
REM Конец цикла
)

ECHO ======================
ECHO END LOOP / Конец цикла 
ECHO !DateNow!_!TimeNow!
ECHO ======================

ECHO ======================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO END LOOP / Конец цикла>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO !DateNow!_!TimeNow!>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log
ECHO.======================>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

ECHO.
ECHO.>>%~dp0%~n0_logs\!DateNow!\ShortLog_!DateNow!.log

Pause

