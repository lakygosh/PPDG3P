USE [master]
GO
/****** Object:  Database [PPdb]    Script Date: 23/03/2026 23:33:16 ******/
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
ALTER DATABASE [PPdb] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [PPdb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [PPdb] SET QUERY_STORE = ON
GO
ALTER DATABASE [PPdb] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [PPdb]
GO
/****** Object:  Schema [ppdg3p]    Script Date: 23/03/2026 23:33:16 ******/
CREATE SCHEMA [ppdg3p]
GO
/****** Object:  Schema [ppdg3p_arc]    Script Date: 23/03/2026 23:33:16 ******/
CREATE SCHEMA [ppdg3p_arc]
GO
/****** Object:  Table [ppdg3p].[PoreskiObveznik]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PoreskiObveznik](
	[JMBG/ESB/PIB_lice] [bigint] NOT NULL,
	[Ime] [nchar](30) NOT NULL,
	[Prezime] [nchar](30) NOT NULL,
	[PrebivalisteOstvPrih] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PoreskiObveznik] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB_lice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[PPDG3P_Details]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PPDG3P_Details](
	[ID] [int] NOT NULL,
	[DatumOstvarivanjaPrihoda] [date] NOT NULL,
	[DatumDospelostiZaPodnosenjePrijave] [date] NOT NULL,
	[DatumNacinPodnosenjaPrijave] [date] NOT NULL,
	[Izmena] [bit] NOT NULL,
	[IDOrganaPoreske] [int] NOT NULL,
	[IDVrstePrijave] [int] NOT NULL,
	[IDOsnovaZaPrijavu] [int] NOT NULL,
 CONSTRAINT [PK_PPDG3P_Details] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[StavkaPrenosa]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[StavkaPrenosa](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[NabavnaCena] [bigint] NOT NULL,
	[DatumPrenosa] [date] NOT NULL,
	[ProdajnaCena] [bigint] NOT NULL,
	[DatumSticanja] [date] NOT NULL,
	[PrenosPravaUdelaDigImov] [bit] NOT NULL,
 CONSTRAINT [PK_StavkaPrenosa_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[IDPrijave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[StavkaUmanjenja]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[StavkaUmanjenja](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[DatumUlaganja] [date] NOT NULL,
 CONSTRAINT [PK_StavkaUmanjenja] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[IDPrijave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[OrgPU]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[Dokazi]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[UlaganjneUResavanjeSP]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[UlaganjneUResavanjeSP](
	[IDStavkeUmanjenja] [int] NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[IznosUlozenihSredstava] [bigint] NOT NULL,
	[PovrsinaZaOslobadjanje] [real] NOT NULL,
	[Domacinstvo] [bit] NOT NULL,
 CONSTRAINT [PK_UlaganjneUResavanjeSP] PRIMARY KEY CLUSTERED 
(
	[IDStavkeUmanjenja] ASC,
	[IDPrijave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[KapitalniGubitak]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[KapitalniGubitak](
	[IDStavkeUmanjenja] [int] NOT NULL,
	[BrojResenja] [int] NOT NULL,
	[IznosKapGub] [bigint] NOT NULL,
	[IDPrijave] [int] NOT NULL,
 CONSTRAINT [PK_KapitalniGubitak] PRIMARY KEY CLUSTERED 
(
	[IDStavkeUmanjenja] ASC,
	[BrojResenja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[UlaganjeUOsnKap]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[PPDG3P]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PPDG3P](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDPoreskogObveznika] [bigint] NOT NULL,
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
/****** Object:  Table [ppdg3p].[Lice]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[Lice](
	[JMBG/ESB/PIB] [bigint] NOT NULL,
	[Telefon] [nvarchar](30) NULL,
	[Adresa] [nvarchar](50) NULL,
	[Drzava] [nvarchar](50) NULL,
	[Email] [nvarchar](30) NULL,
 CONSTRAINT [PK_Lice] PRIMARY KEY CLUSTERED 
(
	[JMBG/ESB/PIB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[PrenosHartijaOdVrednosti]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[PrenosHartijaOdVrednosti](
	[IDStavkePrenosa] [int] NOT NULL,
	[IDPrijave] [int] NOT NULL,
	[Naziv] [nchar](30) NOT NULL,
	[BrDokOPrenosu] [int] NOT NULL,
	[BrPrenetihHOV] [int] NOT NULL,
 CONSTRAINT [PK_PrenosHartijaOdVrednosti] PRIMARY KEY CLUSTERED 
(
	[IDStavkePrenosa] ASC,
	[IDPrijave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ppdg3p].[DokumentOSticanju]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ppdg3p].[DokumentOSticanju](
	[ID] [int] NOT NULL,
	[BrojStecenihJedinica] [int] NOT NULL,
	[IDPrenHartVred] [int] NULL,
	[IDPrijave] [int] NOT NULL,
	[DatumSticanja] [date] NOT NULL,
	[NabavnaCena] [bigint] NOT NULL,
 CONSTRAINT [PK_DokumentOSticanju] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [ppdg3p].[vw_PPDG3P_Document]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [ppdg3p].[vw_PPDG3P_Document]
AS
SELECT
    p.ID AS IDPrijave,
    (
        SELECT
            p.ID AS idPrijave,

            -- HEADER iz PPDG3P_Details
            pd.DatumOstvarivanjaPrihoda AS datumOstvarivanjaPrihoda,
            pd.DatumDospelostiZaPodnosenjePrijave AS datumDospelostiZaPodnosenjePrijave,
            pd.DatumNacinPodnosenjaPrijave AS datumNacinPodnosenjaPrijave,
            pd.Izmena AS izmena,

            pd.IDOrganaPoreske AS idOrganaPoreske,
            p.IDPoreskogObveznika AS idPoreskogObveznika,
            pd.IDVrstePrijave AS idVrstePrijave,
            pd.IDOsnovaZaPrijavu AS idOsnovaZaPrijavu,

            -- TOTALS iz PPDG3P
            p.UkProdajnaCena AS ukProdajnaCena,
            p.UkNabavnaCena AS ukNabavnaCena,
            p.UkUmanjenja AS ukUmanjenja,
            p.KapitalnaOsnovica AS kapitalnaOsnovica,

            JSON_QUERY((
                SELECT
                    po.[JMBG/ESB/PIB_lice] AS id,
                    RTRIM(po.Ime) AS ime,
                    RTRIM(po.Prezime) AS prezime,
                    RTRIM(po.PrebivalisteOstvPrih) AS prebivalisteOstvPrih,
                    RTRIM(l.Email) AS email,
                    RTRIM(l.Telefon) AS telefon,
                    RTRIM(l.Adresa) AS adresa,
                    RTRIM(l.Drzava) AS drzava
                FROM [ppdg3p].[PoreskiObveznik] po
                LEFT JOIN [ppdg3p].[Lice] l
                    ON l.[JMBG/ESB/PIB] = po.[JMBG/ESB/PIB_lice]
                WHERE po.[JMBG/ESB/PIB_lice] = p.IDPoreskogObveznika
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS poreskiObveznik,

            JSON_QUERY((
                SELECT o.ID AS id, RTRIM(o.Naziv) AS naziv
                FROM [ppdg3p].[OrgPU] o
                WHERE o.ID = pd.IDOrganaPoreske
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS organPU,

            -- VrstaPrijave: inline mapping (umesto join na tabelu/view)
            JSON_QUERY((
                SELECT v.ID AS id, v.Naziv AS naziv
                FROM (VALUES
                    (1, N'Konačna prijava'),
                    (2, N'Izmenjena prijava')
                ) v(ID, Naziv)
                WHERE v.ID = pd.IDVrstePrijave
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
            )) AS vrstaPrijave,

            -- OsnovZaPrijavu: inline mapping
            JSON_QUERY((
                SELECT o.ID AS id, o.Naziv AS naziv
                FROM (VALUES
                    (1, N'Prodaja nepokretnosti'),
                    (2, N'Prodaja hartija od vrednosti (HoV)'),
                    (3, N'Udeo u pravnom licu'),
                    (4, N'Autorska prava'),
                    (5, N'Nasleđe/Poklon')
                ) o(ID, Naziv)
                WHERE o.ID = pd.IDOsnovaZaPrijavu
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
                    phv.BrPrenetihHOV AS BrPrenetihHOV,
                    JSON_QUERY((
                        SELECT
                            dos.DatumSticanja AS DatumSticanja,
                            dos.ID AS BrojDokOSticanju,
                            dos.BrojStecenihJedinica AS BrojStecenihJedinica,
                            dos.NabavnaCena AS NabavnaCena
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
FROM [ppdg3p].[PPDG3P] p
JOIN [ppdg3p].[PPDG3P_Details] pd
    ON pd.ID = p.ID;
GO
/****** Object:  Table [ppdg3p].[Broker]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[Fizicko]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[Pravno]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Table [ppdg3p].[Punomocnik]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  Index [IX_Dokazi]    Script Date: 23/03/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_Dokazi] ON [ppdg3p].[Dokazi]
(
	[BrojDokaza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Lice_Email_NotNull]    Script Date: 23/03/2026 23:33:16 ******/
CREATE NONCLUSTERED INDEX [IX_Lice_Email_NotNull] ON [ppdg3p].[Lice]
(
	[Email] ASC
)
INCLUDE([JMBG/ESB/PIB],[Drzava],[Adresa]) 
WHERE ([Email] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StavkaPrenosa_IDPrijave_Cover]    Script Date: 23/03/2026 23:33:16 ******/
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
ALTER TABLE [ppdg3p].[DokumentOSticanju]  WITH CHECK ADD  CONSTRAINT [FK_DokumentOSticanju_PrenosHartijaOdVrednosti] FOREIGN KEY([IDPrenHartVred], [IDPrijave])
REFERENCES [ppdg3p].[PrenosHartijaOdVrednosti] ([IDStavkePrenosa], [IDPrijave])
GO
ALTER TABLE [ppdg3p].[DokumentOSticanju] CHECK CONSTRAINT [FK_DokumentOSticanju_PrenosHartijaOdVrednosti]
GO
ALTER TABLE [ppdg3p].[Fizicko]  WITH CHECK ADD  CONSTRAINT [FK_Fizicko_Lice] FOREIGN KEY([JMGB/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[Fizicko] CHECK CONSTRAINT [FK_Fizicko_Lice]
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik]  WITH CHECK ADD  CONSTRAINT [FK_PoreskiObveznik_Lice] FOREIGN KEY([JMBG/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[PoreskiObveznik] CHECK CONSTRAINT [FK_PoreskiObveznik_Lice]
GO
ALTER TABLE [ppdg3p].[PPDG3P]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_PoreskiObveznik] FOREIGN KEY([IDPoreskogObveznika])
REFERENCES [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice])
GO
ALTER TABLE [ppdg3p].[PPDG3P] CHECK CONSTRAINT [FK_PPDG3P_PoreskiObveznik]
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_Details_OrgPU] FOREIGN KEY([IDOrganaPoreske])
REFERENCES [ppdg3p].[OrgPU] ([ID])
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details] CHECK CONSTRAINT [FK_PPDG3P_Details_OrgPU]
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details]  WITH CHECK ADD  CONSTRAINT [FK_PPDG3P_Details_PPDG3P] FOREIGN KEY([ID])
REFERENCES [ppdg3p].[PPDG3P] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details] CHECK CONSTRAINT [FK_PPDG3P_Details_PPDG3P]
GO
ALTER TABLE [ppdg3p].[Pravno]  WITH CHECK ADD  CONSTRAINT [FK_Pravno_Lice] FOREIGN KEY([JMGB/ESB/PIB_lice])
REFERENCES [ppdg3p].[Lice] ([JMBG/ESB/PIB])
GO
ALTER TABLE [ppdg3p].[Pravno] CHECK CONSTRAINT [FK_Pravno_Lice]
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
ALTER TABLE [ppdg3p].[PPDG3P_Details]  WITH CHECK ADD  CONSTRAINT [CK_PPDG3P_Details_IDOsnovaZaPrijavu] CHECK  (([IDOsnovaZaPrijavu]=(5) OR [IDOsnovaZaPrijavu]=(4) OR [IDOsnovaZaPrijavu]=(3) OR [IDOsnovaZaPrijavu]=(2) OR [IDOsnovaZaPrijavu]=(1)))
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details] CHECK CONSTRAINT [CK_PPDG3P_Details_IDOsnovaZaPrijavu]
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details]  WITH CHECK ADD  CONSTRAINT [CK_PPDG3P_Details_IDVrstePrijave] CHECK  (([IDVrstePrijave]=(2) OR [IDVrstePrijave]=(1)))
GO
ALTER TABLE [ppdg3p].[PPDG3P_Details] CHECK CONSTRAINT [CK_PPDG3P_Details_IDVrstePrijave]
GO
/****** Object:  StoredProcedure [ppdg3p].[PPDG3P_OsnovicaCalc]    Script Date: 23/03/2026 23:33:16 ******/
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
/****** Object:  StoredProcedure [ppdg3p].[Seed_PPDG3P_Bulk]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [ppdg3p].[Seed_PPDG3P_Bulk]
    @N int = 5000,
    @MaxPrenosi int = 4,
    @MaxDokazi  int = 3,
    @MaxUmanj   int = 3
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @N <= 0 SET @N = 0;
    IF @MaxPrenosi < 1 SET @MaxPrenosi = 1;
    IF @MaxDokazi  < 0 SET @MaxDokazi  = 0;
    IF @MaxUmanj   < 0 SET @MaxUmanj   = 0;

    /* 0) OrgPU seed ako je prazna */
    IF NOT EXISTS (SELECT 1 FROM ppdg3p.OrgPU)
    BEGIN
        INSERT ppdg3p.OrgPU(Naziv)
        VALUES (N'PU Beograd'), (N'PU Novi Sad'), (N'PU Niš'), (N'PU Kragujevac'), (N'PU Subotica');
    END

    /* 1) Kandidati iz Lice koji jos nisu PoreskiObveznik */
    IF OBJECT_ID('tempdb..#Cand') IS NOT NULL DROP TABLE #Cand;

    SELECT TOP (@N)
        l.[JMBG/ESB/PIB] AS LiceID,
        l.Email          AS Email,
        ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    INTO #Cand
    FROM ppdg3p.Lice l
    WHERE NOT EXISTS (
        SELECT 1 FROM ppdg3p.PoreskiObveznik po
        WHERE po.[JMBG/ESB/PIB_lice] = l.[JMBG/ESB/PIB]
    )
    ORDER BY NEWID();

    DECLARE @Nreal int = (SELECT COUNT(*) FROM #Cand);
    IF @Nreal = 0
        THROW 53000, 'Nema dostupnih Lice redova (svi su vec u PoreskiObveznik).', 1;

    /* 2) Insert PoreskiObveznik */
    INSERT ppdg3p.PoreskiObveznik([JMBG/ESB/PIB_lice],[Ime],[Prezime],[PrebivalisteOstvPrih])
    SELECT
        c.LiceID,
        CAST(LEFT(N'Ime' + RIGHT(N'00000' + CAST(c.rn AS nvarchar(10)), 5), 30) AS nchar(30)),
        CAST(LEFT(N'Prezime' + RIGHT(N'00000' + CAST(c.rn AS nvarchar(10)), 5), 30) AS nchar(30)),
        N'Beograd'
    FROM #Cand c;

    /* 3) Insert PPDG3P + mapiranje (FIX: nema c.rn u OUTPUT) */
    DECLARE @Inserted TABLE(
        IDPrijave int NOT NULL PRIMARY KEY,
        LiceID bigint NOT NULL,
        Email nvarchar(30) NULL
    );

    INSERT ppdg3p.PPDG3P(IDPoreskogObveznika, Email_lice)
    OUTPUT inserted.ID, inserted.IDPoreskogObveznika, inserted.Email_lice
    INTO @Inserted(IDPrijave, LiceID, Email)
    SELECT c.LiceID, c.Email
    FROM #Cand c;

    DECLARE @Prijave TABLE(
        RowId int IDENTITY(1,1) PRIMARY KEY,
        IDPrijave int NOT NULL,
        LiceID bigint NOT NULL,
        Email nvarchar(30) NULL,
        rn int NOT NULL
    );

    INSERT INTO @Prijave(IDPrijave, LiceID, Email, rn)
    SELECT i.IDPrijave, i.LiceID, i.Email, c.rn
    FROM @Inserted i
    JOIN #Cand c ON c.LiceID = i.LiceID;

    /* 4) Loop: Upsert JSON za svaku prijavu */
    DECLARE @i int = 1;
    DECLARE @imax int = (SELECT MAX(RowId) FROM @Prijave);

    WHILE @i <= @imax
    BEGIN
        DECLARE
            @IDPrijave int,
            @LiceID bigint,
            @Email nvarchar(30),
            @rn int;

        SELECT
            @IDPrijave = IDPrijave,
            @LiceID = LiceID,
            @Email = Email,
            @rn = rn
        FROM @Prijave
        WHERE RowId = @i;

        DECLARE @OrgId int = (SELECT TOP 1 ID FROM ppdg3p.OrgPU ORDER BY NEWID());
        DECLARE @Vrsta int = CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 2 END;
        DECLARE @Osnov int = (ABS(CHECKSUM(NEWID())) % 5) + 1;
        DECLARE @Izmena bit = CASE WHEN ABS(CHECKSUM(NEWID())) % 10 = 0 THEN 1 ELSE 0 END;

        DECLARE @DatumOst date = DATEADD(day, -(ABS(CHECKSUM(NEWID())) % 730), CAST(GETDATE() AS date));
        DECLARE @DatumPod date = DATEADD(day,  (ABS(CHECKSUM(NEWID())) % 10),  @DatumOst);
        DECLARE @DatumDos date = DATEADD(day, 30, @DatumOst);

        DECLARE @Ime nvarchar(30)     = LEFT(N'Ime' + RIGHT(N'00000' + CAST(@rn AS nvarchar(10)), 5), 30);
        DECLARE @Prezime nvarchar(30) = LEFT(N'Prezime' + RIGHT(N'00000' + CAST(@rn AS nvarchar(10)), 5), 30);

        DECLARE @kPrenosi int = 1 + (ABS(CHECKSUM(NEWID())) % @MaxPrenosi);
        DECLARE @kDokazi  int = CASE WHEN @MaxDokazi=0 THEN 0 ELSE (ABS(CHECKSUM(NEWID())) % (@MaxDokazi+1)) END;
        DECLARE @kUmanj   int = CASE WHEN @MaxUmanj=0  THEN 0 ELSE (ABS(CHECKSUM(NEWID())) % (@MaxUmanj+1)) END;

        DECLARE @Prenosi nvarchar(max) =
        (
            SELECT TOP (@kPrenosi)
                NULL AS ID,
                DATEADD(day, (ABS(CHECKSUM(NEWID())) % 60), @DatumOst) AS DatumPrenosa,
                CAST(100000 + (ABS(CHECKSUM(NEWID())) % 900000) AS bigint) AS ProdajnaCena,
                DATEADD(day, -(ABS(CHECKSUM(NEWID())) % 365), @DatumOst) AS DatumSticanja,
                CAST(50000 + (ABS(CHECKSUM(NEWID())) % 400000) AS bigint) AS NabavnaCena,
                d.IsDigital AS IsDigital,

                CASE WHEN d.IsDigital = 1
                     THEN NULL
                     ELSE LEFT(N'HoV ' + CAST(1000 + (ABS(CHECKSUM(NEWID())) % 9000) AS nvarchar(10)), 30)
                END AS Naziv,

                CASE WHEN d.IsDigital = 1
                     THEN NULL
                     ELSE 100000 + (ABS(CHECKSUM(NEWID())) % 900000)
                END AS BrDokOPrenosu,

                CASE WHEN d.IsDigital = 1 THEN NULL
                     ELSE JSON_QUERY((
                        SELECT TOP (1 + (ABS(CHECKSUM(NEWID())) % 3))
                            CAST(1 + (ABS(CHECKSUM(NEWID())) % 500) AS int) AS BrojStecenihJedinica
                        FROM (VALUES(1),(2),(3)) x(n)
                        FOR JSON PATH
                     ))
                END AS DokumentiOSticanju
            FROM (VALUES(1),(2),(3),(4),(5),(6),(7),(8)) v(n)
            CROSS APPLY (SELECT CAST(CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 45 THEN 1 ELSE 0 END AS bit) AS IsDigital) d
            ORDER BY v.n
            FOR JSON PATH
        );

        DECLARE @Dokazi nvarchar(max) =
        (
            SELECT TOP (@kDokazi)
                NULL AS BrojDokaza,
                LEFT(N'Dokaz ' + CAST(v.n AS nvarchar(10)), 30) AS Naziv,
                LEFT(N'/d/' + CAST(@IDPrijave AS nvarchar(10)) + N'_' + CAST(v.n AS nvarchar(10)) + N'.pdf', 30) AS LokacijaFajla,
                @LiceID AS JMBG_ESB_PIB_po
            FROM (VALUES(1),(2),(3),(4),(5)) v(n)
            ORDER BY v.n
            FOR JSON PATH
        );

        DECLARE @Umanjenja nvarchar(max) =
        (
            SELECT TOP (@kUmanj)
                NULL AS ID,
                DATEADD(day, -(ABS(CHECKSUM(NEWID())) % 365), @DatumOst) AS DatumUlaganja,

                t.Tip AS Tip,

                CASE WHEN t.Tip='KAP_GUB' THEN CAST(5000 + (ABS(CHECKSUM(NEWID())) % 50000) AS bigint) END AS IznosKapGub,
                CASE WHEN t.Tip='KAP_GUB' THEN CAST(10000 + (ABS(CHECKSUM(NEWID())) % 90000) AS int) END AS BrojResenja,

                CASE WHEN t.Tip='OSN_KAP' THEN CAST(10000 + (ABS(CHECKSUM(NEWID())) % 80000) AS bigint) END AS IznosUlozenUKapDP,
                CASE WHEN t.Tip='OSN_KAP' THEN CAST(10000 + (ABS(CHECKSUM(NEWID())) % 80000) AS bigint) END AS IznosUlozenUKapIF,

                CASE WHEN t.Tip='RES_SP' THEN CAST(20000 + (ABS(CHECKSUM(NEWID())) % 150000) AS bigint) END AS IznosUlozenihSredstava,
                CASE WHEN t.Tip='RES_SP' THEN CAST((10 + (ABS(CHECKSUM(NEWID())) % 500)) / 10.0 AS real) END AS PovrsinaZaOslobadjanje,
                CASE WHEN t.Tip='RES_SP' THEN CAST(CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 1 ELSE 0 END AS bit) END AS Domacinstvo
            FROM (VALUES(1),(2),(3),(4),(5),(6)) v(n)
            CROSS APPLY (
                SELECT CASE (ABS(CHECKSUM(NEWID())) % 3)
                    WHEN 0 THEN N'OSN_KAP'
                    WHEN 1 THEN N'KAP_GUB'
                    ELSE      N'RES_SP'
                END AS Tip
            ) t
            ORDER BY v.n
            FOR JSON PATH
        );

        DECLARE @JsonDoc nvarchar(max) =
        (
            SELECT
                @IDPrijave AS idPrijave,
                @DatumOst AS datumOstvarivanjaPrihoda,
                @DatumDos AS datumDospelostiZaPodnosenjePrijave,
                @DatumPod AS datumNacinPodnosenjaPrijave,
                @Izmena   AS izmena,

                JSON_QUERY((SELECT @OrgId AS id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS organPU,
                JSON_QUERY((
                    SELECT
                        @LiceID AS id,
                        @Ime AS ime,
                        @Prezime AS prezime,
                        @Email AS email,
                        N'Beograd' AS prebivalisteOstvPrih
                    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
                )) AS poreskiObveznik,
                JSON_QUERY((SELECT @Vrsta AS id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS vrstaPrijave,
                JSON_QUERY((SELECT @Osnov AS id FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS osnovZaPrijavu,

                JSON_QUERY(COALESCE(@Dokazi,    N'[]')) AS Dokazi,
                JSON_QUERY(COALESCE(@Umanjenja, N'[]')) AS Umanjenja,
                JSON_QUERY(COALESCE(@Prenosi,   N'[]')) AS Prenosi
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );

        EXEC ppdg3p.UpsertPPDG3PDocumentFromJson
            @IDPrijave = @IDPrijave,
            @JsonDoc   = @JsonDoc,
            @Sync      = 1;

        SET @i += 1;
    END

    /* 5) Sanity check */
    SELECT
        (SELECT COUNT(*) FROM ppdg3p.PoreskiObveznik) AS PoreskiObveznik_cnt,
        (SELECT COUNT(*) FROM ppdg3p.PPDG3P)          AS PPDG3P_cnt,
        (SELECT COUNT(*) FROM ppdg3p.PPDG3P_Details)  AS PPDG3P_Details_cnt,
        (SELECT COUNT(*) FROM ppdg3p.StavkaPrenosa)   AS StavkaPrenosa_cnt,
        (SELECT COUNT(*) FROM ppdg3p.PrenosHartijaOdVrednosti) AS PrenosHoV_cnt,
        (SELECT COUNT(*) FROM ppdg3p.DokumentOSticanju) AS DokumentOSticanju_cnt,
        (SELECT COUNT(*) FROM ppdg3p.StavkaUmanjenja) AS StavkaUmanjenja_cnt,
        (SELECT COUNT(*) FROM ppdg3p.KapitalniGubitak) AS KapitalniGubitak_cnt,
        (SELECT COUNT(*) FROM ppdg3p.UlaganjeUOsnKap) AS UlaganjeUOsnKap_cnt,
        (SELECT COUNT(*) FROM ppdg3p.UlaganjneUResavanjeSP) AS UlagResavanjeSP_cnt,
        (SELECT COUNT(*) FROM ppdg3p.Dokazi)          AS Dokazi_cnt;
END
GO
/****** Object:  StoredProcedure [ppdg3p].[SetHardcoded_OsnovZaPrijavu]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [ppdg3p].[SetHardcoded_OsnovZaPrijavu]
    @ItemsJson nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF ISJSON(@ItemsJson) <> 1
        THROW 52090, 'ItemsJson nije validan JSON.', 1;

    DECLARE @T TABLE (ID int NOT NULL PRIMARY KEY, Naziv nvarchar(30) NOT NULL);

    INSERT INTO @T(ID, Naziv)
    SELECT TRY_CONVERT(int, JSON_VALUE(j.value, '$.id')),
           LEFT(JSON_VALUE(j.value, '$.naziv'), 30)
    FROM OPENJSON(@ItemsJson) j
    WHERE JSON_VALUE(j.value, '$.id') IS NOT NULL
      AND JSON_VALUE(j.value, '$.naziv') IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM @T)
        THROW 52091, 'ItemsJson nema nijednu validnu stavku (id,naziv).', 1;

    IF EXISTS (SELECT 1 FROM @T WHERE LTRIM(RTRIM(Naziv)) = '')
        THROW 52092, 'Naziv ne sme biti prazan.', 1;

    DECLARE @IdList nvarchar(max) = (SELECT STRING_AGG(CAST(ID AS nvarchar(20)), ',') FROM @T);

    IF EXISTS (
        SELECT 1
        FROM ppdg3p.PPDG3P_Details d
        WHERE d.IDOsnovaZaPrijavu IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM @T t WHERE t.ID = d.IDOsnovaZaPrijavu)
    )
        THROW 52093, 'PPDG3P_Details sadrži IDOsnovaZaPrijavu vrednosti koje nisu u novom dozvoljenom setu.', 1;

    DECLARE @ValuesSql nvarchar(max) =
        (SELECT STRING_AGG('(' + CAST(ID AS nvarchar(20)) + ', N''' + REPLACE(Naziv, '''', '''''') + ''')', ',')
         FROM @T);

    DECLARE @Sql nvarchar(max);

    SET @Sql = N'
CREATE OR ALTER VIEW [ppdg3p].[vw_OsnovZaPrijavu_HC]
AS
SELECT v.ID, CAST(v.Naziv AS nchar(30)) AS Naziv
FROM (VALUES ' + @ValuesSql + N') v(ID, Naziv);';
    EXEC sys.sp_executesql @Sql;

    IF EXISTS (
        SELECT 1
        FROM sys.check_constraints
        WHERE name = 'CK_PPDG3P_Details_IDOsnovaZaPrijavu'
          AND parent_object_id = OBJECT_ID('ppdg3p.PPDG3P_Details')
    )
        ALTER TABLE ppdg3p.PPDG3P_Details DROP CONSTRAINT CK_PPDG3P_Details_IDOsnovaZaPrijavu;

    SET @Sql = N'
ALTER TABLE ppdg3p.PPDG3P_Details WITH CHECK
ADD CONSTRAINT CK_PPDG3P_Details_IDOsnovaZaPrijavu
CHECK (IDOsnovaZaPrijavu IN (' + @IdList + N'));';
    EXEC sys.sp_executesql @Sql;
END
GO
/****** Object:  StoredProcedure [ppdg3p].[SetHardcoded_VrstaPrijave]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [ppdg3p].[SetHardcoded_VrstaPrijave]
    @ItemsJson nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF ISJSON(@ItemsJson) <> 1
        THROW 52080, 'ItemsJson nije validan JSON.', 1;

    DECLARE @T TABLE (ID int NOT NULL PRIMARY KEY, Naziv nvarchar(30) NOT NULL);

    INSERT INTO @T(ID, Naziv)
    SELECT TRY_CONVERT(int, JSON_VALUE(j.value, '$.id')),
           LEFT(JSON_VALUE(j.value, '$.naziv'), 30)
    FROM OPENJSON(@ItemsJson) j
    WHERE JSON_VALUE(j.value, '$.id') IS NOT NULL
      AND JSON_VALUE(j.value, '$.naziv') IS NOT NULL;

    IF NOT EXISTS (SELECT 1 FROM @T)
        THROW 52081, 'ItemsJson nema nijednu validnu stavku (id,naziv).', 1;

    IF EXISTS (SELECT 1 FROM @T WHERE LTRIM(RTRIM(Naziv)) = '')
        THROW 52082, 'Naziv ne sme biti prazan.', 1;

    DECLARE @IdList nvarchar(max) = (SELECT STRING_AGG(CAST(ID AS nvarchar(20)), ',') FROM @T);

    IF EXISTS (
        SELECT 1
        FROM ppdg3p.PPDG3P_Details d
        WHERE d.IDVrstePrijave IS NOT NULL
          AND NOT EXISTS (SELECT 1 FROM @T t WHERE t.ID = d.IDVrstePrijave)
    )
        THROW 52083, 'PPDG3P_Details sadrži IDVrstePrijave vrednosti koje nisu u novom dozvoljenom setu.', 1;

    DECLARE @ValuesSql nvarchar(max) =
        (SELECT STRING_AGG('(' + CAST(ID AS nvarchar(20)) + ', N''' + REPLACE(Naziv, '''', '''''') + ''')', ',')
         FROM @T);

    DECLARE @Sql nvarchar(max);

    SET @Sql = N'
CREATE OR ALTER VIEW [ppdg3p].[vw_VrstaPrijave_HC]
AS
SELECT v.ID, CAST(v.Naziv AS nchar(30)) AS Naziv
FROM (VALUES ' + @ValuesSql + N') v(ID, Naziv);';
    EXEC sys.sp_executesql @Sql;

    IF EXISTS (
        SELECT 1
        FROM sys.check_constraints
        WHERE name = 'CK_PPDG3P_Details_IDVrstePrijave'
          AND parent_object_id = OBJECT_ID('ppdg3p.PPDG3P_Details')
    )
        ALTER TABLE ppdg3p.PPDG3P_Details DROP CONSTRAINT CK_PPDG3P_Details_IDVrstePrijave;

    SET @Sql = N'
ALTER TABLE ppdg3p.PPDG3P_Details WITH CHECK
ADD CONSTRAINT CK_PPDG3P_Details_IDVrstePrijave
CHECK (IDVrstePrijave IN (' + @IdList + N'));';
    EXEC sys.sp_executesql @Sql;
END
GO
/****** Object:  StoredProcedure [ppdg3p].[UpsertPPDG3PDocumentFromJson]    Script Date: 23/03/2026 23:33:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ppdg3p].[UpsertPPDG3PDocumentFromJson]
    @IDPrijave int = NULL,
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
           1) HEADER
        ------------------------------------------------------------ */
        DECLARE
            @DatumOst date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumOstvarivanjaPrihoda')),
            @DatumDos date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumDospelostiZaPodnosenjePrijave')),
            @DatumPod date = TRY_CONVERT(date, JSON_VALUE(@JsonDoc, '$.datumNacinPodnosenjaPrijave')),
            @Izmena   bit  = TRY_CONVERT(bit,  JSON_VALUE(@JsonDoc, '$.izmena')),

            @IDOrganaPoreske int   = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.organPU.id')),
            @IDPoreskogObveznika bigint = TRY_CONVERT(bigint, JSON_VALUE(@JsonDoc, '$.poreskiObveznik.id')),
            @IDVrstePrijave int    = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.vrstaPrijave.id')),
            @IDOsnovaZaPrijavu int = TRY_CONVERT(int,    JSON_VALUE(@JsonDoc, '$.osnovZaPrijavu.id'));

           -- Validate IDVrstePrijave: must be 1 or 2
    IF @IDVrstePrijave IS NOT NULL AND @IDVrstePrijave NOT IN (1, 2)
        THROW 52015, 'Врста пријаве мора бити изабрана. Дозвољене вредности: 1 (Коначна     
        пријава) или 2 (Измењена пријава).', 1;

    -- Validate IDOsnovaZaPrijavu: must be 1-5
    IF @IDOsnovaZaPrijavu IS NOT NULL AND @IDOsnovaZaPrijavu NOT IN (1, 2, 3, 4, 5)
        THROW 52016, 'Основ за пријаву мора бити изабран. Дозвољене вредности: 1-5.', 1;
         
        -- Validate dates: none can be in the future
    IF @DatumOst IS NULL OR @DatumOst > CAST(GETDATE() AS DATE)
        THROW 52017, 'Датум остваривања прихода мора бити изабран и не може бити у будућности.', 1;

    IF @DatumDos IS NULL OR @DatumDos > CAST(GETDATE() AS DATE)
        THROW 52018, 'Датум доспелости за подношење пријаве мора бити изабран и не може бити у будућности.', 1;

    IF @DatumPod IS NULL OR @DatumPod > CAST(GETDATE() AS DATE)
        THROW 52019, 'Датум подношења пријаве мора бити изабран и не може бити у будућности.', 1;

    -- Validate date chronological order: DatumOst <= DatumDos <= DatumPod
    IF @DatumOst IS NOT NULL AND @DatumDos IS NOT NULL AND @DatumOst > @DatumDos
        THROW 52020, 'Датум остваривања прихода мора бити пре или једнак датуму доспелости за подношење.', 1;

    IF @DatumDos IS NOT NULL AND @DatumPod IS NOT NULL AND @DatumDos > @DatumPod
        THROW 52021, 'Датум доспелости за подношење мора бити пре или једнак датуму подношења пријаве.', 1;

    IF @DatumOst IS NOT NULL AND @DatumPod IS NOT NULL AND @DatumOst > @DatumPod
        THROW 52022, 'Датум остваривања прихода мора бити пре или једнак датуму подношења пријаве.', 1;

    IF @IDOrganaPoreske IS NULL
        THROW 52023, 'Орган пореске управе мора бити изабран.', 1;

    IF (@IDPoreskogObveznika IS NULL OR @IDPoreskogObveznika <= 0)    
      THROW 52023, 'ЈМБГ/ЕСБ/ПИБ мора бити валидан број (без слова и специјалних знакова).', 1;
            
        IF @Sync = 1 AND (
            @DatumOst IS NULL OR @DatumDos IS NULL OR @DatumPod IS NULL OR @Izmena IS NULL OR
            @IDOrganaPoreske IS NULL OR @IDPoreskogObveznika IS NULL OR
            @IDVrstePrijave IS NULL OR @IDOsnovaZaPrijavu IS NULL
        )
            THROW 52011, 'Header: nedostaju obavezna polja u JSON-u (PUT mode).', 1;

        /* ------------------------------------------------------------
           1a) ENSURE LICE + PORESKI OBVEZNIK EXIST
        ------------------------------------------------------------ */
        DECLARE
            @PO_Ime nvarchar(100) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.ime'),
            @PO_Prezime nvarchar(100) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.prezime'),
            @PO_Prebivaliste nvarchar(50) = JSON_VALUE(@JsonDoc, '$.poreskiObveznik.prebivalisteOstvPrih'),
            @PO_Email nvarchar(30) = LEFT(JSON_VALUE(@JsonDoc, '$.poreskiObveznik.email'), 30),
            @PO_Telefon nvarchar(30) = LEFT(JSON_VALUE(@JsonDoc, '$.poreskiObveznik.telefon'), 30),
            @PO_Adresa nvarchar(50) = LEFT(JSON_VALUE(@JsonDoc, '$.poreskiObveznik.adresa'), 50),
            @PO_Drzava nvarchar(50) = LEFT(JSON_VALUE(@JsonDoc, '$.poreskiObveznik.drzava'), 50);

            -- Ime: required field
        IF @PO_Ime IS NULL OR LTRIM(RTRIM(@PO_Ime)) = ''
            THROW 52026, 'Име је обавезно поље.', 1;

        -- Prezime: required field
        IF @PO_Prezime IS NULL OR LTRIM(RTRIM(@PO_Prezime)) = ''
            THROW 52027, 'Презиме је обавезно поље.', 1;

        -- Ime: format validation
        IF @PO_Ime LIKE '%[0-9]%' OR
        @PO_Ime LIKE '%[@#$%^&*()+=]%' OR
        @PO_Ime LIKE '%[{}[\]<>]%' OR
        @PO_Ime LIKE '%[.,:;!?/\|~`"_]%'
            THROW 52028, 'Име може садржати само слова (без бројева и специјалних знакова).', 1;   

        -- Prezime: format validation
        IF @PO_Prezime LIKE '%[0-9]%' OR
        @PO_Prezime LIKE '%[@#$%^&*()+=]%' OR
        @PO_Prezime LIKE '%[{}[\]<>]%' OR
        @PO_Prezime LIKE '%[.,:;!?/\|~`"_]%'
            THROW 52029, 'Презиме може садржати само слова (без бројева и специјалних знакова).', 1;

        IF @PO_Adresa IS NULL OR LTRIM(RTRIM(@PO_Adresa)) = ''
            THROW 52030, 'Адреса је обавезно поље.', 1;
            
        IF @PO_Prebivaliste IS NULL OR LTRIM(RTRIM(@PO_Prebivaliste)) = ''
            THROW 52031, 'Пребивалиште је обавезно поље.', 1;

        -- Prezime: required field
        IF @PO_Drzava IS NULL OR LTRIM(RTRIM(@PO_Drzava)) = ''
            THROW 52032, 'Država је обавезно поље.', 1;

        -- Ime: format validation
        IF @PO_Drzava LIKE '%[0-9]%' OR
        @PO_Drzava LIKE '%[@#$%^&*()+=]%' OR
        @PO_Drzava LIKE '%[{}[\]<>]%' OR
        @PO_Drzava LIKE '%[.,:;!?/\|~`"_]%'
            THROW 52033, 'Država може садржати само слова (без бројева и специјалних знакова).', 1;   

        IF @PO_Telefon IS NULL OR LTRIM(RTRIM(@PO_Telefon)) = ''
            THROW 520234, 'Телефон је обавезно поље.', 1;

        -- Validate Telefon: optional +, then only digits, spaces, hyphens, parentheses
        IF @PO_Telefon IS NOT NULL AND LTRIM(RTRIM(@PO_Telefon)) != '' AND (
            -- Remove allowed characters and check if anything remains
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@PO_Telefon, '+', ''), ' ', ''), '-', ''), '(',
        ''), ')', '') LIKE '%[^0-9]%' OR
            -- Check that + is only at the beginning
            (CHARINDEX('+', @PO_Telefon) > 1)
        )
            THROW 52035, 'Телефон може садржати само бројеве, размаке, цртице и опционо + на почетку.', 1;

        IF @PO_Email IS NULL OR LTRIM(RTRIM(@PO_Email)) = ''
            THROW 52036, 'Електронска пошта је обавезно поље.', 1;

        -- Validate Email: must have valid email format (local@domain.tld)
        IF @PO_Email IS NOT NULL AND LTRIM(RTRIM(@PO_Email)) != '' AND (
            @PO_Email NOT LIKE '%_@__%.__%' OR           -- Basic pattern:      something@something.something
            @PO_Email LIKE '%[@]%[@]%' OR                 -- No multiple @
            @PO_Email LIKE '[@]%' OR                      -- @ not at start
            @PO_Email LIKE '%[@]' OR                      -- @ not at end
            @PO_Email LIKE '%[<>()[\]\\,;: ]%'           -- No invalid characters
        )
            THROW 52037, 'Електронска пошта мора бити у валидном формату (пример: korisnik@domen.com).', 1;

        IF @IDPoreskogObveznika IS NOT NULL
        BEGIN
            -- Ensure Lice exists
            IF NOT EXISTS (SELECT 1 FROM ppdg3p.Lice WHERE [JMBG/ESB/PIB] = @IDPoreskogObveznika)
                INSERT INTO ppdg3p.Lice ([JMBG/ESB/PIB], Telefon, Adresa, Drzava, Email)
                VALUES (@IDPoreskogObveznika, @PO_Telefon, @PO_Adresa, @PO_Drzava, @PO_Email);
            ELSE
                UPDATE ppdg3p.Lice SET
                    Telefon = COALESCE(@PO_Telefon, Telefon),
                    Adresa  = COALESCE(@PO_Adresa,  Adresa),
                    Drzava  = COALESCE(@PO_Drzava,  Drzava),
                    Email   = COALESCE(@PO_Email,   Email)
                WHERE [JMBG/ESB/PIB] = @IDPoreskogObveznika;

            -- Ensure PoreskiObveznik exists
            IF NOT EXISTS (SELECT 1 FROM ppdg3p.PoreskiObveznik WHERE [JMBG/ESB/PIB_lice] = @IDPoreskogObveznika)
                INSERT INTO ppdg3p.PoreskiObveznik ([JMBG/ESB/PIB_lice], Ime, Prezime, PrebivalisteOstvPrih)
                VALUES (@IDPoreskogObveznika, CAST(LEFT(@PO_Ime, 30) AS nchar(30)), CAST(LEFT(@PO_Prezime, 30) AS nchar(30)), LEFT(@PO_Prebivaliste, 50));
            ELSE
                UPDATE ppdg3p.PoreskiObveznik SET
                    Ime = COALESCE(CAST(LEFT(@PO_Ime, 30) AS nchar(30)), Ime),
                    Prezime = COALESCE(CAST(LEFT(@PO_Prezime, 30) AS nchar(30)), Prezime),
                    PrebivalisteOstvPrih = COALESCE(LEFT(@PO_Prebivaliste, 50), PrebivalisteOstvPrih)
                WHERE [JMBG/ESB/PIB_lice] = @IDPoreskogObveznika;
        END

        /* ------------------------------------------------------------
           1b) PPDG3P: create or update
        ------------------------------------------------------------ */
        IF @IDPrijave IS NULL
        BEGIN
            -- CREATE mode: insert new PPDG3P row
            INSERT INTO ppdg3p.PPDG3P (IDPoreskogObveznika, Email_lice)
            VALUES (@IDPoreskogObveznika, @PO_Email);

            SET @IDPrijave = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            -- UPDATE mode: PPDG3P must exist
            EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_ppdg3p_update', @value = 1;

            UPDATE p
            SET p.IDPoreskogObveznika = COALESCE(@IDPoreskogObveznika, p.IDPoreskogObveznika)
            FROM ppdg3p.PPDG3P p
            WHERE p.ID = @IDPrijave;

            EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_ppdg3p_update', @value = NULL;

            IF @@ROWCOUNT = 0
                THROW 52012, 'Ne postoji PPDG3P sa datim @IDPrijave.', 1;
        END

        -- Update/insert Details
        UPDATE pd
        SET
            pd.DatumOstvarivanjaPrihoda = COALESCE(@DatumOst, pd.DatumOstvarivanjaPrihoda),
            pd.DatumDospelostiZaPodnosenjePrijave = COALESCE(@DatumDos, pd.DatumDospelostiZaPodnosenjePrijave),
            pd.DatumNacinPodnosenjaPrijave = COALESCE(@DatumPod, pd.DatumNacinPodnosenjaPrijave),
            pd.Izmena = COALESCE(@Izmena, pd.Izmena),
            pd.IDOrganaPoreske = COALESCE(@IDOrganaPoreske, pd.IDOrganaPoreske),
            pd.IDVrstePrijave = COALESCE(@IDVrstePrijave, pd.IDVrstePrijave),
            pd.IDOsnovaZaPrijavu = COALESCE(@IDOsnovaZaPrijavu, pd.IDOsnovaZaPrijavu)
        FROM ppdg3p.PPDG3P_Details pd
        WHERE pd.ID = @IDPrijave;

        IF @@ROWCOUNT = 0
        BEGIN
            IF (
                @DatumOst IS NULL OR @DatumDos IS NULL OR @DatumPod IS NULL OR @Izmena IS NULL OR
                @IDOrganaPoreske IS NULL OR @IDVrstePrijave IS NULL OR @IDOsnovaZaPrijavu IS NULL
            )
                THROW 52014, 'PPDG3P_Details ne postoji za ovu prijavu, a JSON nema sva obavezna polja da bi se napravio red.', 1;

            INSERT ppdg3p.PPDG3P_Details
                (ID, DatumOstvarivanjaPrihoda, DatumDospelostiZaPodnosenjePrijave, DatumNacinPodnosenjaPrijave, Izmena, IDOrganaPoreske, IDVrstePrijave, IDOsnovaZaPrijavu)
            VALUES
                (@IDPrijave, @DatumOst, @DatumDos, @DatumPod, @Izmena, @IDOrganaPoreske, @IDVrstePrijave, @IDOsnovaZaPrijavu);
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
           4) PRENOSI + HARTIJE + DOKUMENTI O STICANJU  (FIXED)
        ------------------------------------------------------------ */
        DECLARE @PrenosMap TABLE (
            ID int NOT NULL PRIMARY KEY,
            IDPrijave int NOT NULL,
            IsDigital bit NOT NULL,
            Naziv nvarchar(30) NULL,
            BrDokOPrenosu int NULL,
            BrojPrenetihHOV int NULL,
            DokumentiJson nvarchar(max) NULL
        );

        DECLARE @ErrorMsg nvarchar(500);

        -- Validate Prenosi fields first (check ALL rows, not just first)
        ;WITH SrcValidate AS (
            SELECT
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum,
                DatumPrenosa,
                ProdajnaCena,
                DatumSticanja,
                NabavnaCena,
                Naziv,
                BrDokOPrenosu,
                BrojPrenetihHOV,
                IsDigital,
                DokumentiJson
            FROM OPENJSON(@JsonDoc, N'$.Prenosi')
            WITH (
                DatumPrenosa date N'$.DatumPrenosa',
                ProdajnaCena nvarchar(30) N'$.ProdajnaCena',
                DatumSticanja date N'$.DatumSticanja',
                NabavnaCena nvarchar(30) N'$.NabavnaCena',
                Naziv nvarchar(30) N'$.Naziv',
                BrDokOPrenosu nvarchar(20) N'$.BrDokOPrenosu',
                BrojPrenetihHOV nvarchar(20) N'$.BrojPrenetihHOV',
                IsDigital bit N'$.IsDigital',
                DokumentiJson nvarchar(max) N'$.DokumentiOSticanju' AS JSON
            )
        )
        SELECT TOP 1
            @ErrorMsg =
                N'Ставка преноса #' + CAST(RowNum AS nvarchar(10)) + N': ' +
                CASE
                    -- Check required fields (NULL means either missing or invalid format)
                    WHEN DatumPrenosa IS NULL THEN N'Датум преноса је обавезно поље и мора бити валидан датум.'
                    WHEN DatumPrenosa > CAST(GETDATE() AS DATE) THEN N'Датум преноса не може бити у будућности.'
                    WHEN DatumSticanja IS NULL THEN N'Датум стицања је обавезно поље и мора бити валидан датум.'
                    WHEN DatumSticanja > CAST(GETDATE() AS DATE) THEN N'Датум стицања не може бити у будућности.'
                    WHEN DatumSticanja > DatumPrenosa THEN N'Датум стицања мора бити пре илиједнак датуму преноса.'
                    WHEN ProdajnaCena IS NULL THEN N'Продајна цена је обавезно поље.'
                    WHEN TRY_CONVERT(bigint, ProdajnaCena) IS NULL THEN N'Продајна цена мора бити валидан број.'
                    WHEN TRY_CONVERT(bigint, ProdajnaCena) <= 0 THEN N'Продајна цена мора бити позитиван број.'
                    WHEN NabavnaCena IS NULL THEN N'Набавна цена је обавезно поље.'
                    WHEN TRY_CONVERT(bigint, NabavnaCena) IS NULL THEN N'Набавна цена мора бити валидан број.'
                    WHEN TRY_CONVERT(bigint, NabavnaCena) <= 0 THEN N'Набавна цена мора бити позитиван број.'
                    -- HoV-specific fields (only for non-digital entries)
                    WHEN COALESCE(IsDigital, 0) = 0 AND (Naziv IS NULL OR LTRIM(RTRIM(Naziv)) = '') THEN N'Назив емитента је обавезно поље.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND BrDokOPrenosu IS NULL THEN N'Број документа о преносу је обавезно поље.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND TRY_CONVERT(int, BrDokOPrenosu) IS NULL THEN N'Број документа о преносу мора бити валидан број.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND TRY_CONVERT(int, BrDokOPrenosu) <= 0 THEN N'Број документа о преносу мора бити позитиван број.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND BrojPrenetihHOV IS NULL THEN N'Број пренетих ХОВ је обавезно поље.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND TRY_CONVERT(int, BrojPrenetihHOV) IS NULL THEN N'Број пренетих ХОВ мора бити валидан број.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND TRY_CONVERT(int, BrojPrenetihHOV) <= 0 THEN N'Број пренетих ХОВ мора бити позитиван број.'
                    WHEN COALESCE(IsDigital, 0) = 0 AND (DokumentiJson IS NULL OR DokumentiJson = N'[]') THEN N'Мора постојати најмање један документ о стицању.'
                    ELSE NULL
                END
        FROM SrcValidate
        WHERE
            DatumPrenosa IS NULL OR
            DatumPrenosa > CAST(GETDATE() AS DATE) OR
            DatumSticanja IS NULL OR
            DatumSticanja > CAST(GETDATE() AS DATE) OR
            DatumSticanja > DatumPrenosa OR
            ProdajnaCena IS NULL OR TRY_CONVERT(bigint, ProdajnaCena) IS NULL OR TRY_CONVERT(bigint, ProdajnaCena) <= 0 OR
            NabavnaCena IS NULL OR TRY_CONVERT(bigint, NabavnaCena) IS NULL OR TRY_CONVERT(bigint, NabavnaCena) <= 0 OR
            (COALESCE(IsDigital, 0) = 0 AND (Naziv IS NULL OR LTRIM(RTRIM(Naziv)) = '')) OR
            (COALESCE(IsDigital, 0) = 0 AND (BrDokOPrenosu IS NULL OR TRY_CONVERT(int, BrDokOPrenosu) IS NULL OR TRY_CONVERT(int, BrDokOPrenosu) <= 0)) OR
            (COALESCE(IsDigital, 0) = 0 AND (BrojPrenetihHOV IS NULL OR TRY_CONVERT(int, BrojPrenetihHOV) IS NULL OR TRY_CONVERT(int, BrojPrenetihHOV) <= 0)) OR
            (COALESCE(IsDigital, 0) = 0 AND (DokumentiJson IS NULL OR DokumentiJson = N'[]'));

        IF @ErrorMsg IS NOT NULL
            THROW 52032, @ErrorMsg, 1;

        -- Validate DokumentiOSticanju fields for each non-digital prenos
        ;WITH SrcDokValidate AS (
            SELECT
                p.RowNum AS PrenosRowNum,
                ROW_NUMBER() OVER (PARTITION BY p.RowNum ORDER BY (SELECT NULL)) AS DokRowNum,
                x.DatumSticanja,
                x.BrojDokOSticanju,
                x.BrojStecenihJedinica,
                x.NabavnaCena
            FROM (
                SELECT
                    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum,
                    IsDigital,
                    DokumentiJson
                FROM OPENJSON(@JsonDoc, N'$.Prenosi')
                WITH (
                    IsDigital bit N'$.IsDigital',
                    DokumentiJson nvarchar(max) N'$.DokumentiOSticanju' AS JSON
                )
                WHERE COALESCE(IsDigital, 0) = 0
            ) p
            CROSS APPLY OPENJSON(p.DokumentiJson)
            WITH (
                DatumSticanja date N'$.DatumSticanja',
                BrojDokOSticanju nvarchar(20) N'$.BrojDokOSticanju',
                BrojStecenihJedinica nvarchar(20) N'$.BrojStecenihJedinica',
                NabavnaCena nvarchar(30) N'$.NabavnaCena'
            ) x
        )
        SELECT TOP 1
            @ErrorMsg =
                N'Документ о стицању #' + CAST(DokRowNum AS nvarchar(10)) +
                N' (пренос #' + CAST(PrenosRowNum AS nvarchar(10)) + N'): ' +
                CASE
                    WHEN DatumSticanja IS NULL THEN N'Датум стицања је обавезно поље и мора бити валидан датум.'
                    WHEN DatumSticanja > CAST(GETDATE() AS DATE) THEN N'Датум стицања не може бити у будућности.'
                    WHEN BrojDokOSticanju IS NULL THEN N'Број документа о стицању је обавезно поље.'
                    WHEN TRY_CONVERT(int, BrojDokOSticanju) IS NULL THEN N'Број документа о стицању мора бити валидан број.'
                    WHEN TRY_CONVERT(int, BrojDokOSticanju) <= 0 THEN N'Број документа о стицању мора бити позитиван број.'
                    WHEN BrojStecenihJedinica IS NULL THEN N'Број стечених ХОВ је обавезно поље.'
                    WHEN TRY_CONVERT(int, BrojStecenihJedinica) IS NULL THEN N'Број стечених ХОВ мора бити валидан број.'
                    WHEN TRY_CONVERT(int, BrojStecenihJedinica) <= 0 THEN N'Број стечених ХОВ мора бити позитиван број.'
                    WHEN NabavnaCena IS NULL THEN N'Набавна цена је обавезно поље.'
                    WHEN TRY_CONVERT(bigint, NabavnaCena) IS NULL THEN N'Набавна цена мора бити валидан број.'
                    WHEN TRY_CONVERT(bigint, NabavnaCena) <= 0 THEN N'Набавна цена мора бити позитиван број.'
                    ELSE NULL
                END
        FROM SrcDokValidate
        WHERE
            DatumSticanja IS NULL OR
            DatumSticanja > CAST(GETDATE() AS DATE) OR
            BrojDokOSticanju IS NULL OR TRY_CONVERT(int, BrojDokOSticanju) IS NULL OR TRY_CONVERT(int, BrojDokOSticanju) <= 0 OR
            BrojStecenihJedinica IS NULL OR TRY_CONVERT(int, BrojStecenihJedinica) IS NULL OR TRY_CONVERT(int, BrojStecenihJedinica) <= 0 OR
            NabavnaCena IS NULL OR TRY_CONVERT(bigint, NabavnaCena) IS NULL OR TRY_CONVERT(bigint, NabavnaCena) <= 0;

        IF @ErrorMsg IS NOT NULL
            THROW 52034, @ErrorMsg, 1;

        -- Now do the MERGE with a fresh CTE
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
                BrojPrenetihHOV,
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
                BrojPrenetihHOV int '$.BrojPrenetihHOV',
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
            inserted.IDPrijave,
            inserted.PrenosPravaUdelaDigImov,
            s.Naziv,
            s.BrDokOPrenosu,
            s.BrojPrenetihHOV,
            s.DokumentiJson
        INTO @PrenosMap(ID, IDPrijave, IsDigital, Naziv, BrDokOPrenosu, BrojPrenetihHOV, DokumentiJson);

        IF @Sync = 1
        BEGIN
            DELETE sp
            FROM ppdg3p.StavkaPrenosa sp
            WHERE sp.IDPrijave = @IDPrijave
              AND NOT EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.ID = sp.ID);
        END

        -- Obrisi HoV za digital prenose (sa istom prijavom)
        DELETE h
        FROM ppdg3p.PrenosHartijaOdVrednosti h
        WHERE h.IDPrijave = @IDPrijave
          AND EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.ID = h.IDStavkePrenosa AND m.IsDigital = 1);

        -- MERGE HoV po KOMPOZITNOM kljucu (IDStavkePrenosa, IDPrijave) i INSERT sa IDPrijave
        MERGE ppdg3p.PrenosHartijaOdVrednosti AS t
        USING (
            SELECT ID, IDPrijave, Naziv, BrDokOPrenosu, BrojPrenetihHOV
            FROM @PrenosMap
            WHERE IsDigital = 0
        ) AS s
          ON t.IDStavkePrenosa = s.ID
         AND t.IDPrijave = s.IDPrijave
        WHEN MATCHED THEN
            UPDATE SET
                t.Naziv = CAST(s.Naziv AS nchar(30)),
                t.BrDokOPrenosu = s.BrDokOPrenosu,
                t.BrPrenetihHOV = COALESCE(s.BrojPrenetihHOV, 0)
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (IDStavkePrenosa, IDPrijave, Naziv, BrDokOPrenosu, BrPrenetihHOV)
            VALUES (s.ID, s.IDPrijave, CAST(s.Naziv AS nchar(30)), s.BrDokOPrenosu, COALESCE(s.BrojPrenetihHOV, 0));

        -- DokOSticanju: brisi samo za ovu prijavu i te prenose
        DELETE d
        FROM ppdg3p.DokumentOSticanju d
        WHERE d.IDPrijave = @IDPrijave
          AND EXISTS (SELECT 1 FROM @PrenosMap m WHERE m.IsDigital = 0 AND m.ID = d.IDPrenHartVred);

        -- INSERT DokOSticanju: OBAVEZNO upisi IDPrijave
        INSERT ppdg3p.DokumentOSticanju (DatumSticanja, ID, BrojStecenihJedinica, NabavnaCena, IDPrenHartVred, IDPrijave)
        SELECT
            x.DatumSticanja,
            COALESCE(x.ID, 0),
            x.BrojStecenihJedinica,
            COALESCE(x.NabavnaCena, 0),
            m.ID,
            m.IDPrijave
        FROM @PrenosMap m
        CROSS APPLY OPENJSON(m.DokumentiJson)
        WITH (
            DatumSticanja date '$.DatumSticanja',
            ID int '$.BrojDokOSticanju',
            BrojStecenihJedinica int '$.BrojStecenihJedinica',
            NabavnaCena bigint '$.NabavnaCena'
        ) x
        WHERE m.IsDigital = 0;

        /* ------------------------------------------------------------
           5) UMANJENJA + SUBTIPOVI  (FIXED)
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

        -- Validate Umanjenja fields (per-type); numeric fields parsed via nvarchar + TRY_CONVERT
        SET @ErrorMsg = NULL;
        ;WITH SrcUmanjValidate AS (
            SELECT
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum,
                DatumUlaganja,
                UPPER(TipRaw) AS Tip,
                IznosKapGub,
                BrojResenja,
                IznosUlozenUKapDP,
                IznosUlozenUKapIF,
                IznosUlozenihSredstava,
                PovrsinaZaOslobadjanje
            FROM OPENJSON(@JsonDoc, '$.Umanjenja')
            WITH (
                DatumUlaganja          date         '$.DatumUlaganja',
                TipRaw                 nvarchar(20) '$.Tip',
                IznosKapGub            nvarchar(30) '$.IznosKapGub',
                BrojResenja            nvarchar(20) '$.BrojResenja',
                IznosUlozenUKapDP      nvarchar(30) '$.IznosUlozenUKapDP',
                IznosUlozenUKapIF      nvarchar(30) '$.IznosUlozenUKapIF',
                IznosUlozenihSredstava nvarchar(30) '$.IznosUlozenihSredstava',
                PovrsinaZaOslobadjanje nvarchar(30) '$.PovrsinaZaOslobadjanje'
            )
        )
        SELECT TOP 1
            @ErrorMsg =
                N'Ставка умањења #' + CAST(RowNum AS nvarchar(10)) + N': ' +
                CASE
                    WHEN DatumUlaganja IS NULL THEN N'Датум улагања је обавезно поље и мора бити валидан датум.'
                    WHEN DatumUlaganja > CAST(GETDATE() AS DATE) THEN N'Датум улагања не може бити у будућности.'
                    -- KAP_GUB
                    WHEN Tip = 'KAP_GUB' AND BrojResenja IS NULL THEN N'Број решења је обавезно поље.'
                    WHEN Tip = 'KAP_GUB' AND TRY_CONVERT(int, BrojResenja) IS NULL THEN N'Број решења мора бити валидан број.'
                    WHEN Tip = 'KAP_GUB' AND TRY_CONVERT(int, BrojResenja) <= 0 THEN N'Број решења мора бити позитиван број.'
                    WHEN Tip = 'KAP_GUB' AND IznosKapGub IS NULL THEN N'Износ капиталног губитка је обавезно поље.'
                    WHEN Tip = 'KAP_GUB' AND TRY_CONVERT(bigint, IznosKapGub) IS NULL THEN N'Износ капиталног губитка мора бити валидан број.'
                    WHEN Tip = 'KAP_GUB' AND TRY_CONVERT(bigint, IznosKapGub) <= 0 THEN N'Износ капиталног губитка мора бити позитиван број.'
                    -- OSN_KAP
                    WHEN Tip = 'OSN_KAP' AND IznosUlozenUKapDP IS NULL THEN N'Износ у капитал привредног друштва је обавезно поље.'
                    WHEN Tip = 'OSN_KAP' AND TRY_CONVERT(bigint, IznosUlozenUKapDP) IS NULL THEN N'Износ у капитал привредног друштва мора бити валидан број.'
                    WHEN Tip = 'OSN_KAP' AND TRY_CONVERT(bigint, IznosUlozenUKapDP) <= 0 THEN N'Износ у капитал привредног друштва мора бити позитиван број.'
                    WHEN Tip = 'OSN_KAP' AND IznosUlozenUKapIF IS NULL THEN N'Износ у капитал инвестиционог фонда је обавезно поље.'
                    WHEN Tip = 'OSN_KAP' AND TRY_CONVERT(bigint, IznosUlozenUKapIF) IS NULL THEN N'Износ у капитал инвестиционог фонда мора бити валидан број.'
                    WHEN Tip = 'OSN_KAP' AND TRY_CONVERT(bigint, IznosUlozenUKapIF) <= 0 THEN N'Износ у капитал инвестиционог фонда мора бити позитиван број.'
                    -- RES_SP
                    WHEN Tip = 'RES_SP' AND IznosUlozenihSredstava IS NULL THEN N'Износ уложених средстава је обавезно поље.'
                    WHEN Tip = 'RES_SP' AND TRY_CONVERT(bigint, IznosUlozenihSredstava) IS NULL THEN N'Износ уложених средстава мора бити валидан број.'
                    WHEN Tip = 'RES_SP' AND TRY_CONVERT(bigint, IznosUlozenihSredstava) <= 0 THEN N'Износ уложених средстава мора бити позитиван број.'
                    WHEN Tip = 'RES_SP' AND PovrsinaZaOslobadjanje IS NULL THEN N'Површина за ослобађање је обавезно поље.'
                    WHEN Tip = 'RES_SP' AND TRY_CONVERT(real, PovrsinaZaOslobadjanje) IS NULL THEN N'Површина за ослобађање мора бити валидан број.'
                    WHEN Tip = 'RES_SP' AND TRY_CONVERT(real, PovrsinaZaOslobadjanje) <= 0 THEN N'Површина за ослобађање мора бити позитиван број.'
                    ELSE NULL
                END
        FROM SrcUmanjValidate
        WHERE
            DatumUlaganja IS NULL OR
            DatumUlaganja > CAST(GETDATE() AS DATE) OR
            (Tip = 'KAP_GUB' AND (BrojResenja IS NULL OR TRY_CONVERT(int, BrojResenja) IS NULL OR TRY_CONVERT(int, BrojResenja) <= 0)) OR
            (Tip = 'KAP_GUB' AND (IznosKapGub IS NULL OR TRY_CONVERT(bigint, IznosKapGub) IS NULL OR TRY_CONVERT(bigint, IznosKapGub) <= 0)) OR
            (Tip = 'OSN_KAP' AND (IznosUlozenUKapDP IS NULL OR TRY_CONVERT(bigint, IznosUlozenUKapDP) IS NULL OR TRY_CONVERT(bigint, IznosUlozenUKapDP) <= 0)) OR
            (Tip = 'OSN_KAP' AND (IznosUlozenUKapIF IS NULL OR TRY_CONVERT(bigint, IznosUlozenUKapIF) IS NULL OR TRY_CONVERT(bigint, IznosUlozenUKapIF) <= 0)) OR
            (Tip = 'RES_SP' AND (IznosUlozenihSredstava IS NULL OR TRY_CONVERT(bigint, IznosUlozenihSredstava) IS NULL OR TRY_CONVERT(bigint, IznosUlozenihSredstava) <= 0)) OR
            (Tip = 'RES_SP' AND (PovrsinaZaOslobadjanje IS NULL OR TRY_CONVERT(real, PovrsinaZaOslobadjanje) IS NULL OR TRY_CONVERT(real, PovrsinaZaOslobadjanje) <= 0));

        IF @ErrorMsg IS NOT NULL
            THROW 52041, @ErrorMsg, 1;

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

        -- Brisi subtipove samo za ovu prijavu gde postoji IDPrijave
        DELETE kg
        FROM ppdg3p.KapitalniGubitak kg
        WHERE kg.IDPrijave = @IDPrijave
          AND EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = kg.IDStavkeUmanjenja);

        DELETE ok
        FROM ppdg3p.UlaganjeUOsnKap ok
        WHERE EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = ok.IDStavkeUmanjenja);

        DELETE rs
        FROM ppdg3p.UlaganjneUResavanjeSP rs
        WHERE rs.IDPrijave = @IDPrijave
          AND EXISTS (SELECT 1 FROM @UmanjMap m WHERE m.ID = rs.IDStavkeUmanjenja);

        -- INSERT KapitalniGubitak: OBAVEZNO IDPrijave
        INSERT ppdg3p.KapitalniGubitak (IDStavkeUmanjenja, BrojResenja, IznosKapGub, IDPrijave)
        SELECT ID, BrojResenja, IznosKapGub, @IDPrijave
        FROM @UmanjMap
        WHERE Tip = 'KAP_GUB';

        -- INSERT UlaganjeUOsnKap: nema IDPrijave u tabeli
        INSERT ppdg3p.UlaganjeUOsnKap (IDStavkeUmanjenja, IznosUlozenUKapDP, IznosUlozenUKapIF)
        SELECT ID, IznosUlozenUKapDP, IznosUlozenUKapIF
        FROM @UmanjMap
        WHERE Tip = 'OSN_KAP';

        -- INSERT ResavanjeSP: OBAVEZNO IDPrijave
        INSERT ppdg3p.UlaganjneUResavanjeSP (IDStavkeUmanjenja, IDPrijave, IznosUlozenihSredstava, PovrsinaZaOslobadjanje, Domacinstvo)
        SELECT ID, @IDPrijave, IznosUlozenihSredstava, PovrsinaZaOslobadjanje, Domacinstvo
        FROM @UmanjMap
        WHERE Tip = 'RES_SP';

        /* ------------------------------------------------------------
           6) REKALKULACIJA SUMA
        ------------------------------------------------------------ */
        EXEC ppdg3p.PPDG3P_OsnovicaCalc @IDPrijave = @IDPrijave;

        COMMIT;

        -- Return the ID (useful for CREATE mode)
        SELECT @IDPrijave AS IDPrijave;
    END TRY
    BEGIN CATCH
        EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_dokazi_jmbg_update', @value = NULL;
        EXEC sys.sp_set_session_context @key = N'ppdg3p_allow_ppdg3p_update', @value = NULL;
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END
GO
/****** Object:  Trigger [ppdg3p].[trg_Dokazi_SetJMBG]    Script Date: 24/03/2026 ******/
GO
CREATE TRIGGER [ppdg3p].[trg_Dokazi_SetJMBG]
ON [ppdg3p].[Dokazi]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Allow the stored procedure to set JMBG directly via MERGE UPDATE
    IF CONVERT(bit, SESSION_CONTEXT(N'ppdg3p_allow_dokazi_jmbg_update')) = 1
        RETURN;

    UPDATE d
    SET d.[JMBG/ESB/PIB_po] = p.IDPoreskogObveznika
    FROM ppdg3p.Dokazi d
    INNER JOIN inserted i ON d.BrojDokaza = i.BrojDokaza
    INNER JOIN ppdg3p.PPDG3P p ON p.ID = i.IDPrijave;
END
GO

USE [master]
GO
ALTER DATABASE [PPdb] SET  READ_WRITE
GO
