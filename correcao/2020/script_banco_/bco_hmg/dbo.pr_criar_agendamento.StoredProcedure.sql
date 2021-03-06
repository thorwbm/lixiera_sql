USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[pr_criar_agendamento]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[pr_criar_agendamento]
    @dias_semana varchar(15),
    @data_inicio date,
    @data_termino date,
    @periodicidade int,
    @usuario_id int,
    @turma nvarchar(200),
    @disciplina nvarchar(200),
    @professor_id int,
    @sala_id int,
    @json nvarchar(max)
as

SET DATEFIRST 1

    declare @i int
    set @i = 1

    declare @agendamento_id int
    declare @aula_agendamento_id int
    declare @grupo_aula_id int
    declare @inicio time
    declare @termino time

    declare @min_inicio time
    declare @max_termino time

    declare @dias_semana_json nvarchar(max)
    declare @dia_atual date

    declare @turma_disciplina_id int

    select @turma_disciplina_id = td.id
      from academico_turmadisciplina td
           inner join academico_turma turma on turma.id = td.turma_id
           inner join academico_disciplina disc on disc.id = td.disciplina_id
     where turma.nome = @turma
       and disc.nome = @disciplina

    if not @turma_disciplina_id  is null begin

        insert into agendamento_agendamento (criado_em, atualizado_em, dias_semana, data_inicio, data_termino, periodicidade_id, tipo_id, criado_por, atualizado_por)
        values (getdate(), getdate(), @dias_semana, @data_inicio, @data_termino, @periodicidade, 1, @usuario_id, @usuario_id)

        set @agendamento_id = SCOPE_IDENTITY()

        insert into aulas_agendamento (criado_em, atualizado_em, criado_por, atualizado_por, professor_id, turma_disciplina_id, agendamento_id, sala_id)
        values (getdate(), getdate(), @usuario_id, @usuario_id, @professor_id, @turma_disciplina_id, @agendamento_id, @sala_id)

        set @aula_agendamento_id = SCOPE_IDENTITY()


        while substring(@dias_semana, @i, 1) <> '' begin

            declare @dia_semana char(1);
            set @dia_semana = substring(@dias_semana, @i, 1);

            declare cur_dias_semana cursor for
            select value from openjson(@json) order by 1
            OFFSET @i - 1 ROWS
            FETCH NEXT 1 ROWS ONLY;

            open cur_dias_semana
            fetch next from cur_dias_semana into @dias_semana_json
            while @@FETCH_STATUS = 0 begin

                select @min_inicio = min(inicio), @max_termino = max(termino) from openjson(@dias_semana_json)
                with (   
                    inicio   time '$.inicio', 
                    termino  time '$.termino'
                )


                
                set @dia_atual = @data_inicio
                while @dia_atual <= @data_termino begin

                    if (DATEPART(WEEKDAY, @dia_atual) - 1) = convert(int, @dia_semana) begin

                        insert into academico_grupoaula (criado_em, atualizado_em, criado_por, atualizado_por, data_inicio, data_termino, turma_disciplina_id, status_id, professor_id, agendamento_id, sala_id)
                        values (getdate(), getdate(), @usuario_id, @usuario_id, convert(varchar, @dia_atual) + ' ' + convert(varchar, @min_inicio), convert(varchar, @dia_atual) + ' ' + convert(varchar, @max_termino), @turma_disciplina_id, 1, @professor_id, @aula_agendamento_id, @sala_id)

                        set @grupo_aula_id = SCOPE_IDENTITY()


                        declare cur_horarios cursor for
                        select inicio, termino from openjson(@dias_semana_json)
                        with (   
                            inicio   time '$.inicio', 
                            termino  time '$.termino'
                        )                        

                        open cur_horarios
                        fetch next from cur_horarios into @inicio, @termino
                        while @@FETCH_STATUS = 0 begin


                            if not exists(select top 1 1 from agendamento_horarioprogramado where agendamento_id = @agendamento_id and dia_semana = @dia_semana and inicio = @inicio) begin
                                insert into agendamento_horarioprogramado (criado_em, atualizado_em, criado_por, atualizado_por, dia_semana, inicio, termino, agendamento_id)
                                values (getdate(), getdate(), @usuario_id, @usuario_id, @dia_semana, @inicio, @termino, @agendamento_id)
                            end

                            insert into agendamento_horariocriado (criado_em, atualizado_em, criado_por, atualizado_por, dia, inicio, termino, agendamento_id)
                            values (getdate(), getdate(), @usuario_id, @usuario_id, @dia_atual, @inicio, @termino, @agendamento_id)


                            print 'agendamento_id: ' + convert(varchar(50), @agendamento_id)

                            insert into academico_aula (criado_em, atualizado_em, criado_por, atualizado_por, data_inicio, data_termino, turma_disciplina_id, duracao, status_id, professor_id, agendamento_id, sala_id)
                            values (getdate(), getdate(), @usuario_id, @usuario_id, convert(varchar, @dia_atual) + ' ' + convert(varchar, @inicio), convert(varchar, @dia_atual) + ' ' + convert(varchar, @termino), @turma_disciplina_id, 50, 1, @professor_id, @aula_agendamento_id, @sala_id)


                            fetch next from cur_horarios into @inicio, @termino
                        end

                        close cur_horarios 
                        deallocate cur_horarios

                    end
                    set @dia_atual = dateadd(day, 1, @dia_atual)
                end                    

                fetch next from cur_dias_semana into @dias_semana_json
            end

            close cur_dias_semana 
            deallocate cur_dias_semana


            set @i = @i + 1
        end
    end

    SET DATEFIRST 7

GO
