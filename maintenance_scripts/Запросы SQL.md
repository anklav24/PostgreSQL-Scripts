### Глянуть процессы

`SELECT datid, datname, pid, usesysid, usename, application_name, client_addr, client_hostname, client_port, backend_start, query_start, state FROM pg_stat_activity;`

`PG_CANCEL_BACKEND` останавливаем нежелательные процессы в базе
`SELECT pid, query, * FROM pg_stat_activity` -- таблица с процессами БД. В старых версиях postgres столбец PID назывался PROCPID
`WHERE state <> 'idle' and pid <> pg_backend_pid();` -- исключаем подключения и свой только что вызванный процесс

`SELECT pid, query, * FROM pg_stat_activity WHERE state <> 'idle' and pid <> pg_backend_pid();`

`SELECT pg_terminate_backend(PID);` /* подставляем сюда PID процесса который мы хотим остановить, в отличие от нижеприведенной команды, посылает более щадящий сигнал о завершении, который не всегда может убить процесс*/
`SELECT pg_cancel_backend(PID);` /* подставляем сюда PID процесса который мы хотим остановить. Практически гарантированно убивает запрос, что-то вроде KILL -9 в LINUX */

### Посмотреть список баз

`\l`
`SELECT * FROM pg_database;`

### Посмотреть размер баз

`\l+`

Или использовать скрипт (копировать целиком 4 строки)

`select t1.datname AS db_name,  
       pg_size_pretty(pg_database_size(t1.datname)) as db_size
from pg_database t1
order by pg_database_size(t1.datname) desc;`
