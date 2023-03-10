
create database QuanLyCuaHangThoiTrang
USE QuanLyCuaHangThoiTrang
GO
/****** Object:  UserDefinedFunction [dbo].[fn_Get_MaDonHang_Next]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_Get_MaDonHang_Next](@MaDH NVARCHAR(50))
RETURNS NVARCHAR(50) 
AS
BEGIN
	SET @MaDH+='%'; 
    DECLARE @MaDH_Next VARCHAR(15)
    SELECT @MaDH_Next = (
        SELECT TOP 1 MaHD
        FROM HoaDon    
        WHERE MaHD like @MaDH
		ORDER BY MaHD DESC
    )    
	DECLARE  @n INT
	SET @n = CONVERT(INT, RIGHT(@MaDH_Next,3)) +1
	SET @MaDH_Next = LEFT(@MaDH,10) + RIGHT('000'+CONVERT(varchar(3),@n),3)
    RETURN @MaDH_Next
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUnsignString]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUnsignString](@strInput NVARCHAR(4000)) 
RETURNS NVARCHAR(4000)
AS
BEGIN     
    IF @strInput IS NULL RETURN @strInput
    IF @strInput = '' RETURN @strInput
    DECLARE @RT NVARCHAR(4000)
    DECLARE @SIGN_CHARS NCHAR(136)
    DECLARE @UNSIGN_CHARS NCHAR (136)

    SET @SIGN_CHARS       = N'ăâđêôơưàảãạáằẳẵặắầẩẫỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ'+NCHAR(272)+ NCHAR(208)
    SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeeeiiiiiooooooooooooooouuuuuuuuuuyyyyyAADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD'

    DECLARE @COUNTER int
    DECLARE @COUNTER1 int
    SET @COUNTER = 1
 
    WHILE (@COUNTER <=LEN(@strInput))
    BEGIN   
      SET @COUNTER1 = 1
      --Tim trong chuoi mau
       WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1)
       BEGIN
     IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) )
     BEGIN           
          IF @COUNTER=1
              SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1)                   
          ELSE
              SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER)    
              BREAK         
               END
             SET @COUNTER1 = @COUNTER1 +1
       END
      --Tim tiep
       SET @COUNTER = @COUNTER +1
    END
    RETURN @strInput
END
GO
/****** Object:  Table [dbo].[ChiTietHD]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHD](
	[MaHD] [nvarchar](50) NOT NULL,
	[MaHang] [nvarchar](50) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [float] NULL,
 CONSTRAINT [PK_ChiTietHD] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC,
	[MaHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietPN]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietPN](
	[MaPN] [nchar](10) NOT NULL,
	[MaHang] [nvarchar](50) NOT NULL,
	[SoLuong] [int] NULL,
	[DonGia] [float] NULL,
 CONSTRAINT [PK_ChiTietPN] PRIMARY KEY CLUSTERED 
(
	[MaPN] ASC,
	[MaHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HangHoa]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HangHoa](
	[MaHang] [nvarchar](50) NOT NULL,
	[TenHang] [nvarchar](50) NULL,
	[DonVi] [nvarchar](20) NULL,
	[GiaBan] [int] NULL,
	[SoLuong] [int] NULL,
 CONSTRAINT [PK_HangHoa] PRIMARY KEY CLUSTERED 
(
	[MaHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHD] [nvarchar](50) NOT NULL,
	[MaKH] [nchar](10) NULL,
	[NgayTao] [date] NOT NULL,
	[TenDangNhap] [varchar](50) NOT NULL,
	[TongTien] [int] NOT NULL,
 CONSTRAINT [PK_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKH] [varchar](20) NOT NULL,
	[TenKH] [nvarchar](50) NOT NULL,
	[GioiTinh] [bit] NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [varchar](10) NOT NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhaCungCap]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhaCungCap](
	[MaNCC] [nchar](10) NOT NULL,
	[TenNCC] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[SDT] [int] NULL,
	[Email] [nvarchar](50) NULL,
 CONSTRAINT [PK_NhaCungCap] PRIMARY KEY CLUSTERED 
(
	[MaNCC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NhanVien]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NhanVien](
	[TenDangNhap] [varchar](50) NOT NULL,
	[MatKhau] [varchar](50) NULL,
	[TenNguoiDung] [nvarchar](50) NULL,
	[Quyen] [nvarchar](20) NULL,
 CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
(
	[TenDangNhap] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PhieuNhap]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhieuNhap](
	[MaPN] [nchar](10) NOT NULL,
	[MaNCC] [nchar](10) NOT NULL,
	[NgayNhap] [date] NOT NULL,
	[TenDangNhap] [varchar](50) NOT NULL,
 CONSTRAINT [PK_PhieuNhap] PRIMARY KEY CLUSTERED 
(
	[MaPN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHD_HangHoa] FOREIGN KEY([MaHang])
REFERENCES [dbo].[HangHoa] ([MaHang])
GO
ALTER TABLE [dbo].[ChiTietHD] CHECK CONSTRAINT [FK_ChiTietHD_HangHoa]
GO
ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHD_HoaDon] FOREIGN KEY([MaHD])
REFERENCES [dbo].[HoaDon] ([MaHD])
GO
ALTER TABLE [dbo].[ChiTietHD] CHECK CONSTRAINT [FK_ChiTietHD_HoaDon]
GO
ALTER TABLE [dbo].[ChiTietPN]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietPN_HangHoa] FOREIGN KEY([MaHang])
REFERENCES [dbo].[HangHoa] ([MaHang])
GO
ALTER TABLE [dbo].[ChiTietPN] CHECK CONSTRAINT [FK_ChiTietPN_HangHoa]
GO
ALTER TABLE [dbo].[ChiTietPN]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietPN_PhieuNhap] FOREIGN KEY([MaPN])
REFERENCES [dbo].[PhieuNhap] ([MaPN])
GO
ALTER TABLE [dbo].[ChiTietPN] CHECK CONSTRAINT [FK_ChiTietPN_PhieuNhap]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_NhanVien] FOREIGN KEY([TenDangNhap])
REFERENCES [dbo].[NhanVien] ([TenDangNhap])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_NhanVien]
GO
ALTER TABLE [dbo].[PhieuNhap]  WITH CHECK ADD  CONSTRAINT [FK_PhieuNhap_NhaCungCap] FOREIGN KEY([MaNCC])
REFERENCES [dbo].[NhaCungCap] ([MaNCC])
GO
ALTER TABLE [dbo].[PhieuNhap] CHECK CONSTRAINT [FK_PhieuNhap_NhaCungCap]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetHoaDon]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetHoaDon]
@MaHD nvarchar(50)
AS
BEGIN
	select *
from HangHoa, ChiTietHD, HoaDon
where HangHoa.MaHang = ChiTietHD.MaHang and ChiTietHD.MaHD = HoaDon.MaHD and HoaDon.MaHD = @MaHD
END
GO

/****** Object:  StoredProcedure [dbo].[USP_GetSLTon]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSLTon]
AS
BEGIN
select ChiTietHD.MaHang AS [Mã Hàng],HangHoa.TenHang AS [Tên Hàng],HangHoa.GiaBan AS [Giá],SUM(ChiTietHD.SoLuong) AS [Số Lượng Đã Bán], HangHoa.SoLuong AS 'Số Lượng Tồn' 
from ChiTietHD, HangHoa where ChiTietHD.MaHang = HangHoa.MaHang 
group by ChiTietHD.MaHang, HangHoa.TenHang, HangHoa.SoLuong, HangHoa.GiaBan
order by [Số Lượng Đã Bán] desc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SelectMaDH]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[USP_SelectMaDH]
@MaDH nvarchar(20)
as
begin
	select * from HoaDon where HoaDon.MaHD = MaHD;
end
GO
/****** Object:  StoredProcedure [dbo].[USP_ThongKe7Ngay]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_ThongKe7Ngay]
@ngaybd date, @ngaykt date
AS
BEGIN
	select DAY(NgayTao) AS 'Ngay', sum(HoaDon.TongTien) AS 'TongTien'
	from HoaDon
	where @ngaybd <= HoaDon.NgayTao and @ngaykt >= HoaDon.NgayTao
	group by NgayTao 
END
GO

exec USP_ThongKe7Ngay @ngaybd ='2021-12-23', @ngaykt ='2021-12-25'
--
select *from HoaDon
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD1',N'KH1', '2021-12-25' , N'admin', 1000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD2',N'KH2', '2021-12-24' , N'admin', 100000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD3',N'KH3', '2021-12-23' , N'admin', 2000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD4',N'KH1', '2021-12-24' , N'admin', 500000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD5',N'KH1', '2021-12-25' , N'admin', 1000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD6',N'KH2', '2021-12-24' , N'admin', 100000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD7',N'KH3', '2021-12-23' , N'admin', 2000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD8',N'KH1', '2021-12-22' , N'admin', 700000)



/****** Object:  StoredProcedure [dbo].[USP_TKHD]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_TKHD]
@ngaybd date, @ngaykt date
AS
BEGIN
	select HoaDon.MaHD AS 'Mã HĐ', HoaDon.NgayTao AS 'Ngày Tạo', KhachHang.TenKH AS 'Tên Khách Hàng', HoaDon.TongTien AS 'Tổng Tiền', HoaDon.TenDangNhap AS 'Người Tạo'
from HoaDon, KhachHang
where @ngaybd <= HoaDon.NgayTao and @ngaykt >= HoaDon.NgayTao and KhachHang.MaKH = HoaDon.MaKH
order by HoaDon.TongTien desc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKKH]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_TKKH]
AS
BEGIN
select KhachHang.MaKH, KhachHang.TenKH, KhachHang.SDT, KhachHang.DiaChi,KhachHang.Email,SUM(HoaDon.TongTien) AS 'Tổng Tiền', COUNT(HoaDon.MaHD) AS 'Số Lần Mua'
from HoaDon, KhachHang
where KhachHang.MaKH = HoaDon.MaKH
group by KhachHang.TenKH, KhachHang.MaKH, KhachHang.SDT, KhachHang.DiaChi, KhachHang.Email
order by SUM(HoaDon.TongTien) desc
END
GO
/****** Object:  StoredProcedure [dbo].[USP_TKPN]    Script Date: 12/24/2020 11:39:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_TKPN]
@ngaybd date, @ngaykt date
AS
BEGIN
	select PhieuNhap.MaPN, PhieuNhap.NgayNhap,NhaCungCap.TenNCC, ChiTietPN.MaHang, ChiTietPN.SoLuong, 
ChiTietPN.DonGia,ChiTietPN.SoLuong * ChiTietPN.DonGia AS 'Tổng Tiền', PhieuNhap.TenDangNhap
from PhieuNhap, ChiTietPN, NhaCungCap
where PhieuNhap.MaPN = ChiTietPN.MaPN and PhieuNhap.MaNCC = NhaCungCap.MaNCC
and @ngaybd <= PhieuNhap.NgayNhap and @ngaykt >= PhieuNhap.NgayNhap
END
GO

select *from HoaDon

INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD10',N'KH1', '2021-12-12' , N'admin', 1000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD11',N'KH2', '2021-12-13' , N'admin', 100000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD12',N'KH3', '2021-12-14' , N'admin', 2000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD13',N'KH1', '2021-12-15' , N'admin', 500000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD14',N'KH1', '2021-12-16' , N'admin', 1000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD15',N'KH2', '2021-12-17' , N'admin', 100000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD16',N'KH3', '2021-12-18' , N'admin', 2000000)
INSERT INTO HoaDon(MaHD, MaKH, NgayTao, TenDangNhap, TongTien)
VALUES('HD17',N'KH1', '2021-12-19' , N'admin', 700000)