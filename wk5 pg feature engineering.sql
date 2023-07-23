-- 1.Create a new table with one-hot encoded variables
CREATE TABLE property_sales_encoded AS
SELECT
    Id,
    MSSubClass,
    LotShape,
    LandContour,
    LandSlope,
    HouseStyle,
    OverallQual,
    OverallCond,
    LotFrontage,
    LotArea,
    GarageArea,
    GrLivArea,
    TotalBsmtSF,
    SalePrice,
    CASE WHEN BldgType = 'Single-family Detached' THEN 1 ELSE 0 END AS BldgType_SingleFamilyDetached,
    CASE WHEN BldgType = 'Two story' THEN 1 ELSE 0 END AS BldgType_TwoStory,
    CASE WHEN BldgType = 'Townhouse Inside Unit' THEN 1 ELSE 0 END AS BldgType_TownhouseInsideUnit,
    CASE WHEN BldgType = 'Duplex' THEN 1 ELSE 0 END AS BldgType_Duplex,
    --CASE WHEN BldgType = 'Two-family Conversion; originally built as one-family dwelling' THEN 1 ELSE 0 END AS BldgType_TwoFamilyConversion,
    CASE WHEN BldgType = 'Townhouse End Unit' THEN 1 ELSE 0 END AS BldgType_TownhouseEndUnit
FROM property_sales;


select *
from property_sales_encoded

-- 2.Create a new table with label encoded variables
CREATE TABLE property_sales_encoded2 AS
SELECT
    Id,
    MSSubClass,
    LOWER(LotShape) AS LotShape,
    CASE
        WHEN LOWER(LotShape) = 'regular' THEN 1
        WHEN LOWER(LotShape) = 'irregular' THEN 2
        WHEN LOWER(LotShape) = 'moderately irregular' THEN 3
        WHEN LOWER(LotShape) = 'slightly irregular' THEN 4
    END AS LotShape_encoded,
    LOWER(LandContour) AS LandContour,
    CASE
        WHEN LOWER(LandContour) = 'depression' THEN 1
        WHEN LOWER(LandContour) = 'hillside - significant slope from side to side' THEN 2
        WHEN LOWER(LandContour) = 'banked - quick and significant rise from street grade to building' THEN 3
        WHEN LOWER(LandContour) = 'near flat/level' THEN 4
    END AS LandContour_encoded,
    LOWER(LandSlope) AS LandSlope,
    CASE
        WHEN LOWER(LandSlope) = 'gentle slope' THEN 1
        WHEN LOWER(LandSlope) = 'moderate slope' THEN 2
		WHEN LOWER(LandSlope) = 'severe slope' THEN 3
		
    END AS LandSlope_encoded,
    LOWER(BldgType) AS BldgType,
    CASE
        WHEN LOWER(BldgType) = 'single-family detached' THEN 1
        WHEN LOWER(BldgType) = 'townhouse inside unit' THEN 2
        WHEN LOWER(BldgType) = 'duplex' THEN 3
        WHEN LOWER(BldgType) = 'two-family conversion; originally built as one-family dwelling' THEN 4
        WHEN LOWER(BldgType) = 'townhouse end unit' THEN 5
    END AS BldgType_encoded,
    HouseStyle,
    OverallQual,
    OverallCond,
    LotFrontage,
    LotArea,
    GarageArea,
    GrLivArea,
    TotalBsmtSF,
    SalePrice
FROM property_sales;

select *
from property_sales_encoded2


select distinct lotshape
from property_sales


select distinct landcontour
from property_sales


select distinct landslope
from property_sales



select distinct bldgtype
from property_sales



--3. Perform Mean encoding on one or more Categorical Variables in the dataset 
SELECT 
    Id, 
    MSSubClass, 
    LotShape, 
    LandContour, 
    LandSlope, 
    BldgType, 
    HouseStyle, 
    OverallQual, 
    OverallCond, 
    LotFrontage, 
    LotArea, 
    GarageArea, 
    GrLivArea, 
    TotalBsmtSF, 
    SalePrice,
    -- Mean encoding for MSSubClass
    AVG(SalePrice) OVER (PARTITION BY MSSubClass) AS Mean_MSSubClass,
    -- Mean encoding for LotShape
    AVG(SalePrice) OVER (PARTITION BY LotShape) AS Mean_LotShape,
    -- Mean encoding for LandContour
    AVG(SalePrice) OVER (PARTITION BY LandContour) AS Mean_LandContour,
    -- Mean encoding for LandSlope
    AVG(SalePrice) OVER (PARTITION BY LandSlope) AS Mean_LandSlope,
    -- Mean encoding for BldgType
    AVG(SalePrice) OVER (PARTITION BY BldgType) AS Mean_BldgType,
    -- Mean encoding for HouseStyle
    AVG(SalePrice) OVER (PARTITION BY HouseStyle) AS Mean_HouseStyle
FROM property_sales;



--4.Perform Mean Normalization on all the numeric variables to rescale these variables 
--(you may add new columns for this)

SELECT
    Id, 
    MSSubClass, 
    LotShape, 
    LandContour, 
    LandSlope, 
    BldgType, 
    HouseStyle, 
    OverallQual, 
    OverallCond,
    LotFrontage,
  	(LotFrontage - avg (LotFrontage) OVER ()) /(	max (LotFrontage) OVER ()- min (LotFrontage) OVER ()) AS meannormfrontage,
 	LotArea,
 	(LotArea - avg (LotArea) OVER ()) /	(max (LotArea) OVER ()- min (LotArea) OVER ()) AS meannormlotarea,
  	GarageArea,
  	(GarageArea - avg (GarageArea) OVER ()) /	(max (GarageArea) OVER ()- min (GarageArea) OVER ()) AS meannormgaragearea,
 	GrLivArea,
  	(GrLivArea - avg (GrLivArea) OVER ()) /	(max (GrLivArea) OVER ()- min (GrLivArea) OVER ()) AS meannormGrLivArea,
	TotalBsmtSF,
 	(TotalBsmtSF - avg (TotalBsmtSF) OVER ()) /	(max (TotalBsmtSF) OVER ()- min (TotalBsmtSF) OVER ()) AS meannormTotalBsmtSF,
	SalePrice,
 	(SalePrice - avg (SalePrice) OVER ()) /	(max (SalePrice) OVER ()- min (SalePrice) OVER ()) AS meannormSalePrice


FROM property_sales
GROUP BY  Id, 
    MSSubClass, 
    LotShape, 
    LandContour, 
    LandSlope, 
    BldgType, 
    HouseStyle, 
    OverallQual, 
    OverallCond,
	LotFrontage,
	LotArea,
	GarageArea,
 	GrLivArea,
	TotalBsmtSF,
	SalePrice



;



--5. Perform Standardization on all the numeric variables to rescale these variables 
--(you may add new columns for this)
SELECT
    Id, 
    MSSubClass, 
    LotShape, 
    LandContour, 
    LandSlope, 
    BldgType, 
    HouseStyle, 
    OverallQual, 
    OverallCond,
    (LotFrontage-avg(LotFrontage) OVER ()) / STDDEV_SAMP(LotFrontage) OVER () AS Normalizedfrontage,
	(LotArea-avg(LotArea) OVER ()) / STDDEV_SAMP(LotArea) OVER () AS NormalizedLotArea,
	(GarageArea-avg(GarageArea) OVER ()) / STDDEV_SAMP(GarageArea) OVER () AS NormalizedGarageArea,
	(GrLivArea-avg(GrLivArea) OVER ()) / STDDEV_SAMP(GrLivArea) OVER () AS NormalizedGrLivArea,
	(TotalBsmtSF-avg(TotalBsmtSF) OVER ()) / STDDEV_SAMP(TotalBsmtSF) OVER () AS NormalizedTotalBsmtSF,
	(SalePrice-avg(SalePrice) OVER ()) / STDDEV_SAMP(SalePrice) OVER () AS Normalizedsaleprice
FROM
    property_sales;




--DRAFT ONLY MIN MAX
--error ??
/*
SELECT
    Id, 
    MSSubClass, 
    LotFrontage,
    round((LotFrontage - MIN(LotFrontage) OVER ()) / (MAX(LotFrontage) OVER () - MIN(LotFrontage) OVER ()),2) AS minmaxfrontage
FROM
    property_sales;

*/