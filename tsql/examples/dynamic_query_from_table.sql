/* Dynamic query from table example */

DECLARE @sql NVARCHAR(MAX)
	, @timestamp VARCHAR(20) =  REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(20), GETDATE(), 120), ':', ''), '-', ''), ' ', '_')
;

SELECT @sql =  COALESCE(@sql, N'') + N'
DROP TABLE IF EXISTS [dbo].[table_' + [name] + N'_' + @timestamp + N']
;
IF OBJECT_ID(N''[dbo].[table_' + [name] + N']'', N''U'') IS NOT NULL 
BEGIN
	SELECT * INTO [dbo].[table_' + [name] + N'_' + @timestamp + N']
	FROM [dbo].[table_' + [name] + N']
END
;
PRINT ''Backup data into [dbo].[table_' + [name] + N'_' + @timestamp + N']'';
;
DROP TABLE IF EXISTS [dbo].[table_' + [name] + N']
;
CREATE TABLE [dbo].[table_' + [name] + N']
(
	[key] INT IDENTITY(1, 1) PRIMARY KEY
	, [id] NVARCHAR(32) NOT NULL
	, [name] NVARCHAR(128) NULL
)
;
'
FROM
(
	SELECT N'A'
	UNION ALL SELECT N'B'
	UNION ALL SELECT N'C'

)L0 ([name])
;

PRINT CAST(@sql AS NTEXT);

EXECUTE sp_executesql @sql;