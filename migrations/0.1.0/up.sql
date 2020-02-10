CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-------------------- Publisher
CREATE TABLE publisher (
    publisher_id        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publisher_name      TEXT NOT NULL CHECK (octet_length(publisher_name) >= 1),
    publisher_shortname TEXT CHECK (octet_length(publisher_shortname) >= 1),
    publisher_url       TEXT CHECK (publisher_url ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)')
);
-- case-insensitive UNIQ index on publisher_name
CREATE UNIQUE INDEX publisher_uniq_idx ON publisher(lower(publisher_name));

-------------------- Work

CREATE TYPE work_type AS ENUM (
  'book-chapter',
  'monograph',
  'edited-book',
  'textbook',
  'journal-issue',
  'book-set'
);

CREATE TYPE work_status AS ENUM (
  'unspecified',
  'cancelled',
  'forthcoming',
  'postponed-indefinitely',
  'active',
  'no-longer-our-product',
  'out-of-stock-indefinitely',
  'out-of-print',
  'inactive',
  'unknown',
  'remaindered',
  'withdrawn-from-sale',
  'recalled'
);

CREATE TABLE work (
    work_id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_type           work_type NOT NULL,
    work_status         work_status NOT NULL,
    full_title          TEXT NOT NULL CHECK (octet_length(full_title) >= 1),
    title               TEXT NOT NULL CHECK (octet_length(title) >= 1),
    subtitle            TEXT CHECK (octet_length(subtitle) >= 1),
    reference           TEXT CHECK (octet_length(reference) >= 1),
    edition             INTEGER NOT NULL CHECK (edition > 0),
    publisher_id        UUID NOT NULL REFERENCES publisher(publisher_id),
    doi                 TEXT CHECK (doi ~* 'https:\/\/doi.org\/10.\d{4,9}\/[-._\;\(\)\/:a-zA-Z0-9]+$'),
    publication_date    DATE,
    place               TEXT CHECK (octet_length(reference) >= 1),
    width               INTEGER CHECK (width > 0),
    height              INTEGER CHECK (height > 0),
    page_count          INTEGER CHECK (page_count > 0),
    page_breakdown      TEXT CHECK(octet_length(page_breakdown) >=1),
    image_count         INTEGER CHECK (image_count >= 0),
    table_count         INTEGER CHECK (table_count >= 0),
    audio_count         INTEGER CHECK (audio_count >= 0),
    video_count         INTEGER CHECK (video_count >= 0),
    license             TEXT CHECK (license ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)'),
    copyright_holder    TEXT NOT NULL CHECK (octet_length(copyright_holder) >= 1),
    landing_page        TEXT CHECK (landing_page ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)'),
    lccn                INTEGER CHECK(lccn > 0),
    oclc                INTEGER CHECK (oclc > 0),
    short_abstract      TEXT CHECK (octet_length(short_abstract) >= 1),
    long_abstract       TEXT CHECK (octet_length(long_abstract) >= 1),
    general_note        TEXT CHECK (octet_length(general_note) >= 1),
    toc                 TEXT CHECK (octet_length(toc) >= 1),
    cover_url           TEXT CHECK (cover_url ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)'),
    cover_caption       TEXT CHECK (octet_length(cover_caption) >= 1)
);
-- case-insensitive UNIQ index on doi
CREATE UNIQUE INDEX doi_uniq_idx ON work(lower(doi));

-------------------- Language

CREATE TYPE language_relation AS ENUM (
  'original',
  'translated-from',
  'translated-into'
);

CREATE TYPE language_code AS ENUM (
  'aar',
  'abk',
  'ace',
  'ach',
  'ada',
  'ady',
  'afa',
  'afh',
  'afr',
  'ain',
  'aka',
  'akk',
  'alb',
  'ale',
  'alg',
  'alt',
  'amh',
  'ang',
  'anp',
  'apa',
  'ara',
  'arc',
  'arg',
  'arm',
  'arn',
  'arp',
  'art',
  'arw',
  'asm',
  'ast',
  'ath',
  'aus',
  'ava',
  'ave',
  'awa',
  'aym',
  'aze',
  'bad',
  'bai',
  'bak',
  'bal',
  'bam',
  'ban',
  'baq',
  'bas',
  'bat',
  'bej',
  'bel',
  'bem',
  'ben',
  'ber',
  'bho',
  'bih',
  'bik',
  'bin',
  'bis',
  'bla',
  'bnt',
  'bos',
  'bra',
  'bre',
  'btk',
  'bua',
  'bug',
  'bul',
  'bur',
  'byn',
  'cad',
  'cai',
  'car',
  'cat',
  'cau',
  'ceb',
  'cel',
  'cha',
  'chb',
  'che',
  'chg',
  'chi',
  'chk',
  'chm',
  'chn',
  'cho',
  'chp',
  'chr',
  'chu',
  'chv',
  'chy',
  'cmc',
  'cnr',
  'cop',
  'cor',
  'cos',
  'cpe',
  'cpf',
  'cpp',
  'cre',
  'crh',
  'crp',
  'csb',
  'cus',
  'cze',
  'dak',
  'dan',
  'dar',
  'day',
  'del',
  'den',
  'dgr',
  'din',
  'div',
  'doi',
  'dra',
  'dsb',
  'dua',
  'dum',
  'dut',
  'dyu',
  'dzo',
  'efi',
  'egy',
  'eka',
  'elx',
  'eng',
  'enm',
  'epo',
  'est',
  'ewe',
  'ewo',
  'fan',
  'fao',
  'fat',
  'fij',
  'fil',
  'fin',
  'fiu',
  'fon',
  'fre',
  'frm',
  'fro',
  'frr',
  'frs',
  'fry',
  'ful',
  'fur',
  'gaa',
  'gay',
  'gba',
  'gem',
  'geo',
  'ger',
  'gez',
  'gil',
  'gla',
  'gle',
  'glg',
  'glv',
  'gmh',
  'goh',
  'gon',
  'gor',
  'got',
  'grb',
  'grc',
  'gre',
  'grn',
  'gsw',
  'guj',
  'gwi',
  'hai',
  'hat',
  'hau',
  'haw',
  'heb',
  'her',
  'hil',
  'him',
  'hin',
  'hit',
  'hmn',
  'hmo',
  'hrv',
  'hsb',
  'hun',
  'hup',
  'iba',
  'ibo',
  'ice',
  'ido',
  'iii',
  'ijo',
  'iku',
  'ile',
  'ilo',
  'ina',
  'inc',
  'ind',
  'ine',
  'inh',
  'ipk',
  'ira',
  'iro',
  'ita',
  'jav',
  'jbo',
  'jpn',
  'jpr',
  'jrb',
  'kaa',
  'kab',
  'kac',
  'kal',
  'kam',
  'kan',
  'kar',
  'kas',
  'kau',
  'kaw',
  'kaz',
  'kbd',
  'kha',
  'khi',
  'khm',
  'kho',
  'kik',
  'kin',
  'kir',
  'kmb',
  'kok',
  'kom',
  'kon',
  'kor',
  'kos',
  'kpe',
  'krc',
  'krl',
  'kro',
  'kru',
  'kua',
  'kum',
  'kur',
  'kut',
  'lad',
  'lah',
  'lam',
  'lao',
  'lat',
  'lav',
  'lez',
  'lim',
  'lin',
  'lit',
  'lol',
  'loz',
  'ltz',
  'lua',
  'lub',
  'lug',
  'lui',
  'lun',
  'luo',
  'lus',
  'mac',
  'mad',
  'mag',
  'mah',
  'mai',
  'mak',
  'mal',
  'man',
  'mao',
  'map',
  'mar',
  'mas',
  'may',
  'mdf',
  'mdr',
  'men',
  'mga',
  'mic',
  'min',
  'mis',
  'mkh',
  'mlg',
  'mlt',
  'mnc',
  'mni',
  'mno',
  'moh',
  'mon',
  'mos',
  'mul',
  'mun',
  'mus',
  'mwl',
  'mwr',
  'myn',
  'myv',
  'nah',
  'nai',
  'nap',
  'nau',
  'nav',
  'nbl',
  'nde',
  'ndo',
  'nds',
  'nep',
  'new',
  'nia',
  'nic',
  'niu',
  'nno',
  'nob',
  'nog',
  'non',
  'nor',
  'nqo',
  'nso',
  'nub',
  'nwc',
  'nya',
  'nym',
  'nyn',
  'nyo',
  'nzi',
  'oci',
  'oji',
  'ori',
  'orm',
  'osa',
  'oss',
  'ota',
  'oto',
  'paa',
  'pag',
  'pal',
  'pam',
  'pan',
  'pap',
  'pau',
  'peo',
  'per',
  'phi',
  'phn',
  'pli',
  'pol',
  'pon',
  'por',
  'pra',
  'pro',
  'pus',
  'qaa',
  'que',
  'raj',
  'rap',
  'rar',
  'roa',
  'roh',
  'rom',
  'rum',
  'run',
  'rup',
  'rus',
  'sad',
  'sag',
  'sah',
  'sai',
  'sal',
  'sam',
  'san',
  'sas',
  'sat',
  'scn',
  'sco',
  'sel',
  'sem',
  'sga',
  'sgn',
  'shn',
  'sid',
  'sin',
  'sio',
  'sit',
  'sla',
  'slo',
  'slv',
  'sma',
  'sme',
  'smi',
  'smj',
  'smn',
  'smo',
  'sms',
  'sna',
  'snd',
  'snk',
  'sog',
  'som',
  'son',
  'sot',
  'spa',
  'srd',
  'srn',
  'srp',
  'srr',
  'ssa',
  'ssw',
  'suk',
  'sun',
  'sus',
  'sux',
  'swa',
  'swe',
  'syc',
  'syr',
  'tah',
  'tai',
  'tam',
  'tat',
  'tel',
  'tem',
  'ter',
  'tet',
  'tgk',
  'tgl',
  'tha',
  'tib',
  'tig',
  'tir',
  'tiv',
  'tkl',
  'tlh',
  'tli',
  'tmh',
  'tog',
  'ton',
  'tpi',
  'tsi',
  'tsn',
  'tso',
  'tuk',
  'tum',
  'tup',
  'tur',
  'tut',
  'tvl',
  'twi',
  'tyv',
  'udm',
  'uga',
  'uig',
  'ukr',
  'umb',
  'und',
  'urd',
  'uzb',
  'vai',
  'ven',
  'vie',
  'vol',
  'vot',
  'wak',
  'wal',
  'war',
  'was',
  'wel',
  'wen',
  'wln',
  'wol',
  'xal',
  'xho',
  'yao',
  'yap',
  'yid',
  'yor',
  'ypk',
  'zap',
  'zbl',
  'zen',
  'zgh',
  'zha',
  'znd',
  'zul',
  'zun',
  'zxx',
  'zza'
);

CREATE TABLE language (
    language_id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_id             UUID NOT NULL REFERENCES work(work_id),
    language_code       language_code NOT NULL,
    language_relation   language_relation NOT NULL,
    main_language       BOOLEAN NOT NULL DEFAULT False
);

-- UNIQ index on combination of language and work
CREATE UNIQUE INDEX language_uniq_work_idx ON language(work_id, language_code);

-------------------- Series

CREATE TYPE series_type AS ENUM (
  'journal',
  'book-series'
);

CREATE TABLE series (
    series_id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    series_type         series_type NOT NULL,
    series_name         TEXT NOT NULL CHECK (octet_length(series_name) >= 1),
    issn_print          TEXT NOT NULL CHECK (issn_print ~* '\d{4}\-\d{3}(\d|X)'),
    issn_digital        TEXT NOT NULL CHECK (issn_digital ~* '\d{4}\-\d{3}(\d|X)'),
    series_url          TEXT CHECK (series_url ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)'),
    publisher_id        UUID NOT NULL REFERENCES publisher(publisher_id)
);

--  UNIQ index on ISSNs
CREATE UNIQUE INDEX series_issn_print_idx ON series(issn_print);
CREATE UNIQUE INDEX series_issn_digital_idx ON series(issn_digital);

CREATE TABLE issue (
    series_id           UUID NOT NULL REFERENCES series(series_id),
    work_id             UUID NOT NULL REFERENCES work(work_id),
    issue_ordinal       INTEGER NOT NULL CHECK (issue_ordinal > 0),
    PRIMARY KEY (series_id, work_id)
);

-- UNIQ index on issue_ordinal and series_id
CREATE UNIQUE INDEX issue_uniq_ord_in_series_idx ON issue(series_id, issue_ordinal);

-------------------- Contributor

CREATE TABLE contributor (
    contributor_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name          TEXT CHECK (octet_length(first_name) >= 1),
    last_name           TEXT NOT NULL CHECK (octet_length(last_name) >= 1),
    full_name           TEXT NOT NULL CHECK (octet_length(full_name) >= 1),
    orcid               TEXT CHECK (orcid ~* '0000-000(1-[5-9]|2-[0-9]|3-[0-4])\d{3}-\d{3}[\dX]'),
    website             TEXT CHECK (octet_length(website) >= 1)
);
-- case-insensitive UNIQ index on orcid
CREATE UNIQUE INDEX orcid_uniq_idx ON contributor(lower(orcid));

CREATE TYPE contribution_type AS ENUM (
  'author',
  'editor',
  'translator',
  'photographer',
  'ilustrator',
  'foreword-by',
  'introduction-by',
  'afterword-by',
  'preface-by'
);

CREATE TABLE contribution (
    work_id             UUID NOT NULL REFERENCES work(work_id),
    contributor_id      UUID NOT NULL REFERENCES contributor(contributor_id),
    contribution_type   contribution_type NOT NULL,
    main_contribution   BOOLEAN NOT NULL DEFAULT False,
    biography           TEXT CHECK (octet_length(biography) >= 1),
    institution         TEXT CHECK (octet_length(institution) >= 1),
    PRIMARY KEY (work_id, contributor_id, contribution_type)
);

-------------------- Publication

CREATE TYPE publication_type AS ENUM (
  'Paperback',
  'Hardback',
  'PDF',
  'HTML',
  'XML',
  'Epub',
  'Mobi'
);

CREATE TABLE publication (
    publication_id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publication_type    publication_type NOT NULL,
    work_id             UUID NOT NULL REFERENCES work(work_id),
    isbn                TEXT CHECK (octet_length(isbn) = 17),
    publication_url     TEXT CHECK (publication_url ~* '^[^:]*:\/\/(?:[^\/:]*:[^\/@]*@)?(?:[^\/:.]*\.)+([^:\/]+)')
);

-------------------- Price

CREATE TYPE currency_code AS ENUM (
  'adp',
  'aed',
  'afa',
  'afn',
  'alk',
  'all',
  'amd',
  'ang',
  'aoa',
  'aok',
  'aon',
  'aor',
  'ara',
  'arp',
  'ars',
  'ary',
  'ats',
  'aud',
  'awg',
  'aym',
  'azm',
  'azn',
  'bad',
  'bam',
  'bbd',
  'bdt',
  'bec',
  'bef',
  'bel',
  'bgj',
  'bgk',
  'bgl',
  'bgn',
  'bhd',
  'bif',
  'bmd',
  'bnd',
  'bob',
  'bop',
  'bov',
  'brb',
  'brc',
  'bre',
  'brl',
  'brn',
  'brr',
  'bsd',
  'btn',
  'buk',
  'bwp',
  'byb',
  'byn',
  'byr',
  'bzd',
  'cad',
  'cdf',
  'chc',
  'che',
  'chf',
  'chw',
  'clf',
  'clp',
  'cny',
  'cop',
  'cou',
  'crc',
  'csd',
  'csj',
  'csk',
  'cuc',
  'cup',
  'cve',
  'cyp',
  'czk',
  'ddm',
  'dem',
  'djf',
  'dkk',
  'dop',
  'dzd',
  'ecs',
  'ecv',
  'eek',
  'egp',
  'ern',
  'esa',
  'esb',
  'esp',
  'etb',
  'eur',
  'fim',
  'fjd',
  'fkp',
  'frf',
  'gbp',
  'gek',
  'gel',
  'ghc',
  'ghp',
  'ghs',
  'gip',
  'gmd',
  'gne',
  'gnf',
  'gns',
  'gqe',
  'grd',
  'gtq',
  'gwe',
  'gwp',
  'gyd',
  'hkd',
  'hnl',
  'hrd',
  'hrk',
  'htg',
  'huf',
  'idr',
  'iep',
  'ilp',
  'ilr',
  'ils',
  'inr',
  'iqd',
  'irr',
  'isj',
  'isk',
  'itl',
  'jmd',
  'jod',
  'jpy',
  'kes',
  'kgs',
  'khr',
  'kmf',
  'kpw',
  'krw',
  'kwd',
  'kyd',
  'kzt',
  'laj',
  'lak',
  'lbp',
  'lkr',
  'lrd',
  'lsl',
  'lsm',
  'ltl',
  'ltt',
  'luc',
  'luf',
  'lul',
  'lvl',
  'lvr',
  'lyd',
  'mad',
  'mdl',
  'mga',
  'mgf',
  'mkd',
  'mlf',
  'mmk',
  'mnt',
  'mop',
  'mro',
  'mru',
  'mtl',
  'mtp',
  'mur',
  'mvq',
  'mvr',
  'mwk',
  'mxn',
  'mxp',
  'mxv',
  'myr',
  'mze',
  'mzm',
  'mzn',
  'nad',
  'ngn',
  'nic',
  'nio',
  'nlg',
  'nok',
  'npr',
  'nzd',
  'omr',
  'pab',
  'peh',
  'pei',
  'pen',
  'pes',
  'pgk',
  'php',
  'pkr',
  'pln',
  'plz',
  'pte',
  'pyg',
  'qar',
  'rhd',
  'rok',
  'rol',
  'ron',
  'rsd',
  'rub',
  'rur',
  'rwf',
  'sar',
  'sbd',
  'scr',
  'sdd',
  'sdg',
  'sdp',
  'sek',
  'sgd',
  'shp',
  'sit',
  'skk',
  'sll',
  'sos',
  'srd',
  'srg',
  'ssp',
  'std',
  'stn',
  'sur',
  'svc',
  'syp',
  'szl',
  'thb',
  'tjr',
  'tjs',
  'tmm',
  'tmt',
  'tnd',
  'top',
  'tpe',
  'trl',
  'try',
  'ttd',
  'twd',
  'tzs',
  'uah',
  'uak',
  'ugs',
  'ugw',
  'ugx',
  'usd',
  'usn',
  'uss',
  'uyi',
  'uyn',
  'uyp',
  'uyu',
  'uyw',
  'uzs',
  'veb',
  'vef',
  'ves',
  'vnc',
  'vnd',
  'vuv',
  'wst',
  'xaf',
  'xag',
  'xau',
  'xba',
  'xbb',
  'xbc',
  'xbd',
  'xcd',
  'xdr',
  'xeu',
  'xfo',
  'xfu',
  'xof',
  'xpd',
  'xpf',
  'xpt',
  'xre',
  'xsu',
  'xts',
  'xua',
  'xxx',
  'ydd',
  'yer',
  'yud',
  'yum',
  'yun',
  'zal',
  'zar',
  'zmk',
  'zmw',
  'zrn',
  'zrz',
  'zwc',
  'zwd',
  'zwl',
  'zwn',
  'zwr'
);

CREATE TABLE price (
    price_id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    publication_id      UUID NOT NULL REFERENCES publication(publication_id),
    currency_code       currency_code NOT NULL,
    unit_price          double precision NOT NULL
);


---------------------------------------------------------------------------
---------------------------------------------------------------------------
---------------------------------------------------------------------------

INSERT INTO publisher VALUES
('00000000-0000-0000-DDDD-000000000001', 'Open Book Publishers', 'OBP', 'https://www.openbookpublishers.com'),
('00000000-0000-0000-DDDD-000000000002', 'punctum books', null, 'https://punctumbooks.com');

INSERT INTO work VALUES
('00000000-0000-0000-AAAA-000000000001', 'monograph', 'active', 'That Greece Might Still Be Free: The Philhellenes in the War of Independence', 'That Greece Might Still Be Free', 'The Philhellenes in the War of Independence', null, 1, '00000000-0000-0000-DDDD-000000000001', 'https://doi.org/10.11647/obp.0001', '2008-11-01', 'Cambridge, UK', 156, 234, 440, 'xxi + 419', 41, 2, 0, 0, 'http://creativecommons.org/licenses/by-nc-nd/2.0/', 'William St Clair', 'https://www.openbookpublishers.com/product/3', null, 849917874, 'When in 1821, the Greeks rose in violent revolution against Ottoman rule, waves of sympathy spread across western Europe and the USA. Inspired by a belief that Greece had a unique claim on the sympathy of the world, more than a thousand Philhellenes set out to fight for the cause. This meticulously researched and highly readable account of their aspirations and experiences has long been the standard account of the Philhellenic movement and essential reading for students of the Greek War of Independence, Byron and European Romanticism. Its relevance to more modern conflicts is also becoming increasingly appreciated.', 'When in 1821, the Greeks rose in violent revolution against Ottoman rule, waves of sympathy spread across western Europe and the USA. Inspired by a belief that Greece had a unique claim on the sympathy of the world, more than a thousand Philhellenes set out to fight for the cause. This meticulously researched and highly readable account of their aspirations and experiences has long been the standard account of the Philhellenic movement and essential reading for students of the Greek War of Independence, Byron and European Romanticism. Its relevance to more modern conflicts is also becoming increasingly appreciated.', null, null, 'https://www.openbookpublishers.com/shopimages/products/cover/3.jpg', null),
('00000000-0000-0000-AAAA-000000000002', 'textbook', 'active', 'Conservation Biology in Sub-Saharan Africa', 'Conservation Biology in Sub-Saharan Africa', null, null, 1, '00000000-0000-0000-DDDD-000000000001', 'https://doi.org/10.11647/obp.0177', '2019-09-09', 'Cambridge, UK', 156, 234, 320, 'vi + 314', 32, 5, 0, 0, 'http://creativecommons.org/licenses/by/4.0/', 'John W. Wilson, Richard B. Primack', 'https://www.openbookpublishers.com/product/1013', null, null, null, null, null, null, 'https://www.openbookpublishers.com/shopimages/products/cover/1013.jpg', null),
('00000000-0000-0000-AAAA-000000000003', 'journal-issue', 'out-of-print', 'What Works in Conservation 2015', 'What Works in Conservation', '2015', null, 1, '00000000-0000-0000-DDDD-000000000001', 'https://doi.org/10.11647/obp.0060', '2015-07-01', 'Cambridge, UK', 156, 234, 198, 'xii + 176', 23, 46, 0, 0, 'http://creativecommons.org/licenses/by/4.0/', 'William J. Sutherland', 'https://www.openbookpublishers.com/product/347', null, null, 'What Works in Conservation has been created to provide practitioners with answers to these and many other questions about practical conservation. This book provides an assessment of the effectiveness of 648 conservation interventions based on summarized scientific evidence relevant to the practical global conservation of amphibians, reducing the risk of predation for birds, conservation of European farmland biodiversity and some aspects of enhancing natural pest control and soil fertility.', 'Is planting grass margins around fields beneficial for wildlife? Which management interventions increase bee numbers in farmland? Does helping migrating toads across roads increase populations? How do you reduce predation on bird populations? What Works in Conservation has been created to provide practitioners with answers to these and many other questions about practical conservation.
This book provides an assessment of the effectiveness of over 200 conservation interventions based on summarized scientific evidence relevant to the practical global conservation of amphibians, reducing the risk of predation for birds, conservation of European farmland biodiversity and some aspects of enhancing natural pest control and soil fertility. It contains key results from the summarized evidence for each conservation intervention and an assessment of the effectiveness of each by international expert panels. The volume is published in partnership with the Conservation Evidence project and is fully linked to the project''s website where background papers such as abstracts and published journal articles can be freely accessed.', null, null, 'http://www.openbookpublishers.com/shopimages/products/cover/347.jpg', null);

INSERT INTO language VALUES
('00000000-0000-0000-FFFF-000000000001', '00000000-0000-0000-AAAA-000000000001', 'eng', 'original', True),
('00000000-0000-0000-FFFF-000000000002', '00000000-0000-0000-AAAA-000000000002', 'eng', 'original', True),
('00000000-0000-0000-FFFF-000000000003', '00000000-0000-0000-AAAA-000000000003', 'eng', 'original', True);

INSERT INTO contributor VALUES
('00000000-0000-0000-CCCC-000000000001', 'William', 'St Clair', 'William St Clair', null, 'https://research.sas.ac.uk/search/fellow/158'),
('00000000-0000-0000-CCCC-000000000002', 'Roderick', 'Beaton', 'Roderick Beaton', null, null),
('00000000-0000-0000-CCCC-000000000003', 'John W.', 'Wilson', 'John W. Wilson', '0000-0002-7230-1449', 'https://johnnybirder.com/index.html'),
('00000000-0000-0000-CCCC-000000000004', 'Richard B.', 'Primack', 'Richard B. Primack', '0000-0002-3748-9853', 'https://www.rprimacklab.com'),
('00000000-0000-0000-CCCC-000000000005', 'William J.', 'Sutherland', 'William J. Sutherland', null, null);


INSERT INTO contribution VALUES
('00000000-0000-0000-AAAA-000000000001', '00000000-0000-0000-CCCC-000000000001', 'author', True, 'William St Clair is a Senior Research Fellow at the Institute of English Studies, School of Advanced Study, University of London, and of the Centre for History and Economics, University of Cambridge. His works include <i>Lord Elgin and the Marbles</i> and <i>The Reading Nation in the Romantic Period</i>. He is a Fellow of the British Academy and of the Royal Society of Literature.', null),
('00000000-0000-0000-AAAA-000000000001', '00000000-0000-0000-CCCC-000000000002', 'introduction-by', False, null, null),
('00000000-0000-0000-AAAA-000000000002', '00000000-0000-0000-CCCC-000000000003', 'author', True, 'John W. Wilson is a conservation biologist interested in solving the dynamic challenges of a changing world. He received his BSc and MSc from Pretoria University, and his PhD from North Carolina State University. He has over 15 years of experience with conservation across Africa. As a NASA Earth and Space Science Fellow, he studied interactions between habitat loss and climate change in West Africa. He also spent 13 months on uninhabited Gough Island, a World Heritage Site in the South Atlantic, where he combatted invasive species. Beyond that, he has studied individual organisms, populations, and natural communities across Southern, East, Central, and West Africa. His work has covered pertinent topics such as conservation planning, population monitoring, protected areas management, translocations, ecological restoration, and movement ecology in savannahs, grasslands, forests, wetlands, and agricultural systems. His love for nature also dominates his free time; he has contributed over 50,000 observation records to the citizen science platforms eBird and iNaturalist, which he also helps curate.', null),
('00000000-0000-0000-AAAA-000000000002', '00000000-0000-0000-CCCC-000000000004', 'author', True, 'Richard B. Primack is a Professor of Biology, specializing in plant ecology, conservation biology, and tropical ecology. He is the author of three widely used conservation biology textbooks; local co-authors have helped to produce 36 translations of these books with local examples. He has been Editor-in-Chief of the journal <i>Biological Conservation</i>, and served as President of the <i>Association for Tropical Biology and Conservation</i>. His research documents the effects of climate change on plants and animals in the Eastern U.S.A., and is often featured in the popular press.', 'Boston University'),
('00000000-0000-0000-AAAA-000000000003', '00000000-0000-0000-CCCC-000000000005', 'editor', True, null, null);

INSERT INTO publication VALUES
('00000000-0000-0000-BBBB-000000000001', 'Paperback', '00000000-0000-0000-AAAA-000000000001', '978-1-906924-00-3', null),
('00000000-0000-0000-BBBB-000000000002', 'Hardback', '00000000-0000-0000-AAAA-000000000001', '978-1-906924-01-0', null),
('00000000-0000-0000-BBBB-000000000003', 'PDF', '00000000-0000-0000-AAAA-000000000001', '978-1-906924-02-7', null),
('00000000-0000-0000-BBBB-000000000004', 'Paperback', '00000000-0000-0000-AAAA-000000000002', '978-1-78374-750-4', null),
('00000000-0000-0000-BBBB-000000000005', 'Hardback', '00000000-0000-0000-AAAA-000000000002', '978-1-78374-751-1', null),
('00000000-0000-0000-BBBB-000000000006', 'PDF', '00000000-0000-0000-AAAA-000000000002', '978-1-78374-752-8', null);

INSERT INTO series VALUES
('00000000-0000-0000-EEEE-000000000001', 'journal', 'What Works in Conservation', '2059-4232', '2059-4240', null, '00000000-0000-0000-DDDD-000000000001');

INSERT INTO issue VALUES
('00000000-0000-0000-EEEE-000000000001', '00000000-0000-0000-AAAA-000000000003', 1);

INSERT INTO price VALUES
('00000000-0000-AAAA-AAAA-000000000001', '00000000-0000-0000-BBBB-000000000001', 'gbp', 15.95),
('00000000-0000-AAAA-AAAA-000000000002', '00000000-0000-0000-BBBB-000000000002', 'gbp', 29.95),
('00000000-0000-AAAA-AAAA-000000000003', '00000000-0000-0000-BBBB-000000000004', 'gbp', 17.95);
