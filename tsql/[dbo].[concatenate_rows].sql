/* Concatenate the records of a table into a string list. There is a SQL Server built-in function STRING_AGG but it is available starting from SQL Server 2017.
	More in the following link https://docs.microsoft.com/en-us/sql/t-sql/functions/string-agg-transact-sql

	Parameters:
		- @input_table TABLE([value]  NVARCHAR(MAX)) records to concatenate 
		- @delimiter CHAR(1) string delimiter. The default value is ; 

	Returns:
		- @string_list NVARCHAR(MAX) string containing the entries  
*/

/* Drops */

DROP FUNCTION IF EXISTS [dbo].[concatenate_rows]
;
GO

DROP TYPE IF EXISTS LISTTABLETYPE;

CREATE TYPE LISTTABLETYPE AS TABLE ([value] NVARCHAR(MAX))
;
GO

/* Creates */

CREATE FUNCTION [dbo].[concatenate_rows]
(
	@input_table LISTTABLETYPE READONLY
	, @delimiter CHAR(1) = N';'
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @stringa NVARCHAR(MAX);

	SELECT @stringa = COALESCE(@stringa + N', ' + [Value], [Value]) 
	FROM @input_table
	
	RETURN @stringa;
END
;
GO

/* Checks */

IF OBJECT_ID(N'[dbo].[concatenate_rows]', N'FN') IS NOT NULL
	PRINT N'Created [dbo].[concatenate_rows] function.';
ELSE
	PRINT N'WARNING: [dbo].[concatenate_rows] function was NOT created.';
;
GO

/* Tests */

IF 1 = 0
BEGIN
	DECLARE @input_table LISTTABLETYPE
		, @stringa NVARCHAR(MAX)
	;

	SELECT * INTO [dbo].[#temp]
	FROM 
	(
		SELECT N'Pippo'
		UNION ALL SELECT N'Pluto'
		UNION ALL SELECT N'Paperino'
	
	) T([Value])
	;
	
	--SELECT * FROM [dbo].[#temp];

	INSERT @input_table
	SELECT [Value]
	FROM [dbo].[#temp]

	/* STRING_AGG requires SQL Server 2017 */
	--SELECT @stringa = REPLACE(STRING_AGG(ISNULL([Value], N' '), ','), N',', N', ')
	--FROM [dbo].[#temp]
	--;

	SELECT @stringa = [dbo].[concatenate_rows] (@input_table, N';');

	PRINT @stringa;

	DROP TABLE [dbo].[#temp];
END
;
GO





