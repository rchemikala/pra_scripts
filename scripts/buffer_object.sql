SELECT ds.buffer_pool, SUBSTR(do.object_name,1,9) OBJECT_NAME,
ds.blocks OBJECT_BLOCKS, COUNT(*) CACHED_BLOCKS
FROM dba_objects do, dba_segments ds, v$bh v
WHERE do.data_object_id=V.OBJD
AND do.owner=ds.owner(+)
AND do.object_name=ds.segment_name(+)
AND DO.OBJECT_TYPE=DS.SEGMENT_TYPE(+)
AND ds.buffer_pool IN ('DEFAULT') and do.owner='XPNINE' 
GROUP BY ds.buffer_pool, do.object_name, ds.blocks
ORDER BY do.object_name, ds.buffer_pool;

