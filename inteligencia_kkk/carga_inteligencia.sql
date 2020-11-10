insert into tmp_inteligencia
select tab.* from (
select item_id = 405, resposta  = 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            texto_comparado = 'Prostaglandina', peso = 0.8 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal', 0.49 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI%neonatal', 0.48 union  
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI', 0.47 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'incubadora', 0.46 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'medidas de suport', 0.45 union  
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'distúrbios eletrolíticos', 0.44 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'distúrbios%eletrolíticos', 0.43 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'eletrolíticos', 0.42 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'Prostaglandina IV até confirmação diagnóstica%UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.', 1 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'Prostaglandina IV até confirmação diagnóstica', 0.99 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'Prostaglandina IV % confirmação diagnóstica', 0.98 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte', 0.97 union  
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal%incubadora% correção de distúrbios eletrolíticos% medidas de suporte', 0.96 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal%incubadora% correção de distúrbios eletrolíticos', 0.95 union   
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal%incubadora% medidas de suporte', 0.94 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal%correção de distúrbios eletrolíticos% medidas de suporte', 0.93 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'UTI neonatal%incubadora%', 0.92 union 
select 405, 'Prostaglandina IV até confirmação diagnóstica UTI neonatal, incubadora, correção de distúrbios eletrolíticos, medidas de suporte.',  
            'Prostaglandina IV até confirmação diagnóstica%UTI neonatal%incubadora%', 0.91  union 
--------------------------------------------------------------------------
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia congênita crítica', 1 union 
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia%congênita%crítica', 0.99 union      
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia congênita', 0.9 union 
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia%congênita', 0.89 union 
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia%crítica'  , 0.8  union 
select 404, 'Cardiopatia congênita crítica',  'Cardiopatia%'         , 0.7  union 
select 404, 'Cardiopatia congênita crítica',  'congênita crítica', 0.5  union 
select 404, 'Cardiopatia congênita crítica',  'congênita%crítica', 0.59  union 
select 404, 'Cardiopatia congênita crítica',  'congênita', 0.4  

) as tab left join tmp_inteligencia xxx on (xxx.item_id = tab.item_id and xxx.texto_comparardo = tab.texto_comparado)
 where xxx.item_id is null     

--	 select * from tmp_inteligencia