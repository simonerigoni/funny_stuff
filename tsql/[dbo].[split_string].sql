/* Splits a string list to a table. There is a SQL Server built-in function STRING_SPLIT but it requires the compatibility level to be at least 130.
	More in the following link https://docs.microsoft.com/en-us/sql/t-sql/functions/string-split-transact-sql

	Parameters:
		- @string_list NVARCHAR(MAX) string containing the entries     
		- @delimiter CHAR(1) string delimiter. The default value is ; 

	Returns:
		- @return_table TABLE([value]  NVARCHAR(MAX)) splitted values
*/

/* Drops */

DROP FUNCTION IF EXISTS [dbo].[split_string]
;
GO

/* Creates */

CREATE FUNCTION [dbo].[split_string]
(
	@string_list NVARCHAR(MAX)
	, @delimiter CHAR(1) = N';'
)
RETURNS @return_table TABLE ([value]  NVARCHAR(MAX))
AS
BEGIN
	DECLARE @next_entry NVARCHAR(MAX)
		, @delimiter_position INT
	;

	SET @delimiter_position = CHARINDEX(@delimiter, @string_list, 1);
	WHILE (@delimiter_position > 0)
	BEGIN
		SET @next_entry = SUBSTRING(@string_list, 1, @delimiter_position - 1); /* get the next entry */
		
		INSERT INTO @return_table
		SELECT @next_entry
		;

		SET @string_list = SUBSTRING(@string_list, @delimiter_position + 1, 999999); /*cut off the current entry from list*/

		SET @delimiter_position = CHARINDEX(@delimiter, @string_list, 1); /* get next position */
	END
	;

	/* insert last one */
	INSERT INTO @return_table
	SELECT @string_list
	;

	RETURN;
END
;
GO

/* Checks */

IF OBJECT_ID(N'[dbo].[split_string]', N'TF') IS NOT NULL
	PRINT N'Created [dbo].[split_string] function.';
ELSE
	PRINT N'WARNING: [dbo].[split_string] function was NOT created.';
;
GO

/* Tests */

IF 1 = 0
BEGIN
	DECLARE @stringa NVARCHAR(MAX) = N'clothing,road,,touring,bike'  
  
	/* STRING_SPLIT requires the compatibility level to be at least 130. To check compatibility level: SELECT [compatibility_level] FROM [sys].[databases] WHERE [name] = N'your_DB'; */
	--SELECT [value]  
	--FROM STRING_SPLIT(@stringa, N',')  
	--WHERE RTRIM([value]) != N'';
	--;

	SELECT [value]
	FROM [dbo].[split_string] (@stringa, N',')
	WHERE RTRIM([value]) != N'';
	;
END
;
GO





