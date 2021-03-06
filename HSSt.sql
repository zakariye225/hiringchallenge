USE [master]
GO
/****** Object:  Database [HSS]    Script Date: 06/13/2020 7:29:07 PM ******/
CREATE DATABASE [HSS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HSS', FILENAME = N'E:\databases\HSS.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HSS_log', FILENAME = N'E:\databases\HSS_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HSS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HSS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HSS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HSS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HSS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HSS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HSS] SET ARITHABORT OFF 
GO
ALTER DATABASE [HSS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HSS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [HSS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HSS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HSS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HSS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HSS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HSS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HSS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HSS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HSS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [HSS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HSS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HSS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HSS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HSS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HSS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HSS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HSS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HSS] SET  MULTI_USER 
GO
ALTER DATABASE [HSS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HSS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HSS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HSS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [HSS]
GO
/****** Object:  StoredProcedure [dbo].[SPCancelation]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPCancelation]
(
@BookID bigint,
@CID bigint,
@CName varchar(50),
@BookedDate date,
@CancelationDate date,
@RoomID bigint,
@Rent varchar(50),
@NODays varchar(50),
@Total varchar(60),
@Prepaid varchar(50),
@Amount varchar(50),
@Payment varchar(50),
@Paymentmode varchar(50),
@liablity varchar(50),
@ReturnLiability varchar(50),
@Cause varchar(80)
)
as
Begin
insert into Cancelation values(@BookID,@CID,@CName,@BookedDate,@CancelationDate,@RoomID,@Rent,@NODays,@Total,@Prepaid,@Amount,@Payment,@Paymentmode,@liablity,@ReturnLiability,@Cause)
update Rooms set Status='Empty' where RoomID=@RoomID
update CheckIns set Status='Canceled' where ID=@BookID
End
GO
/****** Object:  StoredProcedure [dbo].[SPCheckOuts]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPCheckOuts]
(
@CheckoutID int,
@CheckinID nvarchar(50),
@CustomerID nvarchar(50),
@CustomerName nvarchar(50),
@RoomID nvarchar(50),
@RoomType nvarchar(50),
@Rent nvarchar(50),
@Days varchar(50),
@Total nvarchar(50),
@Prepaid nvarchar(50),
@Amount nvarchar(50),
@Payment nvarchar(50),
@PaymentMode nvarchar(50),
@PaymentDate date
)
as
Begin
insert into Checkouts values(@CheckoutID,@CustomerID,@CustomerName,@RoomID,@RoomType,@Rent,@Days,@Total,@Prepaid,@Amount,@Payment,@PaymentMode,@PaymentDate)
update CheckIns set Status='Vocated' where ID=@CheckinID
update Rooms set Status='Empty' where RoomID=@RoomID
End
GO
/****** Object:  StoredProcedure [dbo].[SPCustomerReg]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPCustomerReg]
(
@CustomerID bigint,
@CustomerName varchar(100),
@Gender varchar(50),
@Phone varchar(50),
@Email varchar(50),
@City varchar(50),
@Country varchar(50),
@Date date,
@photo varchar(500)
)
as
BEGIN
IF EXISTS(select * from Customers where CustomerID=@CustomerID )
Update Customers set CustomerName=@CustomerName,Gender=@Gender,Phone=@Phone,Email=@Email,City=@City,Country=@Country,Date=@Date,Photo=@photo
       where CustomerID=@CustomerID
Else
Insert into Customers values(@CustomerID,@CustomerName,@Gender,@Phone,@Email,@City,@Country,@Date,@photo)
END
GO
/****** Object:  StoredProcedure [dbo].[SPFoods]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[SPFoods]
(
@FoodID bigint,
@FoodType varchar(50),
@FoodName varchar(50),
@Costs money
)
as
BEGIN
IF EXISTS(SELECT * FROM Foods WHERE FoodID=@FoodID)
UPDATE Foods SET FoodType = @FoodType,FoodName=@FoodName,Cost=@Costs where FoodID=@FoodID
ELSE
INSERT INTO Foods values(@FoodID,@FoodType,@FoodName,@Costs)
END
GO
/****** Object:  StoredProcedure [dbo].[SPHotelInfo]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPHotelInfo]
(
@ID int,
@HotelName varchar(60),
@Address varchar(80),
@Phone varchar(100),
@Email Varchar(100),
@Logo varchar(900)
)
as
Begin
if exists(select * from HotelInfo where HotelID=@ID)
update HotelInfo set HotelName=@HotelName,Address=@Address,ContactNo=@Phone,Email=@Email,Logo=@Logo where HotelID=@ID
else
insert into HotelInfo values(@ID,@HotelName,@Address,@Phone,@Email,@Logo)
End
GO
/****** Object:  StoredProcedure [dbo].[SPRoomBooking]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SPRoomBooking]
(
@ID Bigint,
@CheckinDate Date,
@CheckoutDate Date,
@NDays varchar(50),
@CID varchar(50),
@CName varchar(50),
@RoomID varchar(50),
@RoomType varchar(50),
@Rent varchar(50),
@Total float,
@Paid float,
@Balane float,
@PaymentMode varchar(60),
@Status varchar(50)
)
as
BEGIN
IF EXISTS(select * from CheckIns where ID=@ID)
Update CheckIns set Checkindate=@CheckinDate,Checkoutdate=@CheckoutDate,NOfDays=@NDays,CID=@CID,CName=@CName,RoomID=@RoomID,
					RoomType=@RoomType,Rent=@Rent,Total=@Total,Paid=@Paid,Balance=@Balane,PaymentMode=@PaymentMode,Status=@Status
ELSE
Insert into CheckIns values(@ID,@CheckinDate,@CheckoutDate,@NDays,@CID,@CName,@RoomID,@RoomType,@Rent,@Total,@Paid,@Balane,
							@PaymentMode,@Status)

END
GO
/****** Object:  StoredProcedure [dbo].[SPRooms]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPRooms]
(
@RoomID Bigint,
@RoomType varchar(50),
@Charges Varchar(50),
@Status varchar(50)
)
as
BEGIN
IF EXISTS(SELECT * FROM Rooms WHERE RoomID=@RoomID)
UPDATE Rooms SET RoomType=@RoomType,Charges=@Charges,Status=@Status
    WHERE RoomID=@RoomID
ELSE
INSERT INTO Rooms VALUES(@RoomID,@RoomType,@Charges,@Status)
END
GO
/****** Object:  StoredProcedure [dbo].[SPRoomStatusUpdate]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPRoomStatusUpdate]
(
@RoomID bigint,
@Status varchar(50)
)
as
Begin
if exists(select * from Rooms where RoomID=@RoomID)
update Rooms set Status=@Status where RoomID=@RoomID 

End
GO
/****** Object:  StoredProcedure [dbo].[SPRPTCheckouts]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPRPTCheckouts]
@CkeckoutID int
as
Begin
select * from Checkouts where ID=@CkeckoutID
End
GO
/****** Object:  StoredProcedure [dbo].[SPSElect]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPSElect]
(
@Fromdate date,
@Todate date
)
as
select * from CheckIns where Checkindate between @Fromdate and @Todate
GO
/****** Object:  StoredProcedure [dbo].[SPSelectCheckinByID]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[SPSelectCheckinByID]
@ID Bigint
as
select * from CheckIns where ID=@ID
GO
/****** Object:  StoredProcedure [dbo].[SPSelectDailyCancelaation]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPSelectDailyCancelaation]
as
Begin
select CancelID,CheckinID,CID,CName,CheckinDate,CancelationDate,RoomID,Cause from Cancelation
where CancelationDate=CONVERT (date, GETDATE()) 
End
GO
/****** Object:  StoredProcedure [dbo].[SPSelectDailyCheckins]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SPSelectDailyCheckins]
as
begin
select ID,Checkindate,Checkoutdate,NOfDays,CID as 'Customer ID',CName as 'Customer Name',
RoomID,RoomType,Rent,Total,Paid,Balance,PaymentMode from CheckIns 
where Checkindate= CONVERT (date, GETDATE()) and Status='Booked'     
End
GO
/****** Object:  StoredProcedure [dbo].[SPSelectDailyPayments]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[SPSelectDailyPayments]
as
begin
select PaymentID,CheckinID,CustomerID,CustomerName,RoomID,
Total,Prepaid,Balance,Payment,PaymentMode 
from Payments where Date=CONVERT (date, GETDATE())
end
GO
/****** Object:  StoredProcedure [dbo].[SPSelectEmptyRooms]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[SPSelectEmptyRooms]
as
begin
SELECT * from Rooms where Status='Empty'
end
GO
/****** Object:  StoredProcedure [dbo].[SPSelectFullRooms]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[SPSelectFullRooms]
as
begin
SELECT * from Rooms where Status='full'
end
GO
/****** Object:  Table [dbo].[Cancelation]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Cancelation](
	[CancelID] [bigint] IDENTITY(1,1) NOT NULL,
	[CheckinID] [bigint] NULL,
	[CID] [bigint] NULL,
	[CName] [varchar](50) NULL,
	[CheckinDate] [date] NULL,
	[CancelationDate] [date] NULL,
	[RoomID] [bigint] NULL,
	[Rent] [nvarchar](50) NULL,
	[NODays] [nvarchar](50) NULL,
	[Total] [nvarchar](50) NULL,
	[Prepaid] [nvarchar](50) NULL,
	[Amount] [nvarchar](50) NULL,
	[Payment] [nvarchar](50) NULL,
	[Paymentmode] [nvarchar](50) NULL,
	[Liability] [nvarchar](50) NULL,
	[ReturnLiability] [nvarchar](50) NULL,
	[Cause] [nvarchar](400) NULL,
 CONSTRAINT [PK_Cancelation] PRIMARY KEY CLUSTERED 
(
	[CancelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CheckIns]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CheckIns](
	[ID] [int] NOT NULL,
	[Checkindate] [date] NULL,
	[Checkoutdate] [date] NULL,
	[NOfDays] [nvarchar](50) NULL,
	[CID] [nvarchar](50) NULL,
	[CName] [nvarchar](50) NULL,
	[RoomID] [nvarchar](50) NULL,
	[RoomType] [nvarchar](50) NULL,
	[Rent] [nvarchar](50) NULL,
	[Total] [float] NULL,
	[Paid] [float] NULL,
	[Balance] [float] NULL,
	[PaymentMode] [varchar](50) NULL,
	[Status] [nvarchar](50) NULL,
 CONSTRAINT [PK_CheckIns] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Checkouts]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Checkouts](
	[ID] [int] NOT NULL,
	[CustomID] [nvarchar](50) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[RoomID] [nvarchar](50) NULL,
	[RoomType] [nvarchar](50) NULL,
	[Rent] [nvarchar](50) NULL,
	[Days] [nvarchar](50) NULL,
	[Total] [nvarchar](50) NULL,
	[Prepaid] [nvarchar](50) NULL,
	[Amount] [nvarchar](50) NULL,
	[Payment] [nvarchar](50) NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[PaymentDate] [date] NULL,
 CONSTRAINT [PK_Checkouts] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomBookings]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomBookings](
	[BookingID] [bigint] NOT NULL,
	[BookedDate] [date] NOT NULL,
	[RoomID] [nvarchar](50) NOT NULL,
	[RoomType] [nvarchar](50) NOT NULL,
	[Charges] [nvarchar](50) NOT NULL,
	[CustomerID] [nvarchar](50) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[InDate] [date] NOT NULL,
	[OutDate] [date] NOT NULL,
	[Staying] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CustomBookings] PRIMARY KEY CLUSTERED 
(
	[BookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerOrder]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerOrder](
	[OrderID] [nvarchar](50) NOT NULL,
	[OrderDate] [date] NOT NULL,
	[CustomerID] [nvarchar](50) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[RoomID] [nvarchar](50) NOT NULL,
	[FoodID] [nvarchar](50) NOT NULL,
	[FoodName] [nvarchar](50) NOT NULL,
	[FoodType] [nvarchar](50) NOT NULL,
	[FQty] [int] NOT NULL,
	[Cost] [money] NOT NULL,
	[TFCost] [bigint] NOT NULL,
	[DrinkID] [nvarchar](50) NOT NULL,
	[DrinkName] [nvarchar](50) NOT NULL,
	[DrinkType] [nvarchar](50) NOT NULL,
	[DQty] [int] NOT NULL,
	[DCost] [money] NOT NULL,
	[TDCost] [bigint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [bigint] NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[City] [nvarchar](50) NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Date] [date] NOT NULL,
	[Photo] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomVocation]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomVocation](
	[BookingID] [nvarchar](50) NOT NULL,
	[CustomerID] [nvarchar](50) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[RoomID] [nvarchar](50) NOT NULL,
	[RoomType] [nvarchar](50) NOT NULL,
	[Charges] [money] NOT NULL,
	[FoodName] [nvarchar](50) NOT NULL,
	[FoodType] [nvarchar](50) NOT NULL,
	[FQty] [int] NOT NULL,
	[FCost] [money] NOT NULL,
	[TFCost] [bigint] NOT NULL,
	[DrinkName] [nvarchar](50) NOT NULL,
	[DrinkType] [nvarchar](50) NOT NULL,
	[DQty] [int] NOT NULL,
	[DCost] [money] NOT NULL,
	[TDCost] [bigint] NOT NULL,
	[TotalAll] [bigint] NOT NULL,
	[Discount] [int] NOT NULL,
	[Paid] [nvarchar](50) NOT NULL,
	[PaidType] [nvarchar](50) NOT NULL,
	[Remain] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Drinks]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drinks](
	[DrinkID] [nvarchar](50) NOT NULL,
	[DrinkType] [nvarchar](50) NOT NULL,
	[DrinkName] [nvarchar](50) NOT NULL,
	[Cost] [money] NOT NULL,
 CONSTRAINT [PK_Drinks] PRIMARY KEY CLUSTERED 
(
	[DrinkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employees]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [nvarchar](50) NOT NULL,
	[EmployeeName] [nvarchar](100) NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](80) NOT NULL,
	[phone] [int] NOT NULL,
	[JobID] [nvarchar](50) NOT NULL,
	[SalaryType] [nvarchar](50) NOT NULL,
	[Salary] [float] NOT NULL,
	[Referencies] [nvarchar](500) NOT NULL,
	[HiredDate] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Foods]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Foods](
	[FoodID] [nvarchar](50) NOT NULL,
	[FoodType] [nvarchar](50) NOT NULL,
	[FoodName] [nvarchar](50) NOT NULL,
	[Cost] [money] NOT NULL,
 CONSTRAINT [PK_Foods] PRIMARY KEY CLUSTERED 
(
	[FoodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GuestBooking]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestBooking](
	[GuestID] [bigint] NOT NULL,
	[GuestName] [nvarchar](50) NOT NULL,
	[Gender] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[City] [nvarchar](50) NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[RegDate] [date] NOT NULL,
	[RoomID] [nvarchar](50) NOT NULL,
	[RoomTye] [nvarchar](50) NOT NULL,
	[Charges] [nvarchar](50) NOT NULL,
	[InDate] [date] NOT NULL,
	[OutDate] [date] NOT NULL,
	[Staying] [nvarchar](50) NOT NULL,
	[TotalCost] [nvarchar](50) NOT NULL,
	[Paid] [nvarchar](50) NOT NULL,
	[Remain] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Photo] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_GuestBooking] PRIMARY KEY CLUSTERED 
(
	[GuestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GuestOrdeer]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GuestOrdeer](
	[OrderID] [nvarchar](50) NOT NULL,
	[OrderDate] [date] NOT NULL,
	[GuestID] [nvarchar](50) NOT NULL,
	[GuestName] [nvarchar](50) NOT NULL,
	[RoomID] [nvarchar](50) NOT NULL,
	[FoodName] [nvarchar](50) NOT NULL,
	[FQty] [int] NOT NULL,
	[FCost] [money] NOT NULL,
	[FTCost] [bigint] NOT NULL,
	[DrinkName] [nvarchar](50) NOT NULL,
	[DQty] [int] NOT NULL,
	[DCost] [money] NOT NULL,
	[TDCost] [bigint] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HotelInfo]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HotelInfo](
	[HotelID] [int] NOT NULL,
	[HotelName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
	[ContactNo] [nvarchar](200) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[Logo] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_HotelInfo] PRIMARY KEY CLUSTERED 
(
	[HotelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Jobs]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
	[JobID] [nvarchar](50) NOT NULL,
	[JobTitle] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Liability]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Liability](
	[LiabilityID] [int] IDENTITY(1,1) NOT NULL,
	[CheckinID] [nvarchar](50) NULL,
	[ReturnedLiability] [nvarchar](50) NULL,
	[DateReturned] [date] NULL,
 CONSTRAINT [PK_Liability] PRIMARY KEY CLUSTERED 
(
	[LiabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Payments]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[CheckinID] [int] NULL,
	[CustomerID] [varchar](50) NULL,
	[CustomerName] [varchar](50) NULL,
	[RoomID] [nvarchar](50) NULL,
	[Total] [float] NULL,
	[Prepaid] [float] NULL,
	[Balance] [float] NULL,
	[Payment] [float] NULL,
	[PaymentMode] [varchar](50) NULL,
	[Date] [date] NULL,
 CONSTRAINT [PK_Payments] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomID] [bigint] NOT NULL,
	[RoomType] [nvarchar](50) NOT NULL,
	[Charges] [nvarchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Rooms] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalaryType]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalaryType](
	[SalaryID] [nvarchar](50) NOT NULL,
	[SalaryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SalaryType] PRIMARY KEY CLUSTERED 
(
	[SalaryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tbl_image]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_image](
	[name] [nvarchar](50) NOT NULL,
	[img_path] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [varchar](50) NOT NULL,
	[UserType] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[EmployeeID] [varchar](50) NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[RegisteredDate] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserStatus]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserStatus](
	[StatusID] [nvarchar](50) NOT NULL,
	[StatusName] [nvarchar](50) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserTypes]    Script Date: 06/13/2020 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserTypes](
	[TypeID] [nvarchar](50) NOT NULL,
	[TypeName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_UserTypes] PRIMARY KEY CLUSTERED 
(
	[TypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Liability] ADD  CONSTRAINT [DF_Liability_DateReturned]  DEFAULT (getdate()) FOR [DateReturned]
GO
ALTER TABLE [dbo].[Payments] ADD  CONSTRAINT [DF_Payments_Date]  DEFAULT (getdate()) FOR [Date]
GO
USE [master]
GO
ALTER DATABASE [HSS] SET  READ_WRITE 
GO
