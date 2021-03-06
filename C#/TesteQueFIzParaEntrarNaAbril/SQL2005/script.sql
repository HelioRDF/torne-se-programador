USE [ExameAbril]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 04/06/2008 11:22:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NULL,
	[Category] [tinyint] NOT NULL,
	[Price] [float] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_Product_CreationDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User]    Script Date: 04/06/2008 11:23:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](80) NOT NULL,
	[Description] [varchar](255) NULL,
	[Theme] [varchar](30) NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_User_CreationDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 04/06/2008 11:22:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[CartId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[ProductId] [int] NOT NULL,
 CONSTRAINT [PK_Cart] PRIMARY KEY CLUSTERED 
(
	[CartId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProduct]    Script Date: 04/06/2008 11:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_GetProduct]
@ProductId int = null,
@Description varchar(255)  = null,
@Category tinyint = null
as
set nocount on
if(@Description is null) set @Description = ''

select ProductId, Description, Category, Price, CreationDate  
from Product 
where Productid = isNull(@ProductId, ProductId) and 
Description like '%' + @Description + '%' and 
Category = isNull(@Category, Category)
GO
/****** Object:  StoredProcedure [dbo].[usp_SaveProduct]    Script Date: 04/06/2008 11:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_SaveProduct]
@ProductId int = null,
@Description varchar(255)  = null,
@Category tinyint = null,
@Price float = null
as
set nocount on
if( @ProductId is null or @ProductId = 0 )
begin
	insert into Product (Description, Category, Price) 
	values (@Description, @Category, @Price) 
	select SCOPE_IDENTITY() as 'identity'
end
else 
begin
	update Product set 
	Description = @Description, 
	Category = @Category, 
	Price = @Price
	Where ProductId = @ProductId 
	select @ProductId
end
GO
/****** Object:  StoredProcedure [dbo].[usp_DelProduct]    Script Date: 04/06/2008 11:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_DelProduct]
@ProductId int = null
as
set nocount on
delete from Product 
where ProductId = isNull(@ProductId, ProductId)
GO
/****** Object:  StoredProcedure [dbo].[usp_DelUser]    Script Date: 04/06/2008 11:22:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_DelUser]
@UserId bigint = null
as
set nocount on
delete from [User] 
where UserId = isNull(@UserId, UserId)
GO
/****** Object:  StoredProcedure [dbo].[usp_SaveUser]    Script Date: 04/06/2008 11:22:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_SaveUser]
@UserId bigint = null,
@Name varchar(80)  = null,
@Description varchar(255)  = null,
@Theme varchar(30)  = null
as
set nocount on
if( @UserId is null or @UserId = 0 )
begin
	insert into [User] (Name, Description, Theme) 
	values (@Name, @Description, @Theme) 
	select SCOPE_IDENTITY() as 'identity'
end
else 
begin
	update [User] set Name = @Name, 
	Description = @Description, 
	Theme = @Theme
	Where UserId = @UserId 
	select @UserId
end
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUser]    Script Date: 04/06/2008 11:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_GetUser]
@UserId bigint = null,
@Name varchar(80)  = null,
@Description varchar(255)  = null,
@Theme varchar(30)  = null
as
set nocount on
select UserId, Name, Description, Theme, CreationDate from [User]
where UserId = isNull(@UserId, UserId) and 
Name = isNull(@Name, Name) and 
(Description = @Description or @Description is null) and 
Theme = isNull(@Theme, Theme)
GO
/****** Object:  StoredProcedure [dbo].[usp_SaveCart]    Script Date: 04/06/2008 11:22:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_SaveCart]
@CartId bigint = null,
@ProductId int = null,
@UserId bigint = null
as
set nocount on
if(not exists(select 1 from Cart where UserId = @UserId and ProductId = @ProductId))
	insert into Cart (UserId, ProductId) 
	values (@UserId, @ProductId)
GO
/****** Object:  StoredProcedure [dbo].[usp_DelCart]    Script Date: 04/06/2008 11:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_DelCart]
@CartId bigint = null,
@ProductId int = null,
@UserId bigint = null
as
set nocount on
delete from Cart 
where Cartid = isNull(@CartId, [CartId]) and 
UserId = isNull(@UserId, [UserId]) and 
ProductId = isNull(@ProductId, [ProductId])
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCart]    Script Date: 04/06/2008 11:22:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[usp_GetCart]
@CartId bigint = null,
@ProductId int = null,
@UserId bigint = null
as
set nocount on
select cartId, userId, productId from Cart 
where Cartid = isNull(@CartId, [CartId]) and 
UserId = isNull(@UserId, [UserId]) and 
ProductId = isNull(@ProductId, [ProductId])
order by cartId
GO
/****** Object:  ForeignKey [FK_Cart_Product]    Script Date: 04/06/2008 11:22:56 ******/
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_Product] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([ProductId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_Product]
GO
/****** Object:  ForeignKey [FK_Cart_User]    Script Date: 04/06/2008 11:22:57 ******/
ALTER TABLE [dbo].[Cart]  WITH CHECK ADD  CONSTRAINT [FK_Cart_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([UserId])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Cart] CHECK CONSTRAINT [FK_Cart_User]
GO
