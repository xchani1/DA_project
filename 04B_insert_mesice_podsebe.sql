
INSERT INTO [dbo].[t_zamestnanec3]
           (mesic_zaznam, id_magma, stredisko, misto, PP, uvazek, nastup, ZD, DD, VystupDate, 
		   Plat, Plat2, Plat3, Premie, Mimoevidencni, pozice, vystupForma, 
		   vystupDuv, vzdelani, rodStav, Deti, stat, flexi, nadrizeny, DatNar, Pohlavi, Mandant)
     
	 SELECT
			EOMONTH(getdate(),-1), ID, stredisko, misto, PP, replace(uvazek,',','.'), 
			convert(date,nastup,104),  convert(date,zd,104), convert(date,dd,104),
			convert(date,vystupDate,104), replace(replace(replace(plat, ',00',''),' ',''),',','.'), 
			replace(replace(plat2, ',00',''),' ',''), replace(replace(plat3, ',00',''),' ',''), 
			replace(replace(premie, ',00',''),' ',''), mimoevidencni, pozice,
			vystupForma, vystupDuv, vzdelani, rodStav, deti, stat, 
			flexi, coalesce(nadrizeny6, nadrizeny5, nadrizeny4, nadrizeny3, nadrizeny2, nadrizeny1), convert(date,datNar,104), Pohlavi, Mandant

	from t_import

	where EOMONTH(getdate(),-1) not in (SELECT mesic_zaznam from t_zamestnanec3)


--pri nacitani starsich (napr. zarijovych) dat pouzit: select EOMONTH('2020-10-01',-1) atd.