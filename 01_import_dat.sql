use hrdata
truncate table t_import

BULK INSERT t_import FROM 'C:\Users\alena.novotna\Desktop\soukr\DA_2020\Projekt\_data\unicode\102020_CZ.csv'
WITH (
DATAFILETYPE = 'widechar',
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)

BULK INSERT t_import FROM 'C:\Users\alena.novotna\Desktop\soukr\DA_2020\Projekt\_data\unicode\102020_EU.csv'
WITH (
DATAFILETYPE = 'widechar',
FIELDTERMINATOR = ';',
ROWTERMINATOR = '\n',
FIRSTROW = 2
)

update t_import SET ID=convert(int, ID)+1000000 WHERE Mandant='MAND30'