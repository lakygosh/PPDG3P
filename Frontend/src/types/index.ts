// API Response Types

export interface SqlError {
  errorNumber: number;
  message: string;
  procedure: string | null;
  lineNumber: number;
  state: number;
  class: number;
  server: string;
}

export interface SqlErrorResponse {
  type: 'SqlException';
  title: string;
  status: number;
  errors: SqlError[];
}

export interface ArgumentErrorResponse {
  type: 'ArgumentException';
  title: string;
  status: number;
  detail: string;
}

export type ApiError = SqlErrorResponse | ArgumentErrorResponse;

// Metadata Types

export interface ColumnMetadata {
  columnName: string;
  dataType: string;
  maxLength: number | null;
  numericPrecision: number | null;
  numericScale: number | null;
  isNullable: boolean;
  isIdentity: boolean;
  isPrimaryKey: boolean;
  defaultValue: string | null;
  ordinalPosition: number;
}

export interface ForeignKeyMetadata {
  constraintName: string;
  columnName: string;
  referencedSchema: string;
  referencedTable: string;
  referencedColumn: string;
  deleteRule: string;
  updateRule: string;
}

export interface TableMetadata {
  schemaName: string;
  tableName: string;
  tableType: string;
  columns: ColumnMetadata[];
  foreignKeys: ForeignKeyMetadata[];
  primaryKeyColumns: string[];
}

// CRUD Types

export interface QueryResult {
  rows: Record<string, unknown>[];
  totalCount: number;
  affectedRows: number;
}

export interface InsertResult {
  affectedRows: number;
  insertedRow: Record<string, unknown> | null;
}

export interface AffectedRowsResult {
  affectedRows: number;
}

// KDT Types

export interface KdtChildTable {
  tableName: string;
  foreignKeyColumn: string;
  typeDiscriminator: string;
}

export interface KdtHierarchy {
  name: string;
  parentTable: string;
  parentKeyColumn: string;
  childTables: KdtChildTable[];
}

export interface KdtRecord {
  parent: Record<string, unknown>;
  type: string;
  children: Record<string, Record<string, unknown> | null>;
}

// Serbian table name translations
export const tableTranslations: Record<string, string> = {
  'PPDG3P': 'PPDG-3P Prijave',
  'PPDG3P_Details': 'Detalji PPDG-3P prijave',
  'PoreskiObveznik': 'Poreski obveznici',
  'Lice': 'Lica',
  'Fizicko': 'Fizička lica',
  'Pravno': 'Pravna lica',
  'Broker': 'Brokeri',
  'OrgPU': 'Organizacione jedinice PU',
  'Punomocnik': 'Punomoćnici',
  'Dokazi': 'Dokazi',
  'StavkaPrenosa': 'Stavke prenosa',
  'PrenosHartijaOdVrednosti': 'Prenos hartija od vrednosti',
  'DokumentOSticanju': 'Dokumenti o sticanju',
  'StavkaUmanjenja': 'Stavke umanjenja',
  'KapitalniGubitak': 'Kapitalni gubici',
  'UlaganjeUOsnKap': 'Ulaganja u osnovni kapital',
  'UlaganjneUResavanjeSP': 'Ulaganja u rešavanje stambenog pitanja',
  'vw_PPDG3P_Document': 'Pregled PPDG-3P dokumenata'
};

// Serbian column name translations
export const columnTranslations: Record<string, string> = {
  'ID': 'ID',
  'JMBG/ESB/PIB': 'JMBG/ESB/PIB',
  'JMBG/ESB/PIB_lice': 'JMBG/ESB/PIB',
  'JMGB/ESB/PIB_lice': 'JMBG/ESB/PIB',
  'Ime': 'Ime',
  'Prezime': 'Prezime',
  'Naziv': 'Naziv',
  'Email': 'E-pošta',
  'Telefon': 'Telefon',
  'Adresa': 'Adresa',
  'Drzava': 'Država',
  'DatumOstvarivanjaPrihoda': 'Datum ostvarivanja prihoda',
  'DatumDospelostiZaPodnosenjePrijave': 'Datum dospelosti za podnošenje',
  'DatumNacinPodnosenjaPrijave': 'Datum podnošenja prijave',
  'Izmena': 'Izmena',
  'IDOrganaPoreske': 'Organ poreske uprave',
  'IDPoreskogObveznika': 'Poreski obveznik',
  'IDVrstePrijave': 'Vrsta prijave',
  'IDOsnovaZaPrijavu': 'Osnov za prijavu',
  'UkProdajnaCena': 'Ukupna prodajna cena',
  'UkNabavnaCena': 'Ukupna nabavna cena',
  'UkUmanjenja': 'Ukupna umanjenja',
  'KapitalnaOsnovica': 'Kapitalna osnovica',
  'DatumPrenosa': 'Datum prenosa',
  'ProdajnaCena': 'Prodajna cena',
  'DatumSticanja': 'Datum sticanja',
  'NabavnaCena': 'Nabavna cena',
  'PrenosPravaUdelaDigImov': 'Digitalna imovina',
  'IDPrijave': 'ID prijave',
  'BrojDokaza': 'Broj dokaza',
  'LokacijaFajla': 'Lokacija fajla',
  'DatumUlaganja': 'Datum ulaganja',
  'IznosKapGub': 'Iznos kapitalnog gubitka',
  'BrojResenja': 'Broj rešenja',
  'IznosUlozenUKapDP': 'Iznos uložen u kapital DP',
  'IznosUlozenUKapIF': 'Iznos uložen u kapital IF',
  'IznosUlozenihSredstava': 'Iznos uloženih sredstava',
  'PovrsinaZaOslobadjanje': 'Površina za oslobađanje',
  'Domacinstvo': 'Domaćinstvo',
  'BrojStecenihJedinica': 'Broj stečenih jedinica',
  'BrDokOPrenosu': 'Broj dokumenata o prenosu',
  'PrebivalisteOstvPrih': 'Prebivalište ostvarivanja prihoda',
  'Email_lice': 'E-pošta lica',
  'IDStavkePrenosa': 'ID stavke prenosa',
  'IDStavkeUmanjenja': 'ID stavke umanjenja',
  'IDPrenHartVred': 'ID prenosa hartija od vrednosti',
  'BrojPrenetihHOV': 'Broj prenetih HOV',
  'BrojDokOSticanju': 'Broj dokumenta o sticanju'
};

export function getTableDisplayName(tableName: string): string {
  return tableTranslations[tableName] || tableName;
}

export function getColumnDisplayName(columnName: string): string {
  return columnTranslations[columnName] || columnName;
}
