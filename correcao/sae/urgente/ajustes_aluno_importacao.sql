SELECT TOP 10 * 
--UPDATE tmp SET tmp.usuarioserie = 'Extensivo'
FROM tmpimp_alunos tmp
WHERE usuarioserie like '3� s�rie / Extensivo ,Extensivo'


SELECT * INTO nao_importados_serie_multipla
--UPDATE tmp SET tmp.usuarioserie = 'nao_importar'
FROM tmpimp_alunos tmp
WHERE usuarioserie like '%,%'
