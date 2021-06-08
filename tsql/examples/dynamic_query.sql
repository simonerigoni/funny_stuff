/* Dynamic query example */

DECLARE @sql NVARCHAR(MAX)
	, @test INT
;

SET @sql = N'SELECT @test = 1;';

SET @test = 0;

SELECT @test;

EXECUTE sp_executesql @sql, N'@test INT OUT', @test = @test OUT;

SELECT @test;
