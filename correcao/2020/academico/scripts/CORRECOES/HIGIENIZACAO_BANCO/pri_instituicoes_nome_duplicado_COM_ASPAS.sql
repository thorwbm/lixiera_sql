select nome, replace(nome, '"','') from core_instituicao
				-- update core_instituicao set nome = replace(nome, '"','')
where nome like '%"%'

select nome, replace(nome, '  ',' ') from core_instituicao
				-- update core_instituicao set nome = replace(nome, '  ',' ')
where nome like '%  %'

select nome, replace(nome, '  ',' ') from core_instituicao
				-- update core_instituicao set nome = ltrim(rtrim(nome))
				where len(nome) <> len(ltrim(rtrim(nome)))

