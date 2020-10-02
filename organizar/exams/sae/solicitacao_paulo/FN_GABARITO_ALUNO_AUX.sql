  
CREATE or alter FUNCTION FN_GABARITO_ALUNO_AUX (@application_id int)  
RETURNS VARCHAR(1000)  
BEGIN  
 declare @letra varchar(1)  
 declare @linha varchar(250) =''  
  
 declare CUR_ cursor for   
   SELECT letter   
   FROM tmp_resposta_aluno  
    WHERE application_id =   @application_id  
    order by position  
  open CUR_   
   fetch next from CUR_ into @letra  
   while @@FETCH_STATUS = 0  
    BEGIN  
     set @linha = @linha + isnull(@letra, 'X')  
  
    fetch next from CUR_ into @letra  
    END  
  close CUR_   
 deallocate CUR_   
  
 RETURN @linha  
  
end