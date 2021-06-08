/* Nested cursors example
	https://docs.microsoft.com/en-us/sql/t-sql/language-elements/declare-cursor-transact-sql?view=sql-server-ver15
*/

DECLARE @vendor_id INT
	, @vendor_name NVARCHAR(50)
	, @message VARCHAR(80)
	, @product NVARCHAR(50)
;  

SELECT * INTO [dbo].[#temp_vendor]
FROM
(
	SELECT 1, N'Pippo', 1
	UNION ALL SELECT 2, N'Pluto', 1
	UNION ALL SELECT 3, N'Paperino', 0
	UNION ALL SELECT 4, N'Topolino', 1
) L0 ([key], [name], [preferred])
;

SELECT * INTO [dbo].[#temp_product]
FROM
(
	SELECT 1, N'A', 1
	UNION ALL SELECT 2, N'B', 1
	UNION ALL SELECT 3, N'C', 1
	UNION ALL SELECT 4, N'D', 1
	UNION ALL SELECT 5, N'E', 2
	UNION ALL SELECT 6, N'F', 2

) L0 ([key], [name], [vendor])
;
  
PRINT N'---- Vendor Products Report ----';  
  
DECLARE vendor_cursor CURSOR FOR   
	SELECT [key]
		, [name] 
	FROM [dbo].[#temp_vendor] 
	WHERE [preferred] = 1  
	;  
;

OPEN vendor_cursor;
  
FETCH NEXT FROM vendor_cursor   
INTO @vendor_id, @vendor_name  
;

WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT N' '  
    SELECT @message = N'-- Products From Vendor: ' +  @vendor_name;
  
    PRINT @message;
   
    DECLARE product_cursor CURSOR FOR   
		SELECT P.[name]  
		FROM [dbo].[#temp_vendor] V
		INNER JOIN [dbo].[#temp_product] P
			ON V.[key] = P.[vendor]
		WHERE V.[key] = @vendor_id
		;
	;

    OPEN product_cursor ;
    FETCH NEXT FROM product_cursor INTO @product;
  
    IF @@FETCH_STATUS <> 0   
        PRINT N'	<<None>>';      
	;

    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        SELECT @message = N'	' + @product;
        PRINT @message;
        FETCH NEXT FROM product_cursor INTO @product;
    END  
	;
    CLOSE product_cursor; 
    DEALLOCATE product_cursor;
	
    FETCH NEXT FROM vendor_cursor   
    INTO @vendor_id, @vendor_name 
	;
END   
;
CLOSE vendor_cursor;  
DEALLOCATE vendor_cursor;  

DROP TABLE [dbo].[#temp_vendor];
DROP TABLE [dbo].[#temp_product];
