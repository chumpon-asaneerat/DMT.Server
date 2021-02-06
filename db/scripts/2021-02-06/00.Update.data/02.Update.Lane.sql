-- Change TSBId
UPDATE Lane
   SET TSBId = '01'
 WHERE TSBId = '311'

GO

UPDATE Lane
   SET TSBId = '09'
 WHERE TSBId = '319'

GO

-- Change PlazaId (DINDANG)
UPDATE Lane
   SET PlazaId = '011'
 WHERE TSBId = '01'
   AND PlazaId = '3101'

GO

UPDATE Lane
   SET PlazaId = '012'
 WHERE TSBId = '01'
   AND PlazaId = '3102'

GO

-- Change PlazaId (ANUSORNSATHAN)
UPDATE Lane
   SET PlazaId = '091'
 WHERE TSBId = '09'
   AND PlazaId = '3115'

GO

UPDATE Lane
   SET PlazaId = '092'
 WHERE TSBId = '09'
   AND PlazaId = '3116'

GO

-- Change TSBId, PlazaId (SUTHISARN)
UPDATE Lane
   SET TSBId = '02'
     , PlazaId = '021'
 WHERE PlazaId = '3103'

GO

-- Change TSBId, PlazaId (LADPROD)
UPDATE Lane
   SET TSBId = '03'
     , PlazaId = '031'
 WHERE PlazaId = '3104'

GO

UPDATE Lane
   SET TSBId = '03'
     , PlazaId = '032'
 WHERE PlazaId = '3105'

GO
