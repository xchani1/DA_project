use [hrdata]
--odstraneni dat ve formatu 00.00.0000
update t_import set zd=null where zd='00.00.0000'
update t_import set dd=null where dd='00.00.0000'
update t_import set vystupDate=null where vystupDate='00.00.0000'
update t_import set datNar=null where datNar='00.00.0000'

--nahrada a doplneni stredisek v zahranici (dle vyplatniho mista)
update t_import set stredisko=N'CC' where (misto=N'�ilina' or misto=N'Lugoj' and Mandant=N'MAND30')
update t_import	set stredisko=N'HR' where (misto=N'Bukure�� Sklad' and Mandant=N'MAND30')
update t_import	set stredisko=N'DP' where (misto!=N'�ilina' and misto!=N'Bukure�� Sklad' and misto!=N'Lugoj' and Mandant=N'MAND30')

--doplneni statu v zahranici dle vyplatniho mista
update t_import set stat=N'DE' where (stat is null and misto=N'N�mecko')
update t_import	set stat=N'SK' where (stat is null and misto=N'�ilina')	
update t_import	set stat=N'RO' where (stat is null and (misto=N'Bukure�� Promenada Mall' or misto=N'Bukure�� Mega Mall'))	
update t_import	set stat=N'BG' where (stat is null and misto=N'Sofia - Bulharsko')	
update t_import	set stat=N'HU' where (stat is null and misto=N'Budape�� Arena Plaza')	
update t_import	set stat=N'PL' where (stat is null and (misto=N'Var�ava Arkadia' or misto=N'Var�ava - Prosta' or misto=N'Var�ava Blue city' or misto=N'Gda�sk' or misto=N'Katowice' or misto=N'Pozna�' or misto=N'Krak�w Bonarka' or misto=N'Wroclaw' or misto=N'Krakow Kamienna' or misto=N'Lod�'))	
				
--doplneni statu v CZ dle mandanta
update t_import set stat=N'CZ' where (stat is null and mandant=N'NOTINO')

--select * from t_zamestnanec3 where stat is null and PP!='EPP'
--select * from t_import 
--v magme chybi u spousty lidi stat - typicky Varsava Arkadia, Gdansk nebo spousta lidi z Rajhradu (hlavne asi dohodari)