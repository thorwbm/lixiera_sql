/*******************************************************************************
   TABELAS IMPORTADAS DE EXCEL 
		TMP_BLK_1 .... TMP_BLK_N
		TMP_AGD_1 .... TMP_AGD_N
		TMP_AGD_ULTIMA_SEMANA

	SAIDAS TMP_IMP_ESCOLA_BLOQUEADA, TMP_IMP_ESCOLA_AGENDAMENTO,
	       TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA
********************************************************************************/


/*******************************************************************************
                    CARGA TABELA ESCOLAS BLOQUEADAS
********************************************************************************/
--    SELECT *  FROM SYS.TABLES WHERE NAME LIKE '%TMP_BLK_%'
 
 SELECT DISTINCT ESCOLA_NOME = REPLICATE('X',250), SERIE =  REPLICATE('X',50), PROCESSO =  REPLICATE('X',150) INTO TMP_IMP_ESCOLA_BLOQUEADA
 DELETE FROM TMP_IMP_ESCOLA_BLOQUEADA

 INSERT INTO TMP_IMP_ESCOLA_BLOQUEADA
 SELECT DISTINCT ESCOLA_NOME , SERIE , PROCESSO = '3 SIMULADO'
 FROM (
 SELECT * FROM TMP_BLK_1 UNION 
 SELECT * FROM TMP_BLK_2 UNION 
 SELECT * FROM TMP_BLK_3 UNION 
 SELECT * FROM TMP_BLK_4 UNION 
 SELECT * FROM TMP_BLK_5 UNION 
 SELECT * FROM TMP_BLK_6 UNION 
 SELECT * FROM TMP_BLK_7 ) AS TAB


/*******************************************************************************
                    CARGA AGENDAMENTO 
********************************************************************************/
--    SELECT *  FROM SYS.TABLES WHERE NAME LIKE '%_AGD%'

--   drop table TMP_IMP_ESCOLA_AGENDAMENTO
select * INTO TMP_IMP_ESCOLA_AGENDAMENTO from (
 SELECT ESCOLA_NOME = REPLICATE('X',250), SERIE = REPLICATE('X',50), INGLES  = REPLICATE('X',50), 
        ESPANHOL  = REPLICATE('X',50), ARTES  = REPLICATE('X',50), FILOSOFIA  = REPLICATE('X',50),
		SOCIOLOGIA  = REPLICATE('X',50), DATA_APLICACAO = getdate(), PROCESSO  = REPLICATE('X',150)  union 
 SELECT ESCOLA_NOME = REPLICATE('X',250), SERIE = REPLICATE('X',50), INGLES  = REPLICATE('X',50), 
        ESPANHOL  = REPLICATE('X',50), ARTES  = REPLICATE('X',50), FILOSOFIA  = REPLICATE('X',50),
		SOCIOLOGIA  = REPLICATE('X',50), DATA_APLICACAO = null, PROCESSO  = REPLICATE('X',150) ) as tab 
 DELETE FROM TMP_IMP_ESCOLA_AGENDAMENTO

 --drop table #tmp_agendamento
select distinct ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA,
DATA_APLICACAO 
into #tmp_agendamento
from (
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_1 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_2 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_3 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_4 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_5 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_6 union 
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, DATA_APLICACAO from TMP_AGD_7) as tab 
where escola_nome is not null 

insert into TMP_IMP_ESCOLA_AGENDAMENTO 
select tmp.ESCOLA_NOME, tmp.SERIE, tmp.INGLES, tmp.ESPANHOL, tmp.ARTES, tmp.FILOSOFIA, tmp.SOCIOLOGIA,
DATA_APLICACAO = cast (right(tmp.data_aplicacao,4) + '-'+ SUBSTRING(tmp.data_aplicacao, 4,2) + '-'+  left(tmp.data_aplicacao,2) as date),
PROCESSO = '3 SIMULADO'
from #tmp_agendamento tmp left join TMP_IMP_ESCOLA_AGENDAMENTO xxx on (xxx.ESCOLA_NOME = tmp.escola_nome and 
                                                                       xxx.serie       = tmp.serie)
where xxx.escola_nome is null and  len(tmp.data_aplicacao) =  10 


insert into TMP_IMP_ESCOLA_AGENDAMENTO
select ESCOLA_NOME, SERIE, INGLES, ESPANHOL, ARTES, FILOSOFIA, SOCIOLOGIA, 
       DATA_APLICACAO = case when DATA_APLICACAO = 44113 then  cast ('2020-10-09' as date)  
	                         when DATA_APLICACAO = 44117 then  cast ('2020-10-13' as date)  
	                         when DATA_APLICACAO = 44088 then  cast ('2020-09-14' as date)  
	                         when DATA_APLICACAO = 44099 then  cast ('2020-09-25' as date)  end,
PROCESSO = '3 SIMULADO'
from #tmp_agendamento tmp
where len(tmp.data_aplicacao) <> 10


/*******************************************************************************
                    CARGA AGENDAMENTO ULTIMA SEMANA
********************************************************************************/

SELECT * FROM TMP_AGD_ULTIMA_SEMANA
WHERE --TURMANOME LIKE '%,%' AND 
      TURMANOME = '3ª série / Extensivo ,Extensivo'

insert into TMP_AGD_ULTIMA_SEMANA
select 'Escola Teste Geral','6º ano' union 
select 'Escola Teste Geral','9º ano' union 
select 'COLÉGIO FUTURO - Búzios','1ª série' union 
select 'COLÉGIO FUTURO - Búzios','3ª série' union 
select 'COLÉGIO FUTURO - Búzios','Extensivo' union 
select 'PROLUB','3ª série' union 
select 'PROLUB','Extensivo' union 
select 'PROLUB','Extensivo Mega' 

insert into TMP_AGD_ULTIMA_SEMANA (TurmaNome, EscolaNome)
select turmanome = '3ª série', escola = 'C.E. MONTEIRO LOBATO' union 
select turmanome = '3ª série', escola = 'Colégio Status Junior' union 
select turmanome = '3ª série', escola = 'INSTITUTO EDUCACIONAL FILOMENA DE MARCO' union 
select turmanome = '3ª série', escola = 'CURSINHO INTENSIVO' union 
select turmanome = '3ª série', escola = 'COLÉGIO GM3' union 
select turmanome = '3ª série', escola = 'GABARITO - UNIDADE RIBEIRÃO PRETO' union 
select turmanome = '3ª série', escola = 'COLÉGIO MADRE TERESA' union 
select turmanome = '3ª série', escola = 'GABARITO - UNIDADE RONDON' union 
select turmanome = '3ª série', escola = 'CENTRO DE APOIO EDUCACIONAL CEDAE LTDA' union 
select turmanome = '3ª série', escola = 'GABARITO - UNIDADE UBERABA' union 
select turmanome = '3ª série', escola = 'ESCOLA MUNDO ENEM' union 
select turmanome = '3ª série', escola = 'IDEALFI' union 
select turmanome = '3ª série', escola = 'GABARITO - UNIDADE ARAXÁ' union 
select turmanome = '3ª série', escola = 'APOGEU ASSESSORIA EDUCACIONAL E CURSOS LIVRES LTDA ME' union 
select turmanome = '3ª série', escola = 'UNIVERSITÁRIO - UNIDADE TATUAPÉ' union 
select turmanome = '3ª série', escola = 'COLÉGIO APOIO' union 
select turmanome = '3ª série', escola = 'CELLULA MATER' union 
select turmanome = '3ª série', escola = 'EQUILIBRIUM VESTILULARES' union 
select turmanome = '3ª série', escola = 'FEDERAL SISTEMA DE ENSINO' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - TEÓFILO (CENTRO)' union 
select turmanome = '3ª série', escola = 'Colégio 1 timóteo' union 
select turmanome = '3ª série', escola = 'Sophos Belém - Alcindo Cacela' union 
select turmanome = '3ª série', escola = 'COLÉGIO ATOPP BRASIL' union 
select turmanome = '3ª série', escola = 'COLEGIO DIOCESANO DE PENEDO' union 
select turmanome = '3ª série', escola = 'COLÉGIO CINCO DE JULHO' union 
select turmanome = '3ª série', escola = 'COLÉGIO MORIÁ' union 
select turmanome = '3ª série', escola = 'CENTRO EDUCACIONAL E CULTURAL CHRISTUS' union 
select turmanome = '3ª série', escola = 'Colégio Decisão' union 
select turmanome = '3ª série', escola = 'QUÍMICA INTEGRADA ' union 
select turmanome = '3ª série', escola = 'COLEGIO FLAMBOYANTS' union 
select turmanome = '3ª série', escola = 'COLÉGIO UNINOVE' union 
select turmanome = '3ª série', escola = 'Radio Crista Educativa' union 
select turmanome = '3ª série', escola = 'COLEGIO UNI-ALPHA' union 
select turmanome = '3ª série', escola = 'ESCOLA MADRE VALDELICIA' union 
select turmanome = '3ª série', escola = 'COLEGIO EMPYRIUS' union 
select turmanome = '3ª série', escola = 'Sophos Belém - Augusto Montenegro' union 
select turmanome = '3ª série', escola = 'COLÉGIO EÇA DE QUEIROZ' union 
select turmanome = '3ª série', escola = 'COLEGIO INTENSIVO' union 
select turmanome = '3ª série', escola = 'COLÉGIO MÚLTIPLO ENSINO' union 
select turmanome = '3ª série', escola = 'Universitário Sistema Educacional' union 
select turmanome = '3ª série', escola = 'ESCOLA DINÂMICA' union 
select turmanome = '3ª série', escola = 'LIMONTI FONSECA EDUCAÇÃO' union 
select turmanome = '3ª série', escola = 'UCB' union 
select turmanome = '3ª série', escola = 'Escola Santo Anjo' union 
select turmanome = '3ª série', escola = 'COLÉGIO CEA' union 
select turmanome = '3ª série', escola = 'Colégio Santana' union 
select turmanome = '3ª série', escola = 'COLÉGIO ELITE' union 
select turmanome = '3ª série', escola = 'ESCOLA COPERIL' union 
select turmanome = '3ª série', escola = 'COLÉGIO SÃO JUDAS TADEU (PICOS)' union 
select turmanome = '3ª série', escola = 'Colégio São Paulo' union 
select turmanome = '3ª série', escola = 'Colégio Agnus - Rosa Olinto' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - TEÓFILO (Dr. Laerte Lander)' union 
select turmanome = '3ª série', escola = 'CENTRO EDUCACIONAL LUZ DO SABER' union 
select turmanome = '3ª série', escola = 'Colégio Santa Terezinha' union 
select turmanome = '3ª série', escola = 'CPG CENTRO EDUCACIONAL' union 
select turmanome = '3ª série', escola = 'COLÉGIO ALFA SAYKOO' union 
select turmanome = '3ª série', escola = 'Colégio Maxx - Foccus 80' union 
select turmanome = '3ª série', escola = 'COLÉGIO MONSENHOR JOVINIANO BARRETO' union 
select turmanome = '3ª série', escola = 'FUNDACAO BAHIANA DE ENGENHARIA' union 
select turmanome = '3ª série', escola = 'COLÉGIO ALFA' union 
select turmanome = '3ª série', escola = 'Facto Colégio e Curso' union 
select turmanome = '3ª série', escola = 'COLÉGIO FUTURO - Búzios' union 
select turmanome = '3ª série', escola = 'COLEGIO.SUPREMUS ITANHAEM' union 
select turmanome = '3ª série', escola = 'VOLTAIRE COLEGIO E VESTIBULARES' union 
select turmanome = '3ª série', escola = 'ESCOLA LIBANESA BRASILEIRA' union 
select turmanome = '3ª série', escola = 'COLEGIO SANTO AGOSTINHO' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - IPATINGA' union 
select turmanome = '3ª série', escola = 'EXATO COLEGIO E CURSO' union 
select turmanome = '3ª série', escola = 'APROV' union 
select turmanome = '3ª série', escola = 'Colégio Heitor Villa Lobos' union 
select turmanome = '3ª série', escola = 'COLÉGIO MAXX RECREIO' union 
select turmanome = '3ª série', escola = 'CURSO FORTUNATO DOS SANTOS' union 
select turmanome = '3ª série', escola = 'Colégio José Américo de Almeida' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - CARATINGA' union 
select turmanome = '3ª série', escola = 'COLEGIO ALTERNATIVO' union 
select turmanome = '3ª série', escola = 'COLEGIO ALFA LOGOS' union 
select turmanome = '3ª série', escola = 'COLÉGIO JOSÉ DE ALENCAR CE' union 
select turmanome = '3ª série', escola = 'Escola Demonstrativa' union 
select turmanome = '3ª série', escola = 'ESCOLA INSIDE' union 
select turmanome = '3ª série', escola = 'DEMONSTRATIVO' union 
select turmanome = '3ª série', escola = 'Victor Caglioni' union 
select turmanome = '3ª série', escola = 'Testagem Editorial 2020' union 
select turmanome = '3ª série', escola = 'Escola Antonio Viveiros' union 
select turmanome = '3ª série', escola = 'Escola Teste Carla' union 
select turmanome = '3ª série', escola = 'COLEGIO EQUIPE JUIZ DE FORA LTDA' union 
select turmanome = '3ª série', escola = 'COLEGIO CEBAM' union 
select turmanome = '3ª série', escola = 'CEMI - Centro Educacional de Ensino Fundamental e Médio' union 
select turmanome = '3ª série', escola = 'COLÉGIO AMPLAÇÃO' union 
select turmanome = '3ª série', escola = 'Escola Evolução' union 
select turmanome = '3ª série', escola = 'CENTRO EDUCACIONAL TOTH' union 
select turmanome = '3ª série', escola = 'Sophos Paragominas' union 
select turmanome = '3ª série', escola = 'GABARITO - UNIDADE ITUMBIARA' union 
select turmanome = '3ª série', escola = 'COLÉGIO VISÃO JUNIOR' union 
select turmanome = '3ª série', escola = 'COLÉGIO MAANAIM' union 
select turmanome = '3ª série', escola = 'SISTEMA UNICO CENTRO EDUCACIONAL LTDA - ME' union 
select turmanome = '3ª série', escola = 'ESCOLA SANTO TOMÁS DE AQUINO (AGNUS)' union 
select turmanome = '3ª série', escola = 'COLEGIO CERI' union 
select turmanome = '3ª série', escola = 'Sophos Parauapebas' union 
select turmanome = '3ª série', escola = 'COLEGIO UNIVERSITARIO DE ITAPETININGA' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - VALADARES' union 
select turmanome = '3ª série', escola = 'COLÉGIO ATITUDE' union 
select turmanome = '3ª série', escola = 'EINSTEIN SISTEMA DE ENSINO' union 
select turmanome = '3ª série', escola = 'JARDIM ESCOLA PETER PAN' union 
select turmanome = '3ª série', escola = 'COLEGIO MODELO' union 
select turmanome = '3ª série', escola = 'Creche Tia Lica e Escola São José' union 
select turmanome = '3ª série', escola = 'Sophos Tucuruí' union 
select turmanome = '3ª série', escola = 'CURSO RADICAL' union 
select turmanome = '3ª série', escola = 'CENTRO EDUCACIONAL ALCANCE EIRELI' union 
select turmanome = '3ª série', escola = 'CEPSMA - COLEGIO E CENTRO DE PESQUISA SOUZA MARTINS' union 
select turmanome = '3ª série', escola = 'CASA DO GAROTO' union 
select turmanome = '3ª série', escola = 'Colégio Pierre Freitas' union 
select turmanome = '3ª série', escola = 'Jardim Escola Santa Marta' union 
select turmanome = '3ª série', escola = 'COLÉGIO FUTURO - São Pedro da Aldeia' union 
select turmanome = '3ª série', escola = 'COLÉGIO HENRIQUE JORGE' union 
select turmanome = '3ª série', escola = 'COLEGIO S. JUDAS TADEU - SEDE CENTRO NORTE' union 
select turmanome = '3ª série', escola = 'COLÉGIO ATENEU SANTISTA' union 
select turmanome = '3ª série', escola = 'Escola Nossa Senhora dos Prazeres' union 
select turmanome = '3ª série', escola = 'EDUCANDARIO ARTE DO SABER' union 
select turmanome = '3ª série', escola = 'ESCOLA TECNICA ELETRO-MECANICA DA BAHIA' union 
select turmanome = '3ª série', escola = 'INSTITUTO DE ENS.ROSATI E CRUCIANI' union 
select turmanome = '3ª série', escola = 'ESCOLA SOUZA ALVES' union 
select turmanome = '3ª série', escola = 'COLÉGIO AVANCE' union 
select turmanome = '3ª série', escola = 'Colégio João Paulo I' union 
select turmanome = '3ª série', escola = 'ESCOLA PROMOVE (B. J. LAPA)' union 
select turmanome = '3ª série', escola = 'BATISTA AGAPE' union 
select turmanome = '3ª série', escola = 'COLÉGIO GENOMA - TEIXEIRA' union 
select turmanome = '3ª série', escola = 'COLÉGIO POSITIVO CONSTRUTIVO E CRIATIVO' union 
select turmanome = '3ª série', escola = 'COOPERATIVA EDUCACIONAL DE FOZ DO IGUACU' union 
select turmanome = '3ª série', escola = 'Hermann' union 
select turmanome = '3ª série', escola = 'COLÉGIO JOSÉ DE ALENCAR RJ' union 
select turmanome = '3ª série', escola = 'COLÉGIO PRINCIPIO DAS ARTES' union 
select turmanome = '3ª série', escola = 'COLEGIO ARCO IRIS' union 
select turmanome = '3ª série', escola = 'UNIDADE CRIATIVA DE ENSINO' union 
select turmanome = '3ª série', escola = 'ESCOLA MAGIA DO SABER' union 
select turmanome = '3ª série', escola = 'COLÉGIO FLUMINENSE CENTRAL (MERITI)' union 
select turmanome = '3ª série', escola = 'COLÉGIO NOSSA SENHORA DA ROSA MISTICA' union 
select turmanome = '3ª série', escola = 'EDUCANDÁRIO NOVA GRÉCIA' union 
select turmanome = '3ª série', escola = 'Colégio São Jorge' union 
select turmanome = '3ª série', escola = 'COLEGIO VIVO MORUMBI' union 
select turmanome = '3ª série', escola = 'COOPERATIVA DE ENSINO E INTEGRACAO' union 
select turmanome = '3ª série', escola = 'COLÉGIO FUTURO PARQUE BURLE' union 
select turmanome = '3ª série', escola = 'CENTRO EDUCACIONAL PARAÍSO' union 
select turmanome = '3ª série', escola = 'ESCOLA ALTO PADRÃO' union 
select turmanome = '3ª série', escola = 'Escola Fábio 2020' union 
select turmanome = '3ª série', escola = 'Escola Rita' union 
select turmanome = '3ª série', escola = 'COLÉGIO SÃO JUDAS TADEU (ALAGOAS)' union 
select turmanome = '3ª série', escola = 'COLÉGIO VIVO SANTA TEREZINHA' union 
select turmanome = '3ª série', escola = 'Escola Teste Geral' union 
select turmanome = '3ª série', escola = 'ESCOLA COOPESAL' union 
select turmanome = '3ª série', escola = 'Escola Paulo Fiatte' union 
select turmanome = '3ª série', escola = 'ESCOLA SAE' union 
select turmanome = '3ª série', escola = 'COLEGIO E CURSO CORACAO DE MARIA' union 


select turmanome = 'Extensivo', escola = 'C.E. MONTEIRO LOBATO' union 
select turmanome = 'Extensivo', escola = 'Colégio Status Junior' union 
select turmanome = 'Extensivo', escola = 'INSTITUTO EDUCACIONAL FILOMENA DE MARCO' union 
select turmanome = 'Extensivo', escola = 'CURSINHO INTENSIVO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GM3' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE RIBEIRÃO PRETO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MADRE TERESA' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE RONDON' union 
select turmanome = 'Extensivo', escola = 'CENTRO DE APOIO EDUCACIONAL CEDAE LTDA' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE UBERABA' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MUNDO ENEM' union 
select turmanome = 'Extensivo', escola = 'IDEALFI' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE ARAXÁ' union 
select turmanome = 'Extensivo', escola = 'APOGEU ASSESSORIA EDUCACIONAL E CURSOS LIVRES LTDA ME' union 
select turmanome = 'Extensivo', escola = 'UNIVERSITÁRIO - UNIDADE TATUAPÉ' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO APOIO' union 
select turmanome = 'Extensivo', escola = 'CELLULA MATER' union 
select turmanome = 'Extensivo', escola = 'EQUILIBRIUM VESTILULARES' union 
select turmanome = 'Extensivo', escola = 'FEDERAL SISTEMA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - TEÓFILO (CENTRO)' union 
select turmanome = 'Extensivo', escola = 'Colégio 1 timóteo' union 
select turmanome = 'Extensivo', escola = 'Sophos Belém - Alcindo Cacela' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ATOPP BRASIL' union 
select turmanome = 'Extensivo', escola = 'COLEGIO DIOCESANO DE PENEDO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO CINCO DE JULHO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MORIÁ' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL E CULTURAL CHRISTUS' union 
select turmanome = 'Extensivo', escola = 'Colégio Decisão' union 
select turmanome = 'Extensivo', escola = 'QUÍMICA INTEGRADA ' union 
select turmanome = 'Extensivo', escola = 'COLEGIO FLAMBOYANTS' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO UNINOVE' union 
select turmanome = 'Extensivo', escola = 'Radio Crista Educativa' union 
select turmanome = 'Extensivo', escola = 'COLEGIO UNI-ALPHA' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MADRE VALDELICIA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO EMPYRIUS' union 
select turmanome = 'Extensivo', escola = 'Sophos Belém - Augusto Montenegro' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO EÇA DE QUEIROZ' union 
select turmanome = 'Extensivo', escola = 'COLEGIO INTENSIVO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MÚLTIPLO ENSINO' union 
select turmanome = 'Extensivo', escola = 'Universitário Sistema Educacional' union 
select turmanome = 'Extensivo', escola = 'ESCOLA DINÂMICA' union 
select turmanome = 'Extensivo', escola = 'LIMONTI FONSECA EDUCAÇÃO' union 
select turmanome = 'Extensivo', escola = 'UCB' union 
select turmanome = 'Extensivo', escola = 'Escola Santo Anjo' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO CEA' union 
select turmanome = 'Extensivo', escola = 'Colégio Santana' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ELITE' union 
select turmanome = 'Extensivo', escola = 'ESCOLA COPERIL' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO SÃO JUDAS TADEU (PICOS)' union 
select turmanome = 'Extensivo', escola = 'Colégio São Paulo' union 
select turmanome = 'Extensivo', escola = 'Colégio Agnus - Rosa Olinto' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - TEÓFILO (Dr. Laerte Lander)' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL LUZ DO SABER' union 
select turmanome = 'Extensivo', escola = 'Colégio Santa Terezinha' union 
select turmanome = 'Extensivo', escola = 'CPG CENTRO EDUCACIONAL' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ALFA SAYKOO' union 
select turmanome = 'Extensivo', escola = 'Colégio Maxx - Foccus 80' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MONSENHOR JOVINIANO BARRETO' union 
select turmanome = 'Extensivo', escola = 'FUNDACAO BAHIANA DE ENGENHARIA' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ALFA' union 
select turmanome = 'Extensivo', escola = 'Facto Colégio e Curso' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO FUTURO - Búzios' union 
select turmanome = 'Extensivo', escola = 'COLEGIO.SUPREMUS ITANHAEM' union 
select turmanome = 'Extensivo', escola = 'VOLTAIRE COLEGIO E VESTIBULARES' union 
select turmanome = 'Extensivo', escola = 'ESCOLA LIBANESA BRASILEIRA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO SANTO AGOSTINHO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - IPATINGA' union 
select turmanome = 'Extensivo', escola = 'EXATO COLEGIO E CURSO' union 
select turmanome = 'Extensivo', escola = 'APROV' union 
select turmanome = 'Extensivo', escola = 'Colégio Heitor Villa Lobos' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MAXX RECREIO' union 
select turmanome = 'Extensivo', escola = 'CURSO FORTUNATO DOS SANTOS' union 
select turmanome = 'Extensivo', escola = 'Colégio José Américo de Almeida' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - CARATINGA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ALTERNATIVO' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ALFA LOGOS' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO JOSÉ DE ALENCAR CE' union 
select turmanome = 'Extensivo', escola = 'Escola Demonstrativa' union 
select turmanome = 'Extensivo', escola = 'ESCOLA INSIDE' union 
select turmanome = 'Extensivo', escola = 'DEMONSTRATIVO' union 
select turmanome = 'Extensivo', escola = 'Victor Caglioni' union 
select turmanome = 'Extensivo', escola = 'Testagem Editorial 2020' union 
select turmanome = 'Extensivo', escola = 'Escola Antonio Viveiros' union 
select turmanome = 'Extensivo', escola = 'Escola Teste Carla' union 
select turmanome = 'Extensivo', escola = 'COLEGIO EQUIPE JUIZ DE FORA LTDA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO CEBAM' union 
select turmanome = 'Extensivo', escola = 'CEMI - Centro Educacional de Ensino Fundamental e Médio' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO AMPLAÇÃO' union 
select turmanome = 'Extensivo', escola = 'Escola Evolução' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL TOTH' union 
select turmanome = 'Extensivo', escola = 'Sophos Paragominas' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE ITUMBIARA' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO VISÃO JUNIOR' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO MAANAIM' union 
select turmanome = 'Extensivo', escola = 'SISTEMA UNICO CENTRO EDUCACIONAL LTDA - ME' union 
select turmanome = 'Extensivo', escola = 'ESCOLA SANTO TOMÁS DE AQUINO (AGNUS)' union 
select turmanome = 'Extensivo', escola = 'COLEGIO CERI' union 
select turmanome = 'Extensivo', escola = 'Sophos Parauapebas' union 
select turmanome = 'Extensivo', escola = 'COLEGIO UNIVERSITARIO DE ITAPETININGA' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - VALADARES' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ATITUDE' union 
select turmanome = 'Extensivo', escola = 'EINSTEIN SISTEMA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'JARDIM ESCOLA PETER PAN' union 
select turmanome = 'Extensivo', escola = 'COLEGIO MODELO' union 
select turmanome = 'Extensivo', escola = 'Creche Tia Lica e Escola São José' union 
select turmanome = 'Extensivo', escola = 'Sophos Tucuruí' union 
select turmanome = 'Extensivo', escola = 'CURSO RADICAL' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL ALCANCE EIRELI' union 
select turmanome = 'Extensivo', escola = 'CEPSMA - COLEGIO E CENTRO DE PESQUISA SOUZA MARTINS' union 
select turmanome = 'Extensivo', escola = 'CASA DO GAROTO' union 
select turmanome = 'Extensivo', escola = 'Colégio Pierre Freitas' union 
select turmanome = 'Extensivo', escola = 'Jardim Escola Santa Marta' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO FUTURO - São Pedro da Aldeia' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO HENRIQUE JORGE' union 
select turmanome = 'Extensivo', escola = 'COLEGIO S. JUDAS TADEU - SEDE CENTRO NORTE' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO ATENEU SANTISTA' union 
select turmanome = 'Extensivo', escola = 'Escola Nossa Senhora dos Prazeres' union 
select turmanome = 'Extensivo', escola = 'EDUCANDARIO ARTE DO SABER' union 
select turmanome = 'Extensivo', escola = 'ESCOLA TECNICA ELETRO-MECANICA DA BAHIA' union 
select turmanome = 'Extensivo', escola = 'INSTITUTO DE ENS.ROSATI E CRUCIANI' union 
select turmanome = 'Extensivo', escola = 'ESCOLA SOUZA ALVES' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO AVANCE' union 
select turmanome = 'Extensivo', escola = 'Colégio João Paulo I' union 
select turmanome = 'Extensivo', escola = 'ESCOLA PROMOVE (B. J. LAPA)' union 
select turmanome = 'Extensivo', escola = 'BATISTA AGAPE' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO GENOMA - TEIXEIRA' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO POSITIVO CONSTRUTIVO E CRIATIVO' union 
select turmanome = 'Extensivo', escola = 'COOPERATIVA EDUCACIONAL DE FOZ DO IGUACU' union 
select turmanome = 'Extensivo', escola = 'Hermann' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO JOSÉ DE ALENCAR RJ' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO PRINCIPIO DAS ARTES' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ARCO IRIS' union 
select turmanome = 'Extensivo', escola = 'UNIDADE CRIATIVA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MAGIA DO SABER' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO FLUMINENSE CENTRAL (MERITI)' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO NOSSA SENHORA DA ROSA MISTICA' union 
select turmanome = 'Extensivo', escola = 'EDUCANDÁRIO NOVA GRÉCIA' union 
select turmanome = 'Extensivo', escola = 'Colégio São Jorge' union 
select turmanome = 'Extensivo', escola = 'COLEGIO VIVO MORUMBI' union 
select turmanome = 'Extensivo', escola = 'COOPERATIVA DE ENSINO E INTEGRACAO' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO FUTURO PARQUE BURLE' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL PARAÍSO' union 
select turmanome = 'Extensivo', escola = 'ESCOLA ALTO PADRÃO' union 
select turmanome = 'Extensivo', escola = 'Escola Fábio 2020' union 
select turmanome = 'Extensivo', escola = 'Escola Rita' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO SÃO JUDAS TADEU (ALAGOAS)' union 
select turmanome = 'Extensivo', escola = 'COLÉGIO VIVO SANTA TEREZINHA' union 
select turmanome = 'Extensivo', escola = 'Escola Teste Geral' union 
select turmanome = 'Extensivo', escola = 'ESCOLA COOPESAL' union 
select turmanome = 'Extensivo', escola = 'Escola Paulo Fiatte' union 
select turmanome = 'Extensivo', escola = 'ESCOLA SAE' union 
select turmanome = 'Extensivo', escola = 'COLEGIO E CURSO CORACAO DE MARIA'  

DROP TABLE TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA
SELECT distinct  ltrim(rtrim(escolanome)) as ESCOLA_NOME, LTRIM(RTRIM(TURMANOME)) AS TURMA_NOME,
       PROCESSO = '3 SIMULADO'
INTO TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA
FROM TMP_AGD_ULTIMA_SEMANA
WHERE TURMANOME not LIKE '%,%' AND 
      TURMANOME <> '3ª série / Extensivo ,Extensivo' AND 
	  TURMANOME NOT IN ('4º ano','5º ano')
	  ORDER BY 1, 2

select * 
--   UPDATE AUS SET AUS.ESCOLA_NOME = 'Colégio Sant''ana'
FROM TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA AUS WHERE ESCOLA_NOME LIKE 'Colégio San%na'