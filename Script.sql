IF OBJECT_ID('[dbo].[Game]') IS NULL
BEGIN
	CREATE TABLE [dbo].[Game](
		[GameId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[GameName] [varchar](255) NOT NULL,
		[CreatedDateTime] [datetime] NOT NULL,
		[CreatedBy] [varchar](255) NOT NULL
	) ON [PRIMARY]
END

IF OBJECT_ID('[dbo].[Users]') IS NULL
BEGIN
	CREATE TABLE [dbo].[Users](
		[UserId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[UserName] [varchar](255) NOT NULL,
		[EmailId] [varchar](50) NOT NULL,
		[Password] [varchar](20) NOT NULL,
		[CreatedDateTime] [datetime] NOT NULL,
		[CreatedBy] [varchar](255) NOT NULL
	) ON [PRIMARY]
END

IF OBJECT_ID('[dbo].[Session]') IS NULL
BEGIN
	CREATE TABLE [dbo].[Session](
		[SessionId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[GameId] [int]  NOT NULL,-- FOREIGN KEY REFERENCES Game(GameID),
		[UserId] [int] NOT NULL,-- FOREIGN KEY REFERENCES Users(UserID),
		[GSStart] [dateTime] NOT NULL,
		[GSStop] [dateTime] NOT NULL
	) ON [PRIMARY]
END

DECLARE @iterator [int],
		@SQL [nvarchar](MAX),
		@MultiIterator [int],
		@MaxIterator [int],
		@TotalSession [int],
	    @ValidSession [int];

SET @SQL = 'INSERT INTO [dbo].[Game]
           ([GameName]
           ,[CreatedDateTime]
           ,[CreatedBy])
			VALUES'

SET @iterator = 0
WHILE @iterator <= 500
BEGIN
	SET @SQL = @SQL + '('+'''GameName - '''+ '+CAST('+CAST(@iterator AS VARCHAR(4))+' AS VARCHAR(4))'+
           ','+'GETDATE()'+
           ','+'''Lokendra J'''+'),'

	SET @iterator = @iterator + 1
END

SET @SQL = SUBSTRING(@SQL,0,LEN(@SQL))

EXEC(@SQL)

SET @SQL = 'INSERT INTO [dbo].[Users]
           ([UserName]
           ,[EmailId]
           ,[Password]
           ,[CreatedDateTime]
           ,[CreatedBy])
			VALUES'

SET @iterator = 0
WHILE @iterator <= 500
BEGIN
	SET @SQL = @SQL + '('+'''UserName - '''+ '+CAST('+CAST(@iterator AS VARCHAR(4))+' AS VARCHAR(4))'+
		   ','+'''EmailId - '''+ '+CAST('+CAST(@iterator AS VARCHAR(4))+' AS VARCHAR(4))'+
		   ','+'''Pass@ '''+ '+CAST('+CAST(@iterator AS VARCHAR(4))+' AS VARCHAR(4))'+
           ','+'GETDATE()'+
           ','+'''Lokendra J'''+'),'

	SET @iterator = @iterator + 1
END

SET @SQL = SUBSTRING(@SQL,0,LEN(@SQL))

EXEC(@SQL)

SET @MaxIterator = ABS(Checksum(NewID()) % 20)+3
SET @MultiIterator = 1

WHILE @MultiIterator < @MaxIterator
BEGIN
	SET @SQL = 'INSERT INTO [dbo].[Session]
	           ([GameId]
	           ,[UserId]
	           ,[GSStart]
	           ,[GSStop])
			    VALUES'
	
	SET @iterator = 1
	WHILE @iterator <= 300
	BEGIN
		SET @SQL = @SQL + '('+'ABS(Checksum(NewID()) % 501)'+
			   ','+'ABS(Checksum(NewID()) % 501)'+
			   ','+'GETDATE()'+
	           ','+'DATEADD(second,ABS(Checksum(NewID()) % 100),GETDATE())'+'),'
	
		SET @iterator = @iterator + 1
	END
	
	SET @SQL = SUBSTRING(@SQL,0,LEN(@SQL))
	
	EXEC (@SQL)
	SET @MultiIterator = @MultiIterator + 1
END

;WITH SecondsDetails AS(
SELECT DATEDIFF(second,[GSStart],[GSStop]) AS [Seconds]
	  ,COUNT([SessionId]) AS [Count]
  FROM [master].[dbo].[Session]
  GROUP BY DATEDIFF(second,[GSStart],[GSStop])
  )

  SELECT @ValidSession = SUM(Count) FROM [SecondsDetails]
  WHERE [Seconds] >= 60 AND [Seconds] IS NOT NULL

;WITH SecondsDetails AS(
SELECT DATEDIFF(second,[GSStart],[GSStop]) AS [Seconds]
	  ,COUNT([SessionId]) AS [Count]
  FROM [master].[dbo].[Session]
  GROUP BY DATEDIFF(second,[GSStart],[GSStop])
  )
 SELECT @TotalSession = SUM(Count) FROM [SecondsDetails]

 SELECT @TotalSession AS TotalSession, @ValidSession AS ValidSession


IF OBJECT_ID('[dbo].[Session]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[Session] 
END

IF OBJECT_ID('[dbo].[Game]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[Game]
END

IF OBJECT_ID('[dbo].[Users]') IS NOT NULL
BEGIN
	DROP TABLE [dbo].[Users]
END

