---#####################################################################
CREATE TABLE [dbo].[egresso_correcao](
	[id] [int] NOT NULL,
	[nomepai] [nvarchar](255) NULL,
	[nomemae] [nvarchar](255) NULL,
	[endereco] [nvarchar](255) NULL,
	[bairro] [nvarchar](255) NULL,
	[cidade] [nvarchar](255) NULL,
	[complemento] [nvarchar](255) NULL,
	[aluno] [nvarchar](255) NULL,
	[corrigido_nomepai] [nvarchar](255) NULL,
	[corrigido_nomemae] [nvarchar](255) NULL,
	[corrigido_endereco] [nvarchar](255) NULL,
	[corrigido_bairro] [nvarchar](255) NULL,
	[corrigido_cidade] [nvarchar](255) NULL,
	[corrigido_complemento] [nvarchar](255) NULL,
	[corrigido_aluno] [nvarchar](255) NULL,
	[flag_nomepai] [int] NOT NULL,
	[flag_nomemae] [int] NOT NULL,
	[flag_endereco] [int] NOT NULL,
	[flag_bairro] [int] NOT NULL,
	[flag_cidade] [int] NOT NULL,
	[flag_complemento] [int] NOT NULL,
	[flag_aluno] [int] NOT NULL,
 CONSTRAINT [PK_egresso_correcao] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
--######################################################################

insert into egresso_correcao (id, nomepai, nomemae, endereco, bairro, cidade, complemento, aluno, corrigido_nomepai, corrigido_nomemae, 
corrigido_endereco, corrigido_bairro, corrigido_cidade, corrigido_complemento, corrigido_aluno, 
flag_nomepai, flag_nomemae, flag_endereco, flag_bairro, flag_cidade, flag_complemento, flag_aluno)
select egr.id, egr.nomepai, egr.nomemae, egr.endereco, egr.bairro, egr.cidade, egr.complemento, egr.aluno,
corrigido_nomepai      = egr.nomepai,   
corrigido_nomemae      = egr.nomemae,   
corrigido_endereco     = egr.endereco,  
corrigido_bairro       = egr.bairro, 
corrigido_cidade       = egr.cidade,
corrigido_complemento  = egr.complemento,
corrigido_aluno        = egr.aluno,
flag_nomepai     = 0,
flag_nomemae     = 0,
flag_endereco    = 0,
flag_bairro      = 0,
flag_cidade      = 0,
flag_complemento = 0,
flag_aluno       = 0
from egressos_univers egr left join egresso_correcao xxx on (xxx.id = egr.id)
where xxx.id is null 


