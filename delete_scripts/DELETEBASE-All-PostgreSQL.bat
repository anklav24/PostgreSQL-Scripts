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
SET PGBIN=C:\Program Files\PostgreSQL 1C\11\bin
SET PGUSER=postgres
SET PGPASSWORD=Control!PG
SET PGPORT=5432
REM Указываем имя/ip сервера. В случае локального выполнения localhost.
SET PGHOST=localhost
REM Рекомендую вручную создать пустую базу удалить из нее схемы очистить её через clean и дать имя (напр. template1c) и указать здесь такое же
REM Эта база станет нашим чистым шаблоном. Можно оставить все как есть и указать здесь template1
SET template=template1c

REM ================================================================================
REM Указываем имя папки с бэкапами. Сам скрипт должен находиться на каталог выше!!!.
REM ================================================================================
SET backupfoldername=25-06-2019

REM =============================================================================
SET backupfolderpatch=%~dp0%backupfoldername%

REM Устанавливаем для того чтобы в цикле работало время правильно в переменных времени меняем % на !
setlocal enabledelayedexpansion

ECHO ======================================================================================================
ECHO START LOOP / Начало цикла восстановления баз 
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ======================================================================================================

ECHO ======================================================================================================>>%~n0.log
ECHO START LOOP / Начало цикла восстановления баз>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO ======================================================================================================>>%~n0.log

REM Для переменной %%I в папке (Путь) с расширениями .backup выполняем дальнейшие действия до конца скрита.
FOR %%I IN (%backupfolderpatch%\*.backup) DO (
REM Получить имя базы переменная %%~nI
REM Получить путь до базы переменная %%I

REM ==================================
REM Этапы восстановления базы postgres
REM ==================================

ECHO ================================================
ECHO START RECOVERY BASE / Начало восстановления базы 
ECHO %%~nI
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ================================================

ECHO ================================================>>%~n0.log
ECHO START RECOVERY BASE / Начало восстановления базы>>%~n0.log
ECHO %%~nI>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log
ECHO ================================================>>%~n0.log

REM Удаление баз для корректного восстановления
ECHO ===============================
ECHO 1 - DELETE BASE / Удаление базы %%~nI
ECHO ===============================

ECHO ===============================>>%~n0.log
ECHO 1 - DELETE BASE / Удаление базы %%~nI>>%~n0.log
ECHO ===============================>>%~n0.log

REM Также в конце идет команда о записи в лог. 2>>%~n0.log
"%PGBIN%\dropdb" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -e --if-exists "%%~nI" 2>>%~n0.log

ECHO.
ECHO.>>%~n0.log

REM Анализ ошибок
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.>>%~n0.log
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.>>%~n0.log

ECHO.
ECHO.>>%~n0.log

ECHO ============================================
ECHO 2 - CREATE EMPTY BASE / Создание пустой базы %%~nI
ECHO ============================================

ECHO ============================================>>%~n0.log
ECHO 2 - CREATE EMPTY BASE / Создание пустой базы %%~nI>>%~n0.log
ECHO ============================================>>%~n0.log

REM Создание пустых баз для корректного восстановления
REM "%PGBIN%\createdb" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -T %template% -e "%%~nI" 2>>%~n0.log

ECHO.
ECHO.>>%~n0.log

REM Анализ ошибок
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.>>%~n0.log
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.>>%~n0.log

ECHO.
ECHO.>>%~n0.log

ECHO =======================================
ECHO 3 - RECOVERY BASE / Восстановление базы %%~nI
ECHO =======================================

ECHO =======================================>>%~n0.log
ECHO 3 - RECOVERY BASE / Восстановление базы %%~nI>>%~n0.log
ECHO =======================================>>%~n0.log

REM Восстановление баз из файлов бэкапов. Добавить ключ -v если нужны подробные логи
REM Подробные логи выводим в отдельные файлы так как достаточно много весят

ECHO ===============================>>%~n0-detail.log
ECHO %%~nI>>%~n0-detail.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0-detail.log
ECHO ===============================>>%~n0-detail.log

REM "%PGBIN%\pg_restore" --username "%PGUSER%" -p %PGPORT% -h %PGHOST% -v -d "%%~nI" "%%I" 2>>%~n0-detail.log
ECHO. >>%~n0-detail.log

ECHO.
ECHO.>>%~n0.log

REM Анализ ошибок
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.
IF NOT %ERRORLEVEL%==0 ECHO Ошибка.>>%~n0.log
IF NOT %ERRORLEVEL%==1 ECHO Успешно завершено.>>%~n0.log

ECHO.>>%~n0.log

Timeout 5
REM Конец цикла
)

ECHO ======================
ECHO END LOOP / Конец цикла 
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!
ECHO ======================

ECHO ======================>>%~n0.log
ECHO END LOOP / Конец цикла>>%~n0.log
ECHO !DATE:~0,2!-!DATE:~3,2!-!DATE:~6,4! !TIME:~0,2!-!TIME:~3,2!-!TIME:~6,2!>>%~n0.log>>%~n0.log
ECHO.======================>>%~n0.log

ECHO.
ECHO.>>%~n0.log

Pause

