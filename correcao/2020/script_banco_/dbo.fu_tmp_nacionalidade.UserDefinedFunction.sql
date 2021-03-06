USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_tmp_nacionalidade]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[fu_tmp_nacionalidade] (@pais varchar(50)) 
returns varchar(100) as
begin

if @pais = 'BRASIL' begin return 'BRASILEIRA' end
if @pais = 'ALEMANHA' begin return 'ALEMÃO' end
if @pais = 'BELGICA' begin return 'BELGA' end
if @pais = 'BOLÍVIA' begin return 'BOLIVIANO' end
if @pais = 'INGLATERRA' begin return 'BRITANICO' end
if @pais = 'CANADA' begin return 'CANADENSE' end
if @pais = 'CHILE' begin return 'CHILENO' end
if @pais = 'CHINA' begin return 'CHINÊS' end
if @pais = 'COREIA' begin return 'COREANO' end
if @pais = 'CUBA' begin return 'CUBANA' end
if @pais = 'ESPANHA' begin return 'ESPANHOL' end
if @pais = 'FRANÇA' begin return 'FRANCÊS' end
if @pais = 'IRAQUE' begin return 'IRAQUIANA' end
if @pais = 'ITÁLIA' begin return 'ITALIANO' end
if @pais = 'JAPÃO' begin return 'JAPONESA' end
if @pais = 'Estados Unidos Da América (Eua)' begin return 'NORTE-AMERICANO' end
if @pais = 'ESTADOS UNIDOS DA AMÉRICA' begin return 'NORTE-AMERICANO' end
if @pais = 'PARAGUAI' begin return 'PARAGUAIO' end
if @pais = 'PORTUGAL' begin return 'PORTUGUÊS' end
if @pais = 'SUIÇA' begin return 'SUIÇO' end
if @pais = 'URUGUAI' begin return 'URUGUAIO' end
if @pais = 'CHINA' begin return 'CHINESA' end
if @pais = 'GUATEMALA' begin return 'GUATEMALTECO' end
if @pais = 'PERU' begin return 'PERUANA' end
if @pais = 'SALVADOR' begin return 'SALVADOR' end
if @pais = 'PORTUGAL' begin return 'PORTUGUESA' end
if @pais = 'HONDURAS' begin return 'HONDURENHA' end
if @pais = 'ANGOLA' begin return 'ANGOLANO' end
if @pais = 'COLOMBIA' begin return 'COLOMBIANA' end
if @pais = 'REPÚBLICA DOMINICANA' begin return 'DOMINICANA' end
if @pais = 'MOÇAMBIQUE' begin return 'MOÇAMBICANA' end
if @pais = 'FILIPINAS' begin return 'FILIPINAS' end
if @pais = 'FILIPINAS' begin return 'FILIPINO' end
if @pais = 'VENEZUELA' begin return 'VENEZUELANA' end
if @pais = 'EQUADOR' begin return 'EQUATORIANA' end
if @pais = 'BRASIL' begin return 'Brasil' end
if @pais = 'ALEMANHA' begin return 'Alemanha' end
if @pais = 'COLOMBIA' begin return 'Colômbia' end
if @pais = 'AFEGANISTÃO' begin return 'Afeganistão' end
  return null
end
GO
