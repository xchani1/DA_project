USE [hrdata]

/*
truncate table t_misto
truncate table t_pozice
truncate table t_PP
truncate table t_rodStav
truncate table t_stat
truncate table t_stredisko
truncate table t_vystupDuv
truncate table t_vystupForma
truncate table t_vzdelani
*/


--SELECT * FROM [dbo].[t_import]

INSERT INTO [dbo].[t_pozice]
           ([pozice])
     SELECT
			distinct pozice from t_import 
	 WHERE
			pozice is not null AND pozice not in (SELECT pozice from t_pozice)
GO

--SELECT * FROM t_pozice

INSERT INTO .[dbo].[t_PP]
           ([PP])
     SELECT
			distinct [PP] from t_import 
	 WHERE
			PP is not null AND PP not in (SELECT PP from t_PP)
GO

--select * from t_PP

INSERT INTO [dbo].[t_rodStav]
           ([rodStav])
     SELECT
			distinct rodStav from t_import 
	 WHERE
			rodStav is not null and rodStav!='0' AND rodStav not in (SELECT rodStav from t_rodStav)
GO
--select * from t_rodStav

INSERT INTO [dbo].[t_stat]
           ([stat])
     SELECT
			distinct stat from [hrdata].[dbo].[t_import]
	 WHERE
			stat is not null AND stat not in (SELECT stat from t_stat)
GO

--select * from t_stat

--ciselnik stredisek

INSERT INTO [dbo].[t_stredisko]
           ([stredisko])
     SELECT
			distinct stredisko from t_import 
	 WHERE
			stredisko is not null AND stredisko!='' AND stredisko not in (SELECT stredisko from t_stredisko)
GO

--select * from t_stredisko

--ciselnik vzdelani

INSERT INTO [dbo].[t_vzdelani]
           ([vzdelani])
     SELECT
			distinct vzdelani from [hrdata].[dbo].[t_import] 
	 WHERE
			vzdelani is not null AND vzdelani!='' AND vzdelani not in (SELECT vzdelani from t_vzdelani)
GO

--select * from t_vzdelani

--zamestnancem uvedeny duvod vystupu

INSERT INTO [dbo].[t_vystupDuv]
           ([vystupDuv])
     SELECT
			distinct vystupDuv from [hrdata].[dbo].[t_import] 
	 WHERE
			vystupDuv is not null AND vystupDuv!='0' and vystupDuv not in (SELECT vystupDuv from t_vystupDuv)
GO

--select * from t_vystupDuv

-- zakonna forma vystupu

INSERT INTO [dbo].[t_vystupForma]
           ([vystupForma])
     SELECT
			distinct vystupForma from t_import
	 WHERE
			vystupForma is not null AND vystupForma!='0' and vystupForma not in (SELECT vystupForma from t_vystupForma)
GO

--select * from t_vystupForma

--misto vykonu 

INSERT INTO [dbo].[t_misto]
           ([misto])
     SELECT
			distinct misto from t_import
	 WHERE
			misto is not null and misto not in (SELECT misto from t_misto)
GO

--select * from t_misto

--puvodni select na ciselnik misto a stat zaroven (byl stale problem s duplicitami - nekde stat nevyplnen, takze pak bylo misto vs. stat 1 a misto vs. stat Null)
/* INSERT INTO [dbo].[t_misto]
           ([misto], [id_stat])
     
	 SELECT
			distinct i.misto,s.id_stat from t_import i
			left join t_stat s on s.stat=i.stat

	 WHERE
			i.misto is not null and i.misto not in (SELECT misto from t_misto)
GO

- kdyz tam dame where i.stat is not null tak zase o nektera mista uplne prijdeme jelikoz je mame pouze v kombinaci se statem NULL - doresit
select * from t_misto */









