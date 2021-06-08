/* Print the given text. The SQL Server built-in PRINT can handle a message string up to 8000 characters long if it is a non-Unicode string, and 4000
	characters long if it is a Unicode string. Longer strings are truncated. The VARCHAR(MAX) and NVARCHAR(MAX) data types are truncated to data 
	types that are no larger than VARCHAR(8000) and NVARCHAR(4000).
	More in the following link https://docs.microsoft.com/en-us/sql/t-sql/language-elements/print-transact-sql

	Parameters:
		- @text NVARCHAR(MAX) string to print

	Returns:
		- None
*/

/* Drops */

DROP PROCEDURE IF EXISTS [dbo].[print]
;
GO

/* Creates */

CREATE PROCEDURE [dbo].[print]
(
	@text NVARCHAR(MAX)
)  
AS
BEGIN  
	PRINT CAST(@text AS NTEXT);
END
;  
GO

/* Checks */

IF OBJECT_ID(N'[dbo].[print]', N'P') IS NOT NULL
	PRINT N'Created [dbo].[print] stored procedure.';
ELSE
	PRINT N'WARNING: [dbo].[print] stored procedure was NOT created.';
;
GO

/* Tests */

IF 1 = 0
BEGIN
	PRINT N'aaaa';
	
	EXECUTE [dbo].[print] N'aaaa'
END
;
GO
