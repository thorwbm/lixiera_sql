-- #### CRIAR NO MASTER ####
USE MASTER
-- Creates the login AbolrousHazem with password '340$Uuxwp7Mcxo7Khy'.  
CREATE LOGIN [resultado]   
    WITH PASSWORD = 'cfhtd@6u69hhj$vfyu6&r';  
GO  
-- Creates a database user for the login created above.  
CREATE USER [resultado] FOR LOGIN [resultado];  


-- #### CRIAR NO BANCO ####
USE entregas_ppl
CREATE USER [resultado]
	FOR LOGIN [resultado]
	WITH DEFAULT_SCHEMA = [dbo]
GO

-- #### DAR PERMISSOES ####

GRANT SELECT ON OBJECT::vw_entregas_n59 TO [resultado]; 
GRANT SELECT ON OBJECT::vw_entregas_n65 TO [resultado]; 
GRANT SELECT ON OBJECT::vw_entregas_n67 TO [resultado]; 
GRANT SELECT ON OBJECT::vw_entregas_n68 TO [resultado]; 
GRANT SELECT ON OBJECT::vw_entregas_n69 TO [resultado]; 
GRANT SELECT ON OBJECT::vw_entregas_n70 TO [resultado]; 
