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
  email?: string;
}

interface OrganPU {
  id: number;
  naziv: string;
}

interface VrstaPrijave {
  id: number;
  naziv: string;
}

interface OsnovZaPrijavu {
  id: number;
  naziv: string;
}

interface StavkaPrenosa {
  redniBroj: number;
  datumPrenosa: string;
  prodajnaCena: number;
  datumSticanja: string;
  nabavnaCena: number;
  isDigital: boolean;
  // Za hartije od vrednosti
  naziv?: string;
  brDokOPrenosu?: number;
  dokumentiOSticanju?: { brojStecenihJedinica: number }[];
}

interface StavkaUmanjenja {
  redniBroj: number;
  tip: 'RES_SP' | 'OSN_KAP' | 'KAP_GUB';
  datumUlaganja: string;
  // RES_SP
  iznosUlozenihSredstava?: number;
  povrsinaZaOslobadjanje?: number;
  domacinstvo?: boolean;
  // OSN_KAP
  iznosUlozenUKapDP?: number;
  iznosUlozenUKapIF?: number;
  // KAP_GUB
  iznosKapGub?: number;
  brojResenja?: number;
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
  prodajnaCena: 0,
  datumSticanja: '',
  nabavnaCena: 0,
  isDigital: true,
});

const emptyStavkaHartije = (): StavkaPrenosa => ({
  redniBroj: 0,
  datumPrenosa: '',
  prodajnaCena: 0,
  datumSticanja: '',
  nabavnaCena: 0,
  isDigital: false,
  naziv: '',
  brDokOPrenosu: 0,
  dokumentiOSticanju: [],
});

const emptyUmanjenjeRESP = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'RES_SP',
  datumUlaganja: '',
  iznosUlozenihSredstava: 0,
  povrsinaZaOslobadjanje: 0,
  domacinstvo: false,
});

const emptyUmanjenjeOSNKAP = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'OSN_KAP',
  datumUlaganja: '',
  iznosUlozenUKapDP: 0,
  iznosUlozenUKapIF: 0,
});

const emptyUmanjenjeKAPGUB = (): StavkaUmanjenja => ({
  redniBroj: 0,
  tip: 'KAP_GUB',
  datumUlaganja: '',
  iznosKapGub: 0,
  brojResenja: 0,
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
  const [organiPU, setOrganiPU] = useState<OrganPU[]>([]);
  const [vrstePrijave, setVrstePrijave] = useState<VrstaPrijave[]>([]);
  const [osnoviZaPrijavu, setOsnoviZaPrijavu] = useState<OsnovZaPrijavu[]>([]);
  const [poreskiObveznici, setPoreskiObveznici] = useState<PoreskiObveznik[]>([]);

  // Form data
  const [formData, setFormData] = useState<FormData>({
    vrstaPrijave: 0,
    osnovZaPrijavu: 0,
    datumOstvarivanjaPrihoda: '',
    datumDospelosti: '',
    datumPodnosenja: '',
    izmena: false,
    organPU: 0,
    tipObveznika: 'fizicko',
    jmbgObveznika: '',
    imeObveznika: '',
    prezimeObveznika: '',
    prebivaliste: '',
    adresaObveznika: '',
    telefon: '',
    email: '',
    jmbgPodnosioca: '',
    zemljaRezidentstva: 'Srbija',
    jmbgPunomocnika: '',
    stavkePrenosa: [],
    stavkeUmanjenja: [],
    dokazi: [],
  });

  // Load lookup data
  useEffect(() => {
    const loadLookups = async () => {
      try {
        const [orgResult, vrsteResult, osnoviResult, obvResult] = await Promise.all([
          tableApi.getAll('OrgPU'),
          tableApi.getAll('VrstaPrijave'),
          tableApi.getAll('OsnovZaPrijavu'),
          tableApi.getAll('PoreskiObveznik'),
        ]);

        setOrganiPU(orgResult.rows.map((r: Record<string, unknown>) => ({
          id: r.ID as number,
          naziv: (r.Naziv as string).trim(),
        })));

        setVrstePrijave(vrsteResult.rows.map((r: Record<string, unknown>) => ({
          id: r.ID as number,
          naziv: (r.Naziv as string).trim(),
        })));

        setOsnoviZaPrijavu(osnoviResult.rows.map((r: Record<string, unknown>) => ({
          id: r.ID as number,
          naziv: (r.Naziv as string).trim(),
        })));

        setPoreskiObveznici(obvResult.rows.map((r: Record<string, unknown>) => ({
          id: r['JMBG/ESB/PIB_lice'] as number,
          ime: (r.Ime as string).trim(),
          prezime: (r.Prezime as string).trim(),
          email: r.Email ? (r.Email as string).trim() : undefined,
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
      if (isEdit && id) {
        // Update existing document
        const jsonDoc = buildJsonDocument();
        await documentApi.update(parseInt(id), jsonDoc);
        navigate('/documents');
      } else {
        // Create new document - first create PPDG3P record
        const createData = {
          datumOstvarivanjaPrihoda: formData.datumOstvarivanjaPrihoda,
          datumDospelostiZaPodnosenjePrijave: formData.datumDospelosti,
          datumNacinPodnosenjaPrijave: formData.datumPodnosenja,
          izmena: formData.izmena,
          idOrganaPoreske: formData.organPU,
          idPoreskogObveznika: parseInt(formData.jmbgObveznika),
          idVrstePrijave: formData.vrstaPrijave,
          idOsnovaZaPrijavu: formData.osnovZaPrijavu,
          email: formData.email || undefined,
        };

        const result = await documentApi.create(createData);
        const newId = result.id;

        // Then update with full document
        const jsonDoc = buildJsonDocument();
        await documentApi.update(newId, jsonDoc);
        navigate('/documents');
      }
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const buildJsonDocument = () => {
    return {
      datumOstvarivanjaPrihoda: formData.datumOstvarivanjaPrihoda,
      datumDospelostiZaPodnosenjePrijave: formData.datumDospelosti,
      datumNacinPodnosenjaPrijave: formData.datumPodnosenja,
      izmena: formData.izmena,
      organPU: { id: formData.organPU },
      vrstaPrijave: { id: formData.vrstaPrijave },
      osnovZaPrijavu: { id: formData.osnovZaPrijavu },
      poreskiObveznik: {
        id: parseInt(formData.jmbgObveznika),
        ime: formData.imeObveznika,
        prezime: formData.prezimeObveznika,
        email: formData.email,
      },
      Prenosi: formData.stavkePrenosa.map((s, idx) => ({
        ID: s.redniBroj || undefined,
        DatumPrenosa: s.datumPrenosa,
        ProdajnaCena: s.prodajnaCena,
        DatumSticanja: s.datumSticanja,
        NabavnaCena: s.nabavnaCena,
        IsDigital: s.isDigital,
        Naziv: s.naziv,
        BrDokOPrenosu: s.brDokOPrenosu,
        DokumentiOSticanju: s.dokumentiOSticanju,
      })),
      Umanjenja: formData.stavkeUmanjenja.map((s) => ({
        ID: s.redniBroj || undefined,
        DatumUlaganja: s.datumUlaganja,
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

  const handleObveznikChange = (jmbg: string) => {
    setFormData(prev => ({ ...prev, jmbgObveznika: jmbg }));
    const obveznik = poreskiObveznici.find(o => String(o.id) === jmbg);
    if (obveznik) {
      setFormData(prev => ({
        ...prev,
        imeObveznika: obveznik.ime,
        prezimeObveznika: obveznik.prezime,
        email: obveznik.email || '',
      }));
    }
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

      <ErrorPanel error={error} onClose={() => setError(null)} />

      <form onSubmit={handleSubmit} className="document-form">
        {/* DEO 1 */}
        <section className="form-section">
          <h2 className="section-title">Део 1. Подаци о пријави</h2>
          <div className="form-row">
            <div className="form-group">
              <label>1.1 Врста пријаве *</label>
              <select
                value={formData.vrstaPrijave}
                onChange={(e) => setFormData(prev => ({ ...prev, vrstaPrijave: parseInt(e.target.value) }))}
                required
              >
                <option value={0}>-- Изаберите --</option>
                {vrstePrijave.map(v => (
                  <option key={v.id} value={v.id}>{v.naziv}</option>
                ))}
              </select>
            </div>
            <div className="form-group">
              <label>1.1а Основ за пријаву *</label>
              <select
                value={formData.osnovZaPrijavu}
                onChange={(e) => setFormData(prev => ({ ...prev, osnovZaPrijavu: parseInt(e.target.value) }))}
                required
              >
                <option value={0}>-- Изаберите --</option>
                {osnoviZaPrijavu.map(o => (
                  <option key={o.id} value={o.id}>{o.naziv}</option>
                ))}
              </select>
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>1.2 Датум остваривања прихода *</label>
              <input
                type="date"
                value={formData.datumOstvarivanjaPrihoda}
                onChange={(e) => setFormData(prev => ({ ...prev, datumOstvarivanjaPrihoda: e.target.value }))}
                required
              />
            </div>
            <div className="form-group">
              <label>1.3 Датум доспелости за подношење *</label>
              <input
                type="date"
                value={formData.datumDospelosti}
                onChange={(e) => setFormData(prev => ({ ...prev, datumDospelosti: e.target.value }))}
                required
              />
            </div>
            <div className="form-group">
              <label>1.4 Датум подношења пријаве *</label>
              <input
                type="date"
                value={formData.datumPodnosenja}
                onChange={(e) => setFormData(prev => ({ ...prev, datumPodnosenja: e.target.value }))}
                required
              />
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>1.5 Измена/Сторнирање</label>
              <select
                value={formData.izmena ? 'true' : 'false'}
                onChange={(e) => setFormData(prev => ({ ...prev, izmena: e.target.value === 'true' }))}
              >
                <option value="false">Не</option>
                <option value="true">Да</option>
              </select>
            </div>
            <div className="form-group">
              <label>Орган пореске управе *</label>
              <select
                value={formData.organPU}
                onChange={(e) => setFormData(prev => ({ ...prev, organPU: parseInt(e.target.value) }))}
                required
              >
                <option value={0}>-- Изаберите --</option>
                {organiPU.map(o => (
                  <option key={o.id} value={o.id}>{o.naziv}</option>
                ))}
              </select>
            </div>
          </div>
        </section>

        {/* DEO 2 */}
        <section className="form-section">
          <h2 className="section-title">Део 2. Подаци о пореском обвезнику</h2>
          <div className="form-row">
            <div className="form-group">
              <label>2.1 Тип пореског обвезника</label>
              <select
                value={formData.tipObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, tipObveznika: e.target.value }))}
              >
                <option value="fizicko">Физичко лице</option>
                <option value="pravno">Правно лице</option>
              </select>
            </div>
            <div className="form-group">
              <label>2.2 ЈМБГ/ЕСБ/ПИБ *</label>
              <select
                value={formData.jmbgObveznika}
                onChange={(e) => handleObveznikChange(e.target.value)}
                required
              >
                <option value="">-- Изаберите обвезника --</option>
                {poreskiObveznici.map(o => (
                  <option key={o.id} value={o.id}>
                    {o.id} - {o.ime} {o.prezime}
                  </option>
                ))}
              </select>
            </div>
          </div>
          <div className="form-row">
            <div className="form-group">
              <label>2.3 Име *</label>
              <input
                type="text"
                value={formData.imeObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, imeObveznika: e.target.value }))}
                required
              />
            </div>
            <div className="form-group">
              <label>2.3 Презиме *</label>
              <input
                type="text"
                value={formData.prezimeObveznika}
                onChange={(e) => setFormData(prev => ({ ...prev, prezimeObveznika: e.target.value }))}
                required
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
                type="email"
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
                          type="date"
                          value={stavka.datumPrenosa}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumPrenosa', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.prodajnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'prodajnaCena', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="date"
                          value={stavka.datumSticanja}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumSticanja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.nabavnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'nabavnaCena', parseInt(e.target.value) || 0)}
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
          <div className="items-table">
            <table>
              <thead>
                <tr>
                  <th>Р.бр.</th>
                  <th>Назив емитента</th>
                  <th>Датум преноса</th>
                  <th>Бр. док. о преносу</th>
                  <th>Продајна цена</th>
                  <th>Датум стицања</th>
                  <th>Набавна цена</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {formData.stavkePrenosa.filter(s => !s.isDigital).map((stavka, index) => {
                  const realIndex = formData.stavkePrenosa.findIndex(s => s === stavka);
                  return (
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>
                        <input
                          type="text"
                          value={stavka.naziv || ''}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'naziv', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="date"
                          value={stavka.datumPrenosa}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumPrenosa', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.brDokOPrenosu || 0}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'brDokOPrenosu', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.prodajnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'prodajnaCena', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="date"
                          value={stavka.datumSticanja}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'datumSticanja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.nabavnaCena}
                          onChange={(e) => updateStavkaPrenosa(realIndex, 'nabavnaCena', parseInt(e.target.value) || 0)}
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
                          type="date"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          step="0.01"
                          value={stavka.povrsinaZaOslobadjanje || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'povrsinaZaOslobadjanje', parseFloat(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.iznosUlozenihSredstava || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenihSredstava', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <select
                          value={stavka.domacinstvo ? 'true' : 'false'}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'domacinstvo', e.target.value === 'true')}
                        >
                          <option value="false">Не</option>
                          <option value="true">Да</option>
                        </select>
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
                          type="date"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.iznosUlozenUKapDP || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenUKapDP', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.iznosUlozenUKapIF || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosUlozenUKapIF', parseInt(e.target.value) || 0)}
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
                          type="date"
                          value={stavka.datumUlaganja}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'datumUlaganja', e.target.value)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.brojResenja || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'brojResenja', parseInt(e.target.value) || 0)}
                        />
                      </td>
                      <td>
                        <input
                          type="number"
                          value={stavka.iznosKapGub || 0}
                          onChange={(e) => updateStavkaUmanjenja(realIndex, 'iznosKapGub', parseInt(e.target.value) || 0)}
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
          <button type="button" className="btn btn-secondary" onClick={() => navigate(-1)} disabled={submitting}>
            Откажи
          </button>
          <button type="submit" className="btn btn-primary" disabled={submitting}>
            {submitting ? 'Чување...' : isEdit ? 'Сачувај измене' : 'Креирај пријаву'}
          </button>
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
    return {
      redniBroj: prenos.ID as number || idx + 1,
      datumPrenosa: formatDateForInput(prenos.DatumPrenosa as string),
      prodajnaCena: prenos.ProdajnaCena as number || 0,
      datumSticanja: formatDateForInput(prenos.DatumSticanja as string),
      nabavnaCena: prenos.NabavnaCena as number || 0,
      isDigital: prenos.IsDigital as boolean || false,
      naziv: prenos.Naziv as string,
      brDokOPrenosu: prenos.BrDokOPrenosu as number,
      dokumentiOSticanju: prenos.DokumentiOSticanju as { brojStecenihJedinica: number }[],
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
      iznosKapGub: umanjenje.IznosKapGub as number,
      brojResenja: umanjenje.BrojResenja as number,
      iznosUlozenUKapDP: umanjenje.IznosUlozenUKapDP as number,
      iznosUlozenUKapIF: umanjenje.IznosUlozenUKapIF as number,
      iznosUlozenihSredstava: umanjenje.IznosUlozenihSredstava as number,
      povrsinaZaOslobadjanje: umanjenje.PovrsinaZaOslobadjanje as number,
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
