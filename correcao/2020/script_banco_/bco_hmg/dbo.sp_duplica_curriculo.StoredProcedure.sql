USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_duplica_curriculo]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_duplica_curriculo] @id_curriculo_origem int, @nome_curriculo_destino varchar(255) as
begin
	begin tran

	declare @curriculo_id int

	set @id_curriculo_origem = 2290
	set @nome_curriculo_destino = 'PSICOLOGIA 2015/10-1.1'

	insert into curriculos_curriculo(criado_em, atualizado_em, ano, nome, atributos, curso_id, criado_por, turno_id, atualizado_por, curso_oferta_id, carga_horaria_min_complementares, carga_horaria_min_exigida, carga_horaria_min_optativas, termino_vigencia, inicio_vigencia)
	select getdate(), getdate(), ano, @nome_curriculo_destino, null, curso_id, 2137, turno_id, 2137, curso_oferta_id, carga_horaria_min_complementares, carga_horaria_min_exigida, 
		   carga_horaria_min_optativas, termino_vigencia, inicio_vigencia
	  from curriculos_curriculo
	 where id = @id_curriculo_origem

	set @curriculo_id = @@IDENTITY


	insert into curriculos_grade (criado_em, atualizado_em, criado_por, atualizado_por, nome, atributos, curriculo_id, etapa_id)
	select getdate(), getdate(), 2137, 2137, grade.nome, null, @curriculo_id, grade.etapa_id
	  from curriculos_grade grade
		   join curriculos_curriculo cur on cur.id = grade.curriculo_id
	 where cur.id = @id_curriculo_origem


	insert into curriculos_gradedisciplina (criado_em, atualizado_em, nr_aulas, carga_horaria, atributos, criado_por, disciplina_id, grade_id, atualizado_por, exigencia_disciplina_id, posicao, media_minima, percentual_aprovacao, maximo_nota_apos_recuperacao, percentual_recuperacao, professor_responsavel_id, frequencia_minima)
	select getdate(), getdate(), gd.nr_aulas, gd.carga_horaria, null, 2137, gd.disciplina_id, grade_o.id, 2137, gd.exigencia_disciplina_id, gd.posicao, gd.media_minima, gd.percentual_aprovacao, gd.maximo_nota_apos_recuperacao, gd.percentual_recuperacao, gd.professor_responsavel_id, gd.frequencia_minima
	  from curriculos_gradedisciplina gd
		   join curriculos_grade grade on grade.id = gd.grade_id
		   join curriculos_curriculo cur on cur.id = grade.curriculo_id
		   join curriculos_curriculo cur_o on cur_o.id = @curriculo_id
		   join curriculos_grade grade_o on grade_o.curriculo_id = cur_o.id and grade_o.etapa_id = grade.etapa_id
	 where cur.id = @id_curriculo_origem

	 insert into curriculos_gradedisciplinaequivalente (criado_em, atualizado_em, atributos, criado_por, grade_disciplina_equivalente_id, grade_disciplina_id, atualizado_por)
	 select getdate(), getdate(), null, 2137, eq.grade_disciplina_equivalente_id, gd_o.id as grade_disciplina_id, 2137
	   from curriculos_gradedisciplinaequivalente eq
		   join curriculos_gradedisciplina gd on gd.id = eq.grade_disciplina_id
		   join curriculos_grade grade on grade.id = gd.grade_id
		   join curriculos_curriculo cur on cur.id = grade.curriculo_id
		   join curriculos_curriculo cur_o on cur_o.id = @curriculo_id
		   join curriculos_grade grade_o on grade_o.curriculo_id = cur_o.id and grade_o.etapa_id = grade.etapa_id
		   join curriculos_gradedisciplina gd_o on gd_o.grade_id = grade_o.id and gd.disciplina_id = gd_o.disciplina_id
	 where cur.id = @id_curriculo_origem

	commit

end
GO
