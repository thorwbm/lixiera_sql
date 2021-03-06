/****** Object:  Table [dbo].[core_feature]    Script Date: 10/27/2020 10:46:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_feature](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](255) NULL,
	[ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, FILLFACTOR = 50) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[core_feature] ON 

INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (1, N'ocorrencia', N'libera funcionalidade de ocorrências', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (2, N'login_duas_etapas', N'Autenticação após verificação de duas etapas', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (3, N'login_local', N'Utilizar serviço de autenticação local', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (4, N'login_externo', N'Utilizar serviço de autenticação externo', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (5, N'exibe_gabarito', N'Exibe o gabarito da prova após o envio da resposta', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (6, N'limitar_tempo_avaliador', N'Limitar o tempo que o avaliador pode acessar o sistema depois de iniciar uma prova', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (7, N'iniciar_no_primeiro_buscar_mais_um', N'Exibe botão iniciar para a primeira correção do usuário', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (8, N'mostrar_nota_correcao_resultado', N'Exibir a nota da correções e avaliador no relatório de resultado', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (9, N'chat', N'Exibir chat na tela.', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (10, N'competencia_5_depende_tipo_prova', N'Competência 5 depende do tipo de prova', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (11, N'dashboard_exibir_grafico_minhas_correcoes', N'Exibe Dashboard dos avaliadores', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (12, N'show_historico_correcoes', N'Exbir o histórico de correções', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (13, N'insere_na_fila_3_automatico', N'Indica se a rotina de análise insere na fila 3 quando ocorrer discrepância entre correções 1 e 2', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (14, N'insere_na_fila_4_automatico', N'Indica se a rotina de análise insere na fila 4 quando ocorrer discrepância entre correções 3 com 1 e 2', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (15, N'salvar_pendente_analise', N'Salvar na tabela pendente análise.', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (16, N'modal_supervisor_4_correcao', N'Modal de 4 correção.', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (17, N'salvar_log_login', N'Salvar os logs do login.', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (18, N'exibe_ferramenta_ortografia', N'Exibe na correção a ferramenta de indicação de erros de ortografia', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (19, N'acessar_como_alguem', N'Acessar Como Alguém', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (20, N'salvar_como_alguem', N'Salvar como alguém', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (21, N'dashboard_exibir_contador_correcoes', N'Exibe o contador de correções no dashboard', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (22, N'ver_acompanhamento_correcoes', N'Ver o acompanhamento das correções no dashboard', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (23, N'resumo_correcoes', N'Ver o resumo das correções com base no gabarito', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (24, N'exibir_tempo_sessao', N'Exibir o tempo restante de sessão', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (25, N'exibir_modal_sessao', N'Exibir modal do tempo restante de sessão', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (26, N'controlar_tempo_sessao', N'Controlar o tempo de sessão do usuário', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (27, N'relatorios', N'Exibir relatorios da correção', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (28, N'mostrar_dsp', N'Mostrar informações de dsp', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (29, N'alterar_contador_corretores', N'Exibir formulário para alterar o tempo restante do contador dos corretores', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (30, N'mostrar_historico_suspensao', N'Mostrar informações de histórico suspensão', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (31, N'mostrar_polo', N'Mostrar informações de polo', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (32, N'mostrar_time', N'Mostrar informações de time', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (33, N'mostrar_correcoes_habilitadas', N'Mostrar informações de correções habilitadas', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (34, N'mostrar_cota', N'Mostrar informações de cota', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (35, N'mostrar_status', N'Mostrar informações de status', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (36, N'mostrar_alertas', N'Mostrar informações de alertas', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (37, N'mostrar_aproveitamento', N'Mostrar informações de aproveitamento', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (38, N'mostrar_pre_teste', N'Mostrar informações de pré teste', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (173, N'ver_avaliacao_desempenho', N'Mostrar avaliação de desempenho', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (221, N'link_para_resumo_na_lista_avaliadores', N'Mostrar um link para o resumo de correções do usuário na lista de avaliadores', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (222, N'mostrar_etapa_de_ensino', N'Mostrar etapa de ensino', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (223, N'mostrar_quarta_correcao', N'Mostrar quarta correção', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (224, N'mostrar_correcao_ouro', N'Mostrar correção ouro', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (225, N'mostrar_correcao_moda', N'Mostrar correção moda', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (226, N'mostrar_correcao_auditoria', N'Mostrar correção auditoria', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (227, N'ver_menu_avaliadores', N'mostrar menu de ver avaliadores', 1)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (228, N'ver_menu_supervisores', N'Mostrar menu de supervisores', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (229, N'banco_redacoes', N'Mostrar banco de redações', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (230, N'configurar_alertas', N'Mostrar configuração de alertas', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (231, N'triagem_fea', N'Mostrar triagem FEA', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (232, N'atualizar_corretores_em_lote', N'Mostrar a opção de atualizar avaliadores em lote', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (233, N'auditoria', N'Indica se serão geradas auditorias para as redações', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (234, N'habilitar_terceira_para_avaliadores', N'Possibilita a opção de habilitar terceira para avaliadores', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (235, N'ver_relatorio_acompanhamento_geral', N'Mostrar relatório acompanhamento geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (236, N'ver_andamento_da_correcao', N'Mostrar andamento da correção no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (237, N'ver_relatorio_geral', N'Mostrar relatório geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (238, N'ver_relatorio_geral_polo', N'Mostrar relatório geral polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (239, N'ver_relatorio_geral_time', N'Mostrar relatório geral time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (240, N'ver_relatorio_distribuicao_notas_competencia_geral', N'Mostrar relatório distribuição notas competência geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (241, N'ver_relatorio_distribuicao_notas_competencia_polo', N'Mostrar relatório distribuição notas competência polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (242, N'ver_relatorio_distribuicao_notas_competencia_time', N'Mostrar relatório distribuição notas competência time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (243, N'ver_relatorio_distribuicao_notas_situacao_geral', N'Mostrar relatório distribuição notas situação geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (244, N'ver_relatorio_distribuicao_notas_situacao_polo', N'Mostrar relatório distribuição notas situação polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (245, N'ver_relatorio_distribuicao_notas_situacao_time', N'Mostrar relatório distribuição notas situação time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (246, N'ver_relatorio_aproveitamento_geral', N'Mostrar relatório aproveitamento geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (247, N'ver_relatorio_aproveitamento_polo', N'Mostrar relatório aproveitamento polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (248, N'ver_relatorio_aproveitamento_time', N'Mostrar relatório aproveitamento time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (249, N'ver_relatorio_aproveitamento_avaliador', N'Mostrar relatório aproveitamento avaliador no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (250, N'ver_relatorio_padrao_ouro_geral', N'Mostrar relatório padrão ouro geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (251, N'ver_relatorio_padrao_ouro_polo', N'Mostrar relatório padrão ouro polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (252, N'ver_relatorio_padrao_ouro_time', N'Mostrar relatório padrão ouro time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (253, N'ver_relatorio_padrao_ouro_avaliador', N'Mostrar relatório padrão ouro avaliador no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (254, N'ver_relatorio_terceira_correcao_geral', N'Mostrar relatório terceira correção geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (255, N'ver_relatorio_terceira_correcao_polo', N'Mostrar relatório terceira correção polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (256, N'ver_relatorio_terceira_correcao_time', N'Mostrar relatório terceira correção time no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (257, N'ver_relatorio_terceira_correcao_avaliador', N'Mostrar relatório terceira correção avaliador no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (258, N'ver_relatorio_quarta_correcao_geral', N'Mostrar relatório quarta correção geral no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (259, N'ver_relatorio_quarta_correcao_polo', N'Mostrar relatório quarta correção polo no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (260, N'ver_relatorio_panorama_geral_ocorrencias', N'Mostrar relatório panorama geral ocorrências no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (261, N'ver_relatorio_acompanhamento_auditoria', N'Mostrar relatório acompanhamento auditoria no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (262, N'ver_relatorio_pre_teste_avaliadores', N'Mostrar relatório pré-teste avaliadores no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (263, N'ver_relatorio_extrato', N'Mostrar relatório extrato no menu', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (264, N'ocorrencia_pai_ser_a_propria_ocorrencia', N'Existe um trecho de código que atualiza a ocorrência colocando o pai dela como ela mesmo, esse trecho de código foi analisado e não parece estar sendo utilizado. Feature criada para testar a remoção desse código', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (265, N'importar_redacoes_desempenho', N'Importar redações de desempenho', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (266, N'enviar_corretor_recapacitacao', N'Habilitar botão de enviar corretor para a recapacitação', 0)
INSERT [dbo].[core_feature] ([id], [codigo], [descricao], [ativo]) VALUES (267, N'liberar_correcao_presa', N'Liberar correcoes presas', 0)
SET IDENTITY_INSERT [dbo].[core_feature] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__core_fea__40F9A2068E1ADF4C]    Script Date: 10/27/2020 10:46:38 AM ******/
ALTER TABLE [dbo].[core_feature] ADD UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, FILLFACTOR = 50) ON [PRIMARY]
GO
