select application_name,description,patch_level from
fnd_product_installations a, fnd_application_vl b where
a.application_id = b.application_id
and b.description like '%&1%'
/
