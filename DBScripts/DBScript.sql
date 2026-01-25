USE [master]
GO
/****** Object:  Database [PPdb]    Script Date: 25/01/2026 22:18:52 ******/
CREATE DATABASE [PPdb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PPdb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\PPdb.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'PPdb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\DATA\PPdb_log.ldf' , SIZE = 139264KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [PPdb] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PPdb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PPdb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PPdb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PPdb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PPdb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PPdb] SET ARITHABORT OFF 
GO
ALTER DATABASE [PPdb] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PPdb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PPdb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PPdb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PPdb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PPdb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PPdb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PPdb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PPdb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PPdb] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PPdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PPdb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PPdb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PPdb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PPdb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PPdb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PPdb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PPdb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PPdb] SET  MULTI_USER 
GO
ALTER DATABASE [PPdb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PPdb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PPdb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PPdb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [PPdb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [PPdb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PPdb] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [PPdb] SET QUERY_STORE = ON
GO
ALTER DATABASE [PPdb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PPdb]
GO
/****** Object:  Schema [ppdg3p]    Script Date: 25/01/2026 22:18:52 ******/
CREATE SCHEMA [ppdg3p]
GO
/****** Object:  Schema [ppdg3p_arc]    Script Date: 25/01/2026 22:18:52 ******/
CREATE SCHEMA [ppdg3p_arc]
GO
/****** Object:  Table [ppdg3p].[PoreskiObveznik]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PoreskiObveznik](
	[JMBG/ESB/PIB_lice] [bigint] NOT NULL,
	[Ime] [nchar](30) NOT NULL,
	[Prezime] [nchar](30) NOT NULL,
	[Email] [nchar](30) NULL,
 CONSTRAINT [PK_PoreskiObveznik] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB_lice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[PrenosHartijaOdVrednosti]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PrenosHartijaOdVrednosti](
	[IDStavkePrenosa] [int] NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
	[BrDokOPrenosu] [int] NOT NULL,
 CONSTRAINT [PK_PrenosHartijaOdVrednosti] PRIMARY KEY CLUSTERED 
(
	[IDStavkePrenosa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[OrgPU]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[OrgPU](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
 CONSTRAINT [PK_OrgPU] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[Dokazi]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Dokazi](
	[BrojDokaza] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
	[LokacijaFajla] [nchar](30) NULL,
	[IDPrijave] [int] NOT NULL,
	[JMBG/ESB/PIB_po] [bigint] NULL,
 CONSTRAINT [PK_Dokazi] PRIMARY KEY CLUSTERED 
(
	[BrojDokaza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[VrstaPrijave]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[VrstaPrijave](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
 CONSTRAINT [PK_VrstaPrijave] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[OsnovZaPrijavu]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[OsnovZaPrijavu](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
 CONSTRAINT [PK_OsnovZaPrijavu] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[StavkaPrenosa]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[StavkaPrenosa](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatumPrenosa] [date] NOT NULL,
	[ProdajnaCena] [bigint] NOT NULL,
	[DatumSticanja] [date] NOT NULL,
	[NabavnaCena] [bigint] NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[PrenosPravaUdelaDigImov] [bit] NOT NULL,
 CONSTRAINT [PK_StavkaPrenosa] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[DokumentOSticanju]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[DokumentOSticanju](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BrojStecenihJedinica] [int] NOT NULL,
	[IDPrenHartVred] [int] NULL,
 CONSTRAINT [PK_DokumentOSticanju] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[StavkaUmanjenja]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[StavkaUmanjenja](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatumUlaganja] [date] NOT NULL,
	[IDPrijave] [int] NOT NULL,
 CONSTRAINT [PK_StavkaUmanjenja] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[UlaganjneUResavanjeSP]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[UlaganjneUResavanjeSP](
	[IDStavkeUmanjenja] [int] NOT NULL,
	[IznosUlozenihSredstava] [bigint] NOT NULL,
	[PovrsinaZaOslobadjanje] [real] NOT NULL,
	[Domacinstvo] [bit] NOT NULL,
 CONSTRAINT [PK_UlaganjneUResavanjeSP] PRIMARY KEY CLUSTERED 
(
	[IDStavkeUmanjenja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[UlaganjeUOsnKap]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[UlaganjeUOsnKap](
	[IDStavkeUmanjenja] [int] NOT NULL,
	[IznosUlozenUKapDP] [bigint] NOT NULL,
	[IznosUlozenUKapIF] [bigint] NOT NULL,
 CONSTRAINT [PK_UlaganjeUOsnKap] PRIMARY KEY CLUSTERED 
(
	[IDStavkeUmanjenja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[KapitalniGubitak]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[KapitalniGubitak](
	[IDStavkeUmanjenja] [int] NOT NULL,
	[IznosKapGub] [bigint] NOT NULL,
	[BrojResenja] [int] NOT NULL,
 CONSTRAINT [PK_KapitalniGubitak] PRIMARY KEY CLUSTERED 
(
	[IDStavkeUmanjenja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[PPDG3P]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PPDG3P](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatumOstvarivanjaPrihoda] [date] NOT NULL,
	[DatumDospelostiZaPodnosenjePrijave] [date] NOT NULL,
	[DatumNacinPodnosenjaPrijave] [date] NOT NULL,
	[Izmena] [bit] NOT NULL,
	[IDOrganaPoreske] [int] NOT NULL,
	[IDPoreskogObveznika] [bigint] NOT NULL,
	[IDVrstePrijave] [int] NOT NULL,
	[IDOsnovaZaPrijavu] [int] NOT NULL,
	[UkProdajnaCena] [bigint] NOT NULL,
	[UkNabavnaCena] [bigint] NOT NULL,
	[UkUmanjenja] [bigint] NOT NULL,
	[KapitalnaOsnovica] [bigint] NOT NULL,
	[Email_lice] [nvarchar](50) NULL,
 CONSTRAINT [PK_PPDG3P] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [ppdg3p].[vw_PPDG3P_Document]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [ppdg3p].[vw_PPDG3P_Document]
AS
SELECT
    p.ID AS IDPrijave,
    (
        SELECT
            p.ID AS idPrijave,
            p.DatumOstvarivanjaPrihoda AS datumOstvarivanjaPrihoda,
            p.DatumDospelostiZaPodnosenjePrijave AS datumDospelostiZaPodnosenjePrijave,
            p.DatumNacinPodnosenjaPrijave AS datumNacinPodnosenjaPrijave,
            p.Izmena AS izmena,

            p.IDOrganaPoreske AS idOrganaPoreske,
            p.IDPoreskogObveznika AS idPoreskogObveznika,
            p.IDVrstePrijave AS idVrstePrijave,
            p.IDOsnovaZaPrijavu AS idOsnovaZaPrijavu,

            JSON_QUERY((
                SELECT
                    po.[JMBG/ESB/PIB_lice] AS id,
                    RTRIM(po.Ime) AS ime,
                    RTRIM(po.Prezime) AS prezime,
                    COALESCE(NULLIF(RTRIM(po.Email), ''), NULLIF(RTRIM(CONVERT(nvarchar(50), p.Email_lice)), '')) AS email
                FROM [ppdg3p].[PoreskiObveznik] po
                WHERE po.[JMBG/ESB/PIB_lice] = p.IDPoreskogObveznika
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS poreskiObveznik,

            JSON_QUERY((
                SELECT o.ID AS id, RTRIM(o.Naziv) AS naziv
                FROM [ppdg3p].[OrgPU] o
                WHERE o.ID = p.IDOrganaPoreske
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS organPU,

            JSON_QUERY((
                SELECT vp.ID AS id, RTRIM(vp.Naziv) AS naziv
                FROM [ppdg3p].[VrstaPrijave] vp
                WHERE vp.ID = p.IDVrstePrijave
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS vrstaPrijave,

            JSON_QUERY((
                SELECT oz.ID AS id, RTRIM(oz.Naziv) AS naziv
                FROM [ppdg3p].[OsnovZaPrijavu] oz
                WHERE oz.ID = p.IDOsnovaZaPrijavu
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS osnovZaPrijavu,

            /* DOKAZI */
            JSON_QUERY((
                SELECT
                    d.BrojDokaza AS BrojDokaza,
                    RTRIM(d.Naziv) AS Naziv,
                    RTRIM(d.LokacijaFajla) AS LokacijaFajla,
                    d.[JMBG/ESB/PIB_po] AS JMBG_ESB_PIB_po
                FROM [ppdg3p].[Dokazi] d
                WHERE d.IDPrijave = p.ID
                FOR JSON PATH
            )) AS Dokazi,

            /* UMANJENJA */
            JSON_QUERY((
                SELECT
                    u.ID AS ID,
                    u.DatumUlaganja AS DatumUlaganja,
                    u.Tip AS Tip,
                    u.IznosKapGub AS IznosKapGub,
                    u.BrojResenja AS BrojResenja,
                    u.IznosUlozenUKapDP AS IznosUlozenUKapDP,
                    u.IznosUlozenUKapIF AS IznosUlozenUKapIF,
                    u.IznosUlozenihSredstava AS IznosUlozenihSredstava,
                    u.PovrsinaZaOslobadjanje AS PovrsinaZaOslobadjanje,
                    u.Domacinstvo AS Domacinstvo
                FROM (
                    SELECT
                        su.ID,
                        su.DatumUlaganja,
                        'KAP_GUB' AS Tip,
                        kg.IznosKapGub,
                        kg.BrojResenja,
                        CAST(NULL AS bigint) AS IznosUlozenUKapDP,
                        CAST(NULL AS bigint) AS IznosUlozenUKapIF,
                        CAST(NULL AS bigint) AS IznosUlozenihSredstava,
                        CAST(NULL AS real)   AS PovrsinaZaOslobadjanje,
                        CAST(NULL AS bit)    AS Domacinstvo
                    FROM ppdg3p.StavkaUmanjenja su
                    JOIN ppdg3p.KapitalniGubitak kg ON kg.IDStavkeUmanjenja = su.ID
                    WHERE su.IDPrijave = p.ID

                    UNION ALL

                    SELECT
                        su.ID,
                        su.DatumUlaganja,
                        'OSN_KAP' AS Tip,
                        CAST(NULL AS bigint) AS IznosKapGub,
                        CAST(NULL AS int)    AS BrojResenja,
                        uok.IznosUlozenUKapDP,
                        uok.IznosUlozenUKapIF,
                        CAST(NULL AS bigint) AS IznosUlozenihSredstava,
                        CAST(NULL AS real)   AS PovrsinaZaOslobadjanje,
                        CAST(NULL AS bit)    AS Domacinstvo
                    FROM ppdg3p.StavkaUmanjenja su
                    JOIN ppdg3p.UlaganjeUOsnKap uok ON uok.IDStavkeUmanjenja = su.ID
                    WHERE su.IDPrijave = p.ID

                    UNION ALL

                    SELECT
                        su.ID,
                        su.DatumUlaganja,
                        'RES_SP' AS Tip,
                        CAST(NULL AS bigint) AS IznosKapGub,
                        CAST(NULL AS int)    AS BrojResenja,
                        CAST(NULL AS bigint) AS IznosUlozenUKapDP,
                        CAST(NULL AS bigint) AS IznosUlozenUKapIF,
                        usp.IznosUlozenihSredstava,
                        usp.PovrsinaZaOslobadjanje,
                        usp.Domacinstvo
                    FROM ppdg3p.StavkaUmanjenja su
                    JOIN ppdg3p.UlaganjneUResavanjeSP usp ON usp.IDStavkeUmanjenja = su.ID
                    WHERE su.IDPrijave = p.ID
                ) u
                FOR JSON PATH
            )) AS Umanjenja,

            /* PRENOSI */
            JSON_QUERY((
                SELECT
                    sp.ID AS ID,
                    sp.DatumPrenosa AS DatumPrenosa,
                    sp.ProdajnaCena AS ProdajnaCena,
                    sp.DatumSticanja AS DatumSticanja,
                    sp.NabavnaCena AS NabavnaCena,
                    sp.PrenosPravaUdelaDigImov AS IsDigital,
                    RTRIM(phv.Naziv) AS Naziv,
                    phv.BrDokOPrenosu AS BrDokOPrenosu,
                    JSON_QUERY((
                        SELECT dos.BrojStecenihJedinica AS BrojStecenihJedinica
                        FROM ppdg3p.DokumentOSticanju dos
                        WHERE dos.IDPrenHartVred = sp.ID
                        FOR JSON PATH
                    )) AS DokumentiOSticanju
                FROM ppdg3p.StavkaPrenosa sp
                LEFT JOIN ppdg3p.PrenosHartijaOdVrednosti phv
                    ON phv.IDStavkePrenosa = sp.ID
                WHERE sp.IDPrijave = p.ID
                FOR JSON PATH
            )) AS Prenosi

        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS JsonDoc
FROM [ppdg3p].[PPDG3P] p;
GO
/****** Object:  Table [ppdg3p].[Broker]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Broker](
	[JMGB/ESB/PIB_lice] [bigint] NOT NULL,
	[Naziv] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Broker] PRIMARY KEY CLUSTERED 
(
	[JMGB/ESB/PIB_lice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[Fizicko]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Fizicko](
	[JMGB/ESB/PIB_lice] [bigint] NOT NULL,
	[Ime] [nvarchar](20) NOT NULL,
	[Prezime] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_Fizicko] PRIMARY KEY CLUSTERED 
(
	[JMGB/ESB/PIB_lice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[Lice]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Lice](
	[JMBG/ESB/PIB] [bigint] NOT NULL,
	[Telefon] [nvarchar](30) NULL,
	[Adresa] [nvarchar](50) NULL,
	[Drzava] [nvarchar](50) NULL,
	[Email] [nvarchar](30) NOT NULL,
 CONSTRAINT [PK_Lice] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[PoreskiObveznik_Details]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PoreskiObveznik_Details](
	[JMBG/ESB/PIB] [bigint] NOT NULL,
	[Telefon] [nchar](30) NULL,
	[Drzava] [nchar](30) NULL,
	[PrebOstvPrih] [nchar](30) NOT NULL,
	[AdrObv] [nchar](30) NOT NULL,
 CONSTRAINT [PK_PoreskiObveznik_Details] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[Pravno]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Pravno](
	[JMGB/ESB/PIB_lice] [bigint] NOT NULL,
	[Naziv] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Pravno] PRIMARY KEY CLUSTERED 
(
	[JMGB/ESB/PIB_lice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[Punomocnik]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Punomocnik](
	[JMBG/ESB/PIB_lice] [bigint] IDENTITY(1,1) NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
	[JMBG/ESB/PIB_pun] [bigint] NOT NULL,
 CONSTRAINT [PK_Punomocnik] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB_lice] ASC,
	[IDPrijave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Dokazi]    Script Date: 25/01/2026 22:18:52 ******/
CREATE NONCLUSTERED INDEX [IX_Dokazi] ON [ppdg3p].[Dokazi]
(
	[BrojDokaza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UX_PoreskiObveznik_Email_NotNull]    Script Date: 25/01/2026 22:18:52 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_PoreskiObveznik_Email_NotNull] ON [ppdg3p].[PoreskiObveznik]
(
	[Email] ASC
)
INCLUDE([Ime],[Prezime]) 
WHERE ([Email] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StavkaPrenosa_IDPrijave_Cover]    Script Date: 25/01/2026 22:18:52 ******/
CREATE NONCLUSTERED INDEX [IX_StavkaPrenosa_IDPrijave_Cover] ON [ppdg3p].[StavkaPrenosa]
(
	[IDPrijave] ASC
)
INCLUDE([NabavnaCena],[ProdajnaCena],[DatumPrenosa],[DatumSticanja],[PrenosPravaUdelaDigImov]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [ppdg3p].[PPDG3P] ADD  CONSTRAINT [DF_PPDG3P_UkProdajnaCena]  DEFAULT ((0)) FOR [UkProdajnaCena]
GO
ALTER TABLE [ppdg3p].[PPDG3P] ADD  CONSTRAINT [DF_PPDG3P_UkNabavnaCena]  DEFAULT ((0)) FOR [UkNabavnaCena]
GO
ALTER TABLE [ppdg3p].[PPDG3P] ADD  CONSTRAINT [DF_PPDG3P_UkUmanjenja]  DEFAULT ((0)) FOR [UkUmanjenja]
GO
ALTER TABLE [ppdg3p].[PPDG3P] ADD  CONSTRAINT [DF_PPDG3P_KapitalnaOsnovica]  DEFAULT ((0)) FOR [KapitalnaOsnovica]
GO
ALTER TABLE [ppdg3p].[StavkaPrenosa] ADD  CONSTRAINT [DF_StavkaPrenosa_PrenosPravaUdelaDigImov]  DEFAULT ((0)) FOR [PrenosPravaUdelaDigImov]
GO
ALTER TABLE [ppdg3p].[UlaganjneUResavanjeSP] ADD  CONSTRAINT [DF_UlaganjneUResavanjeSP_Domacinstvo]  DEFAULT ((0)) FOR [Domacinstvo]
GO
ALTER TABLE [ppdg3p].[Broker]  WITH CHECK ADD  CONSTRAINT [FK_Broker_Lice] FOREIGN KEY([JMGB/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[Broker] CHECK CONSTRAINT [FK_Broker_Lice]
GO
ALTER TABLE [ppdg3p].[Dokazi]  WITH CHECK ADD  CONSTRAINT [FK_Dokazi_PoreskiObveznik] FOREIGN KEY([JMBG/ESB/PIB_po])
REFERENCES [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice])
GO
ALTER TABLE [ppdg3p].[Dokazi] CHECK CONSTRAINT [FK_Dokazi_PoreskiObveznik]
GO
ALTER TABLE [ppdg3p].[Dokazi]  WITH CHECK ADD  CONSTRAINT [FK_Dokazi_PPDG3P] FOREIGN KEY([IDPrijave])
REFERENCES [ppdg3p].[PPDG3P] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[Dokazi] CHECK CONSTRAINT [FK_Dokazi_PPDG3P]
GO
ALTER TABLE [ppdg3p].[DokumentOSticanju]  WITH CHECK ADD  CONSTRAINT [FK_DokumentOSticanju_PrenosHartijaOdVrednosti] FOREIGN KEY([IDPrenHartVred])
REFERENCES [ppdg3p].[PrenosHartijaOdVrednosti] ([IDStavkePrenosa])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[DokumentOSticanju] CHECK CONSTRAINT [FK_DokumentOSticanju_PrenosHartijaOdVrednosti]
GO
ALTER TABLE [ppdg3p].[Fizicko]  WITH CHECK ADD  CONSTRAINT [FK_Fizicko_Lice] FOREIGN KEY([JMGB/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[Fizicko] CHECK CONSTRAINT [FK_Fizicko_Lice]
GO
ALTER TABLE [ppdg3p].[KapitalniGubitak]  WITH CHECK ADD  CONSTRAINT [FK_KapitalniGubitak_StavkaUmanjenja] FOREIGN KEY([IDStavkeUmanjenja])
REFERENCES [ppdg3p].[StavkaUmanjenja] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[KapitalniGubitak] CHECK CONSTRAINT [FK_KapitalniGubitak_StavkaUmanjenja]
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik]  WITH CHECK ADD  CONSTRAINT [FK_PoreskiObveznik_Lice] FOREIGN KEY([JMBG/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik] CHECK CONSTRAINT [FK_PoreskiObveznik_Lice]
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik_Details]  WITH CHECK ADD  CONSTRAINT [FK_PoreskiObveznik_Details_Obveznik] FOREIGN KEY([JMBG/ESB/PIB])
REFERENCES [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik_Details] CHECK CONSTRAINT [FK_PoreskiObveznik_Details_Obveznik]
GO
ALTER TABLE [ppdg3p].[PPDG3P]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_OrgPU] FOREIGN KEY([IDOrganaPoreske])
REFERENCES [ppdg3p].[OrgPU] ([ID])
GO
ALTER TABLE [ppdg3p].[PPDG3P] CHECK CONSTRAINT [FK_PPDG3P_OrgPU]
GO
ALTER TABLE [ppdg3p].[PPDG3P]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_OsnovZaPrijavu] FOREIGN KEY([IDOsnovaZaPrijavu])
REFERENCES [ppdg3p].[OsnovZaPrijavu] ([ID])
GO
ALTER TABLE [ppdg3p].[PPDG3P] CHECK CONSTRAINT [FK_PPDG3P_OsnovZaPrijavu]
GO
ALTER TABLE [ppdg3p].[PPDG3P]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_PoreskiObveznik] FOREIGN KEY([IDPoreskogObveznika])
REFERENCES [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice])
GO
ALTER TABLE [ppdg3p].[PPDG3P] CHECK CONSTRAINT [FK_PPDG3P_PoreskiObveznik]
GO
ALTER TABLE [ppdg3p].[PPDG3P]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_VrstaPrijave] FOREIGN KEY([IDVrstePrijave])
REFERENCES [ppdg3p].[VrstaPrijave] ([ID])
GO
ALTER TABLE [ppdg3p].[PPDG3P] CHECK CONSTRAINT [FK_PPDG3P_VrstaPrijave]
GO
ALTER TABLE [ppdg3p].[Pravno]  WITH CHECK ADD  CONSTRAINT [FK_Pravno_Lice] FOREIGN KEY([JMGB/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[Pravno] CHECK CONSTRAINT [FK_Pravno_Lice]
GO
ALTER TABLE [ppdg3p].[PrenosHartijaOdVrednosti]  WITH CHECK ADD  CONSTRAINT [FK_PrenosHartijaOdVrednosti_StavkaPrenosa] FOREIGN KEY([IDStavkePrenosa])
REFERENCES [ppdg3p].[StavkaPrenosa] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[PrenosHartijaOdVrednosti] CHECK CONSTRAINT [FK_PrenosHartijaOdVrednosti_StavkaPrenosa]
GO
ALTER TABLE [ppdg3p].[Punomocnik]  WITH CHECK ADD  CONSTRAINT [FK_Punomocnik_PoreskiObveznik] FOREIGN KEY([JMBG/ESB/PIB_lice])
REFERENCES [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice])
GO
ALTER TABLE [ppdg3p].[Punomocnik] CHECK CONSTRAINT [FK_Punomocnik_PoreskiObveznik]
GO
ALTER TABLE [ppdg3p].[Punomocnik]  WITH CHECK ADD  CONSTRAINT [FK_Punomocnik_PPDG3P] FOREIGN KEY([IDPrijave])
REFERENCES [ppdg3p].[PPDG3P] ([ID])
GO
ALTER TABLE [ppdg3p].[Punomocnik] CHECK CONSTRAINT [FK_Punomocnik_PPDG3P]
GO
ALTER TABLE [ppdg3p].[StavkaPrenosa]  WITH CHECK ADD  CONSTRAINT [FK_StavkaPrenosa_PPDG3P] FOREIGN KEY([IDPrijave])
REFERENCES [ppdg3p].[PPDG3P] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[StavkaPrenosa] CHECK CONSTRAINT [FK_StavkaPrenosa_PPDG3P]
GO
ALTER TABLE [ppdg3p].[StavkaUmanjenja]  WITH CHECK ADD  CONSTRAINT [FK_StavkaUmanjenja_PPDG3P] FOREIGN KEY([IDPrijave])
REFERENCES [ppdg3p].[PPDG3P] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[StavkaUmanjenja] CHECK CONSTRAINT [FK_StavkaUmanjenja_PPDG3P]
GO
ALTER TABLE [ppdg3p].[UlaganjeUOsnKap]  WITH CHECK ADD  CONSTRAINT [FK_UlaganjeUOsnKap_StavkaUmanjenja] FOREIGN KEY([IDStavkeUmanjenja])
REFERENCES [ppdg3p].[StavkaUmanjenja] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[UlaganjeUOsnKap] CHECK CONSTRAINT [FK_UlaganjeUOsnKap_StavkaUmanjenja]
GO
ALTER TABLE [ppdg3p].[UlaganjneUResavanjeSP]  WITH CHECK ADD  CONSTRAINT [FK_UlaganjneUResavanjeSP_StavkaUmanjenja] FOREIGN KEY([IDStavkeUmanjenja])
REFERENCES [ppdg3p].[StavkaUmanjenja] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[UlaganjneUResavanjeSP] CHECK CONSTRAINT [FK_UlaganjneUResavanjeSP_StavkaUmanjenja]
GO
/****** Object:  StoredProcedure [ppdg3p].[PPDG3P_OsnovicaCalc]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [ppdg3p].[PPDG3P_OsnovicaCalc]
    @IDPrijave int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @SumProd bigint = 0,
        @SumNab  bigint = 0,
        @SumUman bigint = 0;

    -- PRENOSI
    SELECT
        @SumProd = COALESCE(SUM(sp.ProdajnaCena), 0),
        @SumNab  = COALESCE(SUM(sp.NabavnaCena), 0)
    FROM ppdg3p.StavkaPrenosa sp
    WHERE sp.IDPrijave = @IDPrijave;

    -- UMANJENJA (primer: saberi ono što ima smisla kao “umanjenje”)
    SELECT
        @SumUman =
            COALESCE(SUM(kg.IznosKapGub), 0) +
            COALESCE(SUM(uok.IznosUlozenUKapDP + uok.IznosUlozenUKapIF), 0) +
            COALESCE(SUM(usp.IznosUlozenihSredstava), 0)
    FROM ppdg3p.StavkaUmanjenja su
    LEFT JOIN ppdg3p.KapitalniGubitak kg ON kg.IDStavkeUmanjenja = su.ID
    LEFT JOIN ppdg3p.UlaganjeUOsnKap uok ON uok.IDStavkeUmanjenja = su.ID
    LEFT JOIN ppdg3p.UlaganjneUResavanjeSP usp ON usp.IDStavkeUmanjenja = su.ID
    WHERE su.IDPrijave = @IDPrijave;

    UPDATE p
    SET
        UkProdajnaCena = @SumProd,
        UkNabavnaCena  = @SumNab,
        UkUmanjenja    = @SumUman,
        KapitalnaOsnovica = (@SumProd - @SumNab - @SumUman)
    FROM ppdg3p.PPDG3P p
    WHERE p.ID = @IDPrijave;
END
GO
/****** Object:  StoredProcedure [ppdg3p].[UpsertPPDG3PDocumentFromJson]    Script Date: 25/01/2026 22:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [ppdg3p].[UpsertPPDG3PDocumentFromJson]
    @IDPrijave int,
    @JsonDoc nvarchar(max),
    @Sync bit = 1
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF ISJSON(@JsonDoc) <> 1
        THROW 52000, 'JsonDoc nije validan JSON.', 1;

    BEGIN TRY
        BEGIN TRAN;

        /* ------------------------------------------------------------
           1) HEADER: PPDG3P
        ------------------------------------------------------------ */
        DECLARE
            @DatumOst date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumOstvarivanjaPrihoda')),
            @DatumDos date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumDospelostiZaPodnosenjePrijave')),
            @DatumPod date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumNacinPodnosenjaPrijave')),
            @Izmena   bit  = TRY_CONVERT(bit,  JSON_VALUE(@JsonDoc, '$.izmena')),

            @IDOrganaPoreske int   = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.organPU.id')),
            @IDPoreskogObveznika bigint = TRY_CONVERT(bigint, JSON_VALUE(@JsonDoc, '$.poreskiObveznik.id')),
            @IDVrstePrijave int    = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.vrstaPrijave.id')),
            @IDOsnovaZaPrijavu int = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.osnovZaPrijavu.id')),

            -- opcionalno, jer u PPDG3P postoji Email_lice
            @EmailLice nvarchar(50) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.email');

        IF @Sync = 1 AND (
            @DatumOst IS NULL OR @DatumDos IS NULL OR @DatumPod IS NULL OR @Izmena IS NULL OR
            @IDOrganaPoreske IS NULL OR @IDPoreskogObveznika IS NULL OR
            @IDVrstePrijave IS NULL OR @IDOsnovaZaPrijavu IS NULL
        )
            THROW 52011, 'Header: nedostaju obavezna polja u JSON-u (PUT mode).', 1;

        UPDATE p
        SET
            DatumOstvarivanjaPrihoda = COALESCE(@DatumOst, p.DatumOstvarivanjaPrihoda),
            DatumDospelostiZaPodnosenjePrijave = COALESCE(@DatumDos, p.DatumDospelostiZaPodnosenjePrijave),
            DatumNacinPodnosenjaPrijave = COALESCE(@DatumPod, p.DatumNacinPodnosenjaPrijave),
            Izmena = COALESCE(@Izmena, p.Izmena),
            IDOrganaPoreske = COALESCE(@IDOrganaPoreske, p.IDOrganaPoreske),
            IDPoreskogObveznika = COALESCE(@IDPoreskogObveznika, p.IDPoreskogObveznika),
            IDVrstePrijave = COALESCE(@IDVrstePrijave, p.IDVrstePrijave),
            IDOsnovaZaPrijavu = COALESCE(@IDOsnovaZaPrijavu, p.IDOsnovaZaPrijavu),
            Email_lice = COALESCE(@EmailLice, p.Email_lice)
        FROM ppdg3p.PPDG3P p
        WHERE p.ID = @IDPrijave;

        IF @@ROWCOUNT = 0
            THROW 52012, 'Ne postoji PPDG3P sa datim @IDPrijave.', 1;

        /* ------------------------------------------------------------
           2) PORESKI OBVEZNIK (usklađeno sa šemom)
              - nema PravniStatus u tvojoj tabeli, pa ga ne diramo
              - opciono update ime/prezime/email ako postoji u JSON-u
        ------------------------------------------------------------ */
        DECLARE
            @PO_Ime nvarchar(100) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.ime'),
            @PO_Prezime nvarchar(100) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.prezime'),
            @PO_Email nvarchar(200) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.email');

        IF @IDPoreskogObveznika IS NOT NULL
        BEGIN
            UPDATE po
            SET
                po.Ime = COALESCE(CAST(LEFT(@PO_Ime, 30) AS nchar(30)), po.Ime),
                po.Prezime = COALESCE(CAST(LEFT(@PO_Prezime, 30) AS nchar(30)), po.Prezime),
                po.Email = CASE
                              WHEN @PO_Email IS NULL THEN po.Email
                              ELSE CAST(LEFT(@PO_Email, 30) AS nchar(30))
                           END
            FROM ppdg3p.PoreskiObveznik po
            WHERE po.[JMBG/ESB/PIB_lice] = @IDPoreskogObveznika;

            IF @@ROWCOUNT = 0
                THROW 52013, 'Ne postoji PoreskiObveznik sa datim ID iz JSON-a.', 1;

            -- Ako želiš da i Lice.Email bude konzistentan (opciono)
            IF @PO_Email IS NOT NULL
            BEGIN
                UPDATE l
                SET l.Email = LEFT(@PO_Email, 30)
                FROM ppdg3p.Lice l
                WHERE l.[JMBG/ESB/PIB] = @IDPoreskogObveznika;
                -- ovde ne bacam error ako nema reda, jer možeš imati stare podatke
            END
        END

        /* ------------------------------------------------------------
           3) DOKAZI
        ------------------------------------------------------------ */
        EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_dokazi_jmbg_update', @value = 1;

        DECLARE @DokaziKeep TABLE (BrojDokaza int NOT NULL PRIMARY KEY);

        ;WITH Src AS (
            SELECT
                BrojDokaza,
                Naziv,
                LokacijaFajla,
                JMBGpo
            FROM OPENJSON(@JsonDoc, '$.Dokazi')
            WITH (
                BrojDokaza int '$.BrojDokaza',
                Naziv nvarchar(30) '$.Naziv',
                LokacijaFajla nvarchar(30) '$.LokacijaFajla',
                JMBGpo bigint '$.JMBG_ESB_PIB_po'
            )
        )
        MERGE ppdg3p.Dokazi AS t
        USING Src AS s
          ON t.BrojDokaza = s.BrojDokaza AND t.IDPrijave = @IDPrijave
        WHEN MATCHED THEN
            UPDATE SET
                t.Naziv = CAST(s.Naziv AS nchar(30)),
                t.LokacijaFajla = CAST(s.LokacijaFajla AS nchar(30)),
                t.[JMBG/ESB/PIB_po] = s.JMBGpo
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (Naziv, LokacijaFajla, IDPrijave, [JMBG/ESB/PIB_po])
            VALUES (CAST(s.Naziv AS nchar(30)), CAST(s.LokacijaFajla AS nchar(30)), @IDPrijave, s.JMBGpo)
        OUTPUT inserted.BrojDokaza INTO @DokaziKeep;

        IF @Sync = 1
        BEGIN
            DELETE d
            FROM ppdg3p.Dokazi d
            WHERE d.IDPrijave = @IDPrijave
              AND NOT EXISTS (SELECT 1 FROM @DokaziKeep k WHERE k.BrojDokaza = d.BrojDokaza);
        END

        EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_dokazi_jmbg_update', @value = NULL;

        /* ------------------------------------------------------------
           4) PRENOSI + HARTIJE + DOKUMENTI O STICANJU
        ------------------------------------------------------------ */
        DECLARE @PrenosMap TABLE (
            ID int NOT NULL PRIMARY KEY,
            IsDigital bit NOT NULL,
            Naziv nvarchar(30) NULL,
            BrDokOPrenosu int NULL,
            DokumentiJson nvarchar(max) NULL
        );

        ;WITH Src AS (
            SELECT
                ID,
                DatumPrenosa,
                ProdajnaCena,
                DatumSticanja,
                NabavnaCena,
                IsDigital = COALESCE(IsDigital, CAST(0 as bit)),
                Naziv,
                BrDokOPrenosu,
                DokumentiJson
            FROM OPENJSON(@JsonDoc, '$.Prenosi')
            WITH (
                ID int '$.ID',
                DatumPrenosa date '$.DatumPrenosa',
                ProdajnaCena bigint '$.ProdajnaCena',
                DatumSticanja date '$.DatumSticanja',
                NabavnaCena bigint '$.NabavnaCena',
                IsDigital bit '$.IsDigital',
                Naziv nvarchar(30) '$.Naziv',
                BrDokOPrenosu int '$.BrDokOPrenosu',
                DokumentiJson nvarchar(max) '$.DokumentiOSticanju' AS JSON
            )
        )
        MERGE ppdg3p.StavkaPrenosa AS t
        USING Src AS s
          ON t.ID = s.ID AND t.IDPrijave = @IDPrijave
        WHEN MATCHED THEN
            UPDATE SET
                t.DatumPrenosa = s.DatumPrenosa,
                t.ProdajnaCena = s.ProdajnaCena,
                t.DatumSticanja = s.DatumSticanja,
                t.NabavnaCena = s.NabavnaCena,
                t.PrenosPravaUdelaDigImov = s.IsDigital
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (DatumPrenosa, ProdajnaCena, DatumSticanja, NabavnaCena, IDPrijave, PrenosPravaUdelaDigImov)
            VALUES (s.DatumPrenosa, s.ProdajnaCena, s.DatumSticanja, s.NabavnaCena, @IDPrijave, s.IsDigital)
        OUTPUT
            inserted.ID,
            inserted.PrenosPravaUdelaDigImov,
            s.Naziv,
            s.BrDokOPrenosu,
            s.DokumentiJson
        INTO @PrenosMap(ID, IsDigital, Naziv, BrDokOPrenosu, DokumentiJson);

        IF @Sync = 1
        BEGIN
            DELETE sp
            FROM ppdg3p.StavkaPrenosa sp
            WHERE sp.IDPrijave = @IDPrijave
              AND NOT EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.ID = sp.ID);
        END

        -- DIGITAL: obriši hartije (dokumenti idu CASCADE)
        DELETE h
        FROM ppdg3p.PrenosHartijaOdVrednosti h
        WHERE EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.ID = h.IDStavkePrenosa AND m.IsDigital = 1);

        -- Upsert hartije samo za IsDigital=0
        MERGE ppdg3p.PrenosHartijaOdVrednosti AS t
        USING (
            SELECT ID, Naziv, BrDokOPrenosu
            FROM @PrenosMap
            WHERE IsDigital = 0
        ) AS s
          ON t.IDStavkePrenosa = s.ID
        WHEN MATCHED THEN
            UPDATE SET
                t.Naziv = CAST(s.Naziv AS nchar(30)),
                t.BrDokOPrenosu = s.BrDokOPrenosu
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (IDStavkePrenosa, Naziv, BrDokOPrenosu)
            VALUES (s.ID, CAST(s.Naziv AS nchar(30)), s.BrDokOPrenosu);

        -- Replace dokumenti o sticanju za hartije iz JSON-a
        DELETE d
        FROM ppdg3p.DokumentOSticanju d
        WHERE EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.IsDigital = 0 AND m.ID = d.IDPrenHartVred);

        INSERT ppdg3p.DokumentOSticanju (BrojStecenihJedinica, IDPrenHartVred)
        SELECT x.BrojStecenihJedinica, m.ID
        FROM @PrenosMap m
        CROSS APPLY OPENJSON(m.DokumentiJson)
        WITH (BrojStecenihJedinica int '$.BrojStecenihJedinica') x
        WHERE m.IsDigital = 0;

        /* ------------------------------------------------------------
           5) UMANJENJA + SUBTIPOVI
        ------------------------------------------------------------ */
        DECLARE @UmanjMap TABLE (
            ID int NOT NULL PRIMARY KEY,
            Tip nvarchar(20) NOT NULL,
            IznosKapGub bigint NULL,
            BrojResenja int NULL,
            IznosUlozenUKapDP bigint NULL,
            IznosUlozenUKapIF bigint NULL,
            IznosUlozenihSredstava bigint NULL,
            PovrsinaZaOslobadjanje real NULL,
            Domacinstvo bit NULL
        );

        ;WITH Src AS (
            SELECT
                ID,
                DatumUlaganja,
                Tip = UPPER(Tip),
                IznosKapGub,
                BrojResenja,
                IznosUlozenUKapDP,
                IznosUlozenUKapIF,
                IznosUlozenihSredstava,
                PovrsinaZaOslobadjanje,
                Domacinstvo
            FROM OPENJSON(@JsonDoc, '$.Umanjenja')
            WITH (
                ID int '$.ID',
                DatumUlaganja date '$.DatumUlaganja',
                Tip nvarchar(20) '$.Tip',
                IznosKapGub bigint '$.IznosKapGub',
                BrojResenja int '$.BrojResenja',
                IznosUlozenUKapDP bigint '$.IznosUlozenUKapDP',
                IznosUlozenUKapIF bigint '$.IznosUlozenUKapIF',
                IznosUlozenihSredstava bigint '$.IznosUlozenihSredstava',
                PovrsinaZaOslobadjanje real '$.PovrsinaZaOslobadjanje',
                Domacinstvo bit '$.Domacinstvo'
            )
        )
        MERGE ppdg3p.StavkaUmanjenja AS t
        USING Src AS s
          ON t.ID = s.ID AND t.IDPrijave = @IDPrijave
        WHEN MATCHED THEN
            UPDATE SET t.DatumUlaganja = s.DatumUlaganja
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (DatumUlaganja, IDPrijave) VALUES (s.DatumUlaganja, @IDPrijave)
        OUTPUT
            inserted.ID,
            s.Tip,
            s.IznosKapGub, s.BrojResenja,
            s.IznosUlozenUKapDP, s.IznosUlozenUKapIF,
            s.IznosUlozenihSredstava, s.PovrsinaZaOslobadjanje, s.Domacinstvo
        INTO @UmanjMap(ID, Tip, IznosKapGub, BrojResenja, IznosUlozenUKapDP, IznosUlozenUKapIF, IznosUlozenihSredstava, PovrsinaZaOslobadjanje, Domacinstvo);

        IF @Sync = 1
        BEGIN
            DELETE su
            FROM ppdg3p.StavkaUmanjenja su
            WHERE su.IDPrijave = @IDPrijave
              AND NOT EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = su.ID);
        END

        -- reset subtypes za stavke iz JSON-a
        DELETE kg FROM ppdg3p.KapitalniGubitak kg WHERE EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = kg.IDStavkeUmanjenja);
        DELETE ok FROM ppdg3p.UlaganjeUOsnKap ok WHERE EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = ok.IDStavkeUmanjenja);
        DELETE rs FROM ppdg3p.UlaganjneUResavanjeSP rs WHERE EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = rs.IDStavkeUmanjenja);

        INSERT ppdg3p.KapitalniGubitak (IDStavkeUmanjenja, IznosKapGub, BrojResenja)
        SELECT ID, IznosKapGub, BrojResenja
        FROM @UmanjMap
        WHERE Tip = 'KAP_GUB';

        INSERT ppdg3p.UlaganjeUOsnKap (IDStavkeUmanjenja, IznosUlozenUKapDP, IznosUlozenUKapIF)
        SELECT ID, IznosUlozenUKapDP, IznosUlozenUKapIF
        FROM @UmanjMap
        WHERE Tip = 'OSN_KAP';

        INSERT ppdg3p.UlaganjneUResavanjeSP (IDStavkeUmanjenja, IznosUlozenihSredstava, PovrsinaZaOslobadjanje, Domacinstvo)
        SELECT ID, IznosUlozenihSredstava, PovrsinaZaOslobadjanje, Domacinstvo
        FROM @UmanjMap
        WHERE Tip = 'RES_SP';

        /* ------------------------------------------------------------
           6) REKALKULACIJA SUMA (UkProdajnaCena/UkNabavnaCena/UkUmanjenja/KapitalnaOsnovica)
        ------------------------------------------------------------ */
        EXEC ppdg3p.PPDG3P_OsnovicaCalc @IDPrijave = @IDPrijave;

        COMMIT;
    END TRY
    BEGIN CATCH
        EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_dokazi_jmbg_update', @value = NULL;
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [PPdb] SET  READ_WRITE 
GO
