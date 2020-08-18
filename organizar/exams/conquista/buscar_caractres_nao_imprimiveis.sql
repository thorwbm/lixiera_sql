select * 
from bkp_escolas
where nome like '%[^A-z0-9 .\/\-]%'