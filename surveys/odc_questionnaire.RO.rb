survey 'RO',
  :full_title => 'Romania',
  :default_mandatory => 'false',
  :status => 'beta',
  :description => '<p>Acest chestionar de autoevaluare generează un certificat de date deschise și o insignă pe care o puteți publica pentru a spune oamenilor despre datele deschise. De asemenea, vom folosi răspunsurile dumneavoastră pentru a afla modul în care organizațiile publică date deschise.</p><p>Când răspundeți la aceste întrebări, demonstrați efortul de a vă conforma cu legislația relevantă. Trebuie să verificați, de asemenea, ce alte legi și politici se aplică pentru sectorul dumneavoastră.</p><p><strong>Nu aveți nevoie să răspundeți la toate întrebările pentru a obține un certificat.</strong> Răspundeți doar la cele la care puteți.</p>' do

  translations :en => :default
  section_general 'Informații generale',
    :description => '',
    :display_header => false do

    q_dataTitle 'Cum se numesc aceste date?',
      :discussion_topic => :dataTitle,
      :help_text => 'Oamenii pot vedea numele datelor dumneavoastră deschise într-o listă cu nume similare, așa că încercați să faceți titlul cât mai lipsit de ambiguitate și cât mai descriptiv posibil, în limita numărului impus de caractere, astfel încât oricine să identifice rapid ceea ce este unic despre ele.',
      :required => :required
    a_1 'Titlul datelor',
      :string,
      :placeholder => 'Titlul datelor',
      :required => :required

    q_documentationUrl 'Unde sunt descrise?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt descrise la',
      :help_text => 'Furnizați un URL cu descrierea detaliată a datelor, pentru ca oamenii să poată citi mai multe despre conținutul acestora. Acesta poate duce la o pagină dintr-un catalog mai mare, cum ar fi data.gov.ro.'
    a_1 'URL pentru Documentație',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentație',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Trebuie să aveți o <strong>pagină web care oferă documentație</strong> despre datele deschise publicate, astfel încât oamenii să poată înțelege contextul, conținutul și utilitatea lor.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Trebuie să aveți o <strong>pagină web care oferă documentație</strong> și acces la datele deschise publicate, astfel încât oamenii să le poată folosi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Cine publică aceste date?',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt publicate de',
      :help_text => 'Dați numele organizației care publică aceste date. Este, probabil, organizația pentru care lucrați, în cazul în care nu faceți acest lucru în numele altcuiva.',
      :required => :required
    a_1 'Distribuitorul de Date',
      :string,
      :placeholder => 'Distribuitorul de Date',
      :required => :required

    q_publisherUrl 'Care este site-ul pe care sunt publicate datele?',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Datele sunt publicate pe',
      :help_text => 'Furnizați un URL al unui site web. Acest lucru ne ajută să grupăm date de la aceeași organizație, chiar dacă oamenii dau nume diferite.'
    a_1 'URL pentru Distribuitor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Distribuitor'

    q_releaseType 'Ce fel de versiune este aceasta?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'o versiune unică a unui singur set de date',
      :help_text => 'Aceasta este formată dintr-un singur fișier și nu aveți de gând în acest moment să publicați fișiere similare și în viitor.'
    a_collection 'o versiune unică a unui grup de seturi asociate de date',
      :help_text => 'Aceasta este o colecție de fișiere asociate ce se referă la același set de date și nu aveți de gând în acest moment să publicați colecții similare și în viitor.'
    a_series 'o versiune în curs de desfășurare, a unei serii de seturi de date asociate',
      :help_text => 'Aceasta este o succesiune de seturi de date cu reactualizări periodice planificate pentru viitor.'
    a_service 'un serviciu sau un API pentru accesarea datelor deschise',
      :help_text => 'Acesta este un serviciu web live, care expune datele dvs. programatorilor, printr-o interfață către care pot trimite comenzi.'

  end

  section_legal 'Informatii Legale',
    :description => 'Drepturi, licențieri și securitate' do

    label_group_2 'Drepturi',
      :help_text => 'dreptul dumneavoastră de a împărtăși aceste date',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Aveți dreptul de a publica aceste date ca date deschise?',
      :discussion_topic => :ro_publisherRights,
      :help_text => 'Dacă organizația dvs. nu a fost cea care a creat sau colectat aceste date inițial, atunci s-ar putea să nu aveți dreptul să le publicați. Dacă nu sunteți sigur, contactați proprietarul datelor, deoarece veți avea nevoie de permisiunea acestuia pentru a le publica.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'da, aveți dreptul de a publica aceste date ca date deschise',
      :requirement => ['standard_1']
    a_no 'nu, nu aveți dreptul de a publica aceste date ca date deschise'
    a_unsure 'nu sunteți sigur dacă aveți dreptul de a publica aceste date ca date deschise'
    a_complicated 'drepturile referitoare la aceste date sunt complicate sau neclare'

    label_standard_1 'Ar trebui să aveți <strong>dreptul legal clar de a publica aceste date</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'Trebuie să aveți <strong>dreptul de a publica aceste date</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Unde descrieți riscurile pe care oamenii le-ar putea avea în cazul în care folosesc aceste date?',
      :discussion_topic => :ro_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'Riscurile folosirii acestor date sunt descrise la',
      :help_text => 'Poate fi riscant pentru oameni să utilizeze datele fără un drept legal clar de a face acest lucru. De exemplu, datele ar putea fi date jos ca răspuns la o reclamație juridică. Furnizați o adresă URL pentru o pagină care descrie riscul folosirii acestor date.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'URL pentru Documentația Riscurilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentația Riscurilor',
      :requirement => ['pilot_2']

    label_pilot_2 'Ar trebui să documentați <strong>riscurile asociate cu utilizarea acestor date</strong>, astfel încât oamenii să poată decide modul în care doresc să le folosească.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Au fost <em>toate</em> aceste date create sau sau adunate inițial de dumneavoastră?',
      :discussion_topic => :ro_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date au fost',
      :help_text => 'În cazul în care orice parte din aceste date a fost obținută din afara organizației dvs., de la alte persoane sau organizații, atunci trebuie să oferiți informații suplimentare cu privire la dreptul dumneavoastră de a le publica.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'create sau generate inițial de curatorul acestora'

    q_thirdPartyOrigin 'O parte din aceste date a fost extrasă sau calculată din alte date?',
      :discussion_topic => :ro_thirdPartyOrigin,
      :help_text => 'Folosirea unui extract sau a unei mici părți din datele altcuiva înseamnă că drepturile dvs. de a utiliza aceste date ar putea fi afectate. Ar putea exista, de asemenea, probleme legale dacă ați analizat datele lor pentru a produce date noi.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'nu'
    a_true 'da',
      :requirement => ['basic_3']

    label_basic_3 'Ați spus că aceste date nu au fost create sau adunate inițial de dumneavoastră, și nu au fost obținute prin crowdsourcing, prin urmare au fost extrase sau calculate din alte surse de date.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen '
                        <em>Toate</em> sursele acestor date au fost deja publicate ca date deschise?',
      :discussion_topic => :ro_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date au fost create din',
      :help_text => 'Aveți voie să republicați datele altcuiva dacă sunt deja sub o licență de date deschise sau în cazul în care drepturile lor au expirat sau au fost anulate. Dacă oricare parte a acestor date nu îndeplinește aceste condiții, atunci veți avea nevoie de consultanță juridică înainte de a putea publica.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'surse de date deschise',
      :requirement => ['basic_4']

    label_basic_4 'Ar trebui să cereți <strong>consiliere juridică pentru a vă asigura că aveți dreptul de a publica aceste date</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'O parte din aceste date a fost obținută prin crowdsourcing?',
      :discussion_topic => :ro_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'O parte din aceste date este',
      :help_text => 'În cazul în care datele includ informații la care au contribuit persoane din afara organizației dumneavoastră, aveți nevoie de permisiunea lor pentru a le publica contribuțiile ca date deschise.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'obținută prin crowdsourcing',
      :requirement => ['basic_5']

    label_basic_5 'Ați spus că datele nu au fost create sau adunate inițial de dumneavoastră, și nu au fost extrase sau calculate din alte date, prin urmare au fost obținute prin crowdsourcing.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Cei care au contribuit la obținerea acestor date au folosit judecata lor?',
      :discussion_topic => :ro_crowdsourcedContent,
      :help_text => 'În cazul în care oamenii și-au folosit creativitatea sau judecata lor pentru a contribui date, atunci ei au drept de copyright asupra muncii lor. De exemplu, scrierea unei descrieri sau luarea unei decizii referitor la includerea unor date într-un set de date ar necesita judecată. Astfel colaboratorii trebuie să transfere sau să renunțe la drepturile lor, sau să vă licențieze datele înainte ca dumneavoastră să le publicați.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'nu'
    a_true 'da'

    q_claUrl 'Unde este Acordul asupra Licenței de Colaborator (ALC)?',
      :discussion_topic => :ro_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Acordul asupra Licenței de Colaborator se găsește la',
      :help_text => 'Furnizați un link către un acord care arată permisiunea colaboratorilor de a le reutiliza datele. Un ACL fie vă va transfera drepturile colaboratorilor, fie va anula drepturile lor, sau va licenția datele lor către dumneavoastră, pentru a le putea publica.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'URL pentru Acordul asupra Licenței de Colaborator',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Acordul asupra Licenței de Colaborator',
      :required => :required

    q_cldsRecorded 'Toți colaboratorii au acceptat Acordul asupra Licenței de Colaborator (ALC)?',
      :discussion_topic => :ro_cldsRecorded,
      :help_text => 'Verificați dacă toți colaboratorii au acceptat ALC înainte de a reutiliza sau republica contribuțiile lor. Trebuie să țineți o evidență a colaboratorilor și a celor care au fost sau nu de acord cu ALC.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'nu'
    a_true 'da',
      :requirement => ['basic_6']

    label_basic_6 'Trebuie să obțineți <strong>acceptul colaboratorilor referitor la Acordul asupra Licenței de Colaborator</strong> (ALC), care vă oferă dreptul de a publica munca lor ca date deschise.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Unde sunt descrise sursele acestor date?',
      :discussion_topic => :ro_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Sursele acestor date sunt descrise la',
      :help_text => 'Furnizați un URL care arată sursa datelor (proveniența lor), precum și drepturile sub care le publicați. Acest lucru îi ajută pe oameni să înțeleagă de unde provin datele.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'URL pentru Documentația Surselor de Date',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentația Surselor de Date',
      :requirement => ['pilot_3']

    label_pilot_3 'Ar trebui să documentați <strong>de unde provin datele și drepturile sub care le-ați publicat</strong>, astfel încât oamenii să se asigure că pot folosi părți provenite de la părți terțe.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Există documentație cu privire la sursele acestor date și în format lizibil pentru mașină?',
      :discussion_topic => :ro_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Curatorul a publicat',
      :help_text => 'Informațiile despre sursele datelor ar trebui să fie într-un format lizibil de către om, astfel încât oamenii să poată înțelege, precum și într-un format de metadate care poate fi prelucrat de computere. Când toată lumea face acest lucru, ajută alți oameni să afle cum este utilizat un anumit set de date deschise și să justifice continuarea publicării sale.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'date ce sunt lizibile pentru mașină despre sursele acestor date',
      :requirement => ['standard_2']

    label_standard_2 'Ar trebui <strong>să includeți date lizibile pentru mașină, cu privire la sursele acestor date</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Licențiere',
      :help_text => 'cum dați oamenilor permisiunea de a utiliza aceste date',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Unde ați publicat declarația drepturilor pentru acest set de date?',
      :discussion_topic => :ro_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'Declarația drepturilor se află la',
      :help_text => 'Furnizați un URL către o pagină care descrie dreptul de a reutiliza acest set de date. Aceasta ar trebui să includă o referire la licența sa, cerințele de atribuire, precum și o declarație cu privire la copyright și la drepturile asupra bazelor de date relevante. O declarație a drepturilor îi ajută pe oameni să înțeleagă ceea ce pot sau nu pot face cu datele.'
    a_1 'URL pentru Declarația Drepturilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Declarația Drepturilor',
      :requirement => ['pilot_4']

    label_pilot_4 'Ar trebui <strong>să publicați o declarație de drepturi</strong> care detaliază copyright-ul, drepturile asupra bazelor de date, acordarea licențelor și modul în care oamenii ar trebui să facă atribuirea datelor.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Sub ce licență pot oamenii reutiliza aceste date?',
      :discussion_topic => :ro_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt disponibile sub',
      :help_text => 'Amintiți-vă că oricine adună, creează, verifică sau prezintă o bază de date inițial, deține în mod automat drepturile pentru acel lucru. Poate exista de asemenea copyright în organizarea și selectarea datelor. Așa că, oamenii au nevoie de o anulare a acelor drepturi sau o licență care dovedește că ei pot utiliza datele și care explica modul în care aceasta se poate face legal. Vom enumera cele mai frecvente licențe aici; în cazul în care nu există drepturi asupra bazelor de date sau copyright, acestea au expirat, sau le-ați anulat, alegeți "Nu este aplicabil".',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc_by 'Creative Commons Attribution',
      :text_as_statement => 'Creative Commons Attribution'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike',
      :text_as_statement => 'Creative Commons Attribution Share-Alike'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_odc_by 'Open Data Commons Attribution License',
      :text_as_statement => 'Open Data Commons Attribution License'
    a_odc_odbl 'Open Data Commons Open License Database (ODbL)',
      :text_as_statement => 'Open Data Commons Open License Database (ODbL)'
    a_odc_pddl 'Dedicație Open Data Commons Domeniului Public și de licență (PDDL)',
      :text_as_statement => 'Dedicație Open Data Commons Domeniului Public și de licență (PDDL)'
    a_na 'Nu este aplicabil',
      :text_as_statement => ''
    a_other 'Altele...',
      :text_as_statement => ''

    q_dataNotApplicable 'De ce nu se poate aplica o licență pentru aceste date?',
      :discussion_topic => :ro_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date nu sunt licențiate pentru că',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'nu există copyright sau drepturi asupra bazei de date aplicabile acestor date',
      :text_as_statement => 'nu există drepturi în ea',
      :help_text => 'Drepturile asupra bazelor de date se aplică în cazul în care ați depus un efort substanțial în procesul de adunare, verificare sau prezentare a datelor. Nu există drepturi asupra bazelor de date dacă, de exemplu, acestea sunt create de la zero, prezentate într-un mod evident, și nu sunt verificate prin raportare la ceva preexistent. Aveți drepturi de autor dacă selectați elemente din acele date sau le organizați într-un mod neevident.'
    a_expired 'copyright-ul și drepturile asupra bazelor de date au expirat',
      :text_as_statement => 'drepturile au expirat',
      :help_text => 'Drepturile asupra bazelor de date durează zece ani. În cazul în care datele au fost modificate ultima dată în urmă cu peste zece ani, atunci drepturile asupra bazelor de date au expirat. Copyright-ul durează un timp fix, bazat fie pe numărul de ani de la moartea creatorului sau de la publicare. Este puțin probabil să expire copyright-ul.'
    a_waived 'copyright-ul și drepturile asupra bazelor de date au fost anulate',
      :text_as_statement => '',
      :help_text => 'Aceasta înseamnă că nimeni nu deține drepturile și oricine poate să facă ce vrea cu aceste date.'

    q_dataWaiver 'Ce declarație de renunțare utilizați pentru a anula drepturi asupra datelor?',
      :discussion_topic => :ro_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Drepturile asupra datelor au fost anulate cu',
      :help_text => 'Aveți nevoie de o declarație pentru a arăta oamenilor că s-a renunțat la drepturi, astfel încât aceștia să înțeleagă că pot face orice cu aceste date. Declarații de renunțare standard exista deja, precum PDDL și CCZero dar puteți scrie propria dvs. declarație, având consiliere juridică.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Altele...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Unde este declarația de renunțare la drepturile asupra datelor?',
      :discussion_topic => :ro_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Drepturile asupra datelor au fost anulate cu',
      :help_text => 'Furnizați un URL pentru declarația de renunțare, accesibilă public, astfel încât oamenii să poată verifica dacă acesta anulează drepturile asupra datelor.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'URL pentru Declarația de Renunțare',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL pentru Declarația de Renunțare'

    q_otherDataLicenceName 'Care este numele licenței?',
      :discussion_topic => :ro_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt disponibile sub',
      :help_text => 'Dacă utilizați o altă licență, avem nevoie de numele acesteia, astfel încât oamenii să îl poată vedea pe Certificatul de Date Deschise pe care îl veți avea.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Alte nume de licență',
      :string,
      :required => :required,
      :placeholder => 'Alte nume de licență'

    q_otherDataLicenceURL 'Unde este licența?',
      :discussion_topic => :ro_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Această licență se află la',
      :help_text => 'Furnizați un URL pentru licență, astfel încât oamenii să o poată vedea pe Certificatul dumneavoastră de Date Deschise și să verifice dacă este făcută publică.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'URL pentru licența alternativă',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL pentru licența alternativă'

    q_otherDataLicenceOpen 'Este licența o licență deschisă?',
      :discussion_topic => :ro_otherDataLicenceOpen,
      :help_text => 'Dacă nu sunteți sigur ce este o licență deschisă, citiți <a href="http://opendefinition.org/">Open Knowledge Definition</a>. Apoi, alegeți-vă licența de la <a href="http://licenses.opendefinition.org/">Open Definition Advisory Board open licence list</a>. În cazul în care o licență nu este în lista lor, înseamnă că aceasta nu este o licență deschisă sau nu a fost evaluată încă.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'nu'
    a_true 'da',
      :requirement => ['basic_7']

    label_basic_7 'Trebuie să <strong>publicați datele deschise sub o licență deschisă</strong>, astfel încât oamenii să le poată folosi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'Exista drepturi de autor în conținutul acestor date?',
      :discussion_topic => :ro_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Sunt',
      :pick => :one,
      :required => :required
    a_norights 'nu, datele conțin doar fapte și numere',
      :text_as_statement => 'lipsite de drepturi în conținutul datelor',
      :help_text => 'Nu există copyright în informațiile factuale. În cazul în care datele nu au conținut creat printr-un efort intelectual, nu există drepturi în acestea.'
    a_samerights 'da, și toate drepturile sunt deținute de aceeași persoană sau organizație',
      :text_as_statement => '',
      :help_text => 'Alegeți această opțiune în cazul în care conținutul tuturor datelor a fost creat sau transferat de către aceeași persoană sau organizație.'
    a_mixedrights 'da, iar drepturile sunt deținute de persoane sau organizații diferite',
      :text_as_statement => '',
      :help_text => 'În unele colecții de date, drepturile din diferite recorduri sunt deținute de persoane sau organizații diferite. Informațiile despre drepturi trebuie să fie păstrate tot în cadrul datelor.'

    q_explicitWaiver 'Conținutul datelor este marcat ca făcând parte din domeniul public?',
      :discussion_topic => :ro_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Conținutul a fost',
      :help_text => 'Conținutul poate fi marcat ca făcând parte din domeniul public, folosind <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark</a>. Acest lucru ajută oamenii să știe că acesta poate fi reutilizat în mod liber.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'marcat ca făcând parte din domeniul public',
      :requirement => ['standard_3']

    label_standard_3 'Ar trebui <strong>să marcați conținutul ce ține de domeniul public ca făcând parte din domeniul public</strong>, astfel încât oamenii să știe că îl pot reutiliza.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Sub ce licență pot alții reutiliza conținutul?',
      :discussion_topic => :ro_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Conținutul este disponibil sub',
      :help_text => 'Țineți minte că oricine depunde efort intelectual pentru crearea de conținut, în mod automat deține drepturi asupra lui, dar conținutul creativ nu include fapte. Deci, oamenii au nevoie de o declarație de renunțare la drepturi sau o licență care dovedește că ei pot folosi conținutul și explică modul în care pot face acest lucru în mod legal. Vom enumera cele mai frecvente licențe aici; în cazul în care nu există copyright în conținut, este expirat, sau l-ați anulat, alegeți "Nu este aplicabil".',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Creative Commons Attribution',
      :text_as_statement => 'Creative Commons Attribution'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike',
      :text_as_statement => 'Creative Commons Attribution Share-Alike'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_na 'Nu este aplicabil',
      :text_as_statement => ''
    a_other 'Altele...',
      :text_as_statement => ''

    q_contentNotApplicable 'De ce nu se poate aplica o licență conținutului datelor?',
      :discussion_topic => :ro_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Conținutul acestor date nu are licență pentru că',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'nu există copyright în conținutul acestor date',
      :text_as_statement => 'nu există copyright',
      :help_text => 'Copyright-ul se aplică numai în cazul conținutului realizat cu efort intelectual, de exemplu, prin scrierea de text în interiorul datelor. Nu există copyright în cazul în care sunt conținute doar fapte.'
    a_expired 'copyright-ul a expirat',
      :text_as_statement => 'copyright-ul a expirat',
      :help_text => 'Copyright-ul dureaza o perioadă de timp fixă, bazată fie pe numărul de ani de la moartea creatorului sau de la publicare. Ar trebui să verificați data la care a fost creat sau publicat conținutul, deoarece în cazul în care s-a întâmplat cu mult timp în urmă, copyright-ul poate să fie expirat.'
    a_waived 'copyright-ul a fost anulat',
      :text_as_statement => '',
      :help_text => 'Aceasta înseamnă că nimeni nu deține copyright și oricine poate să facă ce vrea cu aceste date.'

    q_contentWaiver 'Ce declarație de renunțare utilizați pentru a renunța la copyright?',
      :discussion_topic => :ro_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Copyright-ul a fost anulat cu',
      :help_text => 'Aveți nevoie de o declarație pentru a arăta oamenilor că ați făcut acest lucru, astfel încât aceștie să înțeleagă că pot face orice cu aceste date. Declarații de renunțare standard, există deja, de exemplu CCZero, dar puteți scrie propria declarație, utilizând consultanța juridică.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Altele...',
      :text_as_statement => 'Altele...'

    q_contentOtherWaiver 'Unde este declarația de renunțare la copyright?',
      :discussion_topic => :ro_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Copyright-ul a fost anulat cu',
      :help_text => 'Furnizați un URL pentru declarația proprie și publică de renunțare la drepturi, astfel încât oamenii să poată verifica dacă aceasta anulează copyright-ul.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'URL pentru Declarația de Renunțare la Drepturi',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL pentru Declarația de Renunțare la Drepturi'

    q_otherContentLicenceName 'Care este numele licenței?',
      :discussion_topic => :ro_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Conținutul este disponibil sub',
      :help_text => 'Dacă utilizați o altă licență, avem nevoie de numele acesteia, pentru ca oamenii să-l poată vedea pe Certificatul dumneavoastră de Date Deschise.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Numele Licenței',
      :string,
      :required => :required,
      :placeholder => 'Numele Licenței'

    q_otherContentLicenceURL 'Unde este licența?',
      :discussion_topic => :ro_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Conținutul licenței se află la',
      :help_text => 'Furnizați un URL pentru licență, pentru ca oamenii să-l poată vedea pe Certificatul dumneavoastră de Date Deschise și să verifice dacă este făcut public.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL pentru Licență',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL pentru Licență'

    q_otherContentLicenceOpen 'Licența este o licență deschisă?',
      :discussion_topic => :ro_otherContentLicenceOpen,
      :help_text => 'Dacă nu sunteți sigur ce este o licență deschisă, citiți <a href="http://opendefinition.org/">Open Knowledge Definition</a>. Apoi, alegeți licența de la <a href="http://licenses.opendefinition.org/">Open Definition Advisory Board open licence list</a>. În cazul în care o licență nu este în lista lor, înseamnă că nu este o licență deschisă sau nu a fost evaluată încă.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'nu'
    a_true 'da',
      :requirement => ['basic_8']

    label_basic_8 'Trebuie <strong>să publicați datele deschise sub o licență deschisă</strong>, astfel încât oamenii să le poată folosi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Unde sunt explicate drepturile și licența asupra conținutului?',
      :discussion_topic => :ro_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'Drepturile și licența asupra conținutului sunt explicate la',
      :help_text => 'Furnizați URL-ul către o pagină ce descrie modul în care cineva poate afla drepturile și licența acordate pentru o parte din conținutul datelor.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'URL pentru Descrierea Drepturilor asupra Conținutului',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL pentru Descrierea Drepturilor asupra Conținutului'

    q_copyrightStatementMetadata 'Declarația dumneavoastră de drepturi include versiuni lizibile pentru mașini pentru',
      :discussion_topic => :ro_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Declarația drepturilor cuprinde date despre',
      :help_text => 'Este o practică bună să încorporați informații cu privire la drepturi în formate lizibile pentru mașini, pentru ca oamenii să poată să vă atribuiască în mod automat aceste date, atunci când le folosesc.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'licență de date',
      :text_as_statement => 'licența de date',
      :requirement => ['standard_4']
    a_contentLicense 'licența conținutului',
      :text_as_statement => 'licența conținutului',
      :requirement => ['standard_5']
    a_attribution 'text de atribuire',
      :text_as_statement => 'ce text de atribuire se utilizează',
      :requirement => ['standard_6']
    a_attributionURL 'URL pentru atribuire',
      :text_as_statement => 'ce link de atribuire trebuie să dați',
      :requirement => ['standard_7']
    a_copyrightNotice 'notificare de copyright sau declarație',
      :text_as_statement => 'o notificare de copyright sau o declarație',
      :requirement => ['exemplar_1']
    a_copyrightYear 'anul de copyright',
      :text_as_statement => 'anul de copyright',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'deținătorul copyright-ului',
      :text_as_statement => 'deținătorul copyright-ului',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'an de drept asupra bazei de date',
      :text_as_statement => 'anul de drept asupra bazei de date',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'titularul dreptului asupra bazei de date',
      :text_as_statement => 'titularul dreptului asupra bazei de date',
      :requirement => ['exemplar_5']

    label_standard_4 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi și licență</strong> a datelor publicate, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturile și licența asupra conținutului</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la textul utilizat atunci când citați datele</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la link-ul utilizat atunci când citați datele</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la declarația sau notificarea de copyright pentru aceste date</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la anul de copyright, pentru aceste date</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la deținătorul copyright-ului pentru aceste date</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la anul de drept asupra bazei de date, pentru aceste date</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'Ar trebui să furnizați <strong>date lizibile pentru mașini, în cadrul declarației dumneavoastră despre drepturi, cu privire la titularul dreptului asupra bazei de date, pentru aceste date</strong>, pentru a putea fi folosite de utilitare automate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Confidențialitatea',
      :help_text => 'cum protejați intimitatea oamenilor',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Pot fi identificate persoane în cadrul acestor date?',
      :discussion_topic => :ro_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date conțin',
      :pick => :one,
      :required => :pilot
    a_not_personal 'nu, datele nu sunt despre persoane sau activitățile lor',
      :text_as_statement => 'nu există date cu privire la persoane',
      :help_text => 'Amintiți-vă că persoanele pot fi identificate, chiar dacă datele nu sunt despre ele în mod direct. De exemplu, datele privind fluxul de trafic rutier combinate cu tiparul de navetă al unui individ ar putea dezvălui informații despre acea persoană.'
    a_summarised 'nu, datele au fost anonimizate prin agregarea indivizilor în grupuri, astfel încât aceștia nu pot fi deosebiți de alte persoane din grup',
      :text_as_statement => 'agregate de date',
      :help_text => 'Controale statistice de dezvăluire a informațiilor pot ajuta pentru a asigura că indivizii nu sunt identificabili în datele agregate.'
    a_individual 'da, există riscul ca persoanele să fie identificate de exemplu, de către terți cu acces la informații suplimentare',
      :text_as_statement => 'informații care ar putea identifica persoanele',
      :help_text => 'Unele date sunt în mod legitim cu privire la persoane cum ar fi salarizarea funcționarilor publici sau cheltuielile publice.'

    q_statisticalAnonAudited 'Procesul dumneavoastră de anonimizare a fost auditat independent?',
      :discussion_topic => :ro_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Procesul de anonimizare a fost',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'auditat independent',
      :requirement => ['standard_8']

    label_standard_8 'Ar trebui <strong>ca procesul de anonimizare folosit de dumneavoastră să fie auditat independent</strong> pentru asigurarea reducerii riscului ca persoanele să fie reidentificate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Ați încercat să reduceți sau să eliminați posibilitatea ca persoanele să fie identificate?',
      :discussion_topic => :ro_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date despre persoane au fost',
      :help_text => 'Anonimizarea reduce riscul ca persoanele să fie identificate din datele pe care le publicați. Cea mai bună tehnică de utilizat depinde de tipul de date pe care îl aveți.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'anonimizate'

    q_lawfulDisclosure 'Este impus sau permis de lege să publicați aceste date despre persoane?',
      :discussion_topic => :ro_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Prin lege, aceste date despre persoane',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'trebuie să fie publicate',
      :requirement => ['pilot_5']

    label_pilot_5 'Nu ar trebui <strong>să publicați datele cu caracter personal cu anonimizare, dacă vi se cere sau vi se permite să faceți acest lucru prin lege</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Unde documentați dreptul de a publica date despre persoane?',
      :discussion_topic => :ro_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'Dreptul de a publica aceste date cu privire la persoane este documentat la'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL pentru Motivarea Publicării',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Motivarea Publicării',
      :requirement => ['standard_9']

    label_standard_9 'Ar trebui <strong>să documentați dreptul de a publica date despre persoane</strong> pentru oamenii care folosesc datele și pentru cei afectați de publicare.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Ați evaluat riscurile publicării datelor cu caracter personal?',
      :discussion_topic => :ro_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'Curatorul',
      :help_text => 'O evaluare a riscurilor măsoară riscurile pentru confidențialitatea persoanelor din datele dumneavoastră, precum și utilizarea și publicarea acestor informații.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'nu',
      :text_as_statement => 'nu a efectuat o evaluare a riscurilor de confidențialitate'
    a_true 'da',
      :text_as_statement => 'a efectuat o evaluare a riscurilor de confidențialitate',
      :requirement => ['pilot_6']

    label_pilot_6 'Ar trebui <strong>să evaluați riscurile de publicare a datelor cu caracter personal</strong> dacă publicați date despre persoane.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Unde este publicată evaluarea riscurilor?',
      :discussion_topic => :ro_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Evaluarea riscurilor este publicată la',
      :help_text => 'Furnizați un URL ca locație pentru verificarea modului în care s-au evaluat riscurile de confidențialitate pentru persoane. Acesta poate fi redactată sau rezumată în cazul în care conține informații sensibile.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL pentru Evaluarea Riscurilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Evaluarea Riscurilor',
      :requirement => ['standard_10']

    label_standard_10 'Ar trebui <strong>să publicați evaluarea riscului de confidențialitate</strong>, astfel încât oamenii să poată înțelege modul în care ați evaluat riscurile de publicare a datelor.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Evaluarea riscului a fost auditată independent?',
      :discussion_topic => :ro_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Evaluarea riscurilor a fost',
      :help_text => 'Este o bună practică să verificați dacă evaluarea riscului a fost făcută în mod corect. Audituri independente făcute de specialiști sau de părți terțe tind să fie mai riguroase și mai imparțiale.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'auditată independent',
      :requirement => ['standard_11']

    label_standard_11 'Ar trebui <strong>să aveți evaluarea riscului auditată independent</strong> pentru a se asigura efectuarea ei în mod corect.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Unde este notificarea de confidențialitate pentru persoanele afectate de datele dumneavoastră?',
      :discussion_topic => :ro_individualConsentURL,
      :display_on_certificate => true,
      :text_as_statement => 'Persoanele afectate de aceste date primesc această notificare de confidențialitate',
      :help_text => 'Când colectați date despre persoane, trebuie să le spuneți cum vor fi utilizate. Oamenii care folosesc datele dumneavoastră au nevoie de acest lucru pentru a se asigura că respectă legislația privind protecția datelor.'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    a_1 'URL pentru Notificarea de Confidențialitate',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Notificarea de Confidențialitate',
      :requirement => ['pilot_7']

    label_pilot_7 'Ar trebui <strong>să spuneți oamenilor în ce scopuri au fost de acord persoanele ca dumneavoastră să le folosiți datele</strong>, astfel încât aceștia să folosească datele în aceleași scopuri și în conformitate cu legislația privind protecția datelor.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    condition_F :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Este cineva din organizația dumneavoastră responsabil de protecția datelor?',
      :discussion_topic => :ro_dpStaff,
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'nu'
    a_true 'da'

    q_dbStaffConsulted 'I-ați implicat în procesul de evaluare a riscurilor?',
      :discussion_topic => :ro_dbStaffConsulted,
      :display_on_certificate => true,
      :text_as_statement => 'Persoana responsabilă de protecția datelor',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'a fost consultată',
      :requirement => ['pilot_8']

    label_pilot_8 'Ar trebui <strong>să implicați persoana responsabilă de protecția datelor</strong> în organizația dumneavoastră înainte de a publica aceste date.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Abordarea anonimizării a fost auditată independent?',
      :discussion_topic => :ro_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Anonimizarea datelor a fost',
      :help_text => 'Este o bună practică să vă asigurați că procesul de a elimina datele de identificare personală funcționează în mod corespunzător. Audituri independente făcute de specialiști sau de părți terțe tind să fie mai riguroase și mai imparțiale.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'auditată independent',
      :requirement => ['standard_12']

    label_standard_12 'Ar trebui <strong>să aveți procesul de anonimizare auditat independent</strong> de un expert pentru a vă asigura că este adecvat pentru datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Informații Practice',
    :description => 'Găsire ușoară, acuratețe, calitate și garanție' do

    label_group_6 'Găsirea ușoară',
      :help_text => 'cum ajutați oamenii să vă găsească datele',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Există un link la datele dvs. de pe site-ul dvs. principal?',
      :discussion_topic => :onWebsite,
      :help_text => 'Datele pot fi găsite mai ușor dacă există un link către ele pe site-ul dvs. principal.',
      :pick => :one
    a_false 'nu'
    a_true 'da',
      :requirement => ['standard_13']

    label_standard_13 'Ar trebui <strong>să vă asigurați că oamenii pot găsi datele direct din site-ul dvs. principal</strong>, astfel încât să poată fi găsite mai ușor.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Pagina Web' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Care pagină din site-ul dvs. conține link către date?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'Site-ul conține link către date la',
        :help_text => 'Puneți un URL pe site-ul principal, care să includă un link la aceste date.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'URL pentru Pagina Web.',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL pentru Pagina Web.'

    end

    q_listed 'Datele dumneavoastră sunt listate într-o colecție?',
      :discussion_topic => :listed,
      :help_text => 'Date sunt mai ușor de găsit atunci când sunt în cataloage de date relevante cum ar fi sectorul public, academic sau de sănătate, sau atunci când sunt găsite în rezultatele unei căutări relevante.',
      :pick => :one
    a_false 'nu'
    a_true 'da',
      :requirement => ['standard_14']

    label_standard_14 'Ar trebuie <strong>să vă asigurați că oamenii pot găsi datele dvs. atunci când le caută </strong>în locații care listează date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listare' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Unde sunt listate?',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'Datele apar în această colecție',
        :help_text => 'Furnizați un URL pentru locația în care aceste date sunt listate într-o colecție relevantă. De exemplu, data.gov.ro (daca sunt date din sectorul public al României), hub.data.ac.uk (daca sunt date din mediul academic, pentru Marea Britanie) sau un URL pentru rezultatele unui motor de căutare.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'URL pentru Listare',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL pentru Listare'

    end

    q_referenced 'Există referință la aceste date în publicațiile proprii?',
      :discussion_topic => :referenced,
      :help_text => 'Când faceți referință la date în propriile publicații precum rapoarte, prezentări sau posturi pe blog, le oferiți context și îi ajutați pe oamenii să le găsească și să le înțeleagă mai bine.',
      :pick => :one
    a_false 'nu'
    a_true 'da',
      :requirement => ['standard_15']

    label_standard_15 'Ar trebui <strong>să faceți referință la date în publicațiile proprii</strong>, pentru ca oamenii să afle de disponibilitatea și contextul lor.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Referință' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Unde există referința către datele dumneavoastră?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Aceste date au referința la',
        :help_text => 'Furnizați un URL la un document care citează sau trimite către aceste date.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL pentru Referință',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL pentru Referință'

    end

    label_group_7 'Acuratețe',
      :help_text => 'cum vă păstrați datele la zi',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Se schimbă datele din spatele API-ului?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'Datele din spatele API-ului',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'nu, API-ul oferă acces la date ce nu se vor schimba',
      :text_as_statement => 'nu se vor schimba',
      :help_text => 'Unele API-uri fac accesarea unui set de date neschimbătoare mai ușoară, mai ales atunci când acestea sunt numeroase.'
    a_changing 'da, API-ul oferă acces la date în curs de schimbare',
      :text_as_statement => 'se vor schimba',
      :help_text => 'Unele API-uri oferă acces instantaneu la date curente și în continuă schimbare'

    q_timeSensitive 'Datele dumneavoastră vor ieși din uz?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'Acuratețea sau relevanța acestor date va',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'da, aceste date vor ieși din uz',
      :text_as_statement => 'ieși din uz',
      :help_text => 'De exemplu, un set de date cu stațiile autobuzelor va ieși din uz în timp, fiindcă unele vor fi mutate sau altele noi create.'
    a_timestamped 'da, aceste date vor ieși din uz în timp, dar ele sunt notate cu momentul exact al publicării (time stamped).',
      :text_as_statement => 'ieși din uz, dar ele sunt notate cu momentul exact al publicării (time stamped).',
      :help_text => 'De exemplu, statistica populației include de obicei momentul exact al publicării pentru a indica momentul în care statisticile au fost relevante.',
      :requirement => ['pilot_9']
    a_false 'nu, aceste date nu conțin informații sensibile la trecerea timpului',
      :text_as_statement => 'nu va ieși din uz',
      :help_text => 'De exemplu, rezultatele unui experiment nu vor ieși din uz, deoarece datele rapoartează cu exactitate rezultatele observate.',
      :requirement => ['standard_16']

    label_pilot_9 'Ar trebui <strong>să puneți momentul exact al publicării datelor dumneavoastră atunci când le publicați</strong>, astfel încât oamenii să știe perioada de timp la care se referă și data expirării.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'Ar trebui <strong>să reactualizați datele sensibile la trecerea timpului</strong>, astfel încât să nu devină învechite.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Această modificare a datelor are loc cel puțin zilnic?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date se modifică',
      :help_text => 'Spuneți-le oamenilor în cazul în care schimbările datelor au loc aproape zilnic. Atunci când datele se schimbă frecvent, acestea ies din uz mai rapid, astfel încât oamenii trebuie să știe dacă și dumneavoastră le actualizați frecvent și rapid.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'cel puțin zilnic'

    q_seriesType 'Ce tip de serie de seturi de date este aceasta?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt o serie de',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'copii frecvente ale unei baze complete de date',
      :text_as_statement => 'copies of a database',
      :help_text => 'Alegeți dacă publicați copii noi și actualizate ale bazei dumneavoastră complete de date, în mod regulat. Când creați o copie a unei baze de date în format de export (dump), este util ca oamenii să aibă acces la fluxul de schimbări, pentru a-și putea ține copiile la curent.'
    a_aggregate 'agregate frecvente de date în schimbare',
      :text_as_statement => 'agregate de date în schimbare',
      :help_text => 'Alegeți dacă veți crea noi seturi de date în mod regulat. S-ar putea să faceți acest lucru dacă datele nu pot fi publicate ca date deschise sau dacă publicați doar datele noi de la ultima publicare.'

    q_changeFeed 'Este disponibil vreun flux de schimbări?',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'Un flux de modificări ale acestor date',
      :help_text => 'Spuneți-le oamenilor, dacă oferiți fluxul de modificări care afectează aceste date, cum ar fi înregistrări noi sau modificări ale înregistrărilor existente. Fluxul ar putea fi în format RSS, Atom sau alt format.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'este disponibil',
      :requirement => ['exemplar_6']

    label_exemplar_6 'Ar trebui <strong>să asigurați un flux de modificări la datele dvs.</strong>, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Cât de des creați o nouă versiune?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Noi versiuni ale acestor date sunt făcute',
      :help_text => 'Aceasta determină cât de ieșite din uz devin datele înainte ca oamenii să poată obține o reactualizare.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'mai puțin de o dată pe lună',
      :text_as_statement => 'mai puțin de o dată pe lună'
    a_monthly 'cel puțin o dată pe lună',
      :text_as_statement => 'cel puțin o dată pe lună',
      :requirement => ['pilot_10']
    a_weekly 'cel puțin o dată pe săptămână',
      :text_as_statement => 'cel puțin o dată pe săptămână',
      :requirement => ['standard_17']
    a_daily 'cel puțin o dată pe zi',
      :text_as_statement => 'cel puțin o dată pe zi',
      :requirement => ['exemplar_7']

    label_pilot_10 'Ar trebui <strong>să creați o nouă versiune a setului de date în fiecare lună</strong>, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Ar trebui <strong>să creați o nouă versiune a setului de date în fiecare săptămână</strong>, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'Ar trebui <strong>să creați o nouă versiune a setului de date în fiecare zi</strong>, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Cât timp trece de la momentul în care creați un set de date până la momentul în care publicați acel set?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'Decalajul dintre creația și publicarea acestor date este',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'mai mult decât perioada de timp dintre versiunile publicate',
      :text_as_statement => 'mai mult decât perioada de timp dintre versiunile publicate',
      :help_text => 'De exemplu, dacă dumneavoastră creați o nouă versiune a setului de date în fiecare zi, alegeți acest lucru dacă aveți nevoie de mai mult de o zi pentru a-l publica.'
    a_reasonable 'aproximativ aceeași cu perioada de timp dintre versiunile publicate',
      :text_as_statement => 'aproximativ aceeași cu perioada de timp dintre versiunile publicate',
      :help_text => 'De exemplu, dacă dumneavoastră creați o nouă versiune a setului de date în fiecare zi, alegeți acest lucru dacă aveți nevoie de aproximativ o zi pentru a-l publica.',
      :requirement => ['pilot_11']
    a_good 'mai puțin de jumătate din decalajul dintre versiunile publicate',
      :text_as_statement => 'mai puțin de jumătate din decalajul dintre versiunile publicate',
      :help_text => 'De exemplu, dacă dumneavoastră creați o nouă versiune a setului de date în fiecare zi, alegeți acest lucru, dacă este nevoie de mai puțin de douăsprezece ore pentru ca acesta să fie publicată.',
      :requirement => ['standard_18']
    a_minimal 'decalajul este minim sau nu există',
      :text_as_statement => 'minim',
      :help_text => 'Alegeți această opțiune dacă publicați în câteva secunde sau câteva minute.',
      :requirement => ['exemplar_8']

    label_pilot_11 'Ar trebui <strong>să aveți un decalaj rezonabil între momentul creării și momentul publicării unui set de date</strong>, care ar trebui să fie mai mic decât diferența dintre versiunile publicate, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Ar trebui <strong>să aveți un decalaj scurt între momentul creării și momentul publicării unui set de date</strong>, care ar trebui să fie mai mic decât jumătate din decalajul dintre versiunile publicate, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'Ar trebui <strong>să aveți un decalaj minim sau inexistent între momentul creării și momentul publicării unui set de date</strong>, astfel încât oamenii să-și păstreze copiile la curent și exacte.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Publicați și dumps (copii ale setului de date în format pentru export) ale acestui set de date?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'Curatorul publică',
      :help_text => 'Un dump este un extras conținând întregul set de date într-un fișier pe care oamenii îl pot descărca. Acesta permite oamenilor să facă analize diferite de cele prin acces API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'copii ale datelor în format pentru export',
      :requirement => ['standard_19']

    label_standard_19 'Ar trebui <strong>să lăsați oamenii să descarce întregul set de date</strong>, astfel încât să poată face o analiză mai completă și exactă, cu toate datele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'Cât de des creați un dump al bazelor de date?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Dumps ale bazelor de date sunt create',
      :help_text => 'Acces mai rapid la extracte frecvente ale întregului set de date înseamnă că oamenii pot începe mai rapid lucrul cu cele mai recente informații.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'mai rar de o dată pe lună',
      :text_as_statement => 'mai rar de o dată pe lună'
    a_monthly 'cel puțin o dată pe lună',
      :text_as_statement => 'cel puțin o dată pe lună',
      :requirement => ['pilot_12']
    a_weekly 'în termen de o săptămână de la orice schimbare',
      :text_as_statement => 'în termen de o săptămână de la orice schimbare',
      :requirement => ['standard_20']
    a_daily 'într-o zi de la orice schimbare',
      :text_as_statement => 'într-o zi de la orice schimbare',
      :requirement => ['exemplar_9']

    label_pilot_12 'Ar trebui <strong>să creați un nou dump în fiecare lună</strong>, astfel încât oamenii să aibă cele mai recente date.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Ar trebui <strong>să creați un nou dump în termen de o săptămână de la orice modificare</strong>, astfel încât oamenii să aibă mai puțin timp de așteptat pentru cele mai recente date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'Ar trebui <strong>să creați un nou dump într-o zi de la orice modificare</strong>, astfel încât oamenilor să le fie ușor să obțină cele mai recente date.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Vor fi corectate datele dumneavoastră în cazul în care conțin erori?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Orice erori din aceste date sunt',
      :help_text => 'Este o bună practică să remediați erorile din date, mai ales daca le folosiți și dumneavoastră. Oamenii ar trebui să știe când faceți corecții.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'corectate',
      :requirement => ['standard_21']

    label_standard_21 'Ar trebuie <strong>să corectați datele atunci când oamenii raportează erori</strong> așa încât toată lumea beneficiază de aceste îmbunătățiri în acuratețe.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Calitate',
      :help_text => 'cât de mult se pot baza oamenii pe datele dumneavoastră',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Unde documentați problemele legate de calitatea acestor date?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Calitatea datelor este documentată la',
      :help_text => 'Furnizați un URL pentru locul în care oamenii pot afla despre calitatea datelor. Oamenii acceptă că erorile sunt inevitabile, de la defecțiuni de echipament până la greșeli care se întâmplă în migrații dintre sisteme. Ar trebui să fiți deschis cu privire la calitatea datelor, astfel încât oamenii să poată știi cât de mult să se bazeze pe ele.'
    a_1 'URL pentru Documentarea Calității Datelor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentarea Calității Datelor',
      :requirement => ['standard_22']

    label_standard_22 'Ar trebui <strong>să documentați orice probleme cunoscute referitoare la calitatea datelor</strong>, astfel încât oamenii să poată decide cât de multă încredere să aibă în acestea.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Unde este descris procesul dumneavoastră de control al calității?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Procesele de control al calității sunt descrise la',
      :help_text => 'Furnizați un URL pentru ca oamenii să știe despre controalele în curs de desfășurare cu privire la datele dumneavoastră, fie ele automate sau manuale. Acest lucru îi reasigură că luați în serios calitatea și încurajează îmbunătățirile de care va beneficia toată lumea.'
    a_1 'URL pentru Descrierea Procesului de Control al Calității',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Descrierea Procesului de Control al Calității',
      :requirement => ['exemplar_10']

    label_exemplar_10 'Ar trebui <strong>să vă documentați procesul de control al calității</strong>, astfel încât oamenii să poată decide cât de mult să aibă încredere în datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garanții',
      :help_text => 'cât de mult pot oamenii să depindă de disponibilitatea datelor dumneavoastră',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Vă creați o copie de rezervă a datelor în afara sitului (clădirii)?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'Datele sunt',
      :help_text => 'Făcând în mod regulat copii de rezervă vă asigurați că datele nu vor fi pierdute în caz de accident.',
      :pick => :one
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'susținute și în afara sitului',
      :requirement => ['standard_23']

    label_standard_23 'Ar trebui <strong>să faceți o copie de rezervă în afara sitului</strong>, pentru a vă asigura că datele nu se vor pierde în cazul în care se întâmplă un accident.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Unde descrieți garanțiile cu privire la disponibilitatea serviciului?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Disponibilitatea serviciului este descrisă la',
      :help_text => 'Furnizați un URL pentru o pagină care descrie garanțiile pe care le dați că serviciul dumneavoastră va fi disponibil pentru utilizare. De exemplu, este posibil să garantați că serviciul va fi disponibil 99,5% din timp, sau s-ar putea să nu oferiți nicio garanție.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL pentru Documentarea Disponibilității Serviciului',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentarea Disponibilității Serviciului',
      :requirement => ['standard_24']

    label_standard_24 'Ar trebuii <strong>să descrieți ce garanții aveți referitor la disponibilitatea serviciilor</strong>, astfel încât oamenii să știe cât de mult se pot baza pe ele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Unde oferiți informații despre starea actuală a serviciului?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Statusul serviciului este oferit la',
      :help_text => 'Furnizați un URL pentru o pagină cu starea curentă a serviciului, inclusiv cu problemele acestuia, de care sunteți conștient.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL pentru Statusul Serviciului',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Statusul Serviciului',
      :requirement => ['exemplar_11']

    label_exemplar_11 'Ar trebui <strong>să aveți o pagină cu statusul serviciului</strong> care să le spună oamenilor despre starea curentă a serviciului.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Pentru cât timp vor fi aceste date disponibile?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'Datele sunt disponibile',
      :pick => :one
    a_experimental 's-ar putea să dispară în orice moment',
      :text_as_statement => 'experimental și s-ar putea să dispară în orice moment'
    a_short 'sunt disponibile experimental, dar ar trebui să fie menținute în jur de aproximativ un an',
      :text_as_statement => 'experimental pentru încă un an aproximativ',
      :requirement => ['pilot_13']
    a_medium 'se află în planurile dumneavoastră pe termen mediu, așa că vor fi disponibile pentru câțiva ani',
      :text_as_statement => 'pentru cel puțin câțiva ani',
      :requirement => ['standard_25']
    a_long 'este parte a operațiilor dumneavoastră zilnice, așa că vor rămâne publicate pentru o perioadă lungă de timp',
      :text_as_statement => 'pentru o perioadă lungă de timp',
      :requirement => ['exemplar_12']

    label_pilot_13 'Ar trebui <strong>să oferiți garanție că datele vor fi disponibile în această formă pentru cel puțin un an</strong>, astfel încât oamenii să poată decide cât de mult să se bazeze pe datele dvs.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Ar trebuie <strong>să garantați că datele vor fi disponibile în această formă pe termen mediu</strong>, astfel încât oamenii să poată decide cât de mult să aibă încredere în datele dvs.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 'Ar trebuie <strong>să garantați că datele vor fi disponibile în această formă pe termen lung</strong>, astfel încât oamenii să poată decide cât de mult să aibă încredere în datele dvs.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Informații tehnice',
    :description => 'Locații, formate și încredere' do

    label_group_11 'Locații',
      :help_text => 'Cum pot oamenii să acceseze datele dumneavoastră',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Unde este setul dumneavoastră de date?',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt publicate la',
      :help_text => 'Furnizați un URL pentru setul de date în sine. Datele deschise ar trebui să aibă link direct pe web, astfel încât oamenii să le poată găsi cu ușurință și le reutilizeze.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'URL pentru Setul de Date',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Setul de Date',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'Trebuie <strong>să oferiți fie un URL pentru datele dvs. sau un URL pentru documentația</strong> despre acestea, astfel încât oamenii să le poată găsi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'Ar trebui să <strong>să aveți un URL care să facă legătura directă cu datele în sine</strong>, astfel încât oamenii să le poată accesa cu ușurință.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Cum publicați o serie a aceluiași set de date?',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'ca o singură adresă URL care este actualizată în mod regulat',
      :help_text => 'Alegeți această opțiune dacă există o singură adresă URL pentru ca oamenii să descarce cea mai recentă versiune a setului de date curent.',
      :requirement => ['standard_26']
    a_template 'ca URL-uri consecvente pentru fiecare versiune publicată',
      :help_text => 'Alegeți această opțiune dacă URL-urile seturilor de date urmează un tipar care include data publicării, de exemplu un URL care începe cu \'2013-04\'. Acest lucru îi ajută pe oameni să înțeleagă cât de des lansați date, și să facă script-uri care preiau datele noi de fiecare dată când acestea sunt publicate.',
      :requirement => ['pilot_15']
    a_list 'ca o listă de versiuni publice',
      :help_text => 'Alegeți această opțiune dacă aveți o listă a seturilor de date pe o pagină web sau într-un flux de informație (feed) (cum ar fi Atom sau RSS), cu link-uri către fiecare versiune în parte și detaliile fiecăreia. Acest lucru îi ajută pe oameni să înțeleagă cât de des publicați date și să scrie script-uri care să preia datele noi de fiecare dată când acestea sunt publicate.',
      :requirement => ['standard_27']

    label_standard_26 'Ar trebui <strong>să aveți o singură adresă URL persistentă pentru a descărca versiunea curentă a datelor</strong>, astfel încât oamenii să le poată accesa cu ușurință.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Ar trebui <strong>să utilizați un model consecvent pentru URL-urile diferitelor versiuni</strong>, astfel încât oamenii să le poată descărca automat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'Ar trebui <strong>să aveți un document sau un feed, cu o listă de versiuni disponibile</strong>, astfel încât oamenii să poată crea script-uri pentru a le descărca pe toate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Trebuie <strong>să oferiți acces la versiuni printr-un URL</strong>, care oferă versiunea curentă, o serie de URL-uri pentru versiunile anterioare sau prin intermediul unei pagini de documentație astfel încât oamenii să le poată găsi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Unde este setul de date curent?',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Setul de date curent este disponibil la',
      :help_text => 'Furnizați un URL unic pentru cea mai recentă versiune a setului de date. Conținutul la care trimite acest URL trebuie să se schimbe de fiecare dată când o nouă versiune este publicată.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'URL pentru Setul de Date Curent',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Setul de Date Curent',
      :required => :required

    q_versionsTemplateUrl 'Ce format au URL-urile versiunilor publicate de date?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Versiunile publicate urmează acest model de URL',
      :help_text => 'Aceasta este structura folosită pentru URL-uri atunci când publicați diferitele versiuni. Folosiți `{variabilă}` pentru a indica părți din formatul URL-ului care se schimbă, de exemplu, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'URL pentru Șablonul de Versiune',
      :string,
      :input_type => :text,
      :placeholder => 'URL pentru Șablonul de Versiune',
      :required => :required

    q_versionsUrl 'Unde este lista de versiuni publicate ale seturilor de date?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Versiunile publicate ale acestor date sunt listate la',
      :help_text => 'Furnizați un URL pentru o pagină sau feed cu o listă a seturilor de date lizibilă pentru mașini. Utilizați URL-ul primei pagini, care ar trebui să aibă link către restul paginilor.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'URL pentru Lista Versiunilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Lista Versiunilor',
      :required => :required

    q_endpointUrl 'Unde este locația serviciului dumneavoastră de API?',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Locația serviciului de API este',
      :help_text => 'Furnizați un URL care să fie punct de plecare pentru script-urile oamenilor, pentru a accesa API-ul. Acesta ar trebui să fie un document de descriere a serviciului, care va ajuta script-ul să-și dea seama ce servicii există.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL pentru Locația API',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Locația API',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Trebuie <strong>să furnizați fie un URL pentru locația API-ului sau o adresă URL pentru documentația sa</strong>, astfel încât oamenii să îl poată găsi.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Ar trebui <strong>să aveți un document de descriere a serviciului sau un punct unic de acces pentru API-ul dumneavoastră</strong>, astfel încât oamenii să îl poată accesa.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Cum publicați copiile bazelor de date în format de export?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'ca un singur URL care este actualizat în mod regulat',
      :help_text => 'Alegeți această opțiune dacă există un singur URL pentru a descărca cea mai recentă versiune a dump-ului bazei de date.',
      :requirement => ['standard_29']
    a_template 'ca URL-uri consecvente pentru fiecare versiune publicată',
      :help_text => 'Alegeți această opțiune dacă URL-urile către copiile datelor curente în format de export urmează un tipar care include data publicării, de exemplu, un URL care începe cu \'2013-04\'. Acest lucru îi ajută pe oameni să înțeleagă cât de des publicați date și să scrie script-uri care să preia datele noi de fiecare dată când acestea sunt publicate.',
      :requirement => ['exemplar_13']
    a_list 'ca o listă de versiuni publicate',
      :help_text => 'Alegeți această opțiune dacă aveți o listă de copii ale bazelor curente de date în format de export pe o pagină web sau într-un flux de informație (feed) (cum ar fi Atom sau RSS), cu link-uri către fiecare versiune publicată și detalii despre aceasta. Acest lucru îi ajută pe oameni să înțeleagă cât de des publicați date și să scrie script-uri care să preia datele noi de fiecare dată când acestea sunt publicate.',
      :requirement => ['exemplar_14']

    label_standard_29 'Ar trebui <strong>să aveți un singur URL consecvent pentru a descărca copia datelor curente în format de export</strong>, astfel încât oamenii să le poată găsi.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 'Ar trebui <strong>să utilizați un tipar consecvent pentru URL-urile către copiile datelor curente în format de export</strong>, astfel încât oamenii să le poată descărca în mod automat pe fiecare.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 'Ar trebui <strong>să aveți un document sau un flux de informație (feed) cu o listă a copiilor de bazele de date disponibile în format de export</strong>, astfel încât oamenii pot crea script-uri pentru a le descărca',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Unde este copia bazei de date curente în format de export?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Cea mai recentă copie a bazei de date în format de export este întotdeauna disponibilă la',
      :help_text => 'Furnizați un URL pentru cea mai recentă copie a bazei de date în format de export. Conținutul la care trimite acest URL trebuie să se schimbe de fiecare dată când se creează o nouă copie a bazei de date în format de export.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'URL-ul Copiei Curente',
      :string,
      :input_type => :url,
      :placeholder => 'URL-ul Copiei Curente',
      :required => :required

    q_dumpsTemplateUrl 'Ce format au URL-urile pentru copiile bazelor de date în format de export?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Copiile bazelor de date în format de export urmează tiparul consecvent de adresă URL',
      :help_text => 'Aceasta este structura URL-urilor atunci când publicați diferite versiuni. Folosiți `{variabilă}` pentru a indica părți din URL-ul șablon care se schimbă, de exemplu, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'URL pentru Șablonul Copiei',
      :string,
      :input_type => :text,
      :placeholder => 'URL pentru Șablonul Copiei',
      :required => :required

    q_dumpsUrl 'Unde este lista cu copiile bazelor de date disponibile în format de export?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'O listă cu copiile bazelor de date în format de export există la',
      :help_text => 'Furnizați un URL pentru o pagină sau flux de informație (feed) cu o listă a copiilor bazelor de date în format de export ce poate fi citită automat de computer. Utilizați URL-ul de pe prima pagină pe care ar trebui să existe link-uri către restul paginilor.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'URL pentru Lista Copiilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Lista Copiilor',
      :required => :required

    q_changeFeedUrl 'Unde este feed-ul de modificări?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Un flux (feed) de modificări ale acestor date se găsește la',
      :help_text => 'Furnizați un URL pentru o pagină sau flux de informație (feed) cu o listă a versiunilor anterioare ale copiilor bazelor de date în format de export, lizibilă pentru mașini. Utilizați URL-ul de pe prima pagină pe care ar trebui să existe link-uri către restul paginilor.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'URL pentru Feed-ul de Modificări',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Feed-ul de Modificări',
      :required => :required

    label_group_12 'Formate',
      :help_text => 'modul în care oamenii pot lucra cu datele dvs.',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Sunt aceste lizibile pentru mașini?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date sunt',
      :help_text => 'Oamenii preferă formatele de date care sunt ușor procesate de un calculator, pentru viteză și precizie. De exemplu, o copie scanată a unei foi de calcul nu este lizibilă pentru mașini, dar un fișier CSV ar putea fi.',
      :pick => :one
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'sunt lizibile pentru mașini',
      :requirement => ['pilot_16']

    label_pilot_16 'Ar trebui <strong>să furnizați datele într-un format lizibil pentru mașini</strong>, pentru a fi ușor de prelucrat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Sunt aceste date într-un format deschis standard?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'Formatul acestor date este',
      :help_text => 'Standardele deschise sunt create printr-un proces corect, transparent și colaborativ. Oricine le poate implementa și există multă asistență, astfel încât este mai ușor pentru dumneavoastră să împărțiți datele cu mai multe persoane. De exemplu, XML, CSV și JSON sunt standarde deschise.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'un format deschis standard',
      :requirement => ['standard_30']

    label_standard_30 'Ar trebui <strong>să furnizați datele într-un format standard deschis</strong>, astfel încât oamenii să poată utiliza instrumente disponibile la scară largă, pentru a le procesa mai ușor.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Ce fel de date publicați?',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'documente lizibile pentru oameni',
      :help_text => 'Alegeți această opțiune dacă datele sunt destinate consumului uman. De exemplu, documente despre diverse politici, documentații tehnice, rapoarte și rezumate (minute) de ședință. Acestea au de obicei o structură, dar majoritatea sunt în format text.'
    a_statistical 'date statistice, cum ar fi numărători, medii și procente',
      :help_text => 'Alegeți această opțiune dacă datele dumneavoastră sunt date statistice sau numerice, precum numărători, medii sau procente. Ca de exemplu rezultate de recensământ, informații despre trafic sau statistici despre criminalitate.'
    a_geographic 'informații geografice, cum ar fi puncte și limite',
      :help_text => 'Alegeți această opțiune dacă datele pot fi reprezentate pe o hartă ca puncte, limite sau linii.'
    a_structured 'alte tipuri de date structurate',
      :help_text => 'Alegeți această opțiune dacă datele dumneavoastră sunt structurate în orice alt mod. Cum ar fi detalii despre evenimente, orare de trenuri, informații de contact sau orice altceva care poate fi interpretat drept date, analizat și prezentat în mai multe moduri.'

    q_documentFormat 'Documentele dumneavoastră lizibile pentru oameni includ formate care',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Documentele sunt publicate',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'descriu structura semantică, cum ar fi HTML, DocBook sau Markdown',
      :text_as_statement => 'într-un format semantic',
      :help_text => 'Aceste structuri etichetează structuri precum capitole, titluri și tabele, ceea ce face mai ușoară crearea automată a sumarelor, cum ar fi tabele de conținut și glosare. De asemenea, ele fac mai ușoară aplicarea de stiluri diferite pentru ca documentul să-și modifice aspectul.',
      :requirement => ['standard_31']
    a_format 'descriu informații despre formatare, precum OOXML sau PDF',
      :text_as_statement => 'într-un format de afișare',
      :help_text => 'Aceste formate pun accent pe aspect și se referă de exemplu, la fonturi, culori și poziționarea diferitelor elemente în cadrul paginii. Acestea sunt bune pentru consumul uman, dar nu sunt la fel de ușor de procesat automat și de schimbat stilul.',
      :requirement => ['pilot_17']
    a_unsuitable 'nu sunt destinate pentru documente, cum ar fi Excel, JSON sau CSV',
      :text_as_statement => 'într-un format nepotrivit pentru documente',
      :help_text => 'Aceste formate sunt mai bune pentru date tabelare sau structurate.'

    label_standard_31 'Ar trebui <strong>să publicați documente într-un format care expune structura semantică</strong>, astfel încât oamenii să le poată afișa în stiluri diferite.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'Ar trebui <strong>să publicați documente într-un format special conceput pentru acestea</strong>, astfel încât acestea să fie ușor de prelucrat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Datele dumneavoastră statistice includ formate care',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Datele statistice sunt publicate',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'expun structura de date statistice de tip hipercub, precum <a href="http://sdmx.org/">SDMX</a> sau <a href="">Data Cube</a>
                     ',
      :text_as_statement => 'într-un format de date statistice',
      :help_text => 'Observațiile individuale în hipercuburi sunt legate de o anumită măsură și un set de dimensiuni. Fiecare observație poate fi, de asemenea, asociată cu adnotări care oferă un context mai detaliat. Formate precum <a href="http://sdmx.org/">SDMX</a> și <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> sunt concepute pentru a exprima această structură fundamentală.',
      :requirement => ['exemplar_15']
    a_tabular 'tratează datele statistice în format de tabel, așa cum face formatul CSV',
      :text_as_statement => 'într-un format tabelar de date',
      :help_text => 'Aceste formate aranjează datele statistice într-un tabel cu rânduri și coloane. Acest format nu oferă prea multe detalii despre hipercubul care stă la baza lor, dar este ușor de prelucrat.',
      :requirement => ['standard_32']
    a_format 'se concentrează pe formatul de date tabelare, precum Excel',
      :text_as_statement => 'într-un format tip prezentare',
      :help_text => 'Foile de calcul tabelar utilizează formatarea, ca de exemplu textul italic, bold sau indentarea dintre câmpuri, pentru a descrie aspectul și structura de bază. Acest stil îi ajută pe oameni să înțeleagă datele dumneavoastră, dar este mai puțin potrivit pentru computere, din punct de vedere al procesării.',
      :requirement => ['pilot_18']
    a_unsuitable 'nu sunt destinate pentru datele statistice sau tabelare, precum Word sau PDF',
      :text_as_statement => 'într-un format nepotrivit pentru datele statistice',
      :help_text => 'Aceste formate nu se potrivesc datelor statistice, deoarece acestea ascund structura de bază a datelor.'

    label_exemplar_15 'Ar trebui <strong>să publicați datele statistice într-un format care expune dimensiunile și măsurile</strong>, pentru a fi ușor de analizat.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Ar trebuit <strong>să publicați datele tabelare într-un format care expune tabelele de date</strong>, pentru a fi ușor de analizat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'Ar trebui <strong>să publicați datele tabelare într-un format conceput în acest scop</strong>, pentru a fi ușor de prelucrat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Datele dumneavoastră geografice includ formate care',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Datele geografice sunt publicate',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'sunt concepute pentru date geografice, cum ar fi <a href="http://www.opengeospatial.org/standards/kml/">KML</a> sau <a href="http://www.geojson.org/">GeoJSON</a>
                     ',
      :text_as_statement => 'într-un format de date geografice',
      :help_text => 'Aceste formate descriu puncte, linii și limite, și expun structurile din interiorul datelor, ceea ce le face mai ușor de procesat în mod automat.',
      :requirement => ['exemplar_16']
    a_generic 'păstrează datele structurate ca JSON, XML sau CSV',
      :text_as_statement => 'într-un format de date generic',
      :help_text => 'Orice format care stochează date structurate normale poate exprima de asemenea, date geografice, în special dacă acesta deține doar date despre puncte.',
      :requirement => ['pilot_19']
    a_unsuitable 'nu sunt concepute pentru date geografice, cum ar fi Word sau PDF',
      :text_as_statement => 'într-un format nepotrivit pentru date geografice',
      :help_text => 'Aceste formate nu se potrivesc datelor geografice, deoarece ascund structura de bază a datelor.'

    label_exemplar_16 'Ar trebui <strong>să publicați datele geografice într-un format proiectat în acest scop</strong>, astfel încât oamenii să poată utiliza instrumente disponibile pe scară largă, pentru a le procesa.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'Ar trebui <strong>să publicați datele geografice ca date structurate</strong>, pentru a fi ușor de prelucrat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Datele dumneavoastră structurate includ formate care',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Datele structurate sunt publicate',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'sunt concepute pentru datele structurate, cum ar fi JSON, XML, Turtle sau CSV',
      :text_as_statement => 'într-un format de date structurate',
      :help_text => 'Aceste formate organizează datele într-o structură de bază formată din obiecte ce au valori corespunzătoare unui set cunoscut de proprietăți. Aceste formate sunt ușor de procesat în mod automat de către calculatoare.',
      :requirement => ['pilot_20']
    a_unsuitable 'nu sunt concepute pentru datele structurate, cum ar fi Word sau PDF',
      :text_as_statement => 'într-un format nepotrivit pentru date structurate',
      :help_text => 'Aceste formate nu se potrivesc acestui tip de date, deoarece ascund structura lor de bază.'

    label_pilot_20 'Ar trebui <strong>să publicați date structurate într-un format proiectat în acest scop</strong>, pentru a fi mai ușor de prelucrat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Datele dumneavoastră folosesc identificatori persistenți?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'Datele includ',
      :help_text => 'Datele sunt, de obicei, despre lucruri reale precum școli sau drumuri sau utilizează un sistem de codificare. Dacă datele din diferite surse folosesc aceiași identificatori persistenți unici pentru a se referi la aceleași lucruri, oamenii pot combina sursele cu ușurință, pentru a crea date și mai utile. Identificatorii ar putea fi de tip GUID, DOI sau URL.',
      :pick => :one
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'identificatori persistenți',
      :requirement => ['standard_33']

    label_standard_33 'Ar trebui <strong>să folosiți identificatori pentru lucrurile din datele dumneavoastră</strong>, pentru a fi mai ușor legate de alte date despre aceleași lucruri.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Se pot folosi identificatorii din datele dumneavoastră pentru a găsi informații suplimentare?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Identificatorii persistenți',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'nu, identificatorii nu pot fi utilizați pentru a găsi informații suplimentare',
      :text_as_statement => ''
    a_service 'da, există un serviciu pe care oamenii îl pot utiliza pentru a obține referințele asociate cu identificatorii',
      :text_as_statement => 'referențiați folosind un serviciu',
      :help_text => 'Servicii online pot fi folosite pentru a le oferi oamenilor informații cu privire la identificatori ca GUID sau DOI, ce nu pot fi accesați în mod direct, așa cum sunt accesate URL-urile.',
      :requirement => ['standard_34']
    a_resolvable 'da, identificatorii sunt URL-uri care referențiază informații',
      :text_as_statement => 'oferă referințe, deoarece acestea sunt URL-uri',
      :help_text => 'URL-urile sunt utile atât pentru oameni cât și pentru computere. Oamenii pot pune o adresă URL în browser-ul lor pentru a citi mai multe informații, precum <a href="http://opencorporates.com/companies/gb/08030289">companii</a> și <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">coduri poștale</a>. Calculatoarele pot de asemenea procesa aceste informații suplimentare, folosind script-uri pentru a accesa datele care stau la baza lor.',
      :requirement => ['exemplar_17']

    label_standard_34 'Ar trebui <strong>să oferiți un serviciu care să ofere referințe despre identificatorii pe care îi utilizați</strong>, pentru ca oamenii să poată găsi informații suplimentare despre ei.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 'Ar trebui <strong>să aveți link către o pagină web cu informații despre fiecare lucru prezent în datele dumneavoastră</strong>, pentru ca oamenii să poată găsi și distribui cu ușurință aceste informații.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Unde este serviciul folosit pentru a referinția identificatorii?',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Serviciul ce oferă referințele identificatorilor se află la',
      :help_text => 'Serviciul de referențiere ar trebui să ia un identificator drept un parametru de interogare și să dea înapoi câteva informații despre ceea ce este identificat prin acesta.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'URL pentru Serviciul de Referențiere al Identificatorilor',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Serviciul de Referențiere al Identificatorilor',
      :requirement => ['standard_35']

    label_standard_35 'Ar trebui <strong>să aveți un URL prin care identificatorii pot fi referențiați</strong>, pentru a se putea găsi mai multe informații despre aceștia.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Există informații de la părți terțe despre entitățile din datele dumneavoastră de pe web?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Uneori, alte persoane aflate în afara controlului dumneavoastră furnizează URL-uri pentru anumite entități despre care aveți date. De exemplu, datele dumneavoastră ar putea conține coduri poștale care fac legătura cu site-ul Ordnance Survey.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'nu'
    a_true 'da'

    q_reliableExternalUrls 'Aceste informații de la părți terțe sunt de încredere?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'În cazul în care o parte terță furnizează URL-uri publice cu privire la entități din datele dumneavoastră, probabil că au luat măsuri pentru a asigura calitatea și fiabilitatea datelor. Aceasta este o măsură a încrederii dumneavoastră în procesele pe care ei le folosesc, pentru a asigura aceste lucruri. Uitați-vă după certificatul lor pentru date deschise sau alte semne similare, pentru a vă ajuta să luați o decizie în privința lor.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'nu'
    a_true 'da'

    q_externalUrls 'Datele dvs. folosesc acele URL-uri de la o parte terță?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'URL-urile către părțile terțe sunt',
      :help_text => 'Ar trebui să utilizați URL-uri de la părți terțe, care se referă la informații despre lucrurile descrise de datele dumneavoastră. Acest lucru reduce duplicarea și îi ajută pe oameni să combine date din surse diferite pentru a le face mai utile.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'referențiate în aceste date',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Ar trebui <strong>să utilizați URL-uri către informațiile terților din datele dvs.</strong>, astfel încât să fie ușor de combinat cu alte date care utilizează aceste URL-uri.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Încredere',
      :help_text => 'Cât de multă încredere pot oamenii să aibă în datele dvs.',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Furnizați surse ce pot fi lizibile pentru mașini, pentru datele dumneavoastră?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'Proveniența acestor date este',
      :help_text => 'Este vorba despre originile datelor, de modul în care datele dumneavoastră au fost create și prelucrate, înainte de a fi publicate. Se mărește încrederea în datele pe care le publicați, deoarece oamenii pot urmări modul în care acestea au fost procesate.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'nu',
      :text_as_statement => ''
    a_true 'da',
      :text_as_statement => 'lizibile pentru mașini',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Ar trebui <strong>să furnizați o cale de proveniență a datelor, lizibilă pentru mașini</strong>, astfel încât oamenii să poată urmări modul în care acestea au fost procesate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Unde descrieți modul în care oamenii pot verifica dacă datele pe care le primesc vin de la dumneavoastră?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Aceste date pot fi verificate cu ajutorul',
      :help_text => 'Dacă furnizați date importante oamenilor, ei ar trebui să poată verifica dacă ceea ce primesc este la fel ca ceea ce ați publicat. De exemplu, puteți semna digital datele pe care le publicați, astfel încât oamenii să-și dea seama dacă acestea au fost modificate.'
    a_1 'URL pentru Procesul de Verificare',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Procesul de Verificare',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Ar trebui <strong>să descrieți modul în care oamenii pot verifica dacă datele pe care le primesc sunt la fel cu cele publicate</strong>, astfel încât aceștia să poată avea încredere în ele.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Informații sociale',
    :description => 'Documentație, suport și servicii' do

    label_group_15 'Documentație',
      :help_text => 'cum îi ajutați pe oameni să înțeleagă contextul și conținutul datelor',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Documentația datelor dumneavoastră include date lizibile pentru mașini pentru:',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Documentația include date lizibile pentru mașini pentru',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'titlu',
      :text_as_statement => 'titlu',
      :requirement => ['standard_36']
    a_description 'descriere',
      :text_as_statement => 'descriere',
      :requirement => ['standard_37']
    a_issued 'data de publicare',
      :text_as_statement => 'data de publicare',
      :requirement => ['standard_38']
    a_modified 'data modificării',
      :text_as_statement => 'data modificării',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'frecvența versiunilor publicate',
      :text_as_statement => 'frecvența publicării',
      :requirement => ['standard_40']
    a_identifier 'identificator',
      :text_as_statement => 'identificator',
      :requirement => ['standard_41']
    a_landingPage 'pagina de primire',
      :text_as_statement => 'pagina de primire',
      :requirement => ['standard_42']
    a_language 'limba',
      :text_as_statement => 'limba',
      :requirement => ['standard_43']
    a_publisher 'distribuitor',
      :text_as_statement => 'distribuitor',
      :requirement => ['standard_44']
    a_spatial 'acoperire spațială/geografică',
      :text_as_statement => 'acoperire spațială/geografică',
      :requirement => ['standard_45']
    a_temporal 'acoperire temporală',
      :text_as_statement => 'acoperire temporală',
      :requirement => ['standard_46']
    a_theme 'subiect(e)',
      :text_as_statement => 'subiect(e)',
      :requirement => ['standard_47']
    a_keyword 'cuvânt(e) cheie sau tag(-uri)',
      :text_as_statement => 'cuvânt(e) cheie sau tag(-uri)',
      :requirement => ['standard_48']
    a_distribution 'distribuție(ii)',
      :text_as_statement => 'distribuție(ii)'

    label_standard_36 'Ar trebui <strong>să includeți în documentație un titlu al datelor lizibil pentru mașini</strong>, pentru ca oamenii să știe cum să se refere la ele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Ar trebui <strong>să includeți în documentație o descriere a datelor lizibilă pentru mașini</strong>, pentru ca oamenii să știe ce conține.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Ar trebui <strong>să includeți în documentație data publicării, lizibilă pentru mașini</strong>, pentru ca oamenii să știe cât de actuale sunt.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Ar trebui <strong>să includeți în documentație o dată pentru ultima modificare, lizibilă pentru mașini</strong>, astfel încât oamenii să știe că au cele mai recente date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Ar trebui <strong>să furnizați metadate lizibile pentru mașini, cu privire la frecvența de publicare a versiunilor</strong>, pentru ca oamenii să știe cât de des le actualizați.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Ar trebui <strong>să includeți un URL canonic pentru datele din documentația lizibilă pentru mașini</strong>, pentru ca oamenii să știe cum să-l acceseze în mod consecvent.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Ar trebui <strong>să includeți un URL canonic și pentru documentația lizibilă pentru mașini</strong>, pentru ca oamenii să știe cum să o acceseze în mod consecvent.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Ar trebui <strong>să includeți limba datelor în documentația lizibilă pentru mașini</strong>, pentru ca oamenii care o caută să știe dacă o pot înțelege.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Ar trebui <strong>să indicați distribuitorul datelor în documentația lizibilă pentru mașini</strong> pentru ca oamenii să poată decide cât de mult să aibă încredere în datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Ar trebui <strong>să includeți acoperirea geografică în documentația lizibilă pentru mașini</strong>, pentru ca oamenii să înțeleagă unde anume sunt aplicabile datele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Ar trebui <strong>să includeți perioada de timp în documentația lizibilă pentru mașini</strong>, pentru ca oamenii să înțeleagă când anume sunt aplicabile datele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Ar trebui <strong>să includeți subiectul datelor, în documentația lizibilă pentru mașini</strong>, pentru ca oamenii să înțeleagă în mare, despre ce anume sunt datele.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Ar trebui <strong>să includeți cuvinte cheie sau tag-uri în documentația lizibilă pentru mașini</strong> pentru a ajuta oamenii să caute mai eficient prin datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Documentația include metadate lizibile pentru mașini, pentru fiecare distribuție, despre:',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Documentația cu privire la fiecare distribuție include date lizibile pentru mașini pentru',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'titlu',
      :text_as_statement => 'titlu',
      :requirement => ['standard_49']
    a_description 'descriere',
      :text_as_statement => 'descriere',
      :requirement => ['standard_50']
    a_issued 'data de publicare',
      :text_as_statement => 'data de publicare',
      :requirement => ['standard_51']
    a_modified 'data modificării',
      :text_as_statement => 'data modificării',
      :requirement => ['standard_52']
    a_rights 'declarația drepturilor',
      :text_as_statement => 'declarația drepturilor',
      :requirement => ['standard_53']
    a_accessURL 'URL pentru a accesa datele',
      :text_as_statement => 'un URL pentru a accesa datele',
      :help_text => 'Aceste metadate ar trebui utilizate atunci când datele nu sunt disponibile pentru descărcare, precum un API.'
    a_downloadURL 'URL pentru a descărca setul de date',
      :text_as_statement => 'un URL pentru a descărca setul de date'
    a_byteSize 'mărimea în byți',
      :text_as_statement => 'mărimea în byți'
    a_mediaType 'formatul de download',
      :text_as_statement => 'formatul de download'

    label_standard_49 'Ar trebui <strong>să includeți în documentație titluri lizibile pentru mașini</strong>, astfel încât oamenii să știe cum să se refere la fiecare distribuție de date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Ar trebui <strong>să includeți în documentație descrieri lizibile pentru mașini</strong>, astfel oamenii să știe ce conține fiecare distribuție de date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Ar trebui <strong>să includeți în documentație datele de publicare lizibile pentru mașini</strong>, astfel încât oamenii să știe cât de actuală este fiecare distribuție.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'Ar trebui <strong>să includeți în documentație ultimele date de modificare, lizibile pentru mașini</strong>, astfel încât oamenii să știe dacă au o copie la zi după o distribuție de date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Ar trebui <strong>să includeți în documentație un link lizibil pentru mașini, către declarația drepturilor aplicabile</strong>, astfel încât oamenii să poată afla ce pot face cu o distribuție de date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Unde este documentația tehnică a datelor?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'Documentația tehnică a datelor se află la'
    a_1 'URL pentru Documentația Tehnică',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentația Tehnică',
      :requirement => ['pilot_21']

    label_pilot_21 'Ar trebui <strong>să furnizați documentația tehnică pentru date</strong>, astfel încât oamenii să înțeleagă cum să le folosească.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Formatele de date utilizează vocabulare sau scheme?',
      :discussion_topic => :vocabulary,
      :help_text => 'Formate, cum ar fi CSV, JSON, XML sau Turtle folosesc vocabulare personalizate sau scheme, care spun ce coloane sau proprietăți conțin datele.',
      :pick => :one,
      :required => :standard
    a_false 'nu'
    a_true 'da'

    q_schemaDocumentationUrl 'Unde se află documentația despre vocabularele de date?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Vocabularele folosite de aceste date sunt documentate la'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'URL pentru Documentația Schemei',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentația Schemei',
      :requirement => ['standard_54']

    label_standard_54 'Ar trebui <strong>să documentați orice vocabular folosiți în datele dvs.</strong>, astfel încât oamenii să știe cum să-l interpreteze.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Există coduri utilizate în aceste date?',
      :discussion_topic => :codelists,
      :help_text => 'Dacă datele dvs. utilizează coduri pentru a se referi la lucruri cum ar fi zone geografice, categorii de cheltuieli sau boli, acestea trebuie să fie explicate oamenilor.',
      :pick => :one,
      :required => :standard
    a_false 'nu'
    a_true 'da'

    q_codelistDocumentationUrl 'Unde sunt documentate codurile din datele dumneavoastră?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Codurile din aceste date sunt documentate la'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'URL pentru Documentația Referitoare la Lista de Coduri',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Documentația Referitoare la Lista de Coduri',
      :requirement => ['standard_55']

    label_standard_55 'Ar trebui <strong>să documentați codurile utilizate în cadrul datelor dvs.</strong>, astfel încât oamenii să știe cum să le interpreteze.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Asisteță',
      :help_text => 'cum comunicați cu persoanele care utilizează datele dumneavoastră',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Unde pot oamenii afla cum să contacteze pe cineva cu întrebări despre aceste date?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Aflați cum să contactați pe cineva cu privire la aceste date la',
      :help_text => 'Furnizați un URL pentru o pagină care descrie modul în care oamenii pot contacta pe cineva în cazul în care au întrebări despre date.'
    a_1 'Documentația Contactului',
      :string,
      :input_type => :url,
      :placeholder => 'Documentația Contactului',
      :requirement => ['pilot_22']

    label_pilot_22 'Ar trebui <strong>să furnizați informații de contact pentru ca persoanele să poată trimite întrebări</strong> despre datele dvs.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Unde pot oamenii afla cum să îmbunătățească modul în care sunt publicate datele dumneavoastră?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Aflați cum să sugerați îmbunătățiri în privința publicării la'
    a_1 'URL pentru Sugestii de Îmbunătățire',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Sugestii de Îmbunătățire',
      :requirement => ['pilot_23']

    label_pilot_23 'Ar trebui <strong>să furnizați instrucțiuni despre cum să sugereze îmbunătățiri</strong> referitor la modul în care publicați date, astfel încât să puteți descoperi ceea ce oamenii au nevoie.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Unde pot oamenii afla cum să contacteze pe cineva cu întrebări despre confidențialitate?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Aflați unde să trimiteți întrebări cu privire la confidențialitate la'
    a_1 'Documentație despre Confidențialitatea Contactului',
      :string,
      :input_type => :url,
      :placeholder => 'Documentație despre Confidențialitatea Contactului',
      :requirement => ['pilot_24']

    label_pilot_24 'Ar trebui <strong>să furnizați informații de contact pentru ca oamenii să trimită întrebări cu privire la confidențialitate</strong> și divulgarea de detalii personale.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Utilizați mediile de socializare pentru a vă conecta cu persoane care utilizează datele dumneavoastră?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'nu'
    a_true 'da',
      :requirement => ['standard_56']

    label_standard_56 'Ar trebui <strong>să folosiți mediile de socializare pentru a ajunge la oamenii care folosesc datele dumneavoastră</strong> și pentru a descoperi modul în care sunt utilizate acestea.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Cont' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Pe ce conturi pentru mediile de socializare vă pot contacta oamenii?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Contactați curatorul prin intermediul acestor conturi pentru mediile de socializare',
        :help_text => 'Furnizați URL-uri către conturile dumneavoastră pentru mediile de socializare, cum ar fi pagina de profil Twitter sau Facebook.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'URL pentru Mediile de Socializare',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL pentru Mediile de Socializare'

    end

    q_forum 'Unde pot oamenii discuta despre acest set de date?',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Discutați aceste date la',
      :help_text => 'Furnizați un URL pentru forum sau lista de discuții, unde oamenii pot vorbi despre datele dumneavoastră.'
    a_1 'URL pentru Forum sau Listă de Discuții',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Forum sau Listă de Discuții',
      :requirement => ['standard_57']

    label_standard_57 'Ar trebui <strong>să le spuneți oamenilor unde pot discuta despre datele dvs.</strong> și unde își pot oferi asistență unul altuia.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Unde pot oamenii să afle cum să solicite corecții ale datelor dumneavoastră?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Aflați cum să solicitați corecții de date la',
      :help_text => 'Furnizați un URL unde oamenii pot raporta erori din cadrul datelor.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL pentru Instrucțiunile de Corecție',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Instrucțiunile de Corecție',
      :requirement => ['standard_58']

    label_standard_58 'Ar trebui <strong>să oferiți instrucțiuni cu privire la modul în care oamenii pot raporta erori</strong> cu privire la datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Unde pot oamenii afla cum să primească notificări despre corecțiile datelor dumneavoastră?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Aflați cum să primiți notificări despre corecțiile datelor la',
      :help_text => 'Furnizați un URL unde descrieți modul în care distribuiți notificările cu privire la corecții.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL pentru Notificări de Corectare',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Notificări de Corectare',
      :requirement => ['standard_59']

    label_standard_59 'Ar trebui <strong>să furnizați o listă de adrese sau flux de informație (feed), cu actualizări</strong> pe care oamenii să îl utilizeze pentru a păstra copiile lor de date la zi.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Aveți pe cineva care construiește în mod activ o comunitate în jurul acestor date?',
      :discussion_topic => :engagementTeam,
      :help_text => 'O echipa de implicare a comunității va face acest lucru prin intermediul mediilor de socializare, blogging-ulului, și va aranja hackdays sau concursuri, pentru a încuraja oamenii să folosească datele dumneavoastră.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'nu'
    a_true 'da',
      :requirement => ['exemplar_21']

    label_exemplar_21 'Ar trebui <strong>să construiți o comunitate de oameni în jurul datelor dumneavoastră</strong>, pentru a încuraja utilizarea lor pe scară largă.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Unde se află pagina lor de start?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Implicarea comunității se face prin',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'URL pentru Pagina de Start a Echipei de Implicare a Comunității',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Pagina de Start a Echipei de Implicare a Comunității',
      :required => :required

    label_group_17 'Servicii',
      :help_text => 'cum dați oamenilor acces la instrumentele de care au nevoie pentru a prelucra datele dvs.',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Unde listați instrumentele ce pot fi folosite pentru a lucra cu datele dumneavoastră?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Instrumente pentru a ajuta să folosiți aceste date sunt listate la',
      :help_text => 'Furnizați un URL care afișează instrumentele pe care le știți sau le recomandați oamenilor pentru a lucra cu datele dumneavoastră.'
    a_1 'URL pentru Instrumente',
      :string,
      :input_type => :url,
      :placeholder => 'URL pentru Instrumente',
      :requirement => ['exemplar_22']

    label_exemplar_22 'Ar trebui <strong>să furnizați o listă de librării de software și alte instrumente ușor disponibile</strong>, astfel încât oamenii să poată ajunge rapid să lucreze cu datele dumneavoastră.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
