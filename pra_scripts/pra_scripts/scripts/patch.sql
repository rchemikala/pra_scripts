set pagesize 1000
set verify off
set feedback off
accept patch_no char prompt 'ENTER PATCH NO : '
select patch_name
  from apps.ad_applied_patches
where patch_name = '&patch_no'
union
select bug_number
  from apps.ad_bugs
where bug_number = '&patch_no'
/
