use [hrdata]

--truncate table t_zamestnanec2
--truncate table t_log


--insert novych lidi do tabulky:

INSERT INTO [dbo].[t_zamestnanec2]
           (id_magma, stredisko, misto, PP, uvazek, nastup, ZD, DD, VystupDate, 
		   Plat, Plat2, Plat3, Premie, Mimoevidencni, pozice, vystupForma, 
		   vystupDuv, vzdelani, rodStav, Deti, stat, flexi, nadrizeny, DatNar, Pohlavi, Mandant)
     
	 SELECT
			ID, stredisko, misto, PP, replace(uvazek,',','.'), 
			convert(date,nastup,104),  convert(date,zd,104), convert(date,dd,104),
			convert(date,vystupDate,104), replace(replace(replace(plat, ',00',''),' ',''),',','.'), 
			replace(replace(plat2, ',00',''),' ',''), replace(replace(plat3, ',00',''),' ',''), 
			replace(replace(premie, ',00',''),' ',''), mimoevidencni, pozice,
			vystupForma, vystupDuv, vzdelani, rodStav, deti, stat, 
			flexi, coalesce(nadrizeny6, nadrizeny5, nadrizeny4, nadrizeny3, nadrizeny2, nadrizeny1), convert(date,datNar,104), Pohlavi, Mandant

	from t_import
			
WHERE
			ID not in (SELECT id_magma from t_zamestnanec2)

--update tabulky a zaroven zapis do logu:

MERGE t_zamestnanec2 AS TARGET
USING  t_import AS SOURCE
                  ON TARGET.ID_magma = SOURCE.ID

WHEN MATCHED AND (TARGET.stredisko<>SOURCE.stredisko or 
				  TARGET.misto<>SOURCE.misto or
				  TARGET.uvazek<>replace(SOURCE.uvazek,',','.') or
				  TARGET.dd<>convert(date,SOURCE.dd,104) or
				  TARGET.vystupDate<>convert(date,SOURCE.vystupDate,104) or
				  TARGET.Plat<>convert(money, replace(replace(replace(SOURCE.PLAT, ',00',''),' ',''),',','.')) or 
				  TARGET.Plat2<>convert(money, replace(replace(replace(SOURCE.PLAT2, ',00',''),' ',''),',','.')) or 
				  TARGET.Plat3<>convert(money, replace(replace(replace(SOURCE.PLAT3, ',00',''),' ',''),',','.')) or 
				  TARGET.Premie<>convert(money, replace(replace(replace(SOURCE.Premie, ',00',''),' ',''),',','.')) or 
				  TARGET.Mimoevidencni<>SOURCE.Mimoevidencni or
				  TARGET.pozice<>SOURCE.pozice or
				  TARGET.vzdelani<>SOURCE.vzdelani or
				  TARGET.rodStav<>SOURCE.rodStav or
				  TARGET.deti<>SOURCE.deti or
				  TARGET.stat<>SOURCE.stat or
				  TARGET.nadrizeny<>COALESCE(SOURCE.Nadrizeny6, SOURCE.Nadrizeny5, SOURCE.Nadrizeny4, SOURCE.Nadrizeny3, SOURCE.Nadrizeny2, SOURCE.Nadrizeny1)) or
				  TARGET.flexi<>SOURCE.flexi
				THEN 
                  UPDATE SET 
						TARGET.stredisko=SOURCE.stredisko,
						TARGET.misto=SOURCE.misto,
						TARGET.uvazek=replace(SOURCE.uvazek,',','.'),
						TARGET.dd=convert(date,SOURCE.dd,104),
						TARGET.vystupDate=convert(date,SOURCE.vystupDate,104),
						TARGET.Plat=convert(money, replace(replace(replace(SOURCE.plat, ',00',''),' ',''),',','.')),
						TARGET.Plat2=convert(money, replace(replace(replace(SOURCE.plat2, ',00',''),' ',''),',','.')),
						TARGET.Plat3=convert(money, replace(replace(replace(SOURCE.plat3, ',00',''),' ',''),',','.')),
						TARGET.Premie=convert(money, replace(replace(replace(SOURCE.premie, ',00',''),' ',''),',','.')),
						TARGET.Mimoevidencni=SOURCE.Mimoevidencni,
						TARGET.pozice=SOURCE.pozice,
						TARGET.vzdelani=SOURCE.vzdelani,
						TARGET.rodStav=SOURCE.rodStav,
						TARGET.deti=SOURCE.deti,
						TARGET.stat=SOURCE.stat,
						TARGET.flexi=SOURCE.flexi,
						TARGET.Nadrizeny=COALESCE(SOURCE.Nadrizeny6, SOURCE.Nadrizeny5, SOURCE.Nadrizeny4, SOURCE.Nadrizeny3, SOURCE.Nadrizeny2, SOURCE.Nadrizeny1)

OUTPUT inserted.[id_magma], EOMONTH(getdate(),-2), deleted.[stredisko], inserted.[stredisko], deleted.[misto],  inserted.[misto], deleted.[uvazek], inserted.[uvazek], deleted.[dd], inserted.[dd],deleted.[vystupDate], inserted.[vystupDate], deleted.[Plat], inserted.[Plat], deleted.[Plat2], inserted.[Plat2], deleted.[Plat3], inserted.[Plat3], deleted.[Premie], inserted.[Premie], deleted.[Mimoevidencni], inserted.[Mimoevidencni],  deleted.[Pozice], inserted.[pozice], deleted.[vzdelani], inserted.[vzdelani], deleted.[rodStav], inserted.[rodStav],  deleted.[Deti], inserted.[Deti], deleted.[stat], inserted.[stat], deleted.[Nadrizeny], inserted.[nadrizeny], deleted.[flexi], inserted.[flexi] INTO t_log;
