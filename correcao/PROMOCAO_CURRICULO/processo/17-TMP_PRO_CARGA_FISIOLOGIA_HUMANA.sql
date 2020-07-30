	  
select * into TMP_PRO_CARGA_FISIOLOGIA_HUMANA from (  
select pai = 'M073S02A202T', filha = 'M073S02A202T01', subfilha = 'M073S02A202P01A' union 
select pai = 'M073S02A202T', filha = 'M073S02A202T01', subfilha = 'M073S02A202P01B' union 
select pai = 'M073S02A202T', filha = 'M073S02A202T02', subfilha = 'M073S02A202P02A' union 
select pai = 'M073S02A202T', filha = 'M073S02A202T02', subfilha = 'M073S02A202P02B' union 
	  
select pai = 'M073S02B202T', filha = 'M073S02B202T01', subfilha = 'M073S02B202P01A' union 
select pai = 'M073S02B202T', filha = 'M073S02B202T01', subfilha = 'M073S02B202P01B' union 
select pai = 'M073S02B202T', filha = 'M073S02B202T02', subfilha = 'M073S02B202P02A' union 
select pai = 'M073S02B202T', filha = 'M073S02B202T02', subfilha = 'M073S02B202P02B' union 
	  
select pai = 'M073S02C202T', filha = 'M073S02C202T01', subfilha = 'M073S02C202P01A' union 
select pai = 'M073S02C202T', filha = 'M073S02C202T01', subfilha = 'M073S02C202P01B' union 
select pai = 'M073S02C202T', filha = 'M073S02C202T02', subfilha = 'M073S02C202P02A' union 
select pai = 'M073S02C202T', filha = 'M073S02C202T02', subfilha = 'M073S02C202P02B' union 
	  
select pai = 'M073S02D202T', filha = 'M073S02D202T01', subfilha = 'M073S02D202P01A' union 
select pai = 'M073S02D202T', filha = 'M073S02D202T01', subfilha = 'M073S02D202P01B' union 
select pai = 'M073S02D202T', filha = 'M073S02D202T02', subfilha = 'M073S02D202P02A' union 
select pai = 'M073S02D202T', filha = 'M073S02D202T02', subfilha = 'M073S02D202P02B' ) as tab

