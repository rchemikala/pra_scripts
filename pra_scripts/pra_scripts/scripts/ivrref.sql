select name,to_char(last_refresh,'dd-mon-yy hh:mi:ss') last_refresh from dba_mview_refresh_times where owner='IVR';
