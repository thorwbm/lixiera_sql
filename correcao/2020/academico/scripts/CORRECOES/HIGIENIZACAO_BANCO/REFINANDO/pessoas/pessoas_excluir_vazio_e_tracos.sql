
select * 
-- update pes set pes.pai_id = null
from pessoas_pessoa pes where pai_id in (
select id from pessoas_pessoa where nome = '')

select * 
-- update pes set pes.mae_id = null
from pessoas_pessoa pes where mae_id in (
select id from pessoas_pessoa where nome = '')

delete from pessoas_pessoa  where id in (
select id from pessoas_pessoa where nome = '')

-- ################################################

select * 
-- update pes set pes.pai_id = null
from pessoas_pessoa pes where pai_id in (
select id from pessoas_pessoa where nome = '-')

select * 
-- update pes set pes.mae_id = null
from pessoas_pessoa pes where mae_id in (
select id from pessoas_pessoa where nome = '-')

delete from pessoas_pessoa  where id in (
select id from pessoas_pessoa where nome = '-')
