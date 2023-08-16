```shell
#!/bin/bash 

TBL_LIST=/tmp/table_name_list.out
TBL_METADATA=/tmp/ddl_tables_all.sql
sqlplus -S '/ as sysdba' << EOF
PROMPT
spool ${TBL_LIST}
set pages 0
set echo off heading off feedback off
select username from dba_users where username not in ('SYS','SYSTEM','DBSNMP','EXFSYS','MDSYS','ORDDATA','UNDOTBS1') order by 1;
spool off
EOF

for USERNAME in `cat ${TBL_LIST}`
do
export USERNAME
sqlplus -S '/ as sysdba' << EOF
begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform,'STORAGE',false); --过滤掉tablespace存储信息
   dbms_metadata.set_transform_param (dbms_metadata.session_transform,'REF_CONSTRAINTS', false); -- 过滤掉外键约束信息
   dbms_metadata.set_transform_param (dbms_metadata.session_transform,'TABLESPACE',false);  -- 过滤掉表空间信息
   dbms_metadata.set_transform_param (dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES', false);   -- 过滤掉段信息信息
   dbms_metadata.set_transform_param (dbms_metadata.session_transform,'CONSTRAINTS', false);   -- 过滤掉约束信息  
end;
/

spool ${TBL_METADATA} APPEND
set termout off
set linesize 190
set pages 50000
set feedback off
set trim on
set echo off
col USERNAME for a30
col account_status for a23
set pages 0;
set echo off heading off feedback off;
SELECT DBMS_METADATA.GET_DDL('TABLE', '$USERNAME') FROM DUAL ;
/
spool off
EOF
done
```