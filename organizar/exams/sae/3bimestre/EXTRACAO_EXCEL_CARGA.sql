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
      TURMANOME = '3� s�rie / Extensivo ,Extensivo'

insert into TMP_AGD_ULTIMA_SEMANA
select 'Escola Teste Geral','6� ano' union 
select 'Escola Teste Geral','9� ano' union 
select 'COL�GIO FUTURO - B�zios','1� s�rie' union 
select 'COL�GIO FUTURO - B�zios','3� s�rie' union 
select 'COL�GIO FUTURO - B�zios','Extensivo' union 
select 'PROLUB','3� s�rie' union 
select 'PROLUB','Extensivo' union 
select 'PROLUB','Extensivo Mega' 

insert into TMP_AGD_ULTIMA_SEMANA (TurmaNome, EscolaNome)
select turmanome = '3� s�rie', escola = 'C.E. MONTEIRO LOBATO' union 
select turmanome = '3� s�rie', escola = 'Col�gio Status Junior' union 
select turmanome = '3� s�rie', escola = 'INSTITUTO EDUCACIONAL FILOMENA DE MARCO' union 
select turmanome = '3� s�rie', escola = 'CURSINHO INTENSIVO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GM3' union 
select turmanome = '3� s�rie', escola = 'GABARITO - UNIDADE RIBEIR�O PRETO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO MADRE TERESA' union 
select turmanome = '3� s�rie', escola = 'GABARITO - UNIDADE RONDON' union 
select turmanome = '3� s�rie', escola = 'CENTRO DE APOIO EDUCACIONAL CEDAE LTDA' union 
select turmanome = '3� s�rie', escola = 'GABARITO - UNIDADE UBERABA' union 
select turmanome = '3� s�rie', escola = 'ESCOLA MUNDO ENEM' union 
select turmanome = '3� s�rie', escola = 'IDEALFI' union 
select turmanome = '3� s�rie', escola = 'GABARITO - UNIDADE ARAX�' union 
select turmanome = '3� s�rie', escola = 'APOGEU ASSESSORIA EDUCACIONAL E CURSOS LIVRES LTDA ME' union 
select turmanome = '3� s�rie', escola = 'UNIVERSIT�RIO - UNIDADE TATUAP�' union 
select turmanome = '3� s�rie', escola = 'COL�GIO APOIO' union 
select turmanome = '3� s�rie', escola = 'CELLULA MATER' union 
select turmanome = '3� s�rie', escola = 'EQUILIBRIUM VESTILULARES' union 
select turmanome = '3� s�rie', escola = 'FEDERAL SISTEMA DE ENSINO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - TE�FILO (CENTRO)' union 
select turmanome = '3� s�rie', escola = 'Col�gio 1 tim�teo' union 
select turmanome = '3� s�rie', escola = 'Sophos Bel�m - Alcindo Cacela' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ATOPP BRASIL' union 
select turmanome = '3� s�rie', escola = 'COLEGIO DIOCESANO DE PENEDO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO CINCO DE JULHO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO MORI�' union 
select turmanome = '3� s�rie', escola = 'CENTRO EDUCACIONAL E CULTURAL CHRISTUS' union 
select turmanome = '3� s�rie', escola = 'Col�gio Decis�o' union 
select turmanome = '3� s�rie', escola = 'QU�MICA INTEGRADA�' union 
select turmanome = '3� s�rie', escola = 'COLEGIO FLAMBOYANTS' union 
select turmanome = '3� s�rie', escola = 'COL�GIO UNINOVE' union 
select turmanome = '3� s�rie', escola = 'Radio Crista Educativa' union 
select turmanome = '3� s�rie', escola = 'COLEGIO UNI-ALPHA' union 
select turmanome = '3� s�rie', escola = 'ESCOLA MADRE VALDELICIA' union 
select turmanome = '3� s�rie', escola = 'COLEGIO EMPYRIUS' union 
select turmanome = '3� s�rie', escola = 'Sophos Bel�m - Augusto Montenegro' union 
select turmanome = '3� s�rie', escola = 'COL�GIO E�A DE QUEIROZ' union 
select turmanome = '3� s�rie', escola = 'COLEGIO INTENSIVO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO M�LTIPLO ENSINO' union 
select turmanome = '3� s�rie', escola = 'Universit�rio Sistema Educacional' union 
select turmanome = '3� s�rie', escola = 'ESCOLA DIN�MICA' union 
select turmanome = '3� s�rie', escola = 'LIMONTI FONSECA EDUCA��O' union 
select turmanome = '3� s�rie', escola = 'UCB' union 
select turmanome = '3� s�rie', escola = 'Escola Santo Anjo' union 
select turmanome = '3� s�rie', escola = 'COL�GIO CEA' union 
select turmanome = '3� s�rie', escola = 'Col�gio Santana' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ELITE' union 
select turmanome = '3� s�rie', escola = 'ESCOLA COPERIL' union 
select turmanome = '3� s�rie', escola = 'COL�GIO S�O JUDAS TADEU (PICOS)' union 
select turmanome = '3� s�rie', escola = 'Col�gio S�o Paulo' union 
select turmanome = '3� s�rie', escola = 'Col�gio Agnus - Rosa Olinto' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - TE�FILO (Dr. Laerte Lander)' union 
select turmanome = '3� s�rie', escola = 'CENTRO EDUCACIONAL LUZ DO SABER' union 
select turmanome = '3� s�rie', escola = 'Col�gio Santa Terezinha' union 
select turmanome = '3� s�rie', escola = 'CPG CENTRO EDUCACIONAL' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ALFA SAYKOO' union 
select turmanome = '3� s�rie', escola = 'Col�gio Maxx - Foccus 80' union 
select turmanome = '3� s�rie', escola = 'COL�GIO MONSENHOR JOVINIANO BARRETO' union 
select turmanome = '3� s�rie', escola = 'FUNDACAO BAHIANA DE ENGENHARIA' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ALFA' union 
select turmanome = '3� s�rie', escola = 'Facto Col�gio e Curso' union 
select turmanome = '3� s�rie', escola = 'COL�GIO FUTURO - B�zios' union 
select turmanome = '3� s�rie', escola = 'COLEGIO.SUPREMUS ITANHAEM' union 
select turmanome = '3� s�rie', escola = 'VOLTAIRE COLEGIO E VESTIBULARES' union 
select turmanome = '3� s�rie', escola = 'ESCOLA LIBANESA BRASILEIRA' union 
select turmanome = '3� s�rie', escola = 'COLEGIO SANTO AGOSTINHO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - IPATINGA' union 
select turmanome = '3� s�rie', escola = 'EXATO COLEGIO E CURSO' union 
select turmanome = '3� s�rie', escola = 'APROV' union 
select turmanome = '3� s�rie', escola = 'Col�gio Heitor Villa Lobos' union 
select turmanome = '3� s�rie', escola = 'COL�GIO MAXX RECREIO' union 
select turmanome = '3� s�rie', escola = 'CURSO FORTUNATO DOS SANTOS' union 
select turmanome = '3� s�rie', escola = 'Col�gio Jos� Am�rico de Almeida' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - CARATINGA' union 
select turmanome = '3� s�rie', escola = 'COLEGIO ALTERNATIVO' union 
select turmanome = '3� s�rie', escola = 'COLEGIO ALFA LOGOS' union 
select turmanome = '3� s�rie', escola = 'COL�GIO JOS� DE ALENCAR CE' union 
select turmanome = '3� s�rie', escola = 'Escola Demonstrativa' union 
select turmanome = '3� s�rie', escola = 'ESCOLA INSIDE' union 
select turmanome = '3� s�rie', escola = 'DEMONSTRATIVO' union 
select turmanome = '3� s�rie', escola = 'Victor Caglioni' union 
select turmanome = '3� s�rie', escola = 'Testagem Editorial 2020' union 
select turmanome = '3� s�rie', escola = 'Escola Antonio Viveiros' union 
select turmanome = '3� s�rie', escola = 'Escola Teste Carla' union 
select turmanome = '3� s�rie', escola = 'COLEGIO EQUIPE JUIZ DE FORA LTDA' union 
select turmanome = '3� s�rie', escola = 'COLEGIO CEBAM' union 
select turmanome = '3� s�rie', escola = 'CEMI - Centro Educacional de Ensino Fundamental e M�dio' union 
select turmanome = '3� s�rie', escola = 'COL�GIO AMPLA��O' union 
select turmanome = '3� s�rie', escola = 'Escola Evolu��o' union 
select turmanome = '3� s�rie', escola = 'CENTRO EDUCACIONAL TOTH' union 
select turmanome = '3� s�rie', escola = 'Sophos Paragominas' union 
select turmanome = '3� s�rie', escola = 'GABARITO - UNIDADE ITUMBIARA' union 
select turmanome = '3� s�rie', escola = 'COL�GIO VIS�O JUNIOR' union 
select turmanome = '3� s�rie', escola = 'COL�GIO MAANAIM' union 
select turmanome = '3� s�rie', escola = 'SISTEMA UNICO CENTRO EDUCACIONAL LTDA - ME' union 
select turmanome = '3� s�rie', escola = 'ESCOLA SANTO TOM�S DE AQUINO (AGNUS)' union 
select turmanome = '3� s�rie', escola = 'COLEGIO CERI' union 
select turmanome = '3� s�rie', escola = 'Sophos Parauapebas' union 
select turmanome = '3� s�rie', escola = 'COLEGIO UNIVERSITARIO DE ITAPETININGA' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - VALADARES' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ATITUDE' union 
select turmanome = '3� s�rie', escola = 'EINSTEIN SISTEMA DE ENSINO' union 
select turmanome = '3� s�rie', escola = 'JARDIM ESCOLA PETER PAN' union 
select turmanome = '3� s�rie', escola = 'COLEGIO MODELO' union 
select turmanome = '3� s�rie', escola = 'Creche Tia Lica e Escola S�o Jos�' union 
select turmanome = '3� s�rie', escola = 'Sophos Tucuru�' union 
select turmanome = '3� s�rie', escola = 'CURSO RADICAL' union 
select turmanome = '3� s�rie', escola = 'CENTRO EDUCACIONAL ALCANCE EIRELI' union 
select turmanome = '3� s�rie', escola = 'CEPSMA - COLEGIO E CENTRO DE PESQUISA SOUZA MARTINS' union 
select turmanome = '3� s�rie', escola = 'CASA DO GAROTO' union 
select turmanome = '3� s�rie', escola = 'Col�gio Pierre Freitas' union 
select turmanome = '3� s�rie', escola = 'Jardim Escola Santa Marta' union 
select turmanome = '3� s�rie', escola = 'COL�GIO FUTURO - S�o Pedro da Aldeia' union 
select turmanome = '3� s�rie', escola = 'COL�GIO HENRIQUE JORGE' union 
select turmanome = '3� s�rie', escola = 'COLEGIO S. JUDAS TADEU - SEDE CENTRO NORTE' union 
select turmanome = '3� s�rie', escola = 'COL�GIO ATENEU SANTISTA' union 
select turmanome = '3� s�rie', escola = 'Escola Nossa Senhora dos Prazeres' union 
select turmanome = '3� s�rie', escola = 'EDUCANDARIO ARTE DO SABER' union 
select turmanome = '3� s�rie', escola = 'ESCOLA TECNICA ELETRO-MECANICA DA BAHIA' union 
select turmanome = '3� s�rie', escola = 'INSTITUTO DE ENS.ROSATI E CRUCIANI' union 
select turmanome = '3� s�rie', escola = 'ESCOLA SOUZA ALVES' union 
select turmanome = '3� s�rie', escola = 'COL�GIO AVANCE' union 
select turmanome = '3� s�rie', escola = 'Col�gio Jo�o Paulo I' union 
select turmanome = '3� s�rie', escola = 'ESCOLA PROMOVE (B. J. LAPA)' union 
select turmanome = '3� s�rie', escola = 'BATISTA AGAPE' union 
select turmanome = '3� s�rie', escola = 'COL�GIO GENOMA - TEIXEIRA' union 
select turmanome = '3� s�rie', escola = 'COL�GIO POSITIVO CONSTRUTIVO E CRIATIVO' union 
select turmanome = '3� s�rie', escola = 'COOPERATIVA EDUCACIONAL DE FOZ DO IGUACU' union 
select turmanome = '3� s�rie', escola = 'Hermann' union 
select turmanome = '3� s�rie', escola = 'COL�GIO JOS� DE ALENCAR RJ' union 
select turmanome = '3� s�rie', escola = 'COL�GIO PRINCIPIO DAS ARTES' union 
select turmanome = '3� s�rie', escola = 'COLEGIO ARCO IRIS' union 
select turmanome = '3� s�rie', escola = 'UNIDADE CRIATIVA DE ENSINO' union 
select turmanome = '3� s�rie', escola = 'ESCOLA MAGIA DO SABER' union 
select turmanome = '3� s�rie', escola = 'COL�GIO FLUMINENSE CENTRAL (MERITI)' union 
select turmanome = '3� s�rie', escola = 'COL�GIO NOSSA SENHORA DA ROSA MISTICA' union 
select turmanome = '3� s�rie', escola = 'EDUCAND�RIO NOVA GR�CIA' union 
select turmanome = '3� s�rie', escola = 'Col�gio S�o Jorge' union 
select turmanome = '3� s�rie', escola = 'COLEGIO VIVO MORUMBI' union 
select turmanome = '3� s�rie', escola = 'COOPERATIVA DE ENSINO E INTEGRACAO' union 
select turmanome = '3� s�rie', escola = 'COL�GIO FUTURO PARQUE BURLE' union 
select turmanome = '3� s�rie', escola = 'CENTRO EDUCACIONAL PARA�SO' union 
select turmanome = '3� s�rie', escola = 'ESCOLA ALTO PADR�O' union 
select turmanome = '3� s�rie', escola = 'Escola F�bio 2020' union 
select turmanome = '3� s�rie', escola = 'Escola Rita' union 
select turmanome = '3� s�rie', escola = 'COL�GIO S�O JUDAS TADEU (ALAGOAS)' union 
select turmanome = '3� s�rie', escola = 'COL�GIO VIVO SANTA TEREZINHA' union 
select turmanome = '3� s�rie', escola = 'Escola Teste Geral' union 
select turmanome = '3� s�rie', escola = 'ESCOLA COOPESAL' union 
select turmanome = '3� s�rie', escola = 'Escola Paulo Fiatte' union 
select turmanome = '3� s�rie', escola = 'ESCOLA SAE' union 
select turmanome = '3� s�rie', escola = 'COLEGIO E CURSO CORACAO DE MARIA' union 


select turmanome = 'Extensivo', escola = 'C.E. MONTEIRO LOBATO' union 
select turmanome = 'Extensivo', escola = 'Col�gio Status Junior' union 
select turmanome = 'Extensivo', escola = 'INSTITUTO EDUCACIONAL FILOMENA DE MARCO' union 
select turmanome = 'Extensivo', escola = 'CURSINHO INTENSIVO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GM3' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE RIBEIR�O PRETO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO MADRE TERESA' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE RONDON' union 
select turmanome = 'Extensivo', escola = 'CENTRO DE APOIO EDUCACIONAL CEDAE LTDA' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE UBERABA' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MUNDO ENEM' union 
select turmanome = 'Extensivo', escola = 'IDEALFI' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE ARAX�' union 
select turmanome = 'Extensivo', escola = 'APOGEU ASSESSORIA EDUCACIONAL E CURSOS LIVRES LTDA ME' union 
select turmanome = 'Extensivo', escola = 'UNIVERSIT�RIO - UNIDADE TATUAP�' union 
select turmanome = 'Extensivo', escola = 'COL�GIO APOIO' union 
select turmanome = 'Extensivo', escola = 'CELLULA MATER' union 
select turmanome = 'Extensivo', escola = 'EQUILIBRIUM VESTILULARES' union 
select turmanome = 'Extensivo', escola = 'FEDERAL SISTEMA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - TE�FILO (CENTRO)' union 
select turmanome = 'Extensivo', escola = 'Col�gio 1 tim�teo' union 
select turmanome = 'Extensivo', escola = 'Sophos Bel�m - Alcindo Cacela' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ATOPP BRASIL' union 
select turmanome = 'Extensivo', escola = 'COLEGIO DIOCESANO DE PENEDO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO CINCO DE JULHO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO MORI�' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL E CULTURAL CHRISTUS' union 
select turmanome = 'Extensivo', escola = 'Col�gio Decis�o' union 
select turmanome = 'Extensivo', escola = 'QU�MICA INTEGRADA�' union 
select turmanome = 'Extensivo', escola = 'COLEGIO FLAMBOYANTS' union 
select turmanome = 'Extensivo', escola = 'COL�GIO UNINOVE' union 
select turmanome = 'Extensivo', escola = 'Radio Crista Educativa' union 
select turmanome = 'Extensivo', escola = 'COLEGIO UNI-ALPHA' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MADRE VALDELICIA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO EMPYRIUS' union 
select turmanome = 'Extensivo', escola = 'Sophos Bel�m - Augusto Montenegro' union 
select turmanome = 'Extensivo', escola = 'COL�GIO E�A DE QUEIROZ' union 
select turmanome = 'Extensivo', escola = 'COLEGIO INTENSIVO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO M�LTIPLO ENSINO' union 
select turmanome = 'Extensivo', escola = 'Universit�rio Sistema Educacional' union 
select turmanome = 'Extensivo', escola = 'ESCOLA DIN�MICA' union 
select turmanome = 'Extensivo', escola = 'LIMONTI FONSECA EDUCA��O' union 
select turmanome = 'Extensivo', escola = 'UCB' union 
select turmanome = 'Extensivo', escola = 'Escola Santo Anjo' union 
select turmanome = 'Extensivo', escola = 'COL�GIO CEA' union 
select turmanome = 'Extensivo', escola = 'Col�gio Santana' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ELITE' union 
select turmanome = 'Extensivo', escola = 'ESCOLA COPERIL' union 
select turmanome = 'Extensivo', escola = 'COL�GIO S�O JUDAS TADEU (PICOS)' union 
select turmanome = 'Extensivo', escola = 'Col�gio S�o Paulo' union 
select turmanome = 'Extensivo', escola = 'Col�gio Agnus - Rosa Olinto' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - TE�FILO (Dr. Laerte Lander)' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL LUZ DO SABER' union 
select turmanome = 'Extensivo', escola = 'Col�gio Santa Terezinha' union 
select turmanome = 'Extensivo', escola = 'CPG CENTRO EDUCACIONAL' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ALFA SAYKOO' union 
select turmanome = 'Extensivo', escola = 'Col�gio Maxx - Foccus 80' union 
select turmanome = 'Extensivo', escola = 'COL�GIO MONSENHOR JOVINIANO BARRETO' union 
select turmanome = 'Extensivo', escola = 'FUNDACAO BAHIANA DE ENGENHARIA' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ALFA' union 
select turmanome = 'Extensivo', escola = 'Facto Col�gio e Curso' union 
select turmanome = 'Extensivo', escola = 'COL�GIO FUTURO - B�zios' union 
select turmanome = 'Extensivo', escola = 'COLEGIO.SUPREMUS ITANHAEM' union 
select turmanome = 'Extensivo', escola = 'VOLTAIRE COLEGIO E VESTIBULARES' union 
select turmanome = 'Extensivo', escola = 'ESCOLA LIBANESA BRASILEIRA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO SANTO AGOSTINHO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - IPATINGA' union 
select turmanome = 'Extensivo', escola = 'EXATO COLEGIO E CURSO' union 
select turmanome = 'Extensivo', escola = 'APROV' union 
select turmanome = 'Extensivo', escola = 'Col�gio Heitor Villa Lobos' union 
select turmanome = 'Extensivo', escola = 'COL�GIO MAXX RECREIO' union 
select turmanome = 'Extensivo', escola = 'CURSO FORTUNATO DOS SANTOS' union 
select turmanome = 'Extensivo', escola = 'Col�gio Jos� Am�rico de Almeida' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - CARATINGA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ALTERNATIVO' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ALFA LOGOS' union 
select turmanome = 'Extensivo', escola = 'COL�GIO JOS� DE ALENCAR CE' union 
select turmanome = 'Extensivo', escola = 'Escola Demonstrativa' union 
select turmanome = 'Extensivo', escola = 'ESCOLA INSIDE' union 
select turmanome = 'Extensivo', escola = 'DEMONSTRATIVO' union 
select turmanome = 'Extensivo', escola = 'Victor Caglioni' union 
select turmanome = 'Extensivo', escola = 'Testagem Editorial 2020' union 
select turmanome = 'Extensivo', escola = 'Escola Antonio Viveiros' union 
select turmanome = 'Extensivo', escola = 'Escola Teste Carla' union 
select turmanome = 'Extensivo', escola = 'COLEGIO EQUIPE JUIZ DE FORA LTDA' union 
select turmanome = 'Extensivo', escola = 'COLEGIO CEBAM' union 
select turmanome = 'Extensivo', escola = 'CEMI - Centro Educacional de Ensino Fundamental e M�dio' union 
select turmanome = 'Extensivo', escola = 'COL�GIO AMPLA��O' union 
select turmanome = 'Extensivo', escola = 'Escola Evolu��o' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL TOTH' union 
select turmanome = 'Extensivo', escola = 'Sophos Paragominas' union 
select turmanome = 'Extensivo', escola = 'GABARITO - UNIDADE ITUMBIARA' union 
select turmanome = 'Extensivo', escola = 'COL�GIO VIS�O JUNIOR' union 
select turmanome = 'Extensivo', escola = 'COL�GIO MAANAIM' union 
select turmanome = 'Extensivo', escola = 'SISTEMA UNICO CENTRO EDUCACIONAL LTDA - ME' union 
select turmanome = 'Extensivo', escola = 'ESCOLA SANTO TOM�S DE AQUINO (AGNUS)' union 
select turmanome = 'Extensivo', escola = 'COLEGIO CERI' union 
select turmanome = 'Extensivo', escola = 'Sophos Parauapebas' union 
select turmanome = 'Extensivo', escola = 'COLEGIO UNIVERSITARIO DE ITAPETININGA' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - VALADARES' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ATITUDE' union 
select turmanome = 'Extensivo', escola = 'EINSTEIN SISTEMA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'JARDIM ESCOLA PETER PAN' union 
select turmanome = 'Extensivo', escola = 'COLEGIO MODELO' union 
select turmanome = 'Extensivo', escola = 'Creche Tia Lica e Escola S�o Jos�' union 
select turmanome = 'Extensivo', escola = 'Sophos Tucuru�' union 
select turmanome = 'Extensivo', escola = 'CURSO RADICAL' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL ALCANCE EIRELI' union 
select turmanome = 'Extensivo', escola = 'CEPSMA - COLEGIO E CENTRO DE PESQUISA SOUZA MARTINS' union 
select turmanome = 'Extensivo', escola = 'CASA DO GAROTO' union 
select turmanome = 'Extensivo', escola = 'Col�gio Pierre Freitas' union 
select turmanome = 'Extensivo', escola = 'Jardim Escola Santa Marta' union 
select turmanome = 'Extensivo', escola = 'COL�GIO FUTURO - S�o Pedro da Aldeia' union 
select turmanome = 'Extensivo', escola = 'COL�GIO HENRIQUE JORGE' union 
select turmanome = 'Extensivo', escola = 'COLEGIO S. JUDAS TADEU - SEDE CENTRO NORTE' union 
select turmanome = 'Extensivo', escola = 'COL�GIO ATENEU SANTISTA' union 
select turmanome = 'Extensivo', escola = 'Escola Nossa Senhora dos Prazeres' union 
select turmanome = 'Extensivo', escola = 'EDUCANDARIO ARTE DO SABER' union 
select turmanome = 'Extensivo', escola = 'ESCOLA TECNICA ELETRO-MECANICA DA BAHIA' union 
select turmanome = 'Extensivo', escola = 'INSTITUTO DE ENS.ROSATI E CRUCIANI' union 
select turmanome = 'Extensivo', escola = 'ESCOLA SOUZA ALVES' union 
select turmanome = 'Extensivo', escola = 'COL�GIO AVANCE' union 
select turmanome = 'Extensivo', escola = 'Col�gio Jo�o Paulo I' union 
select turmanome = 'Extensivo', escola = 'ESCOLA PROMOVE (B. J. LAPA)' union 
select turmanome = 'Extensivo', escola = 'BATISTA AGAPE' union 
select turmanome = 'Extensivo', escola = 'COL�GIO GENOMA - TEIXEIRA' union 
select turmanome = 'Extensivo', escola = 'COL�GIO POSITIVO CONSTRUTIVO E CRIATIVO' union 
select turmanome = 'Extensivo', escola = 'COOPERATIVA EDUCACIONAL DE FOZ DO IGUACU' union 
select turmanome = 'Extensivo', escola = 'Hermann' union 
select turmanome = 'Extensivo', escola = 'COL�GIO JOS� DE ALENCAR RJ' union 
select turmanome = 'Extensivo', escola = 'COL�GIO PRINCIPIO DAS ARTES' union 
select turmanome = 'Extensivo', escola = 'COLEGIO ARCO IRIS' union 
select turmanome = 'Extensivo', escola = 'UNIDADE CRIATIVA DE ENSINO' union 
select turmanome = 'Extensivo', escola = 'ESCOLA MAGIA DO SABER' union 
select turmanome = 'Extensivo', escola = 'COL�GIO FLUMINENSE CENTRAL (MERITI)' union 
select turmanome = 'Extensivo', escola = 'COL�GIO NOSSA SENHORA DA ROSA MISTICA' union 
select turmanome = 'Extensivo', escola = 'EDUCAND�RIO NOVA GR�CIA' union 
select turmanome = 'Extensivo', escola = 'Col�gio S�o Jorge' union 
select turmanome = 'Extensivo', escola = 'COLEGIO VIVO MORUMBI' union 
select turmanome = 'Extensivo', escola = 'COOPERATIVA DE ENSINO E INTEGRACAO' union 
select turmanome = 'Extensivo', escola = 'COL�GIO FUTURO PARQUE BURLE' union 
select turmanome = 'Extensivo', escola = 'CENTRO EDUCACIONAL PARA�SO' union 
select turmanome = 'Extensivo', escola = 'ESCOLA ALTO PADR�O' union 
select turmanome = 'Extensivo', escola = 'Escola F�bio 2020' union 
select turmanome = 'Extensivo', escola = 'Escola Rita' union 
select turmanome = 'Extensivo', escola = 'COL�GIO S�O JUDAS TADEU (ALAGOAS)' union 
select turmanome = 'Extensivo', escola = 'COL�GIO VIVO SANTA TEREZINHA' union 
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
      TURMANOME <> '3� s�rie / Extensivo ,Extensivo' AND 
	  TURMANOME NOT IN ('4� ano','5� ano')
	  ORDER BY 1, 2

select * 
--   UPDATE AUS SET AUS.ESCOLA_NOME = 'Col�gio Sant''ana'
FROM TMP_IMP_ESCOLA_AGENDAMENTO_ULTIMA_SEMANA AUS WHERE ESCOLA_NOME LIKE 'Col�gio San%na'