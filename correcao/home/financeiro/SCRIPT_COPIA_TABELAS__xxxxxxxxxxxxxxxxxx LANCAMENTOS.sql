-- https://trello.com/c/1cLnSM7H


-- drop table #temp
select fnc.lancamento_id, fnc.lanc_boleto_id, fnc.desconto_id as lanc_desconto_id , fnc.contrato_id, 
       par.parcela_id,  des.id as parcela_desconto_id, fnc.lancamento_negociacao_id,
       par.aluno_nome
into #temp
 from VW_FNC_CONTR_CURRIC_LANCAMENTO_DESC_ALUNO fnc join financeiro_lancamento lan on (lan.id = fnc.lancamento_id)
                                                    join VW_FNC_CONTR_CURRIC_PARCELA_DESC_ALUNO par on (par.contrato_id = fnc.contrato_id and 
                                                                                                        par.parcela_id = lan.parcela_id)
                                               left join contratos_desconto  des on (par.parcela_id = des.parcela_id)
                                               left join financeiro_transacao tra on (lan.id = tra.lancamento_id)
 where  cast(lan.criado_em as date) = '2020-04-17' and 
        tra.id is null  and 
       fnc.contrato_id in (1999,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013)

       order by par.aluno_nome
select * from #temp


--   ###############################################################################################
begin tran 
DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME) 

declare @id int 

----------------------------------------------------------------------------------------------------------------
-- deletar lancamento_boleto

declare CUR_lancbol cursor for 
	select distinct aux.id 
      from financeiro_lancamentoboleto aux join #temp tmp on (aux.id = tmp.lanc_boleto_id and 
                                                              aux.lancamento_id = tmp.lancamento_id)
	open CUR_lancbol 
		fetch next from CUR_lancbol into @id
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_GERAR_LOG 'financeiro_lancamentoboleto', @ID, '-', 11717, NULL, null, null

                delete from financeiro_lancamentoboleto where id = @id

			fetch next from CUR_lancbol into @id
			END
	close CUR_lancbol 
    deallocate CUR_lancbol 

---------------------------------------------------------------------------------------------------------------
-- deletar lancamento desconto 

declare CUR_landesc cursor for 
	select distinct aux.id  from financeiro_desconto aux join #temp tmp on (aux.id = tmp.lanc_desconto_id)

	open CUR_landesc 
		fetch next from CUR_landesc into @id
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_GERAR_LOG 'financeiro_desconto', @ID, '-', 11717, NULL, null, null

                delete from financeiro_desconto where id = @id

			fetch next from CUR_landesc into @id
			END
	close CUR_landesc 
    deallocate CUR_landesc 

---------------------------------------------------------------------------------------------------------------
-- deletar lancamento  

declare CUR_lan cursor for 
	select distinct aux.id from financeiro_lancamento aux join #temp tmp on (aux.id = tmp.lancamento_id)

	open CUR_lan 
		fetch next from CUR_lan into @id
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_GERAR_LOG 'financeiro_lancamento', @ID, '-', 11717, NULL, null, null

                delete from financeiro_lancamento where id = @id

			fetch next from CUR_lan into @id
			END
	close CUR_lan 
    deallocate CUR_lan 
---------------------------------------------------------------------------------------------------------------


-- deletar parcela desconto
--  select 'deletar parcela desconto',* 
--  delete aux
--from contratos_desconto aux join #temp tmp on (aux.id = tmp.parcela_desconto_id)

-- deletar parcela 
--  select 'deletar parcela',* 
--  delete aux
--from contratos_parcela aux join #temp tmp on (aux.id = tmp.parcela_id)

-- deletar contrato 
--- select 'deletar contrato ',* 
--  delete aux
--from contratos_contrato aux join #temp tmp on (aux.id = tmp.contrato_id)

--rollback 
-- commit                                                                             ���� JFIF  ` `  �� C 


		
%# , #&')*)-0-(0%()(�� C



(((((((((((((((((((((((((((((((((((((((((((((((((((��  � �" ��           	
�� �   } !1AQa"q2���#B��R��$3br�	
%&'()*456789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz���������������������������������������������������������������������������        	
�� �  w !1AQaq"2�B����	#3R�br�
$4�%�&'()*56789:CDEFGHIJSTUVWXYZcdefghijstuvwxyz��������������������������������������������������������������������������   ? ��8Ԣ|��+F�OYO(��-�QO$F8���F7g$ 	�O?�u�M�b �hH+����[��"��#��s�}������ކ+^����	��I���e��>��3H�o���� J���>mK?[8� »�28�$
ՍV1��m�1x��� �a��h� ��U��_�l|���
/��5y� �O���.c��yXF�d�~ÊʫT�{a��>V�6��߃�>����s��+*_x<F�H�¼��οu1(-c�*_�������?da���kϕj�h�ۧ���IM������}�������?�K�Ǝ1�6c���+��~/Ό��#�A.?C�5�>����[#�R$��Y],����"p��l��=U����z���X���[~�\���(�'�'� W��Xjc	!��SQ��#}+���U^,�+��a��QX�v��ʤ�=��Et�կ�u?��#�rZ��rB���cs�&��,�ҫ:�+�������\����~CKQ�l.c�YB�NF�~ �j����.�L��I`q�=��ү]hҩ$)�Vl�SE���
�S�#�������ZC��[�2M$�3�Ղ��{�zϸH�]�H%\�;s֡s��f�9��(�QE {g�H�|){n��g<��j �?�	�o)#�A�?�"�6P�	YZ�~�n�d�����^3�p���w������
�6ǒO~kZP�0�S��eb%խ�,R[�21��)�����q�>�~�2�LE���qV�ǖO'�5��A�ɍ
Q���� �4|G�ju��a�r���� u��C��GVy��s�Du��S��לO�'��Y�u�ז��`�K[9$  �H~t��ovHҼ'���~^G�j����1��������^��.t��廍�ˌ�r���&�d��g���S��]�J�%���a��8��?VA����d�oM���G�&�uk7n�na���;8���ֱ�C_V��H�O�ź�^���I�F]N@W�)�G�J̇�����I1��]\Hq�ɮ'E��V&-\���3B��W���#�c��� 錧�U��C�U�|/��0x����T�?�D���~1�4����n9�%9_ø�+߾|W���vw �rx�e<���ZЛ�~% <1���焉�)��_>�GÇ �c�C�³xV�2ѝ��mJ��{?ӱ�6�v���� �؊̿��u?��l�>$��!���8�O��R���Y]w�B�����"�0G�+�/O{sϨ�3t�2�
�?�g�KU�j�u��w�x��#�>>��1k1r}�+>��>#��G�=w��u�5���5J�(��+�Լ2��G�^�q�V�����pJ�	F~��.��	[�v��.T��f��S<2�Ø�T�5�� bȠ{^�*�\�}�I�$�����
ǛA����aums `�dR�2r@����ڡ��xt���?-@A�^��i�8��	�����o�>y�����:K`Ď4S�𳅴�,@%��+�еmgV"A�����?�޼�@q%�Q��x�����(b�<"F ;
裹ˈ�^�Ia�8��|I�jz������W���Mܖ�i�Z��Y;4�	U�##��W�M"�F3�L�5�guo���[Ǖ�c�#H���Rx�W�:M:ko���*�T�W����n^��i�ZD#KMB[=��$�Gq v޸� �֖���[L�~qְ�-4�c�G$R�1���s�� Z�czm."���g!7`��ThIS�fs�BS����Ht2��@�II����ij��<p8��:sd�>_@��=\��W�nV�