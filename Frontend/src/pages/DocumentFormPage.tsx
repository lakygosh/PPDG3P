import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { documentApi, tableApi, handleApiError } from '../api/client';
import { ErrorPanel } from '../components';
import type { ApiError } from '../types';
import './DocumentFormPage.css';

interface PoreskiObveznik {
  id: number;
  ime: string;
  prezime: string;
  prebivalisteOstvPrih: string;
}

interface OrganPU {
  id: number;
  naziv: string;
}

interface DokumentOSticanju {
  datumSticanja: string;
  brojDokOSticanju: string;
  brojStecenihJedinica: string;
  nabavnaCena: string;
}

interface StavkaPrenosa {
  redniBroj: number;
  datumPrenosa: string;
  prodajnaCena: string;
  datumSticanja: string;
  nabavnaCena: string;
  isDigital: boolean;
  // Za hartije od vrednosti
  naziv?: string;
  brDokOPrenosu?: string;
  brojPrenetihHOV?: string;
  dokumentiOSticanju?: DokumentOSticanju[];
}

interface StavkaUmanjenja {
  redniBroj: number;
  tip: 'RES_SP' | 'OSN_KAP' | 'KAP_GUB';
  datumUlaganja: string;
  // RES_SP
  iznosUlozenihSredstava?: string;
  povrsinaZaOslobadjanje?: string;
  domacinstvo?: boolean;
  // OSN_KAP
  iznosUlozenUKapDP?: string;
  iznosUlozenUKapIF?: string;
  // KAP_GUB
  iznosKapGub?: string;
  brojResenja?: string;
}

interface Dokaz {
  redniBroj: number;
  naziv: string;
  lokacijaFajla?: string;
}

interface FormData {
  // Deo 1
  vrstaPrijave: number;
  osnovZaPrijavu: number;
  datumOstvarivanjaPrihoda: string;
  datumDospelosti: string;
  datumPodnosenja: string;
  izmena: boolean;
  organPU: number;
  // Deo 2
  tipObveznika: string;
  jmbgObveznika: string;
  imeObveznika: string;
  prezimeObveznika: string;
  prebivaliste: string;
  adresaObveznika: string;
  telefon: string;
  email: string;
  jmbgPodnosioca: string;
  zemljaRezidentstva: string;
  jmbgPunomocnika: string;
  // Deo 3 & 4
  stavkePrenosa: StavkaPrenosa[];
  // Deo 5, 6, 7, 8
  stavkeUmanjenja: StavkaUmanjenja[];
  // Deo 9
  dokazi: Dokaz[];
}

const emptyStavkaPrenosa = (): StavkaPrenosa => ({
  redniBroj: 0,
  datumPrenosa: '',
  prodajnaCena: '',
  datumSticanja: '',
  nabavnaCena: '',
  isDigital: true,
});

const getTodayDate = () => new Date().toISOString().split('T')[0];

const emptyStavkaHartije = (): StavkaPrenosa => ({
  redniBroj: 0,
  datumPrenosa: getTodayDate(),
  prodajnaCena: '100000',
  datumSticanja: getTodayDate(),
  nabavnaCena: '80000',
  isDigital: false,
  naziv: 'NIS а.д. Нови Сад',
  brDokOPrenosu: '1',
  brojPrenetihHOV: '100',
  dokumentiOSticanju: [{
    datumSticanja: getTodayDate(),
    brojDokOSticanju: '1',
    brojStecenihJedinica: '100',
    nabavnaCena: '80000',
  }],
});

const emptyDokumentOSticanju = (): DokumentOSticanju => ({
  datumSticanja: getTodayDate(),
  brojDokOSticanju: '1',
  brojStecenihJedinica: '50',
  nabavnaCena: '40000',
});

const emptyUmanjenjeRESP = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'RES_SP',
  datumUlaganja: '',
  iznosUlozenihSredstava: '',
  povrsinaZaOslobadjanje: '',
  domacinstvo: false,
});

const emptyUmanjenjeOSNKAP = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'OSN_KAP',
  datumUlaganja: '',
  iznosUlozenUKapDP: '',
  iznosUlozenUKapIF: '',
});

const emptyUmanjenjeKAPGUB = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'KAP_GUB',
  datumUlaganja: '',
  iznosKapGub: '',
  brojResenja: '',
});

const emptyDokaz = (): Dokaz => ({
  redniBroj: 0,
  naziv: '',
  lokacijaFajla: '',
});

export function DocumentFormPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEdit = !!id;

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<ApiError | null>(null);
  const [submitting, setSubmitting] = useState(false);

  // Lookup data
  const [, setOrganiPU] = useState<OrganPU[]>([]);
  const [, setPoreskiObveznici] = useState<PoreskiObveznik[]>([]);

  // Form data
  const [formData, setFormData] = useState<FormData>({
    vrstaPrijave: 1,
    osnovZaPrijavu: 1,
    datumOstvarivanjaPrihoda: getTodayDate(),
    datumDospelosti: getTodayDate(),
    datumPodnosenja: getTodayDate(),
    izmena: false,
    organPU: 1,
    tipObveznika: 'fizicko',
    jmbgObveznika: '1234567890123',
    imeObveznika: 'Тест',
    prezimeObveznika: 'Тестовић',
    prebivaliste: 'Београд',
    adresaObveznika: 'Тест улица 123',
    telefon: '0601234567',
    email: 'test@example.com',
    jmbgPodnosioca: '',
    zemljaRezidentstva: 'Србија',
    jmbgPunomocnika: '',
    stavkePrenosa: [],
    stavkeUmanjenja: [],
    dokazi: [],
  });

  // Load lookup data
  useEffect(() => {
    const loadLookups = async () => {
      try {
        const [orgResult, obvResult] = await Promise.all([
          tableApi.getAll('OrgPU'),
          tableApi.getAll('PoreskiObveznik'),
        ]);

        setOrganiPU(orgResult.rows.map((r: Record<string, unknown>) => ({
          id: r.ID as number,
          naziv: (r.Naziv as string).trim(),
        })));

        setPoreskiObveznici(obvResult.rows.map((r: Record<string, unknown>) => ({
          id: r['JMBG/ESB/PIB_lice'] as number,
          ime: (r.Ime as string).trim(),
          prezime: (r.Prezime as string).trim(),
          prebivalisteOstvPrih: (r.PrebivalisteOstvPrih as string).trim(),
        })));
      } catch (err) {
        setError(handleApiError(err));
      }
    };

    loadLookups();
  }, []);

  // Load existing document for edit
  useEffect(() => {
    if (!isEdit || !id) return;

    const loadDocument = async () => {
      setLoading(true);
      try {
        const result = await documentApi.getById(parseInt(id));
        if (result.document) {
          // Map document to form data
          const doc = result.document as Record<string, unknown>;
          setFormData(prev => ({
            ...prev,
            vrstaPrijave: (doc.vrstaPrijave as Record<string, unknown>)?.id as number || 0,
            osnovZaPrijavu: (doc.osnovZaPrijavu as Record<string, unknown>)?.id as number || 0,
            datumOstvarivanjaPrihoda: formatDateForInput(doc.datumOstvarivanjaPrihoda as string),
            datumDospelosti: formatDateForInput(doc.datumDospelostiZaPodnosenjePrijave as string),
            datumPodnosenja: formatDateForInput(doc.datumNacinPodnosenjaPrijave as string),
            izmena: doc.izmena as boolean,
            organPU: (doc.organPU as Record<string, unknown>)?.id as number || 0,
            jmbgObveznika: String((doc.poreskiObveznik as Record<string, unknown>)?.id || ''),
            imeObveznika: ((doc.poreskiObveznik as Record<string, unknown>)?.ime as string) || '',
            prezimeObveznika: ((doc.poreskiObveznik as Record<string, unknown>)?.prezime as string) || '',
            email: ((doc.poreskiObveznik as Record<string, unknown>)?.email as string) || '',
            prebivaliste: ((doc.poreskiObveznik as Record<string, unknown>)?.prebivalisteOstvPrih as string) || '',
            adresaObveznika: ((doc.poreskiObveznik as Record<string, unknown>)?.adresa as string) || '',
            telefon: ((doc.poreskiObveznik as Record<string, unknown>)?.telefon as string) || '',
            zemljaRezidentstva: ((doc.poreskiObveznik as Record<string, unknown>)?.drzava as string) || '',
            // Map arrays
            stavkePrenosa: mapPrenosi(doc.Prenosi as unknown[]),
            stavkeUmanjenja: mapUmanjenja(doc.Umanjenja as unknown[]),
            dokazi: mapDokazi(doc.Dokazi as unknown[]),
          }));
        }
      } catch (err) {
        setError(handleApiError(err));
      } finally {
        setLoading(false);
      }
    };

    loadDocument();
  }, [isEdit, id]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSubmitting(true);
    setError(null);

    try {
      const jsonDoc = buildJsonDocument();
      console.log('Sending to backend:', JSON.stringify(jsonDoc, null, 2));
      console.log('stavkePrenosa before build:', formData.stavkePrenosa);

      if (isEdit && id) {
        await documentApi.update(parseInt(id), jsonDoc);
      } else {
        await documentApi.create(jsonDoc);
      }
      navigate('/documents');
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const buildJsonDocument = () => {
    return {
      datumOstvarivanjaPrihoda: formData.datumOstvarivanjaPrihoda || null,
      datumDospelostiZaPodnosenjePrijave: formData.datumDospelosti || null,
      datumNacinPodnosenjaPrijave: formData.datumPodnosenja || null,
      izmena: formData.izmena,
      organPU: formData.organPU ? { id: formData.organPU } : null,
      vrstaPrijave: formData.vrstaPrijave ? { id: formData.vrstaPrijave } : null,
      osnovZaPrijavu: formData.osnovZaPrijavu ? { id: formData.osnovZaPrijavu } : null,
      poreskiObveznik: {
        id: formData.jmbgObveznika || null,
        ime: formData.imeObveznika || null,
        prezime: formData.prezimeObveznika || null,
        prebivalisteOstvPrih: formData.prebivaliste || null,
        email: formData.email || null,
        telefon: formData.telefon || null,
        adresa: formData.adresaObveznika || null,
        drzava: formData.zemljaRezidentstva || null,
      },
      Prenosi: formData.stavkePrenosa.map((s, idx) => ({
        ID: s.redniBroj || undefined,
        DatumPrenosa: s.datumPrenosa || null,
        ProdajnaCena: s.prodajnaCena || null,
        DatumSticanja: s.datumSticanja || null,
        NabavnaCena: s.nabavnaCena || null,
        IsDigital: s.isDigital,
        Naziv: s.naziv,
        BrDokOPrenosu: s.brDokOPrenosu,
        BrojPrenetihHOV: s.brojPrenetihHOV,
        DokumentiOSticanju: s.dokumentiOSticanju?.map(d => ({
          DatumSticanja: d.datumSticanja || null,
          BrojDokOSticanju: d.brojDokOSticanju,
          BrojStecenihJedinica: d.brojStecenihJedinica,
          NabavnaCena: d.nabavnaCena,
        })),
      })),
      Umanjenja: formData.stavkeUmanjenja.map((s) => ({
        ID: s.redniBroj || undefined,
        DatumUlaganja: s.datumUlaganja || null,
        Tip: s.tip,
        IznosKapGub: s.iznosKapGub,
        BrojResenja: s.brojResenja,
        IznosUlozenUKapDP: s.iznosUlozenUKapDP,
        IznosUlozenUKapIF: s.iznosUlozenUKapIF,
        IznosUlozenihSredstava: s.iznosUlozenihSredstava,
        PovrsinaZaOslobadjanje: s.povrsinaZaOslobadjanje,
        Domacinstvo: s.domacinstvo,
      })),
      Dokazi: formData.dokazi.map((d) => ({
        BrojDokaza: d.redniBroj || undefined,
        Naziv: d.naziv,
        LokacijaFajla: d.lokacijaFajla,
      })),
    };
  };

  // Array management functions
  const addStavkaPrenosa = (isDigital: boolean) => {
    const newItem = isDigital ? emptyStavkaPrenosa() : emptyStavkaHartije();
    newItem.redniBroj = formData.stavkePrenosa.length + 1;
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: [...prev.stavkePrenosa, newItem],
    }));
  };

  const removeStavkaPrenosa = (index: number) => {
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: prev.stavkePrenosa.filter((_, i) => i !== index),
    }));
  };

  const updateStavkaPrenosa = (index: number, field: keyof StavkaPrenosa, value: unknown) => {
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: prev.stavkePrenosa.map((item, i) =>
        i === index ? { ...item, [field]: value } : item
      ),
    }));
  };

  const addDokumentOSticanju = (prenosIndex: number) => {
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: prev.stavkePrenosa.map((item, i) =>
        i === prenosIndex
          ? { ...item, dokumentiOSticanju: [...(item.dokumentiOSticanju || []), emptyDokumentOSticanju()] }
          : item
      ),
    }));
  };

  const removeDokumentOSticanju = (prenosIndex: number, docIndex: number) => {
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: prev.stavkePrenosa.map((item, i) =>
        i === prenosIndex
          ? { ...item, dokumentiOSticanju: (item.dokumentiOSticanju || []).filter((_, j) => j !== docIndex) }
          : item
      ),
    }));
  };

  const updateDokumentOSticanju = (prenosIndex: number, docIndex: number, field: keyof DokumentOSticanju, value: unknown) => {
    setFormData(prev => ({
      ...prev,
      stavkePrenosa: prev.stavkePrenosa.map((item, i) =>
        i === prenosIndex
          ? {
              ...item,
              dokumentiOSticanju: (item.dokumentiOSticanju || []).map((doc, j) =>
                j === docIndex ? { ...doc, [field]: value } : doc
              ),
            }
          : item
      ),
    }));
  };

  const addStavkaUmanjenja = (tip: 'RES_SP' | 'OSN_KAP' | 'KAP_GUB') => {
    let newItem: StavkaUmanjenja;
    switch (tip) {
      case 'RES_SP': newItem = emptyUmanjenjeRESP(); break;
      case 'OSN_KAP': newItem = emptyUmanjenjeOSNKAP(); break;
      case 'KAP_GUB': newItem = emptyUmanjenjeKAPGUB(); break;
    }
    newItem.redniBroj = formData.stavkeUmanjenja.filter(s => s.tip === tip).length + 1;
    setFormData(prev => ({
      ...prev,
      stavkeUmanjenja: [...prev.stavkeUmanjenja, newItem],
    }));
  };

  const removeStavkaUmanjenja = (index: number) => {
    setFormData(prev => ({
      ...prev,
      stavkeUmanjenja: prev.stavkeUmanjenja.filter((_, i) => i !== index),
    }));
  };

  const updateStavkaUmanjenja = (index: number, field: keyof StavkaUmanjenja, value: unknown) => {
    setFormData(prev => ({
      ...prev,
      stavkeUmanjenja: prev.stavkeUmanjenja.map((item, i) =>
        i === index ? { ...item, [field]: value } : item
      ),
    }));
  };

  const addDokaz = () => {
    const newItem = emptyDokaz();
    newItem.redniBroj = formData.dokazi.length + 1;
    setFormData(prev => ({
      ...prev,
      dokazi: [...prev.dokazi, newItem],
    }));
  };

  const removeDokaz = (index: number) => {
    setFormData(prev => ({
      ...prev,
      dokazi: prev.dokazi.filter((_, i) => i !== index),
    }));
  };

  const updateDokaz = (index: number, field: keyof Dokaz, value: unknown) => {
    setFormData(prev => ({
      ...prev,
      dokazi: prev.dokazi.map((item, i) =>
        i === index ? { ...item, [field]: value } : item
      ),
    }));
  };

  if (loading) {
    return <div className="loading">Učitavanje...</div>;
  }

  return (
    <div className="document-form-page">
      <div className="page-header">
        <h1 className="page-title">
          {isEdit ? 'Izmena prijave PPDG-3P' : 'Nova prijava PPDG-3P'}
        </h1>
        <p className="page-subtitle">Poreska prijava za utvrđivanje poreza na kapitalne dobitke</p>
      </div>

      <form onSubmit={handleSubmit} className="document-form">
        {/* DEO 1 */}
        <section className="form-section">
          <h2 className="section-title">Део 1. Подаци о пријави</h2>
          <div className="form-row">
            <div className="form-group">
              <label>1.1 Врста пријаве *</label>
              <input
                type="text"
                value={formData.vrstaPrijave}
                onChange={(e) => setFormData(prev => ({ ...prev, vrstaPrijave: parseInt(e.target.value) || 0 }))}
              />
            </div>
            <div className="form-group">
              <label>1.1а Основ за пријаву *</label>
              <input
                type="text"
                value={formData.osnovZaPrijavu}
                onChange={(e) => setFormData(prev => ({ ...prev, osnovZaPrijavu: parseInt(e.target.value) || 0 }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>1.2 Датум остваривања прихода *</label>
              <input
                type="text"
                value={formData.datumOstvarivanjaPrihoda}
                onChange={(e) => setFormData(prev => ({ ...prev, datumOstvarivanjaPrihoda: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>1.3 Датум доспелости за подношење *</label>
              <input
                type="text"
                value={formData.datumDospelosti}
                onChange={(e) => setFormData(prev => ({ ...prev, datumDospelosti: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>1.4 Датум подношења пријаве *</label>
              <input
                type="text"
                value={formData.datumPodnosenja}
                onChange={(e) => setFormData(prev => ({ ...prev, datumPodnosenja: e.target.value }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>1.5 Измена/Сторнирање</label>
              <input
                type="text"
                value={String(formData.izmena)}
                onChange={(e) => setFormData(prev => ({ ...prev, izmena: e.target.value === 'true' }))}
              />
            </div>
            <div className="form-group">
              <label>Орган пореске управе *</label>
              <input
                type="text"
                value={formData.organPU}
                onChange={(e) => setFormData(prev => ({ ...prev, organPU: parseInt(e.target.value) || 0 }))}
              />
            </div>
          </div>
        </section>

        {/* DEO 2 */}
        <section className="form-section">
          <h2 className="section-title">Део 2. Подаци о пореском обвезнику</h2>
          <div className="form-row">
            <div className="form-group">
              <label>2.1 Тип пореског обвезника</label>
              <input
                type="text"
                value={formData.tipObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, tipObveznika: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>2.2 ЈМБГ/ЕСБ/ПИБ *</label>
              <input
                type="text"
                value={formData.jmbgObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, jmbgObveznika: e.target.value }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>2.3 Име *</label>
              <input
                type="text"
                value={formData.imeObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, imeObveznika: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>2.3 Презиме *</label>
              <input
                type="text"
                value={formData.prezimeObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, prezimeObveznika: e.target.value }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>2.4 Пребивалиште/седиште</label>
              <input
                type="text"
                value={formData.prebivaliste}
                onChange={(e) => setFormData(prev => ({ ...prev, prebivaliste: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>2.5 Адреса</label>
              <input
                type="text"
                value={formData.adresaObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, adresaObveznika: e.target.value }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>2.6 Телефон</label>
              <input
                type="text"
                value={formData.telefon}
                onChange={(e) => setFormData(prev => ({ ...prev, telefon: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>2.7 Електронска адреса</label>
              <input
                type="text"
                value={formData.email}
                onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>2.9 Земља резидентства</label>
              <input
                type="text"
                value={formData.zemljaRezidentstva}
                onChange={(e) => setFormData(prev => ({ ...prev, zemljaRezidentstva: e.target.value }))}
              />
            </div>
            <div className="form-group">
              <label>2.10 ЈМБГ/ПИБ пуномоћника</label>
              <input
                type="text"
                value={formData.jmbgPunomocnika}
                onChange={(e) => setFormData(prev => ({ ...prev, jmbgPunomocnika: e.target.value }))}
              />
            </div>
          </div>
        </section>

        {/* DEO 3 */}
        <section className="form-section">
          <h2 className="section-title">Део 3. Подаци код преноса права/удела/дигиталне имовине</h2>
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Датум преноса</th>
                  <th>Продајна цена</th>
                  <th>Датум стицања</th>
                  <th>Набавна цена</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.stavkePrenosa.filter(s => s.isDigital).map((stavka, index) => {
                  const realIndex = formData.stavkePrenosa.findIndex(s => s === stavka);
                  return (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        <input
                          type="text"
                          value={stavka.datumPrenosa}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumPrenosa', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.prodajnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'prodajnaCena', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.datumSticanja}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumSticanja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.nabavnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'nabavnaCena', e.target.value)}
                        />
                      </td>
                      <td>
                        <button type="button" className="btn-remove" onClick={() => removeStavkaPrenosa(realIndex)}>✕</button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            <button type="button" className="btn-add" onClick={() => addStavkaPrenosa(true)}>
              + Додај ставку
            </button>
          </div>
        </section>

        {/* DEO 4 */}
        <section className="form-section">
          <h2 className="section-title">Део 4. Подаци код преноса хартија од вредности</h2>
          <div className="items-table hov-table">
            {formData.stavkePrenosa.filter(s => !s.isDigital).map((stavka, index) => {
              const realIndex = formData.stavkePrenosa.findIndex(s => s === stavka);
              return (
                <div key={index} className="hov-item">
                  <div className="hov-header">
                    <span className="hov-number">4.{index + 1}</span>
                    <button type="button" className="btn-remove" onClick={() => removeStavkaPrenosa(realIndex)}>✕</button>
                  </div>
                  <div className="hov-main-fields">
                    <div className="form-row">
                      <div className="form-group">
                        <label>4.2 Назив емитента</label>
                        <input
                          type="text"
                          value={stavka.naziv || ''}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'naziv', e.target.value)}
                        />
                      </div>
                      <div className="form-group">
                        <label>4.3 Датум преноса</label>
                        <input
                          type="text"
                          value={stavka.datumPrenosa}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumPrenosa', e.target.value)}
                        />
                      </div>
                      <div className="form-group">
                        <label>4.4 Бр. док. о преносу</label>
                        <input
                          type="text"
                          value={stavka.brDokOPrenosu || ''}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'brDokOPrenosu', e.target.value)}
                        />
                      </div>
                    </div>
                    <div className="form-row">
                      <div className="form-group">
                        <label>4.5 Број пренетих ХоВ</label>
                        <input
                          type="text"
                          value={stavka.brojPrenetihHOV || ''}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'brojPrenetihHOV', e.target.value)}
                        />
                      </div>
                      <div className="form-group">
                        <label>4.6 Продајна цена</label>
                        <input
                          type="text"
                          value={stavka.prodajnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'prodajnaCena', e.target.value)}
                        />
                      </div>
                    </div>
                  </div>
                  <div className="hov-documents">
                    <h4>Документи о стицању</h4>
                    <table className="nested-table">
                      <thead>
                        <tr>
                          <th>4.7 Датум стицања</th>
                          <th>4.8 Бр. док. о стицању</th>
                          <th>4.9 Број стечених ХоВ</th>
                          <th>4.10 Набавна цена</th>
                          <th></th>
                        </tr>
                      </thead>
                      <tbody>
                        {(stavka.dokumentiOSticanju || []).map((doc, docIndex) => (
                          <tr key={docIndex}>
                            <td>
                              <input
                                type="text"
                                value={doc.datumSticanja}
                                onChange={(e) => updateDokumentOSticanju(realIndex, docIndex, 'datumSticanja', e.target.value)}
                              />
                            </td>
                            <td>
                              <input
                                type="text"
                                value={doc.brojDokOSticanju}
                                onChange={(e) => updateDokumentOSticanju(realIndex, docIndex, 'brojDokOSticanju', e.target.value)}
                              />
                            </td>
                            <td>
                              <input
                                type="text"
                                value={doc.brojStecenihJedinica}
                                onChange={(e) => updateDokumentOSticanju(realIndex, docIndex, 'brojStecenihJedinica', e.target.value)}
                              />
                            </td>
                            <td>
                              <input
                                type="text"
                                value={doc.nabavnaCena}
                                onChange={(e) => updateDokumentOSticanju(realIndex, docIndex, 'nabavnaCena', e.target.value)}
                              />
                            </td>
                            <td>
                              <button type="button" className="btn-remove-small" onClick={() => removeDokumentOSticanju(realIndex, docIndex)}>✕</button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                    <button type="button" className="btn-add-small" onClick={() => addDokumentOSticanju(realIndex)}>
                      + Додај документ о стицању
                    </button>
                  </div>
                </div>
              );
            })}
            <button type="button" className="btn-add" onClick={() => addStavkaPrenosa(false)}>
              + Додај хартију од вредности
            </button>
          </div>
        </section>

        {/* DEO 5/6 - Rešavanje stambenog pitanja */}
        <section className="form-section">
          <h2 className="section-title">Део 5/6. Улагања у решавање стамбеног питања</h2>
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Датум улагања</th>
                  <th>Површина за ослобађање</th>
                  <th>Износ уложених средстава</th>
                  <th>Домаћинство</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.stavkeUmanjenja.filter(s => s.tip === 'RES_SP').map((stavka, index) => {
                  const realIndex = formData.stavkeUmanjenja.findIndex(s => s === stavka);
                  return (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        <input
                          type="text"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.povrsinaZaOslobadjanje || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'povrsinaZaOslobadjanje', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.iznosUlozenihSredstava || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenihSredstava', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={String(stavka.domacinstvo)}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'domacinstvo', e.target.value === 'true')}
                        />
                      </td>
                      <td>
                        <button type="button" className="btn-remove" onClick={() => removeStavkaUmanjenja(realIndex)}>✕</button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            <button type="button" className="btn-add" onClick={() => addStavkaUmanjenja('RES_SP')}>
              + Додај ставку
            </button>
          </div>
        </section>

        {/* DEO 7 - Ulaganja u osnovni kapital */}
        <section className="form-section">
          <h2 className="section-title">Део 7. Улагања у основни капитал</h2>
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Датум улагања</th>
                  <th>Износ у капитал привр. друштва</th>
                  <th>Износ у капитал инвест. фонда</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.stavkeUmanjenja.filter(s => s.tip === 'OSN_KAP').map((stavka, index) => {
                  const realIndex = formData.stavkeUmanjenja.findIndex(s => s === stavka);
                  return (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        <input
                          type="text"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.iznosUlozenUKapDP || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenUKapDP', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.iznosUlozenUKapIF || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenUKapIF', e.target.value)}
                        />
                      </td>
                      <td>
                        <button type="button" className="btn-remove" onClick={() => removeStavkaUmanjenja(realIndex)}>✕</button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            <button type="button" className="btn-add" onClick={() => addStavkaUmanjenja('OSN_KAP')}>
              + Додај ставку
            </button>
          </div>
        </section>

        {/* DEO 8 - Kapitalni gubici */}
        <section className="form-section">
          <h2 className="section-title">Део 8. Капитални губици</h2>
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Датум доношења решења</th>
                  <th>Број решења</th>
                  <th>Износ капиталног губитка</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.stavkeUmanjenja.filter(s => s.tip === 'KAP_GUB').map((stavka, index) => {
                  const realIndex = formData.stavkeUmanjenja.findIndex(s => s === stavka);
                  return (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        <input
                          type="text"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.brojResenja || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'brojResenja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="text"
                          value={stavka.iznosKapGub || ''}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosKapGub', e.target.value)}
                        />
                      </td>
                      <td>
                        <button type="button" className="btn-remove" onClick={() => removeStavkaUmanjenja(realIndex)}>✕</button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
            <button type="button" className="btn-add" onClick={() => addStavkaUmanjenja('KAP_GUB')}>
              + Додај ставку
            </button>
          </div>
        </section>

        {/* DEO 9 - Dokazi */}
        <section className="form-section">
          <h2 className="section-title">Део 9. Докази уз пријаву</h2>
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Назив и број доказа</th>
                  <th>Локација фајла</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.dokazi.map((dokaz, index) => (
                  <tr key={index}>
                    <td>{index + 1}</td>
                    <td>
                      <input
                        type="text"
                        value={dokaz.naziv}
                        onChange={(e) => updateDokaz(index, 'naziv', e.target.value)}
                      />
                    </td>
                    <td>
                      <input
                        type="text"
                        value={dokaz.lokacijaFajla || ''}
                        onChange={(e) => updateDokaz(index, 'lokacijaFajla', e.target.value)}
                      />
                    </td>
                    <td>
                      <button type="button" className="btn-remove" onClick={() => removeDokaz(index)}>✕</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            <button type="button" className="btn-add" onClick={addDokaz}>
              + Додај доказ
            </button>
          </div>
        </section>

        {/* Submit buttons */}
        <div className="form-actions">
          <div className="form-actions-error">
            <ErrorPanel error={error} onClose={() => setError(null)} />
          </div>
          <div className="form-actions-buttons">
            <button type="button" className="btn btn-secondary" onClick={() => navigate(-1)} disabled={submitting}>
              Откажи
            </button>
            <button type="submit" className="btn btn-primary" disabled={submitting}>
              {submitting ? 'Чување...' : isEdit ? 'Сачувај измене' : 'Креирај пријаву'}
            </button>
          </div>
        </div>
      </form>
    </div>
  );
}

// Helper functions
function formatDateForInput(dateStr: string | undefined): string {
  if (!dateStr) return '';
  try {
    const date = new Date(dateStr);
    return date.toISOString().split('T')[0];
  } catch {
    return '';
  }
}

function mapPrenosi(prenosi: unknown[] | undefined): StavkaPrenosa[] {
  if (!prenosi) return [];
  return prenosi.map((p: unknown, idx: number) => {
    const prenos = p as Record<string, unknown>;
    const dokumenti = prenos.DokumentiOSticanju as Record<string, unknown>[] | undefined;
    return {
      redniBroj: prenos.ID as number || idx + 1,
      datumPrenosa: formatDateForInput(prenos.DatumPrenosa as string),
      prodajnaCena: String(prenos.ProdajnaCena || ''),
      datumSticanja: formatDateForInput(prenos.DatumSticanja as string),
      nabavnaCena: String(prenos.NabavnaCena || ''),
      isDigital: prenos.IsDigital as boolean || false,
      naziv: prenos.Naziv as string,
      brDokOPrenosu: String(prenos.BrDokOPrenosu ?? ''),
      brojPrenetihHOV: String(prenos.BrPrenetihHOV ?? ''),
      dokumentiOSticanju: dokumenti?.map(d => ({
        datumSticanja: formatDateForInput(d.DatumSticanja as string),
        brojDokOSticanju: String(d.BrojDokOSticanju ?? ''),
        brojStecenihJedinica: String(d.BrojStecenihJedinica ?? ''),
        nabavnaCena: String(d.NabavnaCena ?? ''),
      })) || [],
    };
  });
}

function mapUmanjenja(umanjenja: unknown[] | undefined): StavkaUmanjenja[] {
  if (!umanjenja) return [];
  return umanjenja.map((u: unknown, idx: number) => {
    const umanjenje = u as Record<string, unknown>;
    return {
      redniBroj: umanjenje.ID as number || idx + 1,
      tip: umanjenje.Tip as 'RES_SP' | 'OSN_KAP' | 'KAP_GUB',
      datumUlaganja: formatDateForInput(umanjenje.DatumUlaganja as string),
      iznosKapGub: String(umanjenje.IznosKapGub ?? ''),
      brojResenja: String(umanjenje.BrojResenja ?? ''),
      iznosUlozenUKapDP: String(umanjenje.IznosUlozenUKapDP ?? ''),
      iznosUlozenUKapIF: String(umanjenje.IznosUlozenUKapIF ?? ''),
      iznosUlozenihSredstava: String(umanjenje.IznosUlozenihSredstava ?? ''),
      povrsinaZaOslobadjanje: String(umanjenje.PovrsinaZaOslobadjanje ?? ''),
      domacinstvo: umanjenje.Domacinstvo as boolean,
    };
  });
}

function mapDokazi(dokazi: unknown[] | undefined): Dokaz[] {
  if (!dokazi) return [];
  return dokazi.map((d: unknown, idx: number) => {
    const dokaz = d as Record<string, unknown>;
    return {
      redniBroj: dokaz.BrojDokaza as number || idx + 1,
      naziv: (dokaz.Naziv as string) || '',
      lokacijaFajla: dokaz.LokacijaFajla as string,
    };
  });
}
