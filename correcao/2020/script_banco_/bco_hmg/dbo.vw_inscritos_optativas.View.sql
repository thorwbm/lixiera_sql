USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_inscritos_optativas]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_inscritos_optativas] as
select disciplina_id as disciplina, per.nome as periodicidade, data_inicio_inscricao, data_termino_inscricao, us.username as login_aluno, us.last_name as aluno, category.name as categoria
  from ofertas_disciplina_ofertadisciplina od
       inner join agendamento_periodicidade per on per.id = od.periocidade
       inner join salas_sala sala on sala.id = od.sala_id
       inner join salas_andar andar on andar.id = sala.andar_id
       inner join salas_predio predio on predio.id = andar.predio_id
       inner join ofertas_disciplina_inscricao inscricao on inscricao.oferta_disciplina_id = od.id
       inner join auth_user us on us.id = inscricao.requerido_por
	   inner join ofertas_disciplina_categoria category on category.id = od.category_id
GO
