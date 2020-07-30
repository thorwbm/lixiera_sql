declare @tab1 varchar(100), @tab2 varchar(100), @sql nvarchar(1000), @coluna varchar(500), @qtd int,  @ParmDefinition nvarchar(500)
-- select * from usuarios_hierarquia
set @tab1 = 'usuarios_hierarquia'
set @tab2 = '#TEMP'



set @sql = N'select @qtdOut = COUNT(1) from ' + @tab1 + ' as tab1 join ' + @tab1 + ' as tab2 on ( '

declare abc cursor for 
	select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = @tab1
	open abc 
		fetch next from abc into @coluna
		while @@FETCH_STATUS = 0
			BEGIN
				set @sql = @sql + ' tab1.' + @coluna + ' = tab2.' + @coluna + ' and '
			fetch next from abc into @coluna
			END
	close abc 
deallocate abc 
   
   set @sql = @sql + ')'
   set @sql = REPLACE(@sql, ' and )',  ' )')

   print @sql

   
SET @ParmDefinition = N'@qtdOut int OUTPUT'; 
   exec sp_executesql @sql,  @ParmDefinition, @qtdOut = @qtd OUTPUT

   SELECT @qtd

 --  SELECT @QTD_REG_TAB FROM 

 --SELECT * INTO #TEMP FROM usuarios_hierarquia