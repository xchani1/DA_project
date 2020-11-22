
DECLARE @date DATE = '2017-01-01',
		@Exit_HPP_ZD INT,
		@Exit_HPP INT,
		@Exit_DPP INT,
		@Exit_DPC INT,
		@Exit_EPP INT

truncate table t_Exit
WHILE @date<=Getdate()

BEGIN
    SET @Exit_HPP_ZD = (SELECT count (*)
				FROM v_zamestnanec 
				WHERE (PP='HPP') AND (VystupDate=@date) AND vystupForma='754 Zrušení PP ve zkušební dobì                   ')
	SET @Exit_HPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='HPP') AND (VystupDate=@date))
	SET @Exit_DPC= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='DPÈ') AND (VystupDate=@date))
	SET @Exit_DPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='DPP') AND (VystupDate=@date)) 
	SET @Exit_EPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='EPP') AND (VystupDate=@date))
	INSERT INTO t_Exit ([Date], Exit_HPP_ZD, Exit_HPP, Exit_DPC, Exit_DPP, Exit_EPP) SELECT @Date, @Exit_HPP_ZD, @Exit_HPP, @Exit_DPC, @Exit_DPP, @Exit_EPP

      set @date = DATEADD(day, 1, @date)
END;

/*
use hrdata
select * from t_vystupForma
select * from t_Exit
*/
