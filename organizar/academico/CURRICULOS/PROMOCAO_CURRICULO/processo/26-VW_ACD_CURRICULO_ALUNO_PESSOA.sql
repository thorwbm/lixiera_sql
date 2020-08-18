 create or alter view VW_ACD_CURRICULO_ALUNO_PESSOA as          
select alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,         
       pes.id as pessoa_id, pes.cpf as aluno_cpf, pes.data_nascimento,    
       ema.email as aluno_email,    
       cra.id as curriculo_aluno_id,        
       crc.id as curriculo_id, crc.nome as curriculo_nome,       
       cur.id as curso_id, cur.nome as curso_nome,      
       csa.id as curriculo_aluno_status_id, csa.nome as curriculo_aluno_status_nome,       
       tpo.id as tipo_oferta_id, tpo.nome as tipo_oferta_nome,   
       FMI.ID AS FORMA_INGRESSO_ID, FMI.nome AS FORMA_INGRESSO_NOME ,
	   gra.id as grade_id, gra.nome as grade_nome, 
	   eta.id as etapa_natural_id, eta.nome as etapa_natural_nome
  from academico_aluno alu join pessoas_pessoa           pes on (pes.id = alu.pessoa_id)        
                           join curriculos_aluno         cra on (alu.id = cra.aluno_id)       
                           join curriculos_curriculo     crc on (crc.id = cra.curriculo_id)      
                           join academico_curso          cur on (cur.id = crc.curso_id)      
                           join academico_cursooferta    cof on (cof.id = crc.curso_oferta_id)      
                           join academico_tipooferta     tpo on (tpo.id = cof.tipo_oferta_id)      
                           join curriculos_statusaluno   csa on (csa.id = cra.status_id)    
                           JOIN curriculos_formaingresso FMI ON (FMI.ID = CRA.metodo_admissao_id)  
					  left join curriculos_grade         gra on (gra.id = cra.grade_id)
					  left join academico_etapa          eta on (eta.id = gra.etapa_id)
                      left join pessoas_email            ema on (ema.pessoa_id = pes.id and     
                                                                 ema.principal = 1)    
    
    