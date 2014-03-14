CREATE TABLE [Template_Billing] (
	[SelfId] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[BillId] [numeric](18, 0) NULL ,
	[BillCode] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[ProjectId] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[ProjectName] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[BillAddressId] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[BillAddress] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[BillDate] [datetime] NULL ,
	[Amount] [numeric](18, 2) NULL ,
	[CreateUser] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[InvoiceId] [numeric](18, 0) NULL ,
	[InvoiceCode] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[InvoiceAmount] [numeric](18, 2) NULL ,
	CONSTRAINT [PK_Template_Billing] PRIMARY KEY  CLUSTERED 
	(
		[SelfId]
	)  ON [PRIMARY] 
) ON [PRIMARY]
Go

CREATE TABLE [Template_CAF] (
	[SelfId] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[StaffId] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[StaffName] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[ProjectId] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[ProjectName] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[CAFDate] [datetime] NULL ,
	[WorkingHours] [numeric](18, 4) NULL ,
	[ServiceTypeId] [numeric](18, 0) NULL ,
	[ServiceTypeName] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[BillId] [numeric](18, 0) NULL ,
	[BillCode] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[Rate] [numeric](18, 8) NULL ,
	[ProjectEventId] [numeric](18, 0) NULL ,
	[ProjectEventName] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[Status] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[CreateUser] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [PK_Template_CAF] PRIMARY KEY  CLUSTERED 
	(
		[SelfId]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

CREATE TABLE [Template_Staff] (
	[SelfId] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[StaffNameInPRM] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	[StaffNameInPAS] [varchar] (255) COLLATE Chinese_PRC_CI_AS NULL ,
	[StaffId] [varchar] (50) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [PK_Template_Staff] PRIMARY KEY  CLUSTERED 
	(
		[SelfId]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO