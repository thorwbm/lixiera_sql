/**********************************************************************************************************************************
*                            CORRECAO - DSICIPLINA CONLCUIDA COM PROFESSOR REGISTRADO E SEM TITULACAO                             *
*                                                                                                                                 *
*  BUSCA NA TABELA ACADEMICO_PROFESSOR_TITULACAO E UPDATA NA TABELA DISCIPLINACONCLUIDA                                           *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:08/01/2020 *
**********************************************************************************************************************************/

declare @discon_id int,  @atual_tit int, @novo_tit int, @aux varchar(max)

BEGIN TRAN
	declare CUR_DISCON cursor for 
		select cdc.id as disciplinaconcluida_id, cdc.titulacao_id as titulacao_id_atual, apt.titulacao_id as titulacao_id_nova
			from curriculos_disciplinaconcluida cdc join academico_professor_titulacao apt on(cdc.professor_id = apt.professor_id)
			where cdc.titulacao_id is null 

		open CUR_DISCON 
			fetch next from CUR_DISCON into @discon_id, @atual_tit, @novo_tit
			while @@FETCH_STATUS = 0
				BEGIN
				    -- **** GERANDO LOG *****
					SET @AUX = (  'titulacao_id;' + isnull(CONVERT(VARCHAR(10),@atual_tit),'null') + ';'+ isnull(CONVERT(VARCHAR(10),@novo_tit),'null')
							   )
					   EXEC SP_GERAR_LOG 'curriculos_disciplinaconcluida', @discon_id, '~', 2137,@AUX, NULL, NULL
				    -- **** GERANDO LOG FIM *****

					  update cdc set cdc.titulacao_id = apt.titulacao_id 
					   from curriculos_disciplinaconcluida cdc join academico_professor_titulacao apt on(cdc.professor_id = apt.professor_id)
			          where cdc.titulacao_id is null and
					        cdc.id = @discon_id

				fetch next from CUR_DISCON into @discon_id, @atual_tit, @novo_tit
				END
		close CUR_DISCON 
	deallocate CUR_DISCON 

-- rollback 
-- commit 
