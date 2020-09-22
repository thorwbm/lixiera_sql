

select turma_nome, aluno_nome, curso_nome
  from vw_acd_curso_turma_disciplina_aluno
 where turma_nome in (
'M074S01A202T',
'M074S01B202T',
'M074S01C202T',
'M074S01D202T'
 )