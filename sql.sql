USE [master]
GO
/****** Object:  Database [QuanLyTaiSanCtyDATN_2021]    Script Date: 2/19/2025 10:55:56 PM ******/
CREATE DATABASE [QuanLyTaiSanCtyDATN_2021]
 CONTAINMENT = NONE

GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyTaiSanCtyDATN_2021].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET QUERY_STORE = ON
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [QuanLyTaiSanCtyDATN_2021]
GO
/****** Object:  User [WebDatabaseUser]    Script Date: 2/19/2025 10:55:56 PM ******/
CREATE USER [WebDatabaseUser] FOR LOGIN [IIS APPPOOL\DefaultAppPool] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [WebDatabaseUser]
GO
/****** Object:  UserDefinedFunction [dbo].[splitstring]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[splitstring] ( @stringToSplit VARCHAR(MAX) )
RETURNS
 @returnList TABLE ([Name] [nvarchar] (500))
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)

  INSERT INTO @returnList 
  SELECT @name

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END



GO
/****** Object:  Table [dbo].[Credential]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credential](
	[UserGroupID] [varchar](20) NOT NULL,
	[RoleID] [varchar](50) NOT NULL,
	[ID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_Credential] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC,
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DestructivelDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DestructivelDevice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceId] [int] NULL,
	[DateOfDestructive] [date] NULL,
	[TypeOfDestructive] [int] NULL,
	[AddressOfDestructive] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[Notes] [nvarchar](1000) NULL,
	[CreatedDate] [date] NULL,
 CONSTRAINT [PK_CancelDevice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DestructiveType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DestructiveType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](100) NULL,
	[Notes] [nvarchar](1000) NULL,
 CONSTRAINT [PK_CancelType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Device]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Device](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceCode] [char](50) NULL,
	[DeviceName] [nvarchar](200) NULL,
	[TypeOfDevice] [int] NULL,
	[ParentId] [int] NULL,
	[Configuration] [nvarchar](500) NULL,
	[Price] [float] NULL,
	[PurchaseContract] [nvarchar](500) NULL,
	[DateOfPurchase] [date] NULL,
	[SupplierId] [int] NULL,
	[Guarantee] [date] NULL,
	[UserId] [int] NULL,
	[Notes] [nvarchar](2000) NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[Status] [int] NULL,
	[IsDeleted] [bit] NULL,
	[StatusRepair] [int] NULL,
	[NewCode] [char](50) NULL,
	[DeviceNameEnglish] [nvarchar](200) NULL,
	[DeviceModel] [nvarchar](100) NULL,
	[DeviceSeria] [nvarchar](100) NULL,
	[DateAdded] [date] NULL,
 CONSTRAINT [PK_Device] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceDevice](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceCodeParents] [int] NULL,
	[DeviceCodeChildren] [int] NULL,
	[TypeSymbolParents] [int] NULL,
	[TypeSymbolChildren] [int] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[IsDeleted] [bit] NULL,
	[Notes] [nvarchar](500) NULL,
	[TypeComponant] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceFile]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceFile](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceId] [int] NULL,
	[DeviceCode] [char](50) NULL,
	[FileNames] [varchar](255) NULL,
	[FileSize] [varchar](100) NULL,
	[FileContent] [varchar](7000) NULL,
	[FileType] [varchar](30) NULL,
	[FileStatus] [char](1) NULL,
	[FileLocal] [varchar](300) NULL,
	[IsDelete] [char](1) NULL,
	[CreateUser] [varchar](100) NULL,
	[CreateDate] [date] NULL,
	[ModifiedUser] [varchar](100) NULL,
	[ModifiedDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceOfProject](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[DeviceId] [int] NULL,
	[DateOfDelivery] [date] NULL,
	[DateOfReturn] [date] NULL,
	[Status] [int] NULL,
	[Notes] [nvarchar](2000) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_DeviceOfProject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceSparePart](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SparePartName] [nvarchar](200) NULL,
	[SparePartCode] [char](50) NULL,
	[DeviceType] [int] NULL,
	[TotalSparePart] [int] NULL,
	[RemainingAmount] [int] NULL,
	[DateAdded] [date] NULL,
	[Notes] [nvarchar](400) NULL,
	[Config] [nvarchar](400) NULL,
	[Amount] [decimal](18, 0) NULL,
	[CreateDate] [date] NULL,
	[CreateUser] [nvarchar](50) NULL,
	[Isdelete] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceSparePartHistory]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceSparePartHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SparePartId] [int] NULL,
	[NumSparePart] [int] NULL,
	[TransType] [char](20) NULL,
	[DateAdded] [date] NULL,
	[Notes] [nvarchar](400) NULL,
	[CreateDate] [date] NULL,
	[CreateUser] [nvarchar](50) NULL,
	[Isdelete] [int] NULL,
	[Amount] [decimal](18, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](100) NULL,
	[TypeSymbol] [nchar](50) NULL,
	[Notes] [nvarchar](1000) NULL,
	[OrderCode] [int] NULL,
 CONSTRAINT [PK_DeviceType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceTypeComponantType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceTypeComponantType](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[TypeSymbolParents] [int] NULL,
	[TypeSymbolChildren] [int] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[UserCreated] [int] NULL,
	[UserModified] [int] NULL,
	[IsDeleted] [bit] NULL,
	[TypeComponant] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProjectDKC]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectDKC](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectName] [nvarchar](200) NULL,
	[ProjectSymbol] [nchar](50) NULL,
	[ManagerProject] [int] NULL,
	[Address] [nvarchar](1000) NULL,
	[FromDate] [date] NULL,
	[ToDate] [date] NULL,
	[CreatedDate] [date] NULL,
	[ModifiedDate] [date] NULL,
	[Status] [int] NULL,
	[IsDeleted] [bit] NULL,
	[TypeProject] [int] NULL,
	[ParentId] [int] NULL,
	[HasChild] [int] NULL,
 CONSTRAINT [PK_ProjectDKC] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RepairDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceId] [int] NULL,
	[DateOfRepair] [date] NULL,
	[NextDateOfRepair] [date] NULL,
	[TimeOrder] [int] NULL,
	[TypeOfRepair] [int] NULL,
	[AddressOfRepair] [nvarchar](500) NULL,
	[UserId] [int] NULL,
	[Notes] [nvarchar](1000) NULL,
	[CreateDate] [date] NULL,
	[Price] [float] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_RepairDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RepairType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RepairType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeName] [nvarchar](100) NULL,
	[Notes] [nvarchar](1000) NULL,
 CONSTRAINT [PK_RepairType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RequestDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RequestDevice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserRequest] [int] NULL,
	[DateOfRequest] [date] NULL,
	[DateOfUse] [date] NULL,
	[DeviceName] [nvarchar](200) NULL,
	[TypeOfDevice] [int] NULL,
	[Configuration] [nvarchar](2000) NULL,
	[Notes] [nvarchar](2000) NULL,
	[Approved] [bit] NULL,
	[UserApproved] [int] NULL,
	[CreatedDate] [date] NULL,
	[Status] [int] NULL,
	[NumDevice] [int] NULL,
	[NoteProcess] [nvarchar](2000) NULL,
	[NoteReasonRefuse] [nvarchar](2000) NULL,
	[NameUserApproved] [nvarchar](100) NULL,
 CONSTRAINT [PK_RequestDevice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[ID] [varchar](50) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleTest]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleTest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeviceId] [int] NULL,
	[DateOfTest] [date] NULL,
	[NextDateOfTest] [date] NULL,
	[CategoryTest] [nvarchar](2000) NULL,
	[UserTest] [int] NULL,
	[Notes] [nvarchar](2000) NULL,
	[Status] [int] NULL,
	[CreateDate] [date] NULL,
	[CompanyTest] [nvarchar](300) NULL,
	[CycleTest] [int] NULL,
	[Status_tt] [int] NULL,
 CONSTRAINT [PK_ScheduleTest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NULL,
	[Email] [char](50) NULL,
	[Phone] [char](15) NULL,
	[Address] [nvarchar](500) NULL,
	[Support] [nvarchar](500) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsageDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsageDevice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateUse] [date] NULL,
	[UserId] [int] NULL,
	[ProjectId] [int] NULL,
	[Notes] [nvarchar](500) NULL,
	[DeviceId] [int] NULL,
 CONSTRAINT [PK_UsageDevice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [char](50) NULL,
	[PassWord] [char](200) NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [char](50) NULL,
	[PhoneNumber] [char](15) NULL,
	[Address] [nvarchar](500) NULL,
	[Department] [nvarchar](100) NULL,
	[Position] [nvarchar](100) NULL,
	[RoleId] [int] NULL,
	[Status] [int] NULL,
	[IsDeleted] [bit] NULL,
	[GroupID] [varchar](20) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroup]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroup](
	[ID] [varchar](20) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_UserGroup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserLogin]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserLogin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [char](50) NULL,
	[PassWord] [char](50) NULL,
	[GroupID] [varchar](20) NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [char](50) NULL,
	[IsDeleted] [bit] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_UserLogin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Credential] ON 
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEPARTMENT', 607)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEVICE', 608)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEVICE_COMPONAN', 609)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEVICE_DEVICE', 610)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEVICE_TYPE', 611)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_DEVICEINPROJECT', 612)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_EMPLOYEE', 613)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_GROUP_ROLE', 614)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_REPAIR_DEVICE', 615)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_REQUEST_DEVICE', 616)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_ROLE_FOR_GROUP', 617)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_SUPPLIER', 618)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_TYPE_COMPONAN', 619)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'ADD_USER', 620)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'CHANGE_INFO_USER', 621)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'CHANGE_USER_GROUP', 622)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_DEPARTMENT', 623)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_DEVICE', 624)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_DEVICE_DEVICE', 625)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_GROUP_ROLE', 626)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_REQUEST_DEVICE', 627)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_TYPE_PR_DV', 628)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'DELETE_USER', 629)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EDIT_DEPARTMENT', 630)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EDIT_DEVICE', 631)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EDIT_EMPLOYEE', 632)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EDIT_REQUEST_DEVICE', 633)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EXEL_LIST_DDEVICE', 634)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EXPORT_DV_IN_DEPARTMENT', 635)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'EXPORT_STATISTICAL_DEVICE', 636)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'LIQUIDATION_DEVICE', 637)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'MANAGER_TYPE_PR_DV', 638)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'PRINTBARCODE_DEVICE', 639)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'RETURN_DEVICETODEPOT', 640)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'SCAN_ADD_DVDEPARTMENT', 641)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'SCAN_DEVICE', 642)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'SCAN_RETURN_DV', 643)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'SEACH_DEVICE', 644)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'SEARCH_DEVICE_COMPONAN', 645)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_DEPARTMENT', 646)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_DEVICE', 647)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_EMPLOYEE', 648)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_GROUP_ROLE', 649)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_REQUEST_DEVICE', 650)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_STATISTICAL_DEPARTMENT', 651)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_STATISTICAL_DEVICE', 652)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'ADMIN', N'VIEW_USER', 653)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEPARTMENT', 831)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEVICE', 832)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEVICE_COMPONAN', 833)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEVICE_DEVICE', 834)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEVICE_TYPE', 835)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_DEVICEINPROJECT', 836)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_EMPLOYEE', 837)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_GROUP_ROLE', 838)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_REPAIR_DEVICE', 839)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_REQUEST_DEVICE', 840)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_ROLE_FOR_GROUP', 841)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_SCHEDULETEST', 842)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_SPAREPART', 843)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_SUPPLIER', 844)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_TYPE_COMPONAN', 845)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_UNITDEMPARTMENT', 846)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'ADD_USER', 847)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'CHANGE_INFO_USER', 848)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'CHANGE_USER_GROUP', 849)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_DEPARTMENT', 850)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_DEVICE', 851)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_DEVICE_DEVICE', 852)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_GROUP_ROLE', 853)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_REQUEST_DEVICE', 854)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_SPAREPART', 855)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_SUPPLIER', 856)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_TYPE_PR_DV', 857)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETE_USER', 858)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'DELETENHAPXUAT_SPAREPART', 859)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_DEPARTMENT', 860)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_DEVICE', 861)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_EMPLOYEE', 862)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_REQUEST_DEVICE', 863)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_SCHEDULETEST', 864)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_SPAREPART', 865)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_SUPPLIER', 866)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EDIT_UNITDEPARTMENT', 867)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXEL_LIST_DDEVICE', 868)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXPORT_DV_IN_DEPARTMENT', 869)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXPORT_SCHEDULETEST', 870)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXPORT_SPAREPART', 871)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXPORT_STATISTICAL_DEVICE', 872)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'EXPORTNHAPXUAT_SPAREPART', 873)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'LIQUIDATION_DEVICE', 874)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'MANAGER_TYPE_PR_DV', 875)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'NHAP_SPAREPART', 876)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'NHAPXUAT_SPAREPART', 877)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'PRINTBARCODE_DEVICE', 878)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'RETURN_DEVICETODEPOT', 879)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'SCAN_ADD_DVDEPARTMENT', 880)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'SCAN_DEVICE', 881)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'SCAN_RETURN_DV', 882)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'SEACH_DEVICE', 883)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'SEARCH_DEVICE_COMPONAN', 884)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_DEPARTMENT', 885)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_DEVICE', 886)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_EMPLOYEE', 887)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_GROUP_ROLE', 888)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_REQUEST_DEVICE', 889)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_SCHEDULETEST', 890)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_SPAREPART', 891)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_STATISTICAL_DEPARTMENT', 892)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_STATISTICAL_DEVICE', 893)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_SUPPLIER', 894)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_UNITDEPARTMENT', 895)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'VIEW_USER', 896)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'DIRECTOR', N'XUAT_SPAREPART', 897)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEPARTMENT', 764)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEVICE', 765)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEVICE_COMPONAN', 766)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEVICE_DEVICE', 767)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEVICE_TYPE', 768)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_DEVICEINPROJECT', 769)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_EMPLOYEE', 770)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_GROUP_ROLE', 771)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_REPAIR_DEVICE', 772)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_REQUEST_DEVICE', 773)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_ROLE_FOR_GROUP', 774)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_SCHEDULETEST', 775)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_SPAREPART', 776)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_SUPPLIER', 777)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_TYPE_COMPONAN', 778)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_UNITDEMPARTMENT', 779)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'ADD_USER', 780)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'CHANGE_INFO_USER', 781)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'CHANGE_USER_GROUP', 782)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_DEPARTMENT', 783)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_DEVICE', 784)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_DEVICE_DEVICE', 785)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_GROUP_ROLE', 786)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_REQUEST_DEVICE', 787)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_SPAREPART', 788)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_SUPPLIER', 789)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_TYPE_PR_DV', 790)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETE_USER', 791)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'DELETENHAPXUAT_SPAREPART', 792)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_DEPARTMENT', 793)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_DEVICE', 794)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_EMPLOYEE', 795)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_REQUEST_DEVICE', 796)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_SCHEDULETEST', 797)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_SPAREPART', 798)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_SUPPLIER', 799)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EDIT_UNITDEPARTMENT', 800)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXEL_LIST_DDEVICE', 801)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXPORT_DV_IN_DEPARTMENT', 802)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXPORT_SCHEDULETEST', 803)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXPORT_SPAREPART', 804)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXPORT_STATISTICAL_DEVICE', 805)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'EXPORTNHAPXUAT_SPAREPART', 806)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'LIQUIDATION_DEVICE', 807)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'MANAGER_TYPE_PR_DV', 808)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'NHAP_SPAREPART', 809)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'NHAPXUAT_SPAREPART', 810)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'PRINTBARCODE_DEVICE', 811)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'RETURN_DEVICETODEPOT', 812)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'SCAN_ADD_DVDEPARTMENT', 813)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'SCAN_DEVICE', 814)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'SCAN_RETURN_DV', 815)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'SEACH_DEVICE', 816)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'SEARCH_DEVICE_COMPONAN', 817)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_DEPARTMENT', 818)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_DEVICE', 819)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_EMPLOYEE', 820)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_GROUP_ROLE', 821)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_REQUEST_DEVICE', 822)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_SCHEDULETEST', 823)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_SPAREPART', 824)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_STATISTICAL_DEPARTMENT', 825)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_STATISTICAL_DEVICE', 826)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_SUPPLIER', 827)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_UNITDEPARTMENT', 828)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'VIEW_USER', 829)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'MANAGER', N'XUAT_SPAREPART', 830)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'ADD_GROUP_ROLE', 538)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'ADD_ROLE_FOR_GROUP', 539)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'ADD_USER', 540)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'CHANGE_INFO_USER', 541)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'CHANGE_USER_GROUP', 542)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'DELETE_GROUP_ROLE', 543)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'DELETE_USER', 544)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'VIEW_GROUP_ROLE', 545)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'OFFICER', N'VIEW_USER', 546)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'TESTER', N'ADD_REQUEST_DEVICE', 692)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'TESTER', N'DELETE_REQUEST_DEVICE', 693)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'TESTER', N'EDIT_REQUEST_DEVICE', 694)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'TESTER', N'VIEW_DEVICE', 695)
GO
INSERT [dbo].[Credential] ([UserGroupID], [RoleID], [ID]) VALUES (N'TESTER', N'VIEW_REQUEST_DEVICE', 696)
GO
SET IDENTITY_INSERT [dbo].[Credential] OFF
GO
SET IDENTITY_INSERT [dbo].[Device] ON 
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6178, N'Lo100001                                          ', N'Máy tính', 1035, NULL, N'', 0, N'', CAST(N'2025-01-22' AS Date), 1004, CAST(N'2025-05-14' AS Date), 1020, N'', CAST(N'2025-01-17' AS Date), NULL, 1, 0, NULL, NULL, N'PC', N'', N'', CAST(N'2025-01-22' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6179, N'Lo200001                                          ', N'Camera', 1036, NULL, N'', 0, N'', CAST(N'2025-01-22' AS Date), 1004, CAST(N'2025-01-22' AS Date), 1021, N'', CAST(N'2025-01-17' AS Date), NULL, 1, 0, NULL, NULL, N'Camera', N'', N'', CAST(N'2025-01-22' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6180, N'Lo100006                                          ', N'Máy in', 1035, NULL, N'<p>&aacute;</p>', 200000, N'<p>&aacute;d</p>', CAST(N'2025-02-01' AS Date), 1004, CAST(N'2025-02-20' AS Date), 1020, N'<p>&aacute;</p>', CAST(N'2025-02-13' AS Date), NULL, 1, 0, NULL, NULL, N'Printer', N'P01', N'0111111111', CAST(N'2025-02-08' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6181, N'Lo100007                                          ', N'Thiết bị 01', 1035, NULL, N'', 120000, N'', NULL, NULL, NULL, 1020, N'', CAST(N'2025-02-17' AS Date), NULL, 1, 0, NULL, NULL, N'TB01', N'TB01', N'', CAST(N'2025-02-01' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6182, N'Lo100008                                          ', N'Thiết bị đơn vị 02', 1035, NULL, N'', 123, N'', NULL, NULL, CAST(N'2025-02-06' AS Date), NULL, N'', CAST(N'2025-02-17' AS Date), NULL, 1, 0, NULL, NULL, N'Thiết bị đơn vị 02', N'Thiết bị đơn vị 02', N'', CAST(N'2025-02-06' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6183, N'Lo100009                                          ', N'TB003', 1035, NULL, N'', 10000, N'', CAST(N'2025-02-05' AS Date), NULL, CAST(N'2025-02-28' AS Date), 1020, N'', CAST(N'2025-02-17' AS Date), NULL, 1, 0, NULL, NULL, N'TB003', N'TB003', N'', CAST(N'2025-02-20' AS Date))
GO
INSERT [dbo].[Device] ([Id], [DeviceCode], [DeviceName], [TypeOfDevice], [ParentId], [Configuration], [Price], [PurchaseContract], [DateOfPurchase], [SupplierId], [Guarantee], [UserId], [Notes], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [StatusRepair], [NewCode], [DeviceNameEnglish], [DeviceModel], [DeviceSeria], [DateAdded]) VALUES (6184, N'Lo100010                                          ', N'TTT', 1035, NULL, N'', 12000, N'', CAST(N'2025-02-11' AS Date), NULL, CAST(N'2025-02-06' AS Date), 1020, N'', CAST(N'2025-02-18' AS Date), NULL, 1, 0, NULL, NULL, N'TTT', N'TTT', N'', CAST(N'2025-02-14' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Device] OFF
GO
SET IDENTITY_INSERT [dbo].[DeviceOfProject] ON 
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5198, 2030, 6178, CAST(N'2025-01-17' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5200, 2040, 6180, CAST(N'2025-02-13' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5201, 2045, 6181, CAST(N'2025-02-17' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5202, 2050, 6182, CAST(N'2025-02-17' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5203, 2050, 6183, CAST(N'2025-02-17' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5204, 2050, 6184, CAST(N'2025-02-18' AS Date), NULL, 1, NULL, 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5205, 2050, 6178, CAST(N'2025-02-19' AS Date), NULL, 1, N'', 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5206, 2050, 6179, CAST(N'2025-02-19' AS Date), NULL, 1, N'', 0)
GO
INSERT [dbo].[DeviceOfProject] ([Id], [ProjectId], [DeviceId], [DateOfDelivery], [DateOfReturn], [Status], [Notes], [IsDeleted]) VALUES (5207, 2050, 6180, CAST(N'2025-02-19' AS Date), NULL, 1, N'', 0)
GO
SET IDENTITY_INSERT [dbo].[DeviceOfProject] OFF
GO
SET IDENTITY_INSERT [dbo].[DeviceType] ON 
GO
INSERT [dbo].[DeviceType] ([Id], [TypeName], [TypeSymbol], [Notes], [OrderCode]) VALUES (1035, N'Loại 1', N'Lo1                                               ', N'', 11)
GO
INSERT [dbo].[DeviceType] ([Id], [TypeName], [TypeSymbol], [Notes], [OrderCode]) VALUES (1036, N'Loại 2', N'Lo2                                               ', N'', 4)
GO
INSERT [dbo].[DeviceType] ([Id], [TypeName], [TypeSymbol], [Notes], [OrderCode]) VALUES (1037, N'Thiết bị văn phòng', N'TBV                                               ', N'test', 2)
GO
SET IDENTITY_INSERT [dbo].[DeviceType] OFF
GO
SET IDENTITY_INSERT [dbo].[ProjectDKC] ON 
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2030, N'Phòng 1', N'P1                                                ', 1021, N'update tr tesst asd', NULL, NULL, CAST(N'2025-01-17' AS Date), CAST(N'0001-01-01' AS Date), 1, 0, 1, NULL, 1)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2031, N'Phòng 2', N'P2                                                ', 1021, N'test', NULL, NULL, CAST(N'2025-01-17' AS Date), CAST(N'0001-01-01' AS Date), 1, 0, 1, NULL, 1)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2032, N'Phòng ban 0001', N'VTC001                                            ', 1020, N'test add department', NULL, NULL, CAST(N'2025-02-06' AS Date), NULL, 1, 0, 1, NULL, 1)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2034, N'Đơn vị 0012', N'VTC0092                                           ', 1020, N'test update', NULL, NULL, CAST(N'2025-02-06' AS Date), CAST(N'0001-01-01' AS Date), 1, 0, 1, NULL, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2035, N'Don Vi', N'DV0001                                            ', 1020, N'test', NULL, NULL, CAST(N'2025-02-08' AS Date), NULL, 1, 0, 1, 2030, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2036, N'Phòng test', N'0001                                              ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, 1, NULL)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2037, N'Test Add', N'0002                                              ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, NULL, 1)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2038, N'123', N'test                                              ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, 2031, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2039, N'test01', N'ttsete01                                          ', 1020, N'test update', NULL, NULL, CAST(N'2025-02-09' AS Date), CAST(N'0001-01-01' AS Date), 1, 0, 1, NULL, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2040, N'Phong Y Te', N'DV001                                             ', 1021, N'tsest', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, 2030, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2041, N'GGGG', N'GGGG                                              ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, 2030, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2042, N'test', N'test test                                         ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, 2030, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2043, N'test', N'testtest                                          ', 1020, N'test', NULL, NULL, CAST(N'2025-02-09' AS Date), NULL, 1, 0, 1, NULL, 1)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2044, N'test01', N'0003                                              ', 1020, N'', NULL, NULL, CAST(N'2025-02-10' AS Date), NULL, 1, 0, 1, 2032, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2045, N'ttt', N'tttt                                              ', 1021, N'', NULL, NULL, CAST(N'2025-02-10' AS Date), NULL, 1, 0, 1, 2031, 0)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2046, N'child', N'                                                  ', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 2035, NULL)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2047, N'child2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 2046, NULL)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2048, N'child3', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 2047, NULL)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2049, N'child4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 2048, NULL)
GO
INSERT [dbo].[ProjectDKC] ([Id], [ProjectName], [ProjectSymbol], [ManagerProject], [Address], [FromDate], [ToDate], [CreatedDate], [ModifiedDate], [Status], [IsDeleted], [TypeProject], [ParentId], [HasChild]) VALUES (2050, N'Đơn vị trực thuộc phòng 2', N'DVTT02                                            ', 1020, N'Hà Nội', NULL, NULL, CAST(N'2025-02-17' AS Date), NULL, 1, 0, 1, 2031, 0)
GO
SET IDENTITY_INSERT [dbo].[ProjectDKC] OFF
GO
SET IDENTITY_INSERT [dbo].[RepairType] ON 
GO
INSERT [dbo].[RepairType] ([Id], [TypeName], [Notes]) VALUES (1, N'Sửa phần cứng ', N'')
GO
INSERT [dbo].[RepairType] ([Id], [TypeName], [Notes]) VALUES (2, N'Sửa phần mềm', N'')
GO
SET IDENTITY_INSERT [dbo].[RepairType] OFF
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEPARTMENT', N'Thêm phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEVICE', N'Thêm thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEVICE_COMPONAN', N'Thêm mới thiết bị con ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEVICE_DEVICE', N'Thêm thiết bị con cho thiết bị cha')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEVICE_TYPE', N'Thêm loại thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_DEVICEINPROJECT', N'Thêm thiết bị vào phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_EMPLOYEE', N'Thêm nhân viên')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_GROUP_ROLE', N'Thêm nhóm quyền')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_REPAIR_DEVICE', N'Thêm sửa chữa thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_REQUEST_DEVICE', N'Thêm yêu cầu thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_ROLE_FOR_GROUP', N'Thêm quyền cho nhóm quyền')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_SCHEDULETEST', N'Thêm lịch HC - Kiểm định')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_SPAREPART', N'Thêm phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_SUPPLIER', N'Thêm nhà cung cấp')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_TYPE_COMPONAN', N'Thêm loại thiết bị con cho thiết bị cha')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_UNITDEMPARTMENT', N'Thêm mới đơn vị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'ADD_USER', N'Thêm người dùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'CHANGE_INFO_USER', N'Thay đổi thông tin người dùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'CHANGE_USER_GROUP', N'Thay đổi nhóm quyền cho người dùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_DEPARTMENT', N'Xóa phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_DEVICE', N'Xóa thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_DEVICE_DEVICE', N'Xóa thiết bị con khỏi thiết bị cha')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_GROUP_ROLE', N'Xóa nhóm quyền')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_REQUEST_DEVICE', N'Xóa yêu cầu thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_SPAREPART', N'Xóa phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_SUPPLIER', N'Xóa nhà cung cấp')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_TYPE_PR_DV', N'Xóa loại thiết bị con khỏi loại thiết bị cha')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETE_USER', N'Xóa người dùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'DELETENHAPXUAT_SPAREPART', N'Xóa giao dịch nhập/xuất phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_DEPARTMENT', N'Sửa thông tin phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_DEVICE', N'Sửa thông tin thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_EMPLOYEE', N'Sửa thông tin nhân viên ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_REQUEST_DEVICE', N'Sửa yêu cầu thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_SCHEDULETEST', N'Sửa lịch HC - Kiểm định')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_SPAREPART', N'Sửa thông tin phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_SUPPLIER', N'Sửa thông tin nhà cung cấp')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EDIT_UNITDEPARTMENT', N'Chỉnh sửa đơn vị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXEL_LIST_DDEVICE', N'Xuất danh sách thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXPORT_DV_IN_DEPARTMENT', N'Xuất exel danh sách thiết bị tại phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXPORT_SCHEDULETEST', N'Xuất Exel lịch HC - Kiểm định')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXPORT_SPAREPART', N'Xuất exel danh sách phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXPORT_STATISTICAL_DEVICE', N'Xuất exel thống kê thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'EXPORTNHAPXUAT_SPAREPART', N'Xuất exel danh sách nhập/xuất phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'LIQUIDATION_DEVICE', N'Thanh lý thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'MANAGER_TYPE_PR_DV', N'Quản lý loại thiết bị cha con')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'NHAP_SPAREPART', N'Nhập phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'NHAPXUAT_SPAREPART', N'Danh sách nhập/xuất phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'PRINTBARCODE_DEVICE', N'Tạo mã vạch thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'RETURN_DEVICETODEPOT', N'Trả thiết bị về kho')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'SCAN_ADD_DVDEPARTMENT', N'Quét thêm thiết bị vào phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'SCAN_DEVICE', N'Quét thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'SCAN_RETURN_DV', N'Quét trả thiết bị về kho')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'SEACH_DEVICE', N'Tìm kiếm thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'SEARCH_DEVICE_COMPONAN', N'Tìm kiếm thiết bị con từ danh sách ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_DEPARTMENT', N'Xem danh sách phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_DEVICE', N'Xem danh sách thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_EMPLOYEE', N'Xem danh sách nhân viên ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_GROUP_ROLE', N'Xem danh sách nhóm quyền')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_REQUEST_DEVICE', N'Xem danh sách yêu cầu thiết bị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_SCHEDULETEST', N'Xem danh sách lịch HC - Kiểm định')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_SPAREPART', N'Xem danh sách phụ tùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_STATISTICAL_DEPARTMENT', N'Xem thống kê thiết bị tại phòng ban')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_STATISTICAL_DEVICE', N'Xem thống kê thiết bị ')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_SUPPLIER', N'Xem danh sách nhà cung cấp')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_UNITDEPARTMENT', N'Xem danh sách đơn vị')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'VIEW_USER', N'Xem danh sách người dùng')
GO
INSERT [dbo].[Role] ([ID], [Name]) VALUES (N'XUAT_SPAREPART', N'Xuất phụ tùng')
GO
SET IDENTITY_INSERT [dbo].[Supplier] ON 
GO
INSERT [dbo].[Supplier] ([Id], [Name], [Email], [Phone], [Address], [Support], [Status]) VALUES (1004, N'Việt Thanh', N'viethanh@gmail.com                                ', N'1234567890     ', N'Tỉnh Việt Thanh', N'', 0)
GO
SET IDENTITY_INSERT [dbo].[Supplier] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 
GO
INSERT [dbo].[User] ([Id], [UserName], [PassWord], [FullName], [Email], [PhoneNumber], [Address], [Department], [Position], [RoleId], [Status], [IsDeleted], [GroupID]) VALUES (1020, N'nguyentheanh                                      ', NULL, N'Nguyễn Thế Anh', N'                                                  ', N'               ', N'', N'', N'', NULL, 0, 0, N'MEMBER')
GO
INSERT [dbo].[User] ([Id], [UserName], [PassWord], [FullName], [Email], [PhoneNumber], [Address], [Department], [Position], [RoleId], [Status], [IsDeleted], [GroupID]) VALUES (1021, N'dinhvancuong                                      ', NULL, N'Đinh Văn Cương', N'                                                  ', N'               ', N'', N'2031', N'', NULL, 0, 0, N'MEMBER')
GO
INSERT [dbo].[User] ([Id], [UserName], [PassWord], [FullName], [Email], [PhoneNumber], [Address], [Department], [Position], [RoleId], [Status], [IsDeleted], [GroupID]) VALUES (1022, N'nguyenvana                                        ', NULL, N'Nguyễn Văn A', N'                                                  ', N'               ', N'', N'2030', N'', NULL, 0, 0, N'MEMBER')
GO
INSERT [dbo].[User] ([Id], [UserName], [PassWord], [FullName], [Email], [PhoneNumber], [Address], [Department], [Position], [RoleId], [Status], [IsDeleted], [GroupID]) VALUES (1023, N'linhvqtest                                        ', NULL, N'Vu Quang Linh', N'linhvqdev@gmail.com                               ', N'01234567899    ', N'HN', N'2031', N'Leader', NULL, 0, 0, N'MEMBER')
GO
SET IDENTITY_INSERT [dbo].[User] OFF
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'ADMIN', N'Quản trị viên')
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'DIRECTOR', N'Thủ trưởng')
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'MANAGER', N'Quản lý')
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'MEMBER', N'Cán bộ quản lý')
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'OFFICER', N'Quản lý viên')
GO
INSERT [dbo].[UserGroup] ([ID], [Name]) VALUES (N'TESTER', N'Nhóm test')
GO
SET IDENTITY_INSERT [dbo].[UserLogin] ON 
GO
INSERT [dbo].[UserLogin] ([Id], [UserName], [PassWord], [GroupID], [FullName], [Email], [IsDeleted], [Status]) VALUES (30, N'XuanAnh                                           ', N'V4OIMqd+8r8Qwu4q6s8yJBJ8bgiORb77                  ', N'ADMIN', N'ĐOÀN ĐẮC XUÂN ANH', N'1024                                              ', 0, 1)
GO
INSERT [dbo].[UserLogin] ([Id], [UserName], [PassWord], [GroupID], [FullName], [Email], [IsDeleted], [Status]) VALUES (1029, N'kiemke                                            ', N'POFx4QT/pkIalD76sLINmw==                          ', N'MEMBER', N'kiemke', N'1026                                              ', 0, 0)
GO
INSERT [dbo].[UserLogin] ([Id], [UserName], [PassWord], [GroupID], [FullName], [Email], [IsDeleted], [Status]) VALUES (1033, N'annv                                              ', N'RC6R1BEwbKnOjcYbI3vOXA==                          ', N'DIRECTOR', N'Nguyen Van An', N'2045                                              ', 0, 0)
GO
INSERT [dbo].[UserLogin] ([Id], [UserName], [PassWord], [GroupID], [FullName], [Email], [IsDeleted], [Status]) VALUES (1034, N'hungnv                                            ', N'c/S+SLnL4e+6IoJ4MCgGew==                          ', N'MANAGER', N'Nguyen Van Hung', N'2045                                              ', 0, 0)
GO
INSERT [dbo].[UserLogin] ([Id], [UserName], [PassWord], [GroupID], [FullName], [Email], [IsDeleted], [Status]) VALUES (1035, N'chungnt                                           ', N'uFhnfo14M7Wn0u3LFGa/2i8HS+Vxj1Yb                  ', N'MANAGER', N'Nguyen Tat Chung', N'2050                                              ', 0, 0)
GO
SET IDENTITY_INSERT [dbo].[UserLogin] OFF
GO
ALTER TABLE [dbo].[DeviceType] ADD  CONSTRAINT [DF_DeviceType_OrderCode]  DEFAULT ((1)) FOR [OrderCode]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_GroupID]  DEFAULT ('MEMBER') FOR [GroupID]
GO
ALTER TABLE [dbo].[Credential]  WITH CHECK ADD  CONSTRAINT [FK_Credential_UserGroup] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([ID])
GO
ALTER TABLE [dbo].[Credential] CHECK CONSTRAINT [FK_Credential_UserGroup]
GO
ALTER TABLE [dbo].[Credential]  WITH CHECK ADD  CONSTRAINT [FK_Credential_UserGroup1] FOREIGN KEY([UserGroupID])
REFERENCES [dbo].[UserGroup] ([ID])
GO
ALTER TABLE [dbo].[Credential] CHECK CONSTRAINT [FK_Credential_UserGroup1]
GO
ALTER TABLE [dbo].[DestructivelDevice]  WITH CHECK ADD  CONSTRAINT [FK_CancelDevice_CancelType] FOREIGN KEY([TypeOfDestructive])
REFERENCES [dbo].[DestructiveType] ([Id])
GO
ALTER TABLE [dbo].[DestructivelDevice] CHECK CONSTRAINT [FK_CancelDevice_CancelType]
GO
ALTER TABLE [dbo].[DestructivelDevice]  WITH CHECK ADD  CONSTRAINT [FK_CancelDevice_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[DestructivelDevice] CHECK CONSTRAINT [FK_CancelDevice_Device]
GO
ALTER TABLE [dbo].[DestructivelDevice]  WITH CHECK ADD  CONSTRAINT [FK_CancelDevice_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[DestructivelDevice] CHECK CONSTRAINT [FK_CancelDevice_User]
GO
ALTER TABLE [dbo].[Device]  WITH CHECK ADD  CONSTRAINT [FK_Device_DeviceType] FOREIGN KEY([TypeOfDevice])
REFERENCES [dbo].[DeviceType] ([Id])
GO
ALTER TABLE [dbo].[Device] CHECK CONSTRAINT [FK_Device_DeviceType]
GO
ALTER TABLE [dbo].[Device]  WITH CHECK ADD  CONSTRAINT [FK_Device_Supplier] FOREIGN KEY([SupplierId])
REFERENCES [dbo].[Supplier] ([Id])
GO
ALTER TABLE [dbo].[Device] CHECK CONSTRAINT [FK_Device_Supplier]
GO
ALTER TABLE [dbo].[Device]  WITH CHECK ADD  CONSTRAINT [FK_Device_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Device] CHECK CONSTRAINT [FK_Device_User]
GO
ALTER TABLE [dbo].[DeviceDevice]  WITH CHECK ADD  CONSTRAINT [FK_DeviceDevice_Device] FOREIGN KEY([DeviceCodeChildren])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[DeviceDevice] CHECK CONSTRAINT [FK_DeviceDevice_Device]
GO
ALTER TABLE [dbo].[DeviceDevice]  WITH CHECK ADD  CONSTRAINT [FK_DeviceDevice_Device1] FOREIGN KEY([DeviceCodeParents])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[DeviceDevice] CHECK CONSTRAINT [FK_DeviceDevice_Device1]
GO
ALTER TABLE [dbo].[DeviceOfProject]  WITH CHECK ADD  CONSTRAINT [FK_DeviceOfProject_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[DeviceOfProject] CHECK CONSTRAINT [FK_DeviceOfProject_Device]
GO
ALTER TABLE [dbo].[DeviceOfProject]  WITH CHECK ADD  CONSTRAINT [FK_DeviceOfProject_ProjectDKC] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectDKC] ([Id])
GO
ALTER TABLE [dbo].[DeviceOfProject] CHECK CONSTRAINT [FK_DeviceOfProject_ProjectDKC]
GO
ALTER TABLE [dbo].[DeviceTypeComponantType]  WITH CHECK ADD  CONSTRAINT [FK_DeviceTypeComponantType_DeviceType] FOREIGN KEY([TypeSymbolChildren])
REFERENCES [dbo].[DeviceType] ([Id])
GO
ALTER TABLE [dbo].[DeviceTypeComponantType] CHECK CONSTRAINT [FK_DeviceTypeComponantType_DeviceType]
GO
ALTER TABLE [dbo].[DeviceTypeComponantType]  WITH CHECK ADD  CONSTRAINT [FK_DeviceTypeComponantType_DeviceType1] FOREIGN KEY([TypeSymbolParents])
REFERENCES [dbo].[DeviceType] ([Id])
GO
ALTER TABLE [dbo].[DeviceTypeComponantType] CHECK CONSTRAINT [FK_DeviceTypeComponantType_DeviceType1]
GO
ALTER TABLE [dbo].[ProjectDKC]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDKC_User] FOREIGN KEY([ManagerProject])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ProjectDKC] CHECK CONSTRAINT [FK_ProjectDKC_User]
GO
ALTER TABLE [dbo].[RepairDetails]  WITH CHECK ADD  CONSTRAINT [FK_RepairDetails_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[RepairDetails] CHECK CONSTRAINT [FK_RepairDetails_Device]
GO
ALTER TABLE [dbo].[RepairDetails]  WITH CHECK ADD  CONSTRAINT [FK_RepairDetails_RepairType] FOREIGN KEY([TypeOfRepair])
REFERENCES [dbo].[RepairType] ([Id])
GO
ALTER TABLE [dbo].[RepairDetails] CHECK CONSTRAINT [FK_RepairDetails_RepairType]
GO
ALTER TABLE [dbo].[RepairDetails]  WITH CHECK ADD  CONSTRAINT [FK_RepairDetails_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[RepairDetails] CHECK CONSTRAINT [FK_RepairDetails_User]
GO
ALTER TABLE [dbo].[RequestDevice]  WITH CHECK ADD  CONSTRAINT [FK_RequestDevice_DeviceType] FOREIGN KEY([TypeOfDevice])
REFERENCES [dbo].[DeviceType] ([Id])
GO
ALTER TABLE [dbo].[RequestDevice] CHECK CONSTRAINT [FK_RequestDevice_DeviceType]
GO
ALTER TABLE [dbo].[RequestDevice]  WITH CHECK ADD  CONSTRAINT [FK_RequestDevice_User] FOREIGN KEY([UserRequest])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[RequestDevice] CHECK CONSTRAINT [FK_RequestDevice_User]
GO
ALTER TABLE [dbo].[ScheduleTest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleTest_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[ScheduleTest] CHECK CONSTRAINT [FK_ScheduleTest_Device]
GO
ALTER TABLE [dbo].[ScheduleTest]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleTest_User] FOREIGN KEY([UserTest])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ScheduleTest] CHECK CONSTRAINT [FK_ScheduleTest_User]
GO
ALTER TABLE [dbo].[UsageDevice]  WITH CHECK ADD  CONSTRAINT [FK_UsageDevice_Device] FOREIGN KEY([DeviceId])
REFERENCES [dbo].[Device] ([Id])
GO
ALTER TABLE [dbo].[UsageDevice] CHECK CONSTRAINT [FK_UsageDevice_Device]
GO
ALTER TABLE [dbo].[UsageDevice]  WITH CHECK ADD  CONSTRAINT [FK_UsageDevice_ProjectDKC] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[ProjectDKC] ([Id])
GO
ALTER TABLE [dbo].[UsageDevice] CHECK CONSTRAINT [FK_UsageDevice_ProjectDKC]
GO
ALTER TABLE [dbo].[UsageDevice]  WITH CHECK ADD  CONSTRAINT [FK_UsageDevice_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[UsageDevice] CHECK CONSTRAINT [FK_UsageDevice_User]
GO
ALTER TABLE [dbo].[UserLogin]  WITH CHECK ADD  CONSTRAINT [FK_UserLogin_UserGroup] FOREIGN KEY([GroupID])
REFERENCES [dbo].[UserGroup] ([ID])
GO
ALTER TABLE [dbo].[UserLogin] CHECK CONSTRAINT [FK_UserLogin_UserGroup]
GO
/****** Object:  StoredProcedure [dbo].[AddDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDevice]  
      @DeviceCode char(50),
	  @NewCode char(50),
      @DeviceName nvarchar(200),
      @TypeOfDevice int,
      @ParentId int,
      @Configuration nvarchar(500),
      @Price float,
      @PurchaseContract nvarchar(500),
      @DateOfPurchase date,
      @SupplierId int,
	  @ProjectId int,
      @Guarantee date,
	  @Notes nvarchar(2000),
      @UserId int,
      @Status int,
	  @DeviceNameEnglish nvarchar(200),
	  @DeviceModel nvarchar(100),
	  @DeviceSeria nvarchar(100),
	  @DateAdded date

AS
BEGIN
   INSERT INTO Device(DeviceCode,NewCode,DeviceName,TypeOfDevice,ParentId,Configuration,Price,PurchaseContract,DateOfPurchase,SupplierId,Guarantee,Notes, UserId,CreatedDate,Status,IsDeleted,DeviceNameEnglish,DeviceModel,DeviceSeria,DateAdded)
   values(@DeviceCode,@NewCode,@DeviceName,@TypeOfDevice,@ParentId,@Configuration,@Price,@PurchaseContract,@DateOfPurchase,@SupplierId,@Guarantee,@Notes,@UserId,GETDATE(),@Status,0,@DeviceNameEnglish,@DeviceModel,@DeviceSeria,@DateAdded)
   declare @deviceid int
   set @deviceid=SCOPE_IDENTITY()
   if(@ProjectId !=0)
      begin
            INSERT INTO DeviceOfProject (ProjectId, DeviceId, DateOfDelivery, DateOfReturn, Status, IsDeleted)
  VALUES ( @ProjectId, @deviceid, GETDATE(), null, 1, 0 )
		   Update Device set Status=1 where Id=@deviceid
	  end
END




GO
/****** Object:  StoredProcedure [dbo].[AddDeviceFiles]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddDeviceFiles]
          @DeviceId int, 
          @DeviceCode char(50), 
		  @FileNames varchar(255),
		  @FileSize    varchar(100),
		  @FileContent  varchar(7000),
		  @FileType      varchar(30),
		  @FileLocal     varchar(300)
AS
BEGIN
      INSERT INTO DeviceFile(DeviceId,DeviceCode, FileNames, FileSize, FileContent, FileType, FileStatus, FileLocal, IsDelete, CreateUser, CreateDate, ModifiedUser, ModifiedDate)
	  VALUES ( @DeviceId,@DeviceCode, @FileNames, @FileSize, @FileContent, @FileType, 'A', @FileLocal, '0', '', getdate(), '', '')
END


GO
/****** Object:  StoredProcedure [dbo].[AddDeviceOfDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROC [dbo].[AddDeviceOfDevice]
  @IdParent int,
  @IdChild int ,
  @TypeChild int,
  @TypeParent int ,
  @TypeComponant int
AS
BEGIN
  INSERT INTO DeviceDevice (DeviceCodeParents, DeviceCodeChildren, TypeSymbolParents,TypeSymbolChildren ,CreatedDate, IsDeleted,TypeComponant)
  VALUES ( @IdParent, @IdChild,@TypeParent, @TypeChild,GETDATE(), 0,@TypeComponant ) 
  Update Device  set ParentId = @IdParent where Id= @IdChild
END   



GO
/****** Object:  StoredProcedure [dbo].[AddDeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddDeviceOfProject]
  @ProjectId  int,
  @DeviceId int , 
  @Notes nvarchar(2000)
 
AS
BEGIN
  INSERT INTO DeviceOfProject (ProjectId, DeviceId, DateOfDelivery, DateOfReturn, Status, Notes, IsDeleted)
  VALUES ( @ProjectId, @DeviceId, GETDATE(), null, 1, @Notes, 0 )
  Update Device set Status=1 where Id=@DeviceId
  --Insert into UsageDevice(DeviceId,ProjectId,DateUse,Notes)
  --values(@DeviceId,@ProjectId,GETDATE(),N'Thêm vào dự án')
END



GO
/****** Object:  StoredProcedure [dbo].[AddDeviceType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDeviceType]  
      @TypeName nvarchar(100),
	  @TypeSymbol nchar(50),
      @Notes nvarchar(1000)
AS
BEGIN
   Insert into DeviceType(TypeName,TypeSymbol,Notes)
   values (@TypeName, @TypeSymbol,@Notes)
END



GO
/****** Object:  StoredProcedure [dbo].[AddProject ]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddProject ]
    @ProjectSymbol nchar(50),
    @ProjectName nvarchar(200),
    @ManagerProject int,
    @Address nvarchar(1000),
    @FromDate Date ,
	@ToDate Date,
	@Status int,
	@TypeProject int,
	@ParentId int = NULL 
AS
BEGIN
     INSERT INTO ProjectDKC (ProjectSymbol, ProjectName, ManagerProject, Address, FromDate,ToDate,CreatedDate,Status,IsDeleted,TypeProject, ParentId, HasChild)
     VALUES( @ProjectSymbol,@ProjectName, @ManagerProject, @Address, @FromDate, @ToDate,GETDATE(), @Status, 0, 1, @ParentId, @TypeProject)
END



GO
/****** Object:  StoredProcedure [dbo].[AddRepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROC [dbo].[AddRepairDetails]
           @DeviceId int,
           @DateOfRepair date,
           @NextDateOfRepair date,
           @TimeOrder int,
           @TypeOfRepair int,
           @AddressOfRepair nvarchar(500),
           @UserId int,
           @Notes nvarchar(1000)
		

          
	AS
	BEGIN
	 INSERT INTO [dbo].[RepairDetails]
           ([DeviceId]
           ,[DateOfRepair]
           ,[NextDateOfRepair]
           ,[TimeOrder]
           ,[TypeOfRepair]
           ,[AddressOfRepair]
           ,[UserId]
           ,[Notes]
           ,[CreateDate]
		   ,[Status]
		   ,[Price])
     VALUES
           (@DeviceId ,
           @DateOfRepair ,
           @NextDateOfRepair ,
           @TimeOrder ,
           @TypeOfRepair ,
           @AddressOfRepair ,
           @UserId ,
           @Notes ,
           GETDATE(),
		   0,
		   null)

     Update Device set StatusRepair=1,ModifiedDate=GETDATE() where Id=@DeviceId

	END




GO
/****** Object:  StoredProcedure [dbo].[AddRepairType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AddRepairType]
          
          @TypeName nvarchar(100), 
		  @Notes nvarchar(1000)
AS
BEGIN
      INSERT INTO RepairType(TypeName,Notes)
	  VALUES (@TypeName,@Notes)
END




GO
/****** Object:  StoredProcedure [dbo].[AddRequestDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddRequestDevice]
           @UserRequest int,
           @DateOfRequest date,
           @DateOfUse date,
           @DeviceName nvarchar(200),
           @TypeOfDevice int,
           @Configuration nvarchar(2000),
           @Notes nvarchar(2000),     
           @Status int,
		   @NumDevice int ,
		   @UserApproved int
  
AS
BEGIN
    INSERT INTO RequestDevice (UserRequest, DateOfRequest, DateOfUse, DeviceName, TypeOfDevice, Configuration, Notes, Approved, UserApproved, CreatedDate, Status,NumDevice)
	VALUES ( @UserRequest ,
           GETDATE() ,
           @DateOfUse ,
           @DeviceName ,
           @TypeOfDevice,
           @Configuration,
           @Notes ,
           0,
           @UserApproved,
           GETDATE() ,
           @Status ,
		   @NumDevice)
END




GO
/****** Object:  StoredProcedure [dbo].[AddScheduleTest]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddScheduleTest]
           @DeviceId int,
           @DateOfTest date,
           @NextDateOfTest date,
           @CategoryTest nvarchar(2000),
           @UserTest int,
           @Notes nvarchar(2000),
		   @CompanyTest nvarchar(300),
		   @CycleTest int
         
  
AS
BEGIN
    INSERT INTO  ScheduleTest ( DeviceId, DateOfTest, NextDateOfTest, CategoryTest, UserTest, Notes, Status, CreateDate,CompanyTest,CycleTest)
	VALUES ( @DeviceId,  @DateOfTest, @NextDateOfTest,@CategoryTest,@UserTest,@Notes, 0, GETDATE(),@CompanyTest,@CycleTest )
END






GO
/****** Object:  StoredProcedure [dbo].[AddSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AddSparePart]
@DeviceType int,
@SparePartCode nvarchar(20),
@SparePartName nvarchar(200),
@Amount decimal,
@TotalSparePart int,
@DateAdded date,
@Config nvarchar(400),
@Notes nvarchar(400)

as
begin
insert DeviceSparePart (SparePartName, SparePartCode, DeviceType, TotalSparePart, RemainingAmount, DateAdded, Notes, Config,Amount , CreateDate, CreateUser, Isdelete)
values (@SparePartName, @SparePartCode, @DeviceType, @TotalSparePart, @TotalSparePart, @DateAdded, @Notes, @Config,@Amount , GETDATE(), '', 0)
end;



GO
/****** Object:  StoredProcedure [dbo].[AddSupplier]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSupplier]  
      @Name nvarchar(200),
      @Email char(50),
      @Phone char(15),
      @Address nvarchar(50),
      @Support nvarchar(500)
AS
BEGIN
    Insert into Supplier(Name,Email,Phone,Address,Support,Status)
    values (@Name,@Email,@Phone,@Address,@Support,0)
END



GO
/****** Object:  StoredProcedure [dbo].[AddTypeChidren]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddTypeChidren]
@TypeChidren int,
@TypeParent int,
@Type_TypeCom int
AS
BEGIN
  INSERT INTO DeviceTypeComponantType (TypeSymbolParents,TypeSymbolChildren,CreatedDate,ModifiedDate,UserCreated,UserModified,IsDeleted,TypeComponant)
  VALUES ( @TypeParent, @TypeChidren, GETDATE(), null,null, null, 0 ,@Type_TypeCom)
END   



GO
/****** Object:  StoredProcedure [dbo].[AddUser]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddUser]  
      @UserName char(50),
      @PassWord char(200),
      @FullName nvarchar(100),
      @Email char(50),
      @PhoneNumber char(15),
      @Address nvarchar(500),
      @Department nvarchar(100),
      @Position nvarchar(100),
      @RoleId int,
      @Status int
AS
BEGIN
   Insert into [dbo].[User](UserName,PassWord,FullName,Email,PhoneNumber,Address,Department,Position,RoleId,Status,IsDeleted)
   values (@UserName,@PassWord,@FullName,@Email,@PhoneNumber,@Address,@Department,@Position,@RoleId,@Status,0)
END



GO
/****** Object:  StoredProcedure [dbo].[ChildrenOfDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[ChildrenOfDevice]
@DeviceCodeParents int,
@TypeSymbolChildren int
as
begin
select v.DeviceCode,v.DeviceName,v.TypeOfDevice,p.TypeName,v.Configuration, (FORMAT(v.Price,'#,#')) Price,v.StatusRepair,v.Status as StatusDevice,v.PurchaseContract,v.DateOfPurchase

, d.DeviceCodeParents, d.DeviceCodeChildren,d.TypeSymbolParents,d.TypeSymbolChildren,d.IsDeleted, d.id,d.TypeComponant

 from DeviceDevice d, Device v ,DeviceType p 
  where d.DeviceCodeChildren = v.Id  and v.TypeOfDevice = p.Id
   and  d.DeviceCodeParents = @DeviceCodeParents   and d.TypeSymbolChildren = @TypeSymbolChildren  and d.IsDeleted = 0                                           
end 




GO
/****** Object:  StoredProcedure [dbo].[DeleteAllRole]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 Create PROC [dbo].[DeleteAllRole]
  @GroupId varchar(20)
  
AS
BEGIN
  Delete from Credential  
  where  UserGroupID =  @GroupId
END   



GO
/****** Object:  StoredProcedure [dbo].[DeleteDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteDevice]
@Id int
As
    Delete from Device
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[DeleteDevice1]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDevice1]
@Id char(5000)
AS
BEGIN
    Update Device
    set IsDeleted=1
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS char(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceFiles]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteDeviceFiles]
          @File_id int,
		  @Device_code char(20)
        
AS
BEGIN
if(@File_id <> -1)
      Delete from DeviceFile where id =  @File_id;
if(@Device_code is not null)
 Delete from DeviceFile where DeviceCode =  @Device_code;
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceOfDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[DeleteDeviceOfDevice]
  @IdParent int,
  @IdChild int ,
  @Resons nvarchar(500)
AS
BEGIN
  update DeviceDevice 
  set IsDeleted = 1 , Notes = @Resons
  where DeviceCodeParents =  @IdParent and   DeviceCodeChildren = @IdChild and IsDeleted = 0 
  Update Device  set ParentId = null where Id= @IdChild
END   


GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE PROC [dbo].[DeleteDeviceOfProject]
	  @Id int

	AS
	BEGIN
	  DELETE DeviceOfProject 
	  WHERE Id = @Id  
	END



GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteDeviceSparePart]
@Id char(5000)
AS
BEGIN
    Update DeviceSparePart
    set Isdelete=1
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS char(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceSparePartHistory]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[DeleteDeviceSparePartHistory]
@Id char(5000)
AS
BEGIN
    Update DeviceSparePartHistory
    set Isdelete=1
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS char(5000))))+',',+@Id) > 0 
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteDeviceType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DeleteDeviceType]
@Id int
As
Begin
    Update Device set TypeOfDevice = null where TypeOfDevice =@Id and IsDeleted =1
	Delete RequestDevice where TypeOfDevice =@Id
    Delete from DeviceType
    where Id=@Id
End






GO
/****** Object:  StoredProcedure [dbo].[DeleteProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteProject]
    @Id int
As
Begin
  Update ProjectDKC
    set IsDeleted=1, Status =3
Where Id = @Id
end




GO
/****** Object:  StoredProcedure [dbo].[DeleteProject1]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteProject1]
@Id char(5000)
AS
BEGIN
    Update ProjectDKC
    set IsDeleted=1, Status =3
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(5000))))+',',+@Id) > 0 
END




GO
/****** Object:  StoredProcedure [dbo].[DeleteRepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteRepairDetails]
@Id char(5000)
AS
BEGIN
    Delete  from RepairDetails 
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteRepairDetailsOne]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[DeleteRepairDetailsOne]
    @Id int
As
Begin
  Delete RepairDetails   
  Where Id = @Id
end




GO
/****** Object:  StoredProcedure [dbo].[DeleteRepairType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteRepairType]
@Id char(11)
AS
BEGIN
    Delete RepairType
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(11))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteRequestDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteRequestDevice]
@Id char(5000)
AS
BEGIN
    Delete  from RequestDevice
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteRole]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[DeleteRole]
@Id int
As
    Delete from Role
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[DeleteScheduleTest]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[DeleteScheduleTest]
@Id char(5000)
AS
BEGIN
    Delete ScheduleTest

    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[DeleteSupplier]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[DeleteSupplier]
@Id int
As
Begin
    Update Device set SupplierId = null where SupplierId =@Id and IsDeleted =1
    Delete from Supplier
    where Id=@Id
End




GO
/****** Object:  StoredProcedure [dbo].[DeleteTypeParentTypeChild]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[DeleteTypeParentTypeChild]
@TypeChidren int,
@TypeParent int

AS
BEGIN
  Update DeviceTypeComponantType set IsDeleted = 1  where TypeSymbolChildren = @TypeChidren and TypeSymbolParents = @TypeParent and IsDeleted = 0
END   



GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteUser]  
      @Id int
AS
BEGIN
    Update [dbo].[User] set IsDeleted=1
    where Id=@Id
END



GO
/****** Object:  StoredProcedure [dbo].[DeviceById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[DeviceById]
@Id int
As
    Select dv.*, (  FORMAT(dv.Price, '#,#'))  PriceOne ,(SELECT pj.ProjectName FROM DeviceOfProject dp INNER JOIN ProjectDKC pj ON dp.ProjectId = pj.Id WHERE dp.Status = 1 AND dp.DeviceId = dv.Id) ProjectName,
	            (SELECT dp.ProjectId FROM DeviceOfProject dp INNER JOIN ProjectDKC pj ON dp.ProjectId = pj.Id WHERE dp.Status = 1 AND dp.DeviceId = dv.Id) IdProject 
				 from Device dv
    where dv.Id=@Id




GO
/****** Object:  StoredProcedure [dbo].[DeviceHistory]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DeviceHistory]
as
begin
Select p.ProjectName,d.DeviceId ,v.DeviceName,v.Configuration,v.TypeOfDevice ,d.DateOfDelivery,d.DateOfReturn ,d.Notes ,v.Id,t.TypeName,v.DeviceCode,v.Status,v.StatusRepair
from DeviceOfProject as d join ProjectDKC as p on d.ProjectId = p.Id  join Device as v on d.DeviceId = v.Id   join DeviceType as t on v.TypeOfDevice = t.Id  order by d.DateOfDelivery Desc 
end 



GO
/****** Object:  StoredProcedure [dbo].[DeviceOfProjectAll]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[DeviceOfProjectAll]
@ProjectId int
as
begin
Select p.ProjectName,d.DeviceId ,v.DeviceName,v.Configuration,v.TypeOfDevice ,d.DateOfDelivery,d.DateOfReturn ,d.Notes ,v.Id,t.TypeName,v.DeviceCode,v.Status,v.StatusRepair
from DeviceOfProject as d join ProjectDKC as p on d.ProjectId = p.Id  join Device as v on d.DeviceId = v.Id   join DeviceType as t on v.TypeOfDevice = t.Id 
where @ProjectId = d.ProjectId and d.Status = 1

end 




GO
/****** Object:  StoredProcedure [dbo].[DeviceTypeById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[DeviceTypeById]
@Id int
As
    Select * from DeviceType
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[EditRepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[EditRepairDetails]
           @Id int,
           @DeviceId int,
           @DateOfRepair date,
           @NextDateOfRepair date,
           @TimeOrder int,
           @TypeOfRepair int,
           @AddressOfRepair nvarchar(500),
           @UserId int,
           @Notes nvarchar(1000),
		   @Status int ,
		   @Price float
        
AS
BEGIN
  UPDATE RepairDetails 
  SET DeviceId = @DeviceId , DateOfRepair= @DateOfRepair,  NextDateOfRepair=@NextDateOfRepair, TimeOrder=@TimeOrder, TypeOfRepair= @TypeOfRepair, AddressOfRepair=@AddressOfRepair, UserId= @UserId,Notes=@Notes,Status =  @Status,Price=@Price
  WHERE Id= @Id
  Update Device set StatusRepair = 0 where Id=@DeviceId
END




GO
/****** Object:  StoredProcedure [dbo].[EditRepairType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[EditRepairType]
          @Id int,
          @TypeName nvarchar(100), 
		  @Notes nvarchar(1000)
AS
BEGIN
      UPDATE RepairType
	  SET TypeName= @TypeName,Notes=@Notes
	  WHERE Id =@Id
END




GO
/****** Object:  StoredProcedure [dbo].[GetData_HorizontalChart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetData_HorizontalChart]
AS
BEGIN
select vv.name, vv.num from (
select SUBSTRING(pr.ProjectName,1,20) name, count(ct.DeviceId) num from DeviceOfProject ct, ProjectDKC pr where ct.ProjectId = pr.Id and pr.IsDeleted = 0 and ct.IsDeleted = 0 and ct.Status =  1
group by pr.ProjectName )  vv
END  ; 

GO
/****** Object:  StoredProcedure [dbo].[GetData_PieChart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetData_PieChart]
AS
BEGIN

select sum(vv.num) num, vv.Status_type from (
select case when ce.Status = 0 and ce.IsDeleted = 0 and  ISNULL(ce.StatusRepair,0) = 0 then 1 else 0 end num, N'Thiết bị rảnh' Status_type  from Device ce
where  ce.Status = 0 and ce.IsDeleted = 0 and  ISNULL(ce.StatusRepair,0) = 0
union all
select case when ce.Status = 1 and ce.IsDeleted = 0  and  ISNULL(ce.StatusRepair,0) = 0  then 1 else 0 end num, N'Thiết bị đang sử dụng' Status_type  from Device ce
where  ce.Status = 1 and ce.IsDeleted = 0  and  ISNULL(ce.StatusRepair,0) = 0 
union all
select case when ce.Status = 2 and ce.IsDeleted = 0  then 1 else 0 end num, N'Thiết bị đã thanh lý' Status_type  from Device ce
where ce.Status = 2 and ce.IsDeleted = 0
union all
select case when  ce.Status = 0 and ce.IsDeleted = 0  and ce.StatusRepair = 1 then 1 else 0 end  num, N'Thiết bị rảnh + hỏng' Status_type  from Device ce
where ce.Status = 0 and ce.IsDeleted = 0  and ce.StatusRepair = 1
union all
select case when  ce.Status = 1 and ce.IsDeleted = 0  and ce.StatusRepair = 1 then 1 else 0 end num, N'Thiết bị đang sử dụng + hỏng' Status_type  from Device ce
where ce.Status = 1 and ce.IsDeleted = 0  and ce.StatusRepair = 1
) vv group by vv.Status_type;
END  ; 

GO
/****** Object:  StoredProcedure [dbo].[GetMaxIdSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetMaxIdSparePart]
as
begin
Select Max(Id) from DeviceSparePart;
end
GO
/****** Object:  StoredProcedure [dbo].[GetUnitsById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetUnitsById]
	-- Add the parameters for the stored procedure here
	@Id INT, 
	@UserName NVARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

	declare @parentId int = 0, @roleId NVARCHAR(250); 
	select @roleId = GroupID from UserLogin u where u.UserName = @UserName
	
	if(@roleId = 'ADMIN' or @roleId = 'DIRECTOR')
	 begin 
	    select @parentId = p.ParentId from ProjectDKC p where p.Id = @Id
	 end
    ;with temp as(
		select * from ProjectDKC where @Id = -1 OR  id = @Id or (@parentId > 0and ParentId = @parentId)
		union all
		select p.* from ProjectDKC p inner join temp t on p.id = t.ParentId 
	) select distinct temp.*, 
					  u.FullName, 
					  (select count(dp.DeviceId) from DeviceOfProject dp where dp.ProjectId in (select p.Id from ProjectDKC p where p.Id =  temp.Id or p.ParentId =  temp.Id) and dp.[status] = 1) NumDevice 
					  from temp left outer join [User] u on temp.ManagerProject = u.Id
END
GO
/****** Object:  StoredProcedure [dbo].[HistoryRepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HistoryRepairDetails]
@Id int 
as
Begin 
Select  r.*,u.FullName, d.DeviceName,d.DeviceCode,t.TypeName, format(r.Price, '#,#') PriceOne
FROM  RepairDetails as r 
			  left outer  join Device as d on r.DeviceId = d.Id 
              left outer join [dbo].[User] as u  on r.UserId = u.Id  
	          left outer join RepairType as t  on r.TypeOfRepair = t.Id  
			  Where r.DeviceId = @Id

end





GO
/****** Object:  StoredProcedure [dbo].[HistoryScheduleTestById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[HistoryScheduleTestById]
@Id int 
as
Begin 
Select  s.Id,s.DeviceId,s.DateOfTest,s.NextDateOfTest,s.CategoryTest,s.UserTest,s.Notes,s.Status_tt,
s.CreateDate,s.CompanyTest,s.CycleTest,case when GETDATE() > s.NextDateOfTest then 2 else s.Status end  Status,u.FullName, d.DeviceName,d.DeviceCode
FROM  ScheduleTest as s 
			  left outer  join Device as d on s.DeviceId = d.Id 
              left outer join [dbo].[User] as u  on s.UserTest = u.Id  
	        
			  Where s.DeviceId = @Id order by s.DateOfTest desc

end


GO
/****** Object:  StoredProcedure [dbo].[LiquidationDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LiquidationDevice]
@Id char(5000)
AS
BEGIN
    Update Device
    set Status=2 
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(5000))))+',',+@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[NhapDeviceSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[NhapDeviceSparePart]
@SparePartId int,
@Amount decimal,
@NumSparePart int,
@DateAdded date,
@Notes nvarchar(400)
as
begin
insert into DeviceSparePartHistory  ( SparePartId, NumSparePart, TransType, DateAdded, Notes, CreateDate, CreateUser, Isdelete, Amount)
values (@SparePartId, @NumSparePart, 'NHAP', @DateAdded, @Notes, GETDATE(), '', 0, @Amount)

update DeviceSparePart set TotalSparePart = TotalSparePart + @NumSparePart, RemainingAmount =  RemainingAmount +  @NumSparePart where id = @SparePartId
end;



GO
/****** Object:  StoredProcedure [dbo].[OderCode]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure  [dbo].[OderCode]
          @Id int
as
begin
    declare @odercode int
    set @odercode = (select OrderCode from DeviceType where Id= @Id)
	update DeviceType set OrderCode = @odercode + 1 where Id=@Id
	select @odercode as Code
end



GO
/****** Object:  StoredProcedure [dbo].[ProjectById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ProjectById]
           @Id int
AS
BEGIN

   SELECT *
    FROM ProjectDKC as P
    JOIN [dbo].[User] as U  ON   P.ManagerProject  = U.Id 
	Where P.Id = @Id
  
END




GO
/****** Object:  StoredProcedure [dbo].[RepairDetailsAll]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[RepairDetailsAll]

as
begin
Select r.Id ,r.DeviceId,r.AddressOfRepair,r.DateOfRepair,r.NextDateOfRepair,r.TimeOrder,r.Notes, u.FullName, d.DeviceName,t.TypeName
from RepairDetails as r 
    left outer  join Device as d on r.DeviceId = d.Id 
      left outer join [dbo].[User] as u  on r.UserId = u.Id  
	 left outer join RepairType as t on r.TypeOfRepair = t.Id


end 



GO
/****** Object:  StoredProcedure [dbo].[RepairDetailsById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[RepairDetailsById]
@Id int 
as
Begin 
Select  r.*,u.FullName, d.DeviceName,t.TypeName,d.DeviceCode,d.Price,format(d.Price, '#,#') PriceOne ,format(r.Price, '#,#') PriceRepair, V.TypeName AS DeviceTypeName,S.Name, d.Status as StatusDevice
FROM  RepairDetails as r 
			  left outer  join Device as d on r.DeviceId = d.Id 
              left outer join [dbo].[User] as u  on r.UserId = u.Id  
	          left outer join RepairType as t on r.TypeOfRepair = t.Id 
			   left outer join DeviceType as v on d.TypeOfDevice = v.Id 
			     left outer join Supplier as S on d.SupplierId = S.Id 
			  Where r.Id = @Id

end


GO
/****** Object:  StoredProcedure [dbo].[ReturnDeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ReturnDeviceOfProject]
  @ProjectId  int,
  @DeviceId int ,
  @Notes nvarchar(2000)
 
AS
BEGIN
  update DeviceOfProject set Status = 0,DateOfReturn = GETDATE(), Notes = @Notes where @ProjectId = ProjectId and @DeviceId = DeviceId and Status =1
  Update Device set Status=0 where Id=@DeviceId
  --Insert into UsageDevice(DeviceId,ProjectId,DateUse,Notes)
  --values(@DeviceId,@ProjectId,GETDATE(),N'Trả về kho')
END



GO
/****** Object:  StoredProcedure [dbo].[ReturnDeviceProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ReturnDeviceProject]
  @DeviceId int   
AS
BEGIN
  declare @ProjectId int 
  set @ProjectId = (select ProjectId from DeviceOfProject where DeviceId=@DeviceId and Status=1)
  if (@ProjectId is not Null)
     begin
	    Update DeviceOfProject  set Status = 0,DateOfReturn = GETDATE() where @DeviceId=DeviceId and Status =1
        Update Device set Status=0 where Id=@DeviceId
        Insert into UsageDevice(DeviceId,ProjectId,DateUse,Notes)
          values(@DeviceId,@ProjectId,GETDATE(),N'Trả về kho')
     end
END



GO
/****** Object:  StoredProcedure [dbo].[RoleById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[RoleById]
@Id int
As
    Select * from Role
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[ScheduleTestById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ScheduleTestById]
@Id int 
as
Begin 
Select  s.*,u.FullName, d.DeviceName,d.DeviceCode,   case when  GETDATE() < DATEADD(DAY, -10, s.NextDateOfTest) then 0 when GETDATE() between DATEADD(DAY, -10, s.NextDateOfTest) and s.NextDateOfTest then 1 when GETDATE() > s.NextDateOfTest then 2  else -1 end as Status_tt2
FROM  ScheduleTest as s 
			  left outer  join Device as d on s.DeviceId = d.Id 
              left outer join [dbo].[User] as u  on s.UserTest = u.Id  
	        
			  Where s.Id = @Id

end




GO
/****** Object:  StoredProcedure [dbo].[SeachDeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SeachDeviceOfProject]
@devicetypes int, 
@status int
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = 'Where 1 = 1 '
if (@devicetypes <> null )
    set @condition = @condition + 'AND ManagerProject =' + CAST(@devicetypes as char)
if(@status <> -1)
	set @condition = @condition + ' AND D.Status = ' + CAST(@status as char)
SET @query = 'SELECT  * FROM DeviceOfProject as D JOIN Device as E  ON   D.DeviceId  = E.Id  ' + @condition 
EXECUTE sp_executesql @query
end





GO
/****** Object:  StoredProcedure [dbo].[SearchDepartment]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchDepartment] 
@managerProject int = NULL, 
@status int = NULL,
@TypeProject int = NULL, 
@ProjectSymbol nchar(50) = NULL, 
@HasChild INT = NULL, 
@ParentId INT = NULL, 
@DepartmentId INT = NULL
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where P.IsDeleted = 0'
if (@managerProject <> -1 )
    set @condition = @condition + ' AND ManagerProject =' + CAST(@managerProject as char)
if(@status <> -1)
	set @condition = @condition + ' AND P.Status = ' + CAST(@status as char)

if(@ProjectSymbol<> '' )
	set @condition = @condition + N' AND P.ProjectSymbol LIKE N' + char(39) + @ProjectSymbol + char(39)

if(@TypeProject <> -1)
	set @condition = @condition + ' AND P.TypeProject = ' + CAST(@TypeProject as char)

if(@HasChild <> -1)
	set @condition = @condition + ' AND P.HasChild = ' + CAST(@HasChild as char)

if(@DepartmentId <> -1)
	set @condition = @condition + ' AND ( P.Id = ' + CAST(@DepartmentId as char) + ' ) OR ( P.ParentId = ' +  CAST(@DepartmentId as char) + ' )'


SET @query = 'SELECT  P.* , U.[FullName], (SELECT count(dp.DeviceId)
FROM DeviceOfProject dp where dp.ProjectId = P.Id and dp.Status =1) NumDevice FROM ProjectDKC as P  left outer JOIN  [dbo].[User] as U  ON   P.ManagerProject  = U.Id  ' + @condition 
EXECUTE sp_executesql @query
END





GO
/****** Object:  StoredProcedure [dbo].[SearchDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery21.sql|7|0|C:\Users\tribm\AppData\Local\Temp\~vs8CDF.sql
CREATE PROC [dbo].[SearchDevice] 
@status int = null,
@devicetype int = null,
@guarantee int = null,
@projectid int = null,
@devicecode nvarchar(500) = null, 
@userName nvarchar(50)
as
begin

	declare @query Nvarchar(2000)
	declare @condition Nvarchar(2000) 
	declare @parentId int 
	declare @roleId nvarchar(1500)
		select @roleId = GroupID from UserLogin u where u.UserName = @userName
	if(@roleId = 'ADMIN' or @roleId = 'DIRECTOR')
	 begin 
	        print('ad')
			select @parentId = ParentId from ProjectDKC p where p.Id = @projectid
	 end

		select nv.*,( format(nv.Price, 'N0')) PriceOne,ph.TypeName,kv.FullName,sp.Name,
										(select distinct top 1 pj.ProjectSymbol FROM DeviceOfProject dv 
										 inner join ProjectDKC pj ON dv.ProjectId = pj.Id 
										 where dv.Status = 1 AND dv.DeviceId = nv.Id) ProjectSymbol, 
									    (select distinct top 1 pj.ProjectName FROM DeviceOfProject dv INNER JOIN ProjectDKC pj ON dv.ProjectId = pj.Id WHERE dv.Status = 1 AND dv.DeviceId = nv.Id) ProjectName,
										(select top 1 concat((case TypeComponant when 0 then char(39)+'Tb ngoài'+char(39)+' when 1 then N'+char(39)+'Tb trong'+char(39)+' else '+char(39)+' '+char(39) end ) , char(39)+' - '+char(39)  , 
																			(select top 1 v.DeviceCode from Device  v where v.Id = d.DeviceCodeParents ))
																			from DeviceDevice d where d.DeviceCodeParents = nv.ParentId and d.DeviceCodeChildren = nv.Id and d.IsDeleted = 0 ) 
																			NameTypeComponant
										FROM Device nv inner join DeviceOfProject dov on nv.Id = dov.DeviceId
										               left outer JOIN DeviceType ph ON ph.Id = nv.TypeOfDevice
													   left outer JOIN [User] kv ON kv.Id = nv.UserId 
													   left outer JOIN Supplier sp ON sp.Id = nv.SupplierId 
													    where  (isnull(@status, -1) < 0 or nv.[Status] = isnull(@status, nv.[Status]))
														      and (isnull(@devicetype, 0) <= 0 or TypeOfDevice = isnull(@devicetype, TypeOfDevice) )
															  and ( isnull(@guarantee, -1) = -1 or (@guarantee = 1 and Guarantee >= getdate()) or (@guarantee = 2 and Guarantee <= getdate()))
															  and ( isnull(@devicecode, '') = '' or (nv.DeviceCode LIKE char(39)+'%'+@devicecode+'%'+ char(39) or kv.FullName Like  nchar(39) +'%'+@devicecode+'%' + nchar(39)  OR  nv.DeviceName Like  nchar(39) +'%'+ @devicecode+ '%' + nchar(39)))
															  and  dov.ProjectId in (SELECT p.Id FROM ProjectDKC p WHERE isnull(@projectid, -1)= -1 OR ( P.Id = @projectid or p.ParentId = @parentId))

end

GO
/****** Object:  StoredProcedure [dbo].[SearchDevice2]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[SearchDevice2] 
@status int,
@devicetype int,
@guarantee int,
@projectid int,
@devicecode nvarchar(500)
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' Where nv.IsDeleted=0 '
if(@status <> -1)
	set @condition = @condition + ' AND nv.Status = ' + CAST(@status as char)
if(@devicetype <> 0)
	set @condition = @condition + ' AND TypeOfDevice = ' + CAST(@devicetype as char)
if(@guarantee =1 )
	set @condition = @condition + ' AND Guarantee >=  GETDATE()' 
if(@guarantee =2)
	set @condition = @condition + ' AND Guarantee < GETDATE()' 
if(@projectid <> 0)
	set @condition = @condition + ' AND (SELECT dv.ProjectId FROM DeviceOfProject dv INNER JOIN ProjectDKC pj ON dv.ProjectId = pj.Id WHERE dv.Status = 1 AND dv.DeviceId = nv.Id) = ' + CAST(@projectid as char)
if(@devicecode<> '' )
	set @condition = @condition + ' AND (nv.DeviceCode LIKE N'+char(39)+'%'+@devicecode+'%'+ char(39)+ ' OR kv.FullName Like N'+ nchar(39) +'%'+@devicecode+'%' + nchar(39)+ N' OR  nv.DeviceName Like N'+ nchar(39) +'%'+@devicecode+'%' + nchar(39)+')'
SET @query = 'SELECT nv.*,ph.TypeName,kv.FullName,sp.Name,(SELECT pj.ProjectSymbol FROM DeviceOfProject dv INNER JOIN ProjectDKC pj ON dv.ProjectId = pj.Id WHERE dv.Status = 1 AND dv.DeviceId = nv.Id) ProjectSymbol,(SELECT pj.ProjectName FROM DeviceOfProject dv INNER JOIN ProjectDKC pj ON dv.ProjectId = pj.Id WHERE dv.Status = 1 AND dv.DeviceId = nv.Id) ProjectName FROM Device nv
    left outer JOIN DeviceType ph
          ON ph.Id = nv.TypeOfDevice
    left outer JOIN [User] kv
          ON kv.Id = nv.UserId 
    left outer JOIN Supplier sp
          ON sp.Id = nv.SupplierId ' + @condition +' ORDER BY nv.Id Desc '
EXECUTE sp_executesql @query
end





GO
/****** Object:  StoredProcedure [dbo].[SearchDeviceSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SearchDeviceSparePart]
@DeviceType int,
@SparePartName nvarchar(100)
as 
Declare @txt nvarchar(100)
begin 
set @txt = ISNULL(@SparePartName,'');
Select t.*, (FORMAT(t.Amount, '#,#'))  Amountfomat,(FORMAT(t.TotalSparePart, '#,#')) TotalSparePartFomat,(FORMAT(t.RemainingAmount, '#,#')) RemainingAmountFomat , p.TypeName
 from DeviceSparePart t, DeviceType p where t.DeviceType = p.Id and t.DeviceType = case when @DeviceType is null or @DeviceType = -1 then t.DeviceType else @DeviceType end
 and t.SparePartName like N'%'+@txt+'%' and t.Isdelete = 0 order by Id desc
end


GO
/****** Object:  StoredProcedure [dbo].[SearchDeviceSparePartHistory]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SearchDeviceSparePartHistory]
@DeviceType int,
@SparePartName nvarchar(100),
@TypeTran nvarchar(20)
as 
Declare @txt nvarchar(100),
 @txt_type nvarchar(100)
begin 
set @txt = ISNULL(@SparePartName,'');
set @txt_type = ISNULL(@TypeTran,'');
Select h.*, t.SparePartName, (FORMAT(h.Amount, '#,#'))  Amountfomat, p.TypeName, (FORMAT(h.NumSparePart, '#,#'))  NumSparePartfomat
 from DeviceSparePart t, DeviceType p, DeviceSparePartHistory h where h.SparePartId = t.Id and t.DeviceType = p.Id and t.DeviceType = case when @DeviceType is null or @DeviceType = -1 then t.DeviceType else @DeviceType end
 and t.SparePartName like N'%'+@txt+'%' and h.Isdelete = 0 and h.TransType like N'%'+@txt_type+'%' order by Id desc
end


GO
/****** Object:  StoredProcedure [dbo].[SearchDeviceType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROC [dbo].[SearchDeviceType] 
as
begin
Select * from DeviceType
end



GO
/****** Object:  StoredProcedure [dbo].[SearchProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchProject] 
@managerProject int, 
@status int,
@TypeProject int , 
@ProjectSymbol nchar(50)
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where P.IsDeleted = 0'
if (@managerProject <> -1 )
    set @condition = @condition + ' AND ManagerProject =' + CAST(@managerProject as char)
if(@status <> -1)
	set @condition = @condition + ' AND P.Status = ' + CAST(@status as char)

if(@ProjectSymbol<> '' )
	set @condition = @condition + N' AND P.ProjectSymbol LIKE N' + char(39) + @ProjectSymbol + char(39)

if(@TypeProject <> -1)
	set @condition = @condition + ' AND P.TypeProject = ' + CAST(@TypeProject as char)


SET @query = 'SELECT  P.* , U.[FullName], (SELECT count(dp.DeviceId)
FROM DeviceOfProject dp where dp.ProjectId = P.Id and dp.Status =1) NumDevice FROM ProjectDKC as P  left outer JOIN  [dbo].[User] as U  ON   P.ManagerProject  = U.Id  ' + @condition 
EXECUTE sp_executesql @query
end




GO
/****** Object:  StoredProcedure [dbo].[SearchRepairDetails]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchRepairDetails] 
@repairtypes int, 
@user int,
@iddevice int,
@status int,
@departmentId int
as
begin
   
    SELECT r.*,( FORMAT(r.Price,+char(39)+  +char(35)+ ','+char(35)+ ''+char(39) )) PriceOne, u.FullName, d.DeviceName,t.TypeName,d.DeviceCode FROM RepairDetails as r 
	   inner join DeviceOfProject dp on r.DeviceId = dp.DeviceId and (isnull(@departmentId, -1) = -1 or dp.ProjectId = @departmentId)
	   left outer join Device d on r.DeviceId = d.Id
	   left outer join [dbo].[User] u on r.UserId = u.Id
	   left outer join RepairType t on r.TypeOfRepair = t.Id
	   where (@repairtypes = -1 or r.TypeOfRepair = @repairtypes)
	          and (@user = -1 or u.Id = @user)
			  and (@iddevice = -1 or r.DeviceId = @iddevice)

/*declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where 1=1'
if (@repairtypes <> -1 )
    set @condition = @condition + 'AND r.TypeOfRepair =' + CAST(@repairtypes as char)
if(@user <> -1)
	set @condition = @condition + ' AND r.UserId = ' + CAST(@user as char)
if (@iddevice <> -1 )
    set @condition = @condition + 'AND r.DeviceId =' + CAST(@iddevice as char)
if (@status <> -1 )
set @condition = @condition + 'AND r.Status =' + CAST(@status as char)
SET @query = 'SELECT r.*,( FORMAT(r.Price,'+char(39)+'  '+char(35)+','+char(35)+''+char(39)+')) PriceOne, u.FullName, d.DeviceName,t.TypeName,d.DeviceCode
              FROM  RepairDetails as r 
			  left outer  join Device as d on r.DeviceId = d.Id 
              left outer join [dbo].[User] as u  on r.UserId = u.Id  
	          left outer join RepairType as t on r.TypeOfRepair = t.Id '
			   + @condition 
EXECUTE sp_executesql @query
*/
end


GO
/****** Object:  StoredProcedure [dbo].[SearchRepairDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchRepairDevice] 
@id int

as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = 'Where nv.IsDeleted=0 '
if(@id <> -1)
	set @condition = @condition + ' AND nv.Id = ' + CAST(@id as char)

SET @query = 'SELECT nv.*,ph.TypeName,kv.FullName,sp.Name,pj.ProjectName FROM Device nv
    left outer JOIN DeviceType ph
          ON ph.Id = nv.TypeOfDevice
    left outer JOIN [User] kv
          ON kv.Id = nv.UserId 
    left outer JOIN Supplier sp
          ON sp.Id = nv.SupplierId 
    left outer JOIN DeviceOfProject dp
          ON dp.DeviceId = nv.Id
    left outer JOIN ProjectDKC pj
          ON pj.Id = dp.ProjectId ' + @condition 
EXECUTE sp_executesql @query
end



GO
/****** Object:  StoredProcedure [dbo].[SearchRequestDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchRequestDevice]
@status int, 
@approved bit

as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where 1=1'
if (@status <> -1 )
    set @condition = @condition + 'AND r.Status =' + CAST(@status as char)
if(@approved <> -1)
	set @condition = @condition + ' AND r.Approved = ' + CAST(@approved as char)

SET @query = 'SELECT r.*,u.FullName,d.TypeName
				 FROM  RequestDevice as r
				 left outer  join [dbo].[User] as u on r.UserRequest = u.Id
				 left outer  join DeviceType as d on r.TypeOfDevice = d.Id
                                                                      '
			   + @condition 
EXECUTE sp_executesql @query
end




GO
/****** Object:  StoredProcedure [dbo].[SearchRequestDeviceNew]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchRequestDeviceNew]
@status int, 
@approved bit

as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where 1=1'
if (@status <> -1 )
    set @condition = @condition + 'AND r.Status =' + CAST(@status as char)
if(@approved <> -1)
	set @condition = @condition + ' AND r.Approved = ' + CAST(@approved as char)

SET @query = 'SELECT r.*,u.FullName,d.TypeName
				 FROM  RequestDevice as r
				 left outer  join [dbo].[User] as u on r.UserRequest = u.Id
				 left outer  join DeviceType as d on r.TypeOfDevice = d.Id
                                                                      '
			   + @condition 
EXECUTE sp_executesql @query
end






GO
/****** Object:  StoredProcedure [dbo].[SearchRole]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SearchRole]
as
begin
Select * from Role
end



GO
/****** Object:  StoredProcedure [dbo].[SearchScheduleTest]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchScheduleTest]
@user int, 
@status int,
@Status_tt int,
@Device_id int
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = ' where 1=1'
if (@Device_id <> -1 )
    set @condition = @condition + 'AND d.Id =' + CAST(@Device_id as char)
if (@user <> -1 )
    set @condition = @condition + 'AND s.UserTest =' + CAST(@user as char)
if (@Status_tt = 0 )
    set @condition = @condition + 'AND  GETDATE() < DATEADD(DAY, -30, s.NextDateOfTest)'
if (@Status_tt = 1 )
	 set @condition = @condition + 'AND  GETDATE() between DATEADD(DAY, -30, s.NextDateOfTest) and s.NextDateOfTest'
if (@Status_tt = 2 )
	 set @condition = @condition + 'AND  GETDATE() > s.NextDateOfTest'

if(@status <> -1)
	set @condition = @condition + ' AND s.Status = ' + CAST(@status as char)

SET @query = 'SELECT s.CategoryTest,s.CreateDate,s.DateOfTest,s.DeviceId,s.Id,s.NextDateOfTest,s.Notes,s.Status,s.UserTest ,s.CompanyTest,ISNULL(s.CycleTest,0) CycleTest, u.FullName, d.DeviceName,d.DeviceCode , 
                 case when  GETDATE() < DATEADD(DAY, -30, s.NextDateOfTest) then 0 when GETDATE() between DATEADD(DAY, -30, s.NextDateOfTest) and s.NextDateOfTest then 1 when GETDATE() > s.NextDateOfTest then 2  else -1 end as Status_tt
				 FROM  ScheduleTest as s
				 left outer  join [dbo].[User] as u on s.UserTest = u.Id
				 left outer  join Device as d on s.DeviceId = d.Id
				 join (select max(t.DateOfTest) DateOfTest,t.DeviceId from  ScheduleTest t  group by t.DeviceId )  as f on ( s.DeviceId = f.DeviceId and s.DateOfTest = f.DateOfTest )'
				  + @condition + ' order by DateOfTest Desc'
EXECUTE sp_executesql @query
end




GO
/****** Object:  StoredProcedure [dbo].[SearchSupplier]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[SearchSupplier]
@Status int
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = 'Where 1 = 1 '
if(@status <> -1)
	set @condition = @condition + ' AND Status = ' + CAST(@status as char)
SET @query = 'SELECT * FROM Supplier' + @condition 
EXECUTE sp_executesql @query
end



GO
/****** Object:  StoredProcedure [dbo].[SearchUseDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SearchUseDevice] 
           @DeviceId int 
as
Begin
   Select ud.*,pj.ProjectName from UsageDevice ud
         left outer JOIN ProjectDKC pj
          ON pj.Id = ud.ProjectId
       Where ud.DeviceId =@DeviceId
	   ORDER BY ud.Id Desc
End



GO
/****** Object:  StoredProcedure [dbo].[SearchUser]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SearchUser] 
@status int
as
begin
declare @query Nvarchar(2000)
declare @condition Nvarchar(2000) 
SET @condition = 'Where CAST(us.Department as int) = pr.Id and us.IsDeleted=0 '
if(@status <> -1)
	set @condition = @condition + ' AND us.Status = ' + CAST(@status as char)

SET @query = 'Select us.Id,us.UserName,us.FullName,us.Email,us.PhoneNumber,us.Address,pr.ProjectName Department,us.Position,us.Status,us.IsDeleted,us.GroupID FROM [dbo].[User] us, ProjectDKC pr ' + @condition 
EXECUTE sp_executesql @query
end



GO
/****** Object:  StoredProcedure [dbo].[SelectList]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectList]
@Id char(11)
AS
BEGIN
    select* from Device 
    WHERE CHARINDEX(','+LTRIM(RTRIM(CAST(Id AS CHAR(11))))+',',@Id) > 0 
END



GO
/****** Object:  StoredProcedure [dbo].[StatisticalDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[StatisticalDevice]
@departmentId INT
as
begin
select dv.*,   (  FORMAT(dv.Price, '#,#'))  PriceOne , (SELECT COUNT(DeviceId) FROM DeviceOfProject where dv.Id=DeviceOfProject.DeviceId ) as TimeUse,
                                          (Select Count(Id) from RepairDetails where dv.Id=RepairDetails.DeviceId ) TimeRepair,
                                          FORMAT( (Select SUM(Price) from RepairDetails where dv.Id=RepairDetails.DeviceId ), '#,#') SumPrice										
from Device dv INNER JOIN DeviceOfProject dP on dv.Id = dP.deviceId AND (dP.ProjectId IN (SELECT p.Id FROM ProjectDKC p WHERE @departmentId= -1 OR ( P.Id = @departmentId or p.ParentId = @departmentId)))
where dv.IsDeleted = 0 and dv.Status != 2
end

GO
/****** Object:  StoredProcedure [dbo].[StatisticProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE proc [dbo].[StatisticProject]
 @departmentId INT
as
begin
SELECT  Id, ProjectName,ProjectSymbol,Status,NumDevice, NumDeviceActive, NumDevice - NumDeviceActive as NumDeviceReturn  FROM
(
	SELECT
		P.Id , P.ProjectName , P.ProjectSymbol , P.Status,
		(SELECT count(DISTINCT dp.DeviceId)FROM DeviceOfProject dp where dp.ProjectId = P.Id) as NumDevice ,
		(SELECT count(dp.DeviceId)FROM DeviceOfProject dp where dp.ProjectId = P.Id  and dp.Status=1) as NumDeviceActive
	FROM
		ProjectDKC as P where P.IsDeleted = 0 and P.TypeProject = 1 and (@departmentId = -1 or p.Id = @departmentId or p.ParentId = @departmentId)
)
ReturnTable

end 




GO
/****** Object:  StoredProcedure [dbo].[SupplierById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[SupplierById]
@Id int
As
    Select * from Supplier
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[TypeComponantOfDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[TypeComponantOfDevice]
@TypeParent int
as
begin
select 
(Select t.TypeName from DeviceType t where t.Id = d.TypeSymbolParents )  NameTypeParents,
(Select t.TypeName from DeviceType t where t.Id = d.TypeSymbolChildren )  NameTypeChildren,
d.TypeSymbolParents , d.TypeSymbolChildren,d.id,d.IsDeleted, d.TypeComponant
from DeviceTypeComponantType as d 
where d.TypeSymbolParents = @TypeParent 
end 


GO
/****** Object:  StoredProcedure [dbo].[UpdateDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDevice]  
      @Id int,
      @DeviceCode char(50),
	  @NewCode char(50),
      @DeviceName nvarchar(200),
      @TypeOfDevice int,
      @ParentId int,
      @Configuration nvarchar(500),
      @Price float,
      @PurchaseContract nvarchar(500),
      @DateOfPurchase date,
      @SupplierId int,
      @Guarantee date,
      @UserId int,
      @Notes nvarchar(2000),
      @CreatedDate date,
      @Status int,
	    @DeviceNameEnglish nvarchar(200),
	  @DeviceModel nvarchar(100),
	  @DeviceSeria nvarchar(100),
	  @DateAdded date
AS
BEGIN
   Update Device
   set DeviceCode=@DeviceCode,NewCode=@NewCode,DeviceName=@DeviceName,TypeOfDevice=@TypeOfDevice,ParentId=@ParentId,Configuration=@Configuration,Price=@Price,PurchaseContract=@PurchaseContract,DateOfPurchase=@DateOfPurchase,SupplierId=@SupplierId,Guarantee=@Guarantee,UserId=@UserId,Notes=@Notes,CreatedDate=@CreatedDate,Status=@Status,
   DeviceNameEnglish =@DeviceNameEnglish,DeviceModel = @DeviceModel,DeviceSeria = @DeviceSeria,DateAdded = @DateAdded
   where Id=@Id
END



GO
/****** Object:  StoredProcedure [dbo].[UpdateDeviceOfProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateDeviceOfProject]
  @Id int,
  @ProjectId  int,
  @DeviceId int , 
  @DateOfDelivery date,
  @DateOfReturn date, 
  @Status int,
  @Notes nvarchar(2000),
  @IsDeleted bit
AS
BEGIN
  UPDATE DeviceOfProject 
  SET ProjectId =@ProjectId ,  DeviceId=@DeviceId,  DateOfDelivery=@DateOfDelivery,DateOfReturn= @DateOfReturn,Status= @Status,Notes= @Notes,IsDeleted= @IsDeleted 
 WHERE Id = @Id  
END




GO
/****** Object:  StoredProcedure [dbo].[UpdateDeviceType]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDeviceType] 
      @Id int, 
      @TypeName nvarchar(100),
	  @TypeSymbol nchar(50),
      @Notes nvarchar(1000)
AS
BEGIN
   Update DeviceType
   set TypeName=@TypeName,TypeSymbol= @TypeSymbol ,Notes=@Notes where Id=@Id
END



GO
/****** Object:  StoredProcedure [dbo].[UpdateProject]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProject]
    @Id int,
	@ProjectSymbol nchar(50),
    @ProjectName nvarchar(200),
    @ManagerProject int,
    @Address nvarchar(1000),
    @FromDate Date ,
	@ToDate Date,
	@CreatedDate Date,
	@ModifiedDate Date,
	@Status int ,
	@IsDeleted bit, 
	@ParentId INT
AS
BEGIN
     UPDATE ProjectDKC
	SET  ProjectSymbol=@ProjectSymbol,ProjectName=@ProjectName, ManagerProject=@ManagerProject, Address=@Address, FromDate=@FromDate, ToDate=@ToDate, CreatedDate=@CreatedDate, ModifiedDate=@ModifiedDate, Status=@Status, IsDeleted=@IsDeleted, ParentId = @ParentId
	 WHERE  Id = @Id
END




GO
/****** Object:  StoredProcedure [dbo].[UpdateRequestDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateRequestDevice]
           @Id int ,
           @UserRequest int,
           @DateOfRequest date,
           @DateOfUse date,
           @DeviceName nvarchar(200),
           @TypeOfDevice int,
           @Configuration nvarchar(2000),
           @Notes nvarchar(2000),
           @Approved bit,
           @UserApproved int,           
           @Status int,
		   @NumDevice int,
		   @NoteProcess nvarchar(2000),
           @NoteReasonRefuse nvarchar(2000),
		   @NameUserApproved nvarchar(100)
  
AS
BEGIN
    UPDATE RequestDevice
	SET  UserRequest= @UserRequest ,
           DateOfRequest=@DateOfRequest ,
           DateOfUse=@DateOfUse ,
          DeviceName= @DeviceName ,
         TypeOfDevice=  @TypeOfDevice,
          Configuration= @Configuration,
           Notes=@Notes ,
          Approved= @Approved,
          UserApproved= @UserApproved ,     
           Status= @Status ,
		   NumDevice = @NumDevice,
		  NoteProcess = @NoteProcess,
		   NoteReasonRefuse = @NoteReasonRefuse,
		   NameUserApproved = @NameUserApproved
	WHERE Id = @Id
END




GO
/****** Object:  StoredProcedure [dbo].[UpdateScheduleTest]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateScheduleTest]
           @Id int,
           @DeviceId int,
           @DateOfTest date,
           @NextDateOfTest date,
           @CategoryTest nvarchar(2000),
           @UserTest int,
           @Notes nvarchar(2000),
           @Status int,
		    @CompanyTest nvarchar(300)
           
  
AS
BEGIN
    UPDATE  ScheduleTest 
	SET DeviceId= @DeviceId, DateOfTest = @DateOfTest, NextDateOfTest= @NextDateOfTest, CategoryTest=@CategoryTest, UserTest=@UserTest, Notes=@Notes, Status=@Status,CompanyTest = @CompanyTest 
     WHERE Id = @Id
END







GO
/****** Object:  StoredProcedure [dbo].[UpdateSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[UpdateSparePart]
@id int,
@DeviceType int,
@SparePartName nvarchar(200),
@Amount decimal,
@TotalSparePart int,
@DateAdded date,
@Config nvarchar(400),
@Notes nvarchar(400)

as
begin
update DeviceSparePart set   SparePartName = @SparePartName, DateAdded = @DateAdded, Notes = @Notes, Config = @Config,Amount = @Amount
where Id = @id ;

end;


GO
/****** Object:  StoredProcedure [dbo].[UpdateSupplier]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSupplier]
      @Id int,
      @Name nvarchar(200),
      @Email char(50),
      @Phone char(15),
      @Address nvarchar(50),
      @Support nvarchar(500),
      @Status int
AS
BEGIN
      Update Supplier
      set Name=@Name,Email=@Email,Phone=@Phone,Address=@Address,Support=@Support,Status=@Status where Id=@Id
      
END



GO
/****** Object:  StoredProcedure [dbo].[UpdateUser]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateUser]  
      @Id int,
      @UserName char(50),
      @PassWord char(200),
      @FullName nvarchar(100),
      @Email char(50),
      @PhoneNumber char(15),
      @Address nvarchar(500),
      @Department nvarchar(100),
      @Position nvarchar(100),
      @RoleId int,
      @Status int
AS
BEGIN
   Update [dbo].[User]
   set UserName=@UserName,PassWord=@PassWord,FullName=@FullName,Email=@Email,PhoneNumber=@PhoneNumber,Address=@Address,Department=@Department,Position=@Position,RoleId=@RoleId,Status=@Status where Id=@Id
END



GO
/****** Object:  StoredProcedure [dbo].[UpdateUserDevice]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UpdateUserDevice]  
      @IdDv int,
      @IdUser int
	  
AS
BEGIN
   Update Device
   set  UserId= @IdUser
   where Id= @IdDv
END



GO
/****** Object:  StoredProcedure [dbo].[UserById]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[UserById]
@Id int
As
    Select * from [dbo].[User]
    where Id=@Id



GO
/****** Object:  StoredProcedure [dbo].[XuatDeviceSparePart]    Script Date: 2/19/2025 10:55:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[XuatDeviceSparePart]
@SparePartId int,
@NumSparePart int,
@DateAdded date,
@Notes nvarchar(400)
as
begin
insert into DeviceSparePartHistory  ( SparePartId, NumSparePart, TransType, DateAdded, Notes, CreateDate, CreateUser, Isdelete, Amount)
values (@SparePartId, @NumSparePart, 'XUAT', @DateAdded, @Notes, GETDATE(), '', 0, null)

update DeviceSparePart set  RemainingAmount =  RemainingAmount -  @NumSparePart where id = @SparePartId
end;


GO
USE [master]
GO
ALTER DATABASE [QuanLyTaiSanCtyDATN_2021] SET  READ_WRITE 
GO
