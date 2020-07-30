DECLARE @TERM_YEAR int;
SET @TERM_YEAR = 1; -- TODO: TERM YEAR NÃO PODE SER UM PARAMETRO, DEVE PEGAR PELO ATUAL = 1
​
begin tran
    -- RESOLVER CONTRATO ASSINADO E REGRAS REGIMENTAIS MATRICULA POS
    insert into promocao_promocaoaluno (criado_em, atualizado_em, contrato_assinado, regras_regimento, promocao_id, aluno_id)
    select
        GETDATE(),
        GETDATE(),
        1,
        1,
        (select top 1 id from promocao_promocao where promocao_atual = 1),
        a.id
    from academico_aluno a
    join mat_pos_prd..onboarding_enrollment e on a.ra = e.student_id COLLATE SQL_Latin1_General_CP1_CI_AI
    join mat_pos_prd..onboarding_onboarding o on o.id = e.onboarding_id -- CRIAR JOIN COM TERM YEAR PARA PEGAR O ATUAL = 1
    where e.status_id = 6 and o.term_year_id = @TERM_YEAR and a.id not in (select aluno_id from promocao_promocaoaluno)
​
    --RESOLVER CONTA FINANCEIRA MATRICULA DA POS
    insert into financeiro_conta (criado_em, atualizado_em, saldo, pessoa_id, titular_id)
    select
        GETDATE() as criado_em,
        GETDATE() as atualizado_em,
        0 as saldo,
        a.pessoa_id,
        (CASE WHEN fo.cpf is not null
            THEN (select id from pessoas_pessoa where cpf = fo.cpf COLLATE SQL_Latin1_General_CP1_CI_AS)
            ELSE a.pessoa_id
        END) as titular_id
    from promocao_promocaoaluno pa
        join academico_aluno a on a.id = pa.aluno_id
        join mat_pos_prd..onboarding_enrollment e on a.ra = e.student_id COLLATE SQL_Latin1_General_CP1_CI_AI
        join mat_pos_prd..onboarding_onboarding o on o.id = e.onboarding_id -- CRIAR JOIN COM TERM YEAR PARA PEGAR O ATUAL = 1
        left join mat_pos_prd..onboarding_financedata fd on fd.enrollment_id = e.id
        left join mat_pos_prd..onboarding_financeofficer fo on fo.finance_data_id = fd.id
    where e.status_id = 6 and o.term_year_id = 1 and a.pessoa_id not in (select pessoa_id from financeiro_conta)
​
commit