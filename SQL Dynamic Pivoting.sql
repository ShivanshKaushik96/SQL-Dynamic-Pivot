
SELECT *
FROM Orders$;

SELECT *
FROM (SELECT DISTINCT Segment
                    ,[Sub-Category]
	                ,[Product ID]
      FROM Orders$) metrics
PIVOT (COUNT([Product ID]) FOR [Segment] IN ("Corporate", "Home Office", "Consumer")) piv;
SELECT DISTINCT Segment
FROM Orders$;



DECLARE @pivot_query NVARCHAR(MAX) = ''
       ,@distinct_values NVARCHAR(MAX) = '';

SELECT @distinct_values += QUOTENAME([Sub-Category]) + ','
FROM (SELECT DISTINCT [Sub-Category]
      FROM Orders$) alias;

SET @distinct_values = LEFT(@distinct_values, LEN(@distinct_values)-1);

SET @pivot_query = 'SELECT *
                    FROM (SELECT DISTINCT Category
                                ,[Sub-Category]
	                            ,[Product ID]
                          FROM Orders$) metrics
                    PIVOT (COUNT([Product ID]) FOR [Sub-Category] IN (' + @distinct_values + ')) piv;';

EXEC sp_executesql @pivot_query;





-- 1. create a PIVOT to display the average discount in each segment and category
DECLARE @pivot_query_1 NVARCHAR(MAX) = ''
       ,@distinct_values_1 NVARCHAR(MAX) = '';

SELECT @distinct_values_1 += QUOTENAME([Segment]) + ','
FROM (SELECT DISTINCT [Segment]
      FROM Orders$) alias;

SET @distinct_values_1 = LEFT(@distinct_values_1, LEN(@distinct_values_1)-1);

SET @pivot_query_1 = 'SELECT *
                      FROM (SELECT Category
                                  ,Segment
	                              ,Discount
                            FROM Orders$) metrics
                      PIVOT(AVG([Discount]) FOR [Segment] IN (' + @distinct_values_1 + ')) piv;';

EXEC sp_executesql @pivot_query_1;


-- 2. create a PIVOT to show number of products in each region and sub-category.
--	Resultant should have Region column and Sub-Category values as columns
DECLARE @pivot_query_2 NVARCHAR(MAX) = ''
       ,@distinct_values_2 NVARCHAR(MAX) = '';

SELECT @distinct_values_2 += QUOTENAME([Sub-Category]) + ','
FROM (SELECT DISTINCT [Sub-Category]
      FROM Orders$) alias;

SET @distinct_values_2 = LEFT(@distinct_values_2, LEN(@distinct_values_2)-1);

SET @pivot_query_2 = 'SELECT *
                      FROM (SELECT DISTINCT Region
                                 ,[Sub-Category]
	                             ,[Product ID]
                            FROM Orders$) metrics
                      PIVOT (COUNT([Product ID]) FOR [Sub-Category] IN (' + @distinct_values_2 + ')) piv;';

EXEC sp_executesql @pivot_query_2;

-- 3. create a PIVOT to show number of customers in each year in each segment
DECLARE @pivot_query_3 NVARCHAR(MAX) = ''
       ,@distinct_values_3 NVARCHAR(MAX) = '';

SELECT @distinct_values_3 += QUOTENAME([Segment]) + ','
FROM (SELECT DISTINCT [Segment]
      FROM Orders$) alias;

SET @distinct_values_3 = LEFT(@distinct_values_3, LEN(@distinct_values_3)-1);

SET @pivot_query_3 = 'SELECT *
                      FROM (SELECT DISTINCT YEAR([Order Date]) [Order Year]
                                 ,[Segment]
	                             ,[Customer ID]
                            FROM Orders$) metrics
                      PIVOT (COUNT([Customer ID]) FOR [Segment] IN (' + @distinct_values_3 + ')) piv;';

EXEC sp_executesql @pivot_query_3;

-- 4. create a PIVOT to show transactions by each customer in each Sub-Category
DECLARE @pivot_query_4 NVARCHAR(MAX) = ''
       ,@distinct_values_4 NVARCHAR(MAX) = '';

SELECT @distinct_values_4 += QUOTENAME([Sub-Category]) + ','
FROM (SELECT DISTINCT [Sub-Category]
      FROM Orders$) alias;

SET @distinct_values_4 = LEFT(@distinct_values_4, LEN(@distinct_values_4)-1);

SET @pivot_query_4 = 'SELECT *
                      FROM (SELECT [Sub-Category]
	                              ,[Customer ID]
                            FROM Orders$) metrics
                      PIVOT (COUNT([Sub-Category]) FOR [Sub-Category] IN (' + @distinct_values_4 + ')) piv;';

EXEC sp_executesql @pivot_query_4;

-- 5. create a PIVOT to show sales in each year and month. 
--	Resultant table should have Year column and Month names as columns
DECLARE @pivot_query_5 NVARCHAR(MAX) = ''
       ,@distinct_values_5 NVARCHAR(MAX) = '';

SELECT @distinct_values_5 += QUOTENAME([Order Month]) + ','
FROM (SELECT DISTINCT DATENAME(MONTH, [Order Date]) [Order Month]
      FROM Orders$) alias;

SET @distinct_values_5 = LEFT(@distinct_values_5, LEN(@distinct_values_5)-1);

SET @pivot_query_5 = 'SELECT *
                      FROM (SELECT YEAR([Order Date]) [Order Year]
	                              ,DATENAME(MONTH, [Order Date]) [Order Month]
		                          ,Sales
                            FROM Orders$) metrics
                      PIVOT (SUM(Sales) FOR [Order Month] IN (' + @distinct_values_5 + ')) piv;';

EXEC sp_executesql @pivot_query_5;