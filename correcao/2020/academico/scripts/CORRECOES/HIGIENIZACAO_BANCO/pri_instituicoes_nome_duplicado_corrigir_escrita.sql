select nome into #temp from core_instituicao
where nome like '%"%'

insert into #temp
select nome from core_instituicao
where nome like '%  %'

insert into #temp
select nome from core_instituicao
where len(nome) <> len(ltrim(rtrim(nome)))

--  #######

declare @instintuicao varchar(500)
declare @instintuicao varchar(500)

declare CUR_ cursor for 
	select nome from #temp order by 1 
	open CUR_ 
		fetch next from CUR_ into @instintuicao
		while @@FETCH_STATUS = 0
			BEGIN



				select nome, replace(nome, '"','') from core_instituicao
				-- update core_instituicao set nome = replace(nome, '"','')
				where nome = @instintuicao

				select nome, replace(nome, '  ',' ') from core_instituicao
				-- update core_instituicao set nome = replace(nome, '  ',' ')
				where nome  = @instintuicao

				select nome, replace(nome, '  ',' ') from core_instituicao
				-- update core_instituicao set nome = ltrim(rtrim(nome))
				where len(nome) <> len(ltrim(rtrim(nome))) and 
				      nome  = @instintuicao
					  
			fetch next from CUR_ into @instintuicao
			END
	close CUR_ 
deallocate CUR_ 
