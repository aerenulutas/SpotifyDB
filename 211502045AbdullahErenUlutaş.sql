USE [Spotify]
GO
/****** Object:  UserDefinedFunction [dbo].[DinlenmeSayisiHesaplama]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DinlenmeSayisiHesaplama]
(@AlbumSarkiID int,@DinlenmeSayisi nvarchar(50))
RETURNS nvarchar(50)
AS
BEGIN
	
	DECLARE @Güncel nvarchar(50)
    DECLARE @AlbumYili int
	set @AlbumYili=(Select COUNT(*) from Albumler where AlbumSarkiID=@AlbumSarkiID)
	if @AlbumYili<2000

	begin
	   set @Güncel=@DinlenmeSayisi + 1000000
	end

	else 
	begin
	   set @Güncel=@DinlenmeSayisi
    end
	RETURN @Güncel


END
GO
/****** Object:  Table [dbo].[Sanatcilar]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sanatcilar](
	[KullaniciID] [int] NOT NULL,
	[SanatciID] [int] IDENTITY(1,1) NOT NULL,
	[SanatciAdi] [nvarchar](50) NULL,
	[SanatciSoyadi] [nvarchar](50) NULL,
 CONSTRAINT [PK_KitaplikSanatcilar] PRIMARY KEY CLUSTERED 
(
	[SanatciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Kullanici]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanici](
	[KullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciAdi] [nvarchar](50) NULL,
	[Sifre] [nvarchar](50) NULL,
 CONSTRAINT [PK_Kullanici] PRIMARY KEY CLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewKullaniciBilgisi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewKullaniciBilgisi]
AS
SELECT
k.KullaniciID, k.KullaniciAdi, s.SanatciID, s.SanatciAdi, s.SanatciSoyadi
FROM Kullanici k
inner join Sanatcilar s ON k.KullaniciID = s.KullaniciID
GO
/****** Object:  Table [dbo].[CalmaListesi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CalmaListesi](
	[CalmaListesiID] [int] NOT NULL,
	[CalmaListesiAdi] [nvarchar](50) NULL,
	[SarkiAdi] [nvarchar](50) NULL,
	[SanatciAdi] [nvarchar](50) NULL,
	[SanatciSoyadi] [nvarchar](50) NULL,
	[Album] [nvarchar](50) NULL,
	[EklenmeTarihi] [nvarchar](20) NULL,
	[Sure] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CalmaListeleri]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CalmaListeleri](
	[KullaniciID] [int] NOT NULL,
	[CalmaListesiID] [int] NOT NULL,
	[CalmaListesiAdi] [nvarchar](50) NULL,
 CONSTRAINT [PK_KitaplikCalmaListesi] PRIMARY KEY CLUSTERED 
(
	[CalmaListesiID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewCalmaListesiBilgisi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewCalmaListesiBilgisi]
AS
SELECT
k.KullaniciID, k.KullaniciAdi, cr.CalmaListesiID,cr.CalmaListesiAdi,c.SarkiAdi,c.SanatciAdi, c.SanatciSoyadi,c.EklenmeTarihi
FROM Kullanici k
inner join CalmaListeleri cr ON k.KullaniciID = cr.KullaniciID
inner join CalmaListesi c ON cr.CalmaListesiID = c.CalmaListesiID
GO
/****** Object:  View [dbo].[viewSure]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewSure]
AS
SELECT
c.CalmaListesiID,c.CalmaListesiAdi,c.SanatciAdi, c.SanatciSoyadi,c.SarkiAdi,c.Sure
FROM CalmaListesi c
where c.Sure>'5,00'
GO
/****** Object:  View [dbo].[viewSanatciAdNull]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Sanatcilar tablosunda tek isim olan sanatciların SanatciID, SanatciAdi,SanatciSoyadi bilgilerini veren viewSanatciAdNull adlı View yazınız
CREATE VIEW [dbo].[viewSanatciAdNull]
AS    
SELECT
SanatciID, SanatciAdi,SanatciSoyadi
FROM Sanatcilar   
WHERE SanatciSoyadi is null 


GO
/****** Object:  View [dbo].[viewKlasikleriKelimesi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewKlasikleriKelimesi]
AS
SELECT
CalmaListesiID, SarkiAdi, SanatciAdi, SanatciSoyadi,Album
FROM
CalmaListesi where Album like '%Klasikleri%'
GO
/****** Object:  Table [dbo].[Albumler]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Albumler](
	[SanatciID] [int] NOT NULL,
	[AlbumSarkiID] [int] NULL,
	[AlbumAdi] [nvarchar](50) NULL,
	[AlbumYili] [int] NULL,
	[SarkiAdi] [nvarchar](50) NULL,
	[DinlenmeSayisi] [nvarchar](50) NULL,
	[Sure] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewSanatciAlbumBilgisi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewSanatciAlbumBilgisi]
AS
SELECT 
s.SanatciID, s.SanatciAdi, s.SanatciSoyadi, a.AlbumSarkiID, a.SarkiAdi, a.AlbumAdi
FROM 
Sanatcilar s INNER JOIN Albumler a ON s.SanatciID = a.SanatciID
GO
/****** Object:  View [dbo].[viewAlbumYiliAsc]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAlbumYiliAsc]
AS
SELECT top 1 
SanatciID,AlbumSarkiID,AlbumAdi,AlbumYili
FROM 
Albumler  order by AlbumYili asc
GO
/****** Object:  View [dbo].[viewAlbumYilidesc]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewAlbumYilidesc]
AS
SELECT top 1 
SanatciID,AlbumSarkiID,AlbumAdi,AlbumYili
FROM 
Albumler  order by AlbumYili desc
GO
/****** Object:  View [dbo].[viewAlbumYiliAralik]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAlbumYiliAralik]
AS
SELECT 
SanatciID,AlbumSarkiID,AlbumAdi,AlbumYili
FROM 
Albumler where AlbumYili between 1997 and 2009
GO
/****** Object:  Table [dbo].[Sarkilar]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sarkilar](
	[SanatciID] [int] NOT NULL,
	[SarkiID] [int] NULL,
	[SarkiAdi] [nvarchar](50) NULL,
	[DinlenmeSayisi] [nvarchar](50) NULL,
	[Sure] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[viewAskKelimesi]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAskKelimesi]
AS
SELECT
SarkiID, SarkiAdi,SanatciID
FROM
Sarkilar where SarkiAdi like '%Aşk%'
GO
/****** Object:  Table [dbo].[SanatciYedek]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SanatciYedek](
	[KullaniciID] [int] NULL,
	[SanatciID] [int] NULL,
	[SanatciAdi] [nvarchar](50) NULL,
	[SanatciSoyadi] [nvarchar](50) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 1, N'Dokunmayın Çok Fenayım', 1995, N'Dem Vuralım', N'287,248', N'3:31')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 2, N'Dokunmayın Çok Fenayım', 1995, N'Ben Babayım', N'465,267', N'4:27')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 3, N'Dokunmayın Çok Fenayım', 1995, N'Yaralandın mı Can', N'6,358,336', N'4:51')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 4, N'Dokunmayın Çok Fenayım', 1995, N'Her An Her Şey Olabilir', N'1,267,850', N'4:49')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 5, N'Dokunmayın Çok Fenayım', 1995, N'Alıram Yar Alıram', N'304,500', N'2:47')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 6, N'Dokunmayın Çok Fenayım', 1995, N'Ben Seninle Mutluyum', N'2,034,902', N'3:32')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 7, N'Dokunmayın Çok Fenayım', 1995, N'Nereye Gidiyorsun', N'714,360', N'2:30')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 8, N'Dokunmayın Çok Fenayım', 1995, N'Şevko', N'280,654', N'4:12')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 9, N'Dokunmayın Çok Fenayım', 1995, N'Çoğu Gitti Azı Kaldı', N'2,1104,865', N'3:44')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 10, N'Güz Gülleri', 2000, N'Sen Uyurken Gideceğim', N'2,776,899', N'5:23')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 11, N'Güz Gülleri', 2000, N'Geleceği Yok Onun', N'222,104', N'5:00')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 12, N'Güz Gülleri', 2000, N'Ben Unutamam', N'95,513', N'4:28')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 13, N'Güz Gülleri', 2000, N'Cezam Bitmiyor', N'69,735', N'3:34')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 14, N'Güz Gülleri', 2000, N'Gerçek Aşkın Yeri Yok', N'20,318', N'4:50')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 15, N'Güz Gülleri', 2000, N'Gelde Bana Sor', N'23,022', N'4:29')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 16, N'Güz Gülleri', 2000, N'Utan', N'33,819', N'4:44')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 17, N'Güz Gülleri', 2000, N'Sen Delimisin', N'25,515', N'3:35')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 18, N'Güz Gülleri', 2000, N'Layık Değilim', N'32,077', N'4:13')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 19, N'Bombabomba.com', 2006, N'Allah Belanı Versin', N'2,622,109', N'4:51')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 20, N'Bombabomba.com', 2006, N'Şekerim', N'10,539,365', N'3:57')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 21, N'Bombabomba.com', 2006, N'Git Hadi Git', N'1,312,596', N'5:26')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 22, N'Bombabomba.com', 2006, N'Eskisi Gibi', N'244,698', N'3:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 23, N'Bombabomba.com', 2006, N'İstemiyorum Seni', N'160,969', N'3:57')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 24, N'Bombabomba.com', 2006, N'Gıcık Şey-Amman', N'280,854', N'3:45')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 25, N'Bombabomba.com', 2006, N'Bu Şarkının Sözleri Yok', N'659,592', N'3:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 26, N'Bombabomba.com', 2006, N'Of Ne Parça Bu', N'102,171', N'3:58')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 27, N'Bombabomba.com', 2006, N'Seviyorum', N'652,821', N'5:49')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 28, N'Unutulan', 2002, N'Gelin', N'2,638,162', N'5:19')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 29, N'Unutulan', 2002, N'Küllenen Aşk', N'36,320,853', N'5:06')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 30, N'Unutulan', 2002, N'Yalan Gözler', N'652,329', N'3:49')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 31, N'Unutulan', 2002, N'Yine Mi Sen', N'1,057,642', N'3:58')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 32, N'Unutulan', 2002, N'Liselim', N'4,876,629', N'4:22')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 33, N'Unutulan', 2002, N'Küstüm Sevgilim Senle', N'217,172', N'4:13')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 34, N'Unutulan', 2002, N'Duvardaki', N'5,837,568', N'4:33')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 35, N'Unutulan', 2002, N'Unutulan', N'7,277,218', N'4:44')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 36, N'Neden', 2008, N'Kop Gel Günahlarından', N'13,048,135', N'3:16')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 37, N'Neden', 2008, N'Sözüm Yok Artık', N'4,749,407', N'4:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 38, N'Neden', 2008, N'Bir Yıldız Kaydı', N'1,175,655', N'3:27')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 39, N'Neden', 2008, N'Gelmezsen Gelme', N'6,287,153', N'3:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 40, N'Neden', 2008, N'Hadi Hadi', N'730,719', N'3:55')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 41, N'Neden', 2008, N'Eşik Taşı', N'686,466', N'4:16')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 42, N'Neden', 2008, N'Pusat', N'453,442', N'3:10')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 43, N'Batsın Bu Dünya', 1975, N'Hayat Kavgası', N'1,734,313', N'5:36')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 44, N'Batsın Bu Dünya', 1975, N'Benim Dünyam', N'103,991', N'5:08')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 45, N'Batsın Bu Dünya', 1975, N'Ben Doğarken Ölmüşüm', N'66,695', N'4:17')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 46, N'Batsın Bu Dünya', 1975, N'Seviyorum Deme', N'35,331', N'4:44')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 47, N'Batsın Bu Dünya', 1975, N'Duyun Beni', N'41,507', N'5:09')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 48, N'Batsın Bu Dünya', 1975, N'Bir Araya Gelemeyiz', N'80,902', N'4:44')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 49, N'Batsın Bu Dünya', 1975, N'Dertler Benim Olsun', N'139,757', N'5:26')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 50, N'Küskünüm', 1986, N'Seni Yazdım', N'47,236,429', N'4:36')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 51, N'Küskünüm', 1986, N'Bir Anda', N'3,191,253', N'5:28')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 52, N'Küskünüm', 1986, N'Topraklara Gömeceğim', N'1,753,883', N'3:57')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 53, N'Küskünüm', 1986, N'Kolay', N'613,860', N'3:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 54, N'Küskünüm', 1986, N'Hasret Rüzgarları', N'8,348,814', N'4:59')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 55, N'Küskünüm', 1986, N'Seni Kalbime Gömdüm', N'3,933,696', N'4:27')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 56, N'Küskünüm', 1986, N'Ne Yapsın', N'1,173,261', N'4:17')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 57, N'Hoşçakal', 1990, N'Hoşça Kal Leyla', N'183,387', N'3:30')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 58, N'Hoşçakal', 1990, N'Bir Mucize Yarat', N'128,910', N'3:57')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 59, N'Hoşçakal', 1990, N'Döndüm Durdum', N'107,187', N'3:12')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 60, N'Hoşçakal', 1990, N'Başlamak Niye', N'84,570', N'2:59')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 61, N'Hoşçakal', 1990, N'Bana Sor', N'11,143,643', N'6:01')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 62, N'Hoşçakal', 1990, N'Hatıran Yeter', N'11,350,711', N'4:47')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 63, N'Hoşçakal', 1990, N'Yanmışım', N'138,169', N'3:36')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 64, N'Flashback', 2018, N'Karanlık', N'910,286', N'2:42')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 65, N'Flashback', 2018, N'Strassen', N'476,862', N'2:54')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 66, N'Flashback', 2018, N'İblis', N'3,157,687', N'3:35')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 67, N'Flashback', 2018, N'Güneş Battı', N'257,514', N'2:34')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 68, N'Flashback', 2018, N'Hodri Meydan', N'778,055', N'3:01')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 69, N'Flashback', 2018, N'Eşkiya', N'1,378,133', N'3:08')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 70, N'Fight Kulüp', 2019, N'Geçti Zaman', N'1,577,688', N'5:03')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 71, N'Fight Kulüp', 2019, N'Şans Dilemez', N'311,316', N'4:01')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 72, N'Fight Kulüp', 2019, N'Sen Bir Köle', N'135,634', N'3:36')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 73, N'Fight Kulüp', 2019, N'10 Köyden Kovuldum', N'1,364,981', N'4:15')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 74, N'Fight Kulüp', 2019, N'İlk Kural Saygı', N'9,519,260', N'4:41')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 75, N'Fight Kulüp', 2019, N'Ece Ve Gece', N'106,471', N'4:24')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 76, N'Sen Kötü Bir Rüyasın', 2016, N'Can Sıkıntısı', N'607,389', N'2:16')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 77, N'Sen Kötü Bir Rüyasın', 2016, N'Elektrik', N'468,162', N'2:39')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 78, N'Sen Kötü Bir Rüyasın', 2016, N'Ateş Ve Barut', N'6,845,948', N'3:22')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 79, N'Sen Kötü Bir Rüyasın', 2016, N'Harikalar Diyarında', N'2,287,993', N'4:27')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 80, N'Sen Kötü Bir Rüyasın', 2016, N'Böyle İyi', N'43,177,856', N'4:32')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 81, N'Evet', 2008, N'Harika', N'13,151,273', N'3:18')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 82, N'Evet', 2008, N'Ölümsüz Aşklar', N'21,152,702', N'4:50')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 83, N'Evet', 2008, N'Evcilik Oynayamam', N'293,075', N'3:59')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 84, N'Evet', 2008, N'Sadece Sevdim', N'1,057,504', N'4:14')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 85, N'Evet', 2008, N'Tükeneceğiz', N'2,218,551', N'5:18')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 86, N'Evet', 2008, N'Kızıl,Mavi', N'8,918,449', N'3:06')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 87, N'Bu Devirde', 1997, N'Razıyım', N'26,619,566', N'3:52')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 88, N'Bu Devirde', 1997, N'Havar', N'129,865', N'4:15')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 89, N'Bu Devirde', 1997, N'Geçmiş Olsun', N'118,978', N'3:55')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 90, N'Bu Devirde', 1997, N'Gülüm', N'212,613', N'5:17')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 91, N'Bu Devirde', 1997, N'Aman', N'351,330', N'3:50')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 92, N'Bu Devirde', 1997, N'Kansın', N'2,156,606', N'4:59')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 93, N'Dillere Destan', 1995, N'Vazgeçtim', N'24,595,829', N'4:42')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 94, N'Dillere Destan', 1995, N'Vuracak', N'756,202', N'3:39')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 95, N'Dillere Destan', 1995, N'Havalım', N'718,939', N'4:55')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 96, N'Dillere Destan', 1995, N'Arzular Arsız', N'2,456,514', N'4:49')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 97, N'Dillere Destan', 1995, N'Anlamak İçin', N'639,509', N'4:24')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 98, N'Dillere Destan', 1995, N'Mühür Gözlüm', N'339,517', N'3:46')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 99, N'Nostalji', 1998, N'Nikah Masası', N'14,339,362', N'4:49')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 100, N'Nostalji', 1998, N'Okul Yolunda', N'2,108,502', N'4:03')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 101, N'Nostalji', 1998, N'Bayramın Olsun', N'213,433', N'4:37')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 102, N'Nostalji', 1998, N'Çakıl Taşları', N'95,012', N'3:01')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 103, N'Nostalji', 1998, N'Diyemedim', N'174,171', N'3:16')
GO
INSERT [dbo].[Albumler] ([SanatciID], [AlbumSarkiID], [AlbumAdi], [AlbumYili], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 104, N'Nostalji', 1998, N'Islak Mendil', N'796,189', N'4:14')
GO
INSERT [dbo].[CalmaListeleri] ([KullaniciID], [CalmaListesiID], [CalmaListesiAdi]) VALUES (7, 1, N'Arabesk')
GO
INSERT [dbo].[CalmaListeleri] ([KullaniciID], [CalmaListesiID], [CalmaListesiAdi]) VALUES (8, 2, N'Fantezi')
GO
INSERT [dbo].[CalmaListeleri] ([KullaniciID], [CalmaListesiID], [CalmaListesiAdi]) VALUES (11, 3, N'Babalar')
GO
INSERT [dbo].[CalmaListeleri] ([KullaniciID], [CalmaListesiID], [CalmaListesiAdi]) VALUES (12, 4, N'Rap')
GO
INSERT [dbo].[CalmaListeleri] ([KullaniciID], [CalmaListesiID], [CalmaListesiAdi]) VALUES (13, 5, N'Kraliçeler')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (1, N'Arabesk', N'Affet', N'Müslüm', N'Gürses', N'Aşk Tesadüfleri Sever', N'12.04.2023', N'4:39')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (1, N'Arabesk', N'Yanımda Sen Olmayınca', N'Kıvırcık Ali', NULL, N'Hepimize Yeter Dünya', N'12.04.2023', N'4:22')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (1, N'Arabesk', N'Doldur Meyhaneci', N'Adnan', N'Şenses', N'Adnan Şenses Klasikleri', N'12.04.2023', N'6:18')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (1, N'Arabesk', N'Sen Affetsen', N'Bergen', NULL, N'Acıların Kadını', N'12.04.2023', N'4:25')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (1, N'Arabesk', N'Mest Oldum', N'Müslüm', N'Gürses', N'Yüreğimden Vurdun Beni', N'12.04.2023', N'2:25')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (2, N'Fantezi', N'Nikah Masası', N'Ümit', N'Besen', N'Nostalji', N'14.04.2023', N'4:50')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (2, N'Fantezi', N'Ağlamak Yok Yüreğim', N'Hakan', N'Altun', N'Ağlamak Yok Yüreğim', N'14.04.2023', N'5:21')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (2, N'Fantezi', N'Okul Yolunda', N'Ümit', N'Besen', N'Nostolji', N'14.04.2023', N'4:03')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (2, N'Fantezi', N'Ümit Yere Batsın', N'Cengiz', N'Kurtoğlu', N'Yıllarım', N'14.04.2023', N'5:17')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (2, N'Fantezi', N'Gönül Yarası', N'Hakan', N'Altun', N'Ağlamak Yok Yüreğim', N'14.04.2023', N'4:39')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (3, N'Babalar', N'Kaderimin Oyunu', N'Orhan', N'Gencebay', N'Orhan Gencebay Klasikleri', N'20.04.2023', N'4:06')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (3, N'Babalar', N'Bana Sor', N'Ferdi', N'Tayfur', N'Bana Sor', N'20.04.2023', N'6:02')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (3, N'Babalar', N'Hatasız Kul Olmaz', N'Orhan', N'Gencebay', N'Orhan Gencebay Klasikleri', N'20.04.2023', N'5:17')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (3, N'Babalar', N'Yıllar Utansın', N'Müslüm', N'Gürses', N'Mahsun Kul', N'20.04.2023', N'6:47')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (3, N'Babalar', N'Batsın Bu Dünya', N'Orhan', N'Gencebay', N'Batsın Bu Dünya', N'20.04.2023', N'5:37')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (4, N'Rap', N'Yerli Plaka', N'Ceza', NULL, N'Yerli Plaka', N'28.04.2023', N'4:35')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (4, N'Rap', N'Dünya Gül Bana', N'No.1', NULL, N'Siyah Bayrak', N'28.04.2023', N'4:43')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (4, N'Rap', N'Fark Var', N'Ceza', NULL, N'Yerli Plaka', N'28.04.2023', N'4:16')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (4, N'Rap', N'Yıkıla Yıkıla', N'Yener', N'Çevik', N'Yıkıla Yıkıla', N'28.04.2023', N'3:24')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (4, N'Rap', N'Neyim Var Kİ', N'Ceza', NULL, N'Rapstar', N'28.04.2023', N'3:27')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (5, N'Kraliçeler', N'Çabuk Olalım Aşkım', N'Yıldız', N'Tilbe', N'Yürü Anca Gidersin', N'03.05.2023', N'4:13')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (5, N'Kraliçeler', N'Çingenem', N'Ebru', N'Gündeş', N'Dön Ne Olur', N'03.05.2023', N'3:11')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (5, N'Kraliçeler', N'Kış Masalı', N'Sibel', N'Can', N'Galata', N'03.05.2023', N'4:16')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (5, N'Kraliçeler', N'Vazgeçtim', N'Yıldız', N'Tilbe', N'Dillere Destan', N'03.05.2023', N'4:42')
GO
INSERT [dbo].[CalmaListesi] ([CalmaListesiID], [CalmaListesiAdi], [SarkiAdi], [SanatciAdi], [SanatciSoyadi], [Album], [EklenmeTarihi], [Sure]) VALUES (5, N'Kraliçeler', N'Ölümsüz Aşklar', N'Ebru', N'Gündeş', N'Evet', N'03.05.2023', N'4:50')
GO
SET IDENTITY_INSERT [dbo].[Kullanici] ON 
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Sifre]) VALUES (7, N'erenulutas1453', N'ulutas75')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Sifre]) VALUES (8, N'ayberkyıldırım32', N'erzurum36')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Sifre]) VALUES (11, N'barbaroskınalı44', N'geliboluwww')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Sifre]) VALUES (12, N'gamzekirazözcan', N'kirazbülbül88')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Sifre]) VALUES (13, N'cahitbekir12', N'kayseri123')
GO
SET IDENTITY_INSERT [dbo].[Kullanici] OFF
GO
SET IDENTITY_INSERT [dbo].[Sanatcilar] ON 
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (7, 1, N'Azer', N'Bülbül')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (7, 2, N'Hakan', N'Taşıyan')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (7, 3, N'İsmail', N'YK')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (8, 4, N'Ümit', N'Besen')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (8, 5, N'Cengiz', N'Kurtoğlu')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (8, 6, N'İbrahim', N'Tatlıses')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (11, 7, N'Orhan', N'Gencebay')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (11, 8, N'Müslüm', N'Gürses')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (11, 9, N'Ferdi', N'Tayfur')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (12, 10, N'Massaka', NULL)
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (12, 11, N'KillaHakan', NULL)
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (12, 12, N'No.1', NULL)
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (13, 13, N'Ebru', N'Gündeş')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (13, 14, N'Sibel', N'Can')
GO
INSERT [dbo].[Sanatcilar] ([KullaniciID], [SanatciID], [SanatciAdi], [SanatciSoyadi]) VALUES (13, 15, N'Yıldız', N'Tilbe')
GO
SET IDENTITY_INSERT [dbo].[Sanatcilar] OFF
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 1, N'Çoğu Gitti Azı Kaldı', N'21,072,280', N'3:44')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 2, N'Duygularım', N'18,395,448', N'4:56')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 3, N'Caney', N'9,505,643', N'4:39')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 4, N'Aman Güzel Yavaş Yürü', N'5,387,565', N'2:37')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 11, N'Bombabomba.com', N'20,705,456', N'4:32')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 12, N'Bas Gaza', N'13,411,696', N'4:09')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 13, N'Şekerim', N'10,523,533', N'3:57')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 14, N'Kudur Baby', N'8,244,294', N'4:18')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (3, 15, N'Tıkla', N'4,252,622', N'4:44')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 16, N'Nikah Masası', N'14,324,505', N'4:49')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 17, N'Okul Yolunda', N'2,105,869', N'4:03')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 18, N'Seni Unutmaya Ömür Yetermi', N'27,135,628', N'3:44')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 19, N'Alışmak Sevmekten Daha Zor Geliyor', N'3,021,150', N'4:51')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (4, 20, N'Unutmaya Ömrüm Yeter Mi', N'3,341,014', N'5:22')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 21, N'Küllenen Aşk', N'36,271,544', N'5:06')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 22, N'Yorgun Yıllarım', N'23,077,884', N'4:39')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 23, N'Unutulan', N'7,265,379', N'4:44')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 24, N'Resmini Öptümde Yattım', N'7,320,641', N'5:29')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (5, 25, N'Saklı Düşler', N'10,233,107', N'4:23')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 26, N'Eyvah Neye Yarar', N'4,877,358', N'4:22')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 27, N'Mutlu Ol Yeter', N'21,820,852', N'4:23')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 28, N'Tamam Aşkım', N'17,395,056', N'3:38')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 29, N'Mavişim', N'20,949,256', N'3:12')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (6, 30, N'Senden İnsaf Diler Yarın', N'9,165,179', N'4:11')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 31, N'Kaderimin Oyunu', N'13,777,683', N'4:06')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 32, N'Dokunma', N'9,356,304', N'5:11')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 33, N'Hatasız Kul Olmaz', N'7,837,627', N'5:17')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 34, N'Milletin Duası', N'5,172,666', N'4:19')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (7, 35, N'Akşam Güneşi', N'4,569,411', N'4:34')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 36, N'Seni Yazdım', N'47,154,476', N'4:36')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 37, N'Nilüfer', N'72,784,104', N'4:18')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 38, N'Bir Ömür Yetmez', N'19,539,212', N'4:02')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 39, N'Affet', N'64,362,652', N'4:39')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (8, 40, N'Unutamadım-Kaç Kadeh Kırıldı', N'47,083,360', N'4:29')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 41, N'Bana Sor', N'11,116,617', N'6:01')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 42, N'Hatıran Yeter', N'11,331,026', N'4:47')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 43, N'Sabahçı Kahvesi', N'9,302,829', N'4:40')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 44, N'Sigarayı Bıraktım', N'9,284,486', N'3:33')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (9, 45, N'Huzurum Kalmadı', N'12,723,546', N'3:56')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 46, N'Katliam 3', N'27,660,686', N'6:51')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 47, N'Cehennemin Dibi', N'7,640,033', N'2:38')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 48, N'Katliam 2', N'24,264,716', N'5:06')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 49, N'Soğuk Mevsim', N'12,239,032', N'3:51')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (10, 50, N'Dolunay', N'8,345,762', N'2:58')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 51, N'Fight Kulup', N'33,311,990', N'6:18')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 52, N'Her Şey Yolundadır', N'4,781,307', N'3:50')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 53, N'Fight Kulüp 2', N'16,934,840', N'7:17')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 54, N'İlk Kural Saygı', N'9,517,047', N'4:41')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (11, 55, N'Tek Şans', N'1,903,703', N'4:10')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 56, N'Yarım Kalan Sigara', N'78,411,399', N'3:03')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 57, N'Böyle İyi', N'43,125,144', N'4:32')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 58, N'Dünya Gül Bana', N'39,959,344', N'4:42')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 59, N'Hiç Işık Yok', N'52,113,616', N'7:07')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (12, 60, N'Bu Benim Hayatım', N'11,930,406', N'2:19')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 61, N'Çingenem', N'38,416,096', N'3:10')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 62, N'Cennet', N'44.095.504', N'3:33')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 63, N'Ölümsüz Aşklar', N'23,098,008', N'4:50')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 64, N'Demir Attım', N'28,346,982', N'5:00')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (13, 65, N'Yaparım Bilirsin', N'14,958,717', N'3:09')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 66, N'Diken Mİ Gül Mü?', N'27,945,690', N'3:28')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 67, N'Padişah', N'26,476,856.', N'3:52')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 68, N'Çakmak Çakmak', N'15,394,220', N'4:12')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 69, N'Karakol', N'731,101', N'4:18')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (14, 70, N'Bil Diye Söylüyorum', N'22,671,612', N'4:10')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 71, N'Hastayım Sana', N'14,556,737', N'3:45')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 72, N'Vazgeçtim', N'24,567,280', N'4:42')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 73, N'Sana Değer', N'17,174,960', N'4:38')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 74, N'Delikanlım', N'23,833,580', N'5:14')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (15, 75, N'Çabuk Olalım Aşkım', N'10,582,400', N'4:13')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (1, 5, N'Başaramadım', N'8,810,243', N'3:44')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 6, N'Doktor', N'3,264,953', N'5:41')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 7, N'Güz Gülleri', N'2,773,796', N'5:23')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 8, N'Sensiz İki Gün', N'2,751,820', N'5:17')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 9, N'Hazin Geliyor', N'2,958,261', N'5:12')
GO
INSERT [dbo].[Sarkilar] ([SanatciID], [SarkiID], [SarkiAdi], [DinlenmeSayisi], [Sure]) VALUES (2, 10, N'Gelin Olduğun Gece', N'998,534', N'4:10')
GO
ALTER TABLE [dbo].[Albumler]  WITH CHECK ADD  CONSTRAINT [FK_Albumler_KitaplikSanatcilar] FOREIGN KEY([SanatciID])
REFERENCES [dbo].[Sanatcilar] ([SanatciID])
GO
ALTER TABLE [dbo].[Albumler] CHECK CONSTRAINT [FK_Albumler_KitaplikSanatcilar]
GO
ALTER TABLE [dbo].[CalmaListeleri]  WITH CHECK ADD  CONSTRAINT [FK_KitaplikCalmaListesi_Kullanici] FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanici] ([KullaniciID])
GO
ALTER TABLE [dbo].[CalmaListeleri] CHECK CONSTRAINT [FK_KitaplikCalmaListesi_Kullanici]
GO
ALTER TABLE [dbo].[CalmaListesi]  WITH CHECK ADD  CONSTRAINT [FK_CalmaListesi_CalmaListeleri] FOREIGN KEY([CalmaListesiID])
REFERENCES [dbo].[CalmaListeleri] ([CalmaListesiID])
GO
ALTER TABLE [dbo].[CalmaListesi] CHECK CONSTRAINT [FK_CalmaListesi_CalmaListeleri]
GO
ALTER TABLE [dbo].[Sanatcilar]  WITH CHECK ADD  CONSTRAINT [FK_KitaplikSanatcilar_Kullanici] FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanici] ([KullaniciID])
GO
ALTER TABLE [dbo].[Sanatcilar] CHECK CONSTRAINT [FK_KitaplikSanatcilar_Kullanici]
GO
ALTER TABLE [dbo].[Sarkilar]  WITH CHECK ADD  CONSTRAINT [FK_PopulerSarkilar_KitaplikSanatcilar] FOREIGN KEY([SanatciID])
REFERENCES [dbo].[Sanatcilar] ([SanatciID])
GO
ALTER TABLE [dbo].[Sarkilar] CHECK CONSTRAINT [FK_PopulerSarkilar_KitaplikSanatcilar]
GO
/****** Object:  StoredProcedure [dbo].[spAlbumListeleme]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spAlbumListeleme]
as
select AlbumAdi from Albumler where AlbumYili=2008
GO
/****** Object:  StoredProcedure [dbo].[spAlbumYiliAralik]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spAlbumYiliAralik]
@birinciTarih int,
@ikinciTarih int
as
select * from Albumler where AlbumYili between @birinciTarih and @ikinciTarih
GO
/****** Object:  StoredProcedure [dbo].[spAlbumYiliEnEski]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spAlbumYiliEnEski]
as
SELECT top 1 
SanatciID,AlbumSarkiID,AlbumAdi,AlbumYili
FROM 
Albumler  order by AlbumYili asc
GO
/****** Object:  StoredProcedure [dbo].[spAlbumYiliEnYeni]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spAlbumYiliEnYeni]
as
SELECT top 1 
SanatciID,AlbumSarkiID,AlbumAdi,AlbumYili
FROM 
Albumler  order by AlbumYili desc
GO
/****** Object:  StoredProcedure [dbo].[spAlbumYiliOrt]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spAlbumYiliOrt]
as
SELECT AVG(AlbumYili) 
FROM Albumler
GO
/****** Object:  StoredProcedure [dbo].[spCalmaListesiSen]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create proc [dbo].[spCalmaListesiSen]

AS
SELECT
CalmaListesiID, SarkiAdi, SanatciAdi, SanatciSoyadi,Album
FROM
CalmaListesi where SarkiAdi like '%Sen%'
GO
/****** Object:  StoredProcedure [dbo].[spCalmaListesiTekİsim]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spCalmaListesiTekİsim]
as
SELECT CalmaListesiID, SanatciAdi, SanatciSoyadi 
FROM CalmaListesi

WHERE SanatciSoyadi is null 
GO
/****** Object:  StoredProcedure [dbo].[spFanteziCalmaListeleri]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spFanteziCalmaListeleri]
as
 SELECT
     k.KullaniciID, k.KullaniciAdi, cl.CalmaListesiID,  cl.CalmaListesiAdi, c.SarkiAdi, c.SanatciAdi, c.SanatciSoyadi, c.EklenmeTarihi
     FROM
     Kullanici k INNER JOIN
     CalmaListeleri cl ON k.KullaniciID = cl.KullaniciID INNER JOIN
     CalmaListesi c ON cl.CalmaListesiID = c.CalmaListesiID

WHERE c.CalmaListesiAdi like  '%Fantezi%'
GO
/****** Object:  StoredProcedure [dbo].[spKullanicilariDuzenle]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spKullanicilariDuzenle]
@KullaniciID int,
@KullaniciAdi nvarchar(50),
@Sifre nvarchar(50)
as
Update Kullanici set KullaniciAdi=@KullaniciAdi,Sifre=@Sifre
where KullaniciID=@KullaniciID

GO
/****** Object:  StoredProcedure [dbo].[spKullanicilariEkle]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spKullanicilariEkle]
@KullaniciAdi nvarchar(50),
@Sifre nvarchar(50)
as
insert into Kullanici (KullaniciAdi,Sifre) values (@KullaniciAdi,@Sifre)
GO
/****** Object:  StoredProcedure [dbo].[spSanatciEkle]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSanatciEkle]
@SanatciAdi nvarchar(50),
@SanatciSoyadi nvarchar(50)
as
declare @adet int
set @adet = (Select count(*) from Sanatcilar where 
SanatciAdi = @SanatciAdi and SanatciSoyadi=@SanatciSoyadi)
if @adet>0
begin
	print 'Bu Sanatcı Zaten Kayıtlı'
end
else
begin
	insert into Sanatcilar (SanatciAdi,SanatciSoyadi) 
	values(@SanatciAdi,@SanatciSoyadi)
	print 'Sanatcı eklendi.'
end
GO
/****** Object:  StoredProcedure [dbo].[spSanatcilarTekİsimHaric]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSanatcilarTekİsimHaric]
as
SELECT KullaniciID,SanatciID, SanatciAdi, SanatciSoyadi 
FROM Sanatcilar

WHERE SanatciSoyadi is not null 
GO
/****** Object:  StoredProcedure [dbo].[spSanatciSil]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSanatciSil]
@SanatciID int
as
delete from Sanatcilar where SanatciID = @SanatciID
GO
/****** Object:  StoredProcedure [dbo].[spSarkilarSanatciID]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSarkilarSanatciID]
@SanatciID int
as
select sr.SarkiID,sr.SarkiAdi,sn.SanatciAdi,sn.SanatciSoyadi
from Sarkilar sr inner join Sanatcilar sn on 
sr.SanatciID = sn.SanatciID
where sr.SanatciID = @SanatciID
GO
/****** Object:  StoredProcedure [dbo].[spSureSorgusu]    Script Date: 9.06.2023 18:31:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spSureSorgusu]
as
select SarkiAdi,SanatciAdi,SanatciSoyadi,Sure from CalmaListesi where 
(Sure > '6:00')
GO
