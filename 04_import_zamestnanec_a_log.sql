use [hrdata]

--truncate table t_zamestnanec2
--truncate table t_log
--select * from t_zamestnanec2
--select * from t_log




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

/*
select * from t_log 
select * from t_zamestnanec2
select * from t_import
*/


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

/* puvodni insert s IDcky:

INSERT INTO [dbo].[t_zamestnanec]
           (id_magma, id_stredisko, id_misto, id_PP, uvazek, nastup, ZD, DD, VystupDate, 
		   Plat, Plat2, Plat3, Premie, Mimoevidencni, id_pozice, id_vystupForma, 
		   id_vystupDuv, id_vzdelani, id_rodStav, Deti, id_stat, flexi, DatNar, Pohlavi, Mandant)
     
	 SELECT
			i.ID, s.id_stredisko, m.id_misto, pp.id_PP, replace(i.uvazek,',','.'), 
			convert(date,i.nastup,104),  convert(date,i.zd,104), convert(date,i.dd,104),
			convert(date,i.vystupDate,104), replace(replace(replace(i.plat, ',00',''),' ',''),',','.'), 
			replace(replace(i.plat2, ',00',''),' ',''), replace(replace(i.plat3, ',00',''),' ',''), 
			replace(replace(i.premie, ',00',''),' ',''), i.mimoevidencni, p.id_pozice,
			f.id_vystupForma, d.id_vystupDuv, v.id_vzdelani, r.id_rodStav, i.deti, st.id_stat, 
			i.flexi, convert(date,i.datNar,104), i.Pohlavi, i.Mandant
			from t_import i
			left join t_stredisko s on s.stredisko=i.stredisko
			left join t_misto m on m.misto=i.misto
			left join t_pozice p on p.pozice=i.pozice
			left join t_pp pp on pp.pp=i.pp
			left join t_vystupForma f on f.vystupForma=i.vystupForma
			left join t_vystupDuv d on d.vystupDuv=i.vystupDuv
			left join t_vzdelani v on v.vzdelani=i.vzdelani
			left join t_rodStav r on r.rodStav=i.rodStav
			left join t_stat st on st.stat=i.stat

WHERE
			i.ID not in (SELECT id_magma from t_zamestnanec)
*/

/* puvodni insert do tabulky log:

INSERT INTO t_log (id_zamestnanec, platnost_do, stredisko_old, stredisko_new, misto_old, 
			misto_new, uvazek_old, uvazek_new, DD_old, DD_new, VystupDate_old, VystupDate_new, 
			Plat_old, Plat_new, Plat2_old, Plat2_new, Plat3_old, Plat3_new, Premie_old, Premie_new, 
			Mimoevidencni_old, Mimoevidencni_new, pozice_old, pozice_new, vzdelani_old, vzdelani_new, 
			rodStav_old, rodStav_new, Deti_old, Deti_new, stat_old, stat_new, nadrizeny_old, 
			nadrizeny_new, flexi_old, flexi_new)
	
	SELECT 
			z.id_magma, CAST (getdate() as date), z.stredisko, i.stredisko, z.misto, i.misto, 
			z.uvazek, i.uvazek, z.DD, convert(date,i.DD,104), z.vystupDate, convert(date,i.vystupDate,104), 
			CASE WHEN z.plat <> replace(replace(replace(i.plat, ',00',''),' ',''),',','.') THEN convert(money, z.plat) END as plat_old, 
			CASE WHEN z.plat <> replace(replace(replace(i.plat, ',00',''),' ',''),',','.') THEN convert(money, replace(replace(replace(i.plat, ',00',''),' ',''),',','.')) END as plat_new, 
			/*z.plat2, convert(money, i.plat2), z.plat3,convert(money, i.plat3), z.premie, convert(money, i.premie),*/ null, null, null, null, null, null, z.mimoevidencni, i.mimoevidencni, 
			z.pozice, i.pozice, z.vzdelani, i.vzdelani, z.rodStav, i.rodStav, z.deti, i.deti, z.stat, 
			i.stat, null, null, z.flexi, i.flexi
			
			
	FROM t_import i
	left join v_zamestnanec z on i.ID=z.id_magma
			
	
	WHERE
			i.stredisko<>z.stredisko
			or
			i.misto<>z.misto
			or
			convert(decimal(6,2),(replace(i.uvazek,',','.')))<>z.uvazek
			or
			convert(date, i.DD, 104)<>z.DD
			or
			convert(date, i.vystupDate, 104)<>z.vystupDate
			or
			replace(replace(replace(i.plat, ',00',''),' ',''),',','.')<>z.Plat
			or
			replace(replace(replace(i.plat2, ',00',''),' ',''),',','.')<>z.Plat2
			or
			replace(replace(replace(i.plat3, ',00',''),' ',''),',','.')<>z.Plat3
			or
			replace(replace(replace(i.premie, ',00',''),' ',''),',','.')<>z.Premie
			or
			i.rodStav<>z.rodStav
			or
			i.pozice<>z.pozice
			or
			i.mimoevidencni<>z.mimoevidencni
			or 
			i.deti<>z.deti
			or
			i.vzdelani<>z.vzdelani
			or
			i.flexi<>z.flexi

--select * from t_log
--select * FROM t_import i
	--left join v_zamestnanec z on i.ID=z.id_magma
	--where replace(replace(replace(i.plat, ',00',''),' ',''),',','.')=z.Plat and i.pozice<>z.pozice

*/


/* puvodni snaha o update, bohuzel nefunkcni- ke vsem zapisuje prvni nalezenou hodnotu:

update t_zamestnanec set id_stredisko=s.id_stredisko, id_misto=m.id_misto, 
		uvazek=i.uvazek, plat=replace(replace(replace(i.plat, ',00',''),' ',''),',','.'), 
		plat2=replace(replace(replace(i.plat2, ',00',''),' ',''),',','.'), plat3=replace(replace(replace(i.plat3, ',00',''),' ',''),',','.'), 
		premie=replace(replace(replace(i.premie, ',00',''),' ',''),',','.'),
		id_rodStav=r.id_rodStav, id_pozice=p.id_pozice, mimoevidencni=i.mimoevidencni, 
		deti=i.deti, id_stat=st.id_stat, id_vzdelani=v.id_vzdelani

	FROM t_import i
		left join v_zamestnanec z on i.ID=z.id_magma
		left join t_stredisko s on s.stredisko=i.stredisko
		left join t_misto m on m.misto=i.misto
		left join t_pozice p on p.pozice=i.pozice
		left join t_pp pp on pp.pp=i.pp
		left join t_vystupForma f on f.vystupForma=i.vystupForma
		left join t_vystupDuv d on d.vystupDuv=i.vystupDuv
		left join t_vzdelani v on v.vzdelani=i.vzdelani
		left join t_rodStav r on r.rodStav=i.rodStav
		left join t_stat st on st.stat=i.stat

	WHERE
		z.id_magma=i.id

--select * from t_zamestnanec
	
	
--insert vklada data do prazdnych bunek, update prepisuje
*/
