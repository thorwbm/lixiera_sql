 select base = 'REDACOES_03122018_001',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_03122018_001 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_03122018_001 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_03122018_001 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_03122018_001 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_03122018_001 with (nolock)  where ID_SITUACAO_AVAa is not null)
 union 
 select base = 'REDACOES_03122018_001_ERRO_001',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_03122018_001_ERRO_001 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_03122018_001_ERRO_001 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_03122018_001_ERRO_001 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_03122018_001_ERRO_001 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_03122018_001_ERRO_001 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_03122018_002',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_03122018_002 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_03122018_002 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_03122018_002 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_03122018_002 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_03122018_002 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_03122018_003',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_03122018_003 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_03122018_003 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_03122018_003 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_03122018_003 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_03122018_003 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_03122018_004',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_03122018_004 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_03122018_004 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_03122018_004 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_03122018_004 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_03122018_004 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_04122018_001',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_04122018_001 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_04122018_001 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_04122018_001 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_04122018_001 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_04122018_001 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_04122018_002',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_04122018_002 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_04122018_002 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_04122018_002 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_04122018_002 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_04122018_002 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_04122018_003',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_04122018_003 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_04122018_003 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_04122018_003 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_04122018_003 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_04122018_003 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_04122018_004',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_04122018_004 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_04122018_004 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_04122018_004 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_04122018_004 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_04122018_004 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_05122018_001',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_05122018_001 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_05122018_001 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_05122018_001 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_05122018_001 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_05122018_001 with (nolock)  where ID_SITUACAO_AVAa is not null)
  union 
 select base = 'REDACOES_05122018_002',
 qtd_AVA1 =  (select count(co_barra_redacao) from REDACOES_05122018_002 with (nolock)  where ID_SITUACAO_AVA1 is not null), 
 qtd_AVA2 =  (select count(co_barra_redacao) from REDACOES_05122018_002 with (nolock)  where ID_SITUACAO_AVA2 is not null), 
 qtd_AVA3 =  (select count(co_barra_redacao) from REDACOES_05122018_002 with (nolock)  where ID_SITUACAO_AVA3 is not null), 
 qtd_AVA4 =  (select count(co_barra_redacao) from REDACOES_05122018_002 with (nolock)  where ID_SITUACAO_AVA4 is not null), 
 qtd_AVAa =  (select count(co_barra_redacao) from REDACOES_05122018_002 with (nolock)  where ID_SITUACAO_AVAa is not null)




