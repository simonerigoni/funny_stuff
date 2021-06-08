/* Remove forbidden characters 

	Parameters:
		- @text NVARCHAR(MAX) string containing forbidden characters 

	Returns:
		- @sanitized_text NVARCHAR(MAX) string without forbidden characters 
*/

/* Drops */

DROP FUNCTION IF EXISTS [dbo].[remove_forbidden_characters]
;
GO

/* Creates */

CREATE FUNCTION [dbo].[remove_forbidden_characters]
(
	@text NVARCHAR(MAX)
)  
RETURNS NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @result NVARCHAR(MAX) = @text;

	SELECT @result = CASE WHEN CHARINDEX([value], @text) > 0 THEN REPLACE(@result, [value], N'') ELSE @result END
	FROM ( VALUES (N'.'), (N','), (N';'), (N''''), (N':'), (N'/'), (N'\'), (N'*'), (N'|'), (N'?'), (N'"'), (N'&'), (N'%'), (N'$'), (N'!'), (N'+'), (N'='), (N'('), (N')'), (N'['), (N']'), (N'{'), (N'}'), (N'<'), (N'>') ) AS S ([value])
	;

	RETURN @result;
END
;  
GO

/* Checks */

IF OBJECT_ID(N'[dbo].[remove_forbidden_characters]', N'FN') IS NOT NULL
	PRINT N'Created [dbo].[remove_forbidden_characters] function.';
ELSE
	PRINT N'WARNING: [dbo].[remove_forbidden_characters] function was NOT created.';
;
GO

/* Tests */

IF 1 = 0
BEGIN
	DECLARE @stringa NVARCHAR(MAX) = N'pippo.,;'':/\*|paperino?"&%$!+=),)[]{}<>'')pluto'  
  
	SELECT [dbo].[remove_forbidden_characters] (@stringa)
	;
END
;
GO
