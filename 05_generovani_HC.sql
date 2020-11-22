
DECLARE @date DATE = '2017-01-01',
		@HC_HPP_ZD INT,
		@HC_HPP INT,
		@HC_DPP INT,
		@HC_DPC INT,
		@HC_EPP INT

truncate table t_HC
WHILE @date<=Getdate()

BEGIN
   SET @HC_HPP_ZD = (SELECT count (*)
				FROM v_zamestnanec 
				WHERE (PP='HPP') AND (nastup<=@date) AND (ZD>=@date) and (ZD is not null))
	SET @HC_HPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='HPP') AND (nastup<=@date) AND ((VystupDate>=@date) or (VystupDate is null)))
	SET @HC_DPC= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='DPÈ') AND (nastup<=@date) AND ((VystupDate>=@date) or (VystupDate is null)))
	SET @HC_DPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='DPP') AND (nastup<=@date) AND ((VystupDate>=@date) or (VystupDate is null)))
	SET @HC_EPP= (SELECT count (*)
			FROM v_zamestnanec
			WHERE (PP='EPP') AND (nastup<=@date) AND ((VystupDate>=@date) or (VystupDate is null)))
	INSERT INTO t_HC ([Date], HC_HPP_ZD, HC_HPP, HC_DPC, HC_DPP, HC_EPP) SELECT @Date, @HC_HPP_ZD, @HC_HPP, @HC_DPC, @HC_DPP, @HC_EPP

      set @date = DATEADD(day, 1, @date)
END;

/*
use hrdata
select * from v_zamestnanec
select * from t_HC
*/

--doresit, aby se data a HC jen dopisoval (nebo to projedem vzdy znovu, kdyby se data o HC zmenily?)