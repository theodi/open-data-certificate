survey 'IT',
  :full_title => 'Italy',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>Questo questionario di autovalutazione genera un certificato open data e un distintivo che è possibile pubblicare a corredo dei dataset per spiegare tutto quello che c\'è da sapere su quei dati aperti. Utilizziamo le tue risposte anche per imparare il modo in cui le organizzazioni pubblicano dati aperti.</p><p>Quando rispondi a queste domande si dimostra la volontà a rispettare le normative pertinenti. Dovresti anche controllare quali ulteriori leggi e politiche risultano applicabili al settore in oggetto.</p><p><strong>Non hai bisogno di rispondere a tutte le domande per ottenere un certificato</strong> Basta rispondere a quelle che puoi.</p>' do

  translations :en => :default
  section_general 'Informazioni generali',
    :description => '',
    :display_header => false do

    q_dataTitle 'Come si chiamano questi dati?',
      :discussion_topic => :dataTitle,
      :help_text => 'I tuoi open data vengono visualizzati assieme ad altri dati similari. Quindi fai in modo che il nome inserito in questa casella sia il più possibile univoco e preciso per permettere agli utenti di identificare rapidamente la loro unicità.',
      :required => :required
    a_1 'Titolo dei dati',
      :string,
      :placeholder => 'Titolo dei dati',
      :required => :required

    q_documentationUrl 'Dove sono descritti?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'questi dati sono descritti in',
      :help_text => ''
    a_1 'La URL della documentazione',
      :string,
      :input_type => :url,
      :placeholder => 'La URL della documentazione',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Dovresti avere <strong>una pagina web che dia accesso alla documentazione</strong> sui tuoi open data così da capirne il contesto, contenuto ed utilità.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Devi avere <strong>una pagina web che dia accesso alla documentazione</strong> sui tuoi open data così che la gente possa utilizzarli',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Chi pubblica questi dati?',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono pubblicati da',
      :help_text => 'Inserisci il nome dell\'organizzazione che pubblica questi dati. Probabilmente è l\'organizzazione per cui lavori, a meno che tu non stia facendo il lavoro al posto di qualcun altro.',
      :required => :required
    a_1 'informazioni sull\'editore',
      :string,
      :placeholder => 'informazioni sull\'editore',
      :required => :required

    q_publisherUrl 'Su quale sito si trovano i dati?',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'I dati sono pubblicati su',
      :help_text => 'dai al sito web una URL; questo ci aiuta a raggruppare i dati dello stesso organismo anche se le persone danno loro dei nomi diversi.'
    a_1 'URL dell\'editore',
      :string,
      :input_type => :url,
      :placeholder => 'URL dell\'editore'

    q_releaseType 'Di che tipo di aggiornamento si tratta?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'un unico aggiornamento di un pacchetto singolo di dati.',
      :help_text => 'Si tratta di un unico file e non prevedi di pubblicarne di simili in futuro'
    a_collection 'Un unico aggiornamento di un insieme di pacchetti di dati correlati',
      :help_text => 'E\' una raccolta di file correlati relativi agli stessi dati e per i quali al momento non prevedi di pubblicarne di simili in futuro'
    a_series 'Una serie di pacchetti di dati correlati in corso di pubblicazione',
      :help_text => 'Questa rappresenta una serie di pacchetti di dati con aggiornamenti periodici già previsti per il futuro'
    a_service 'un servizio o un API per accedere agli open data',
      :help_text => 'Questo è un live web service che permette ai programmatori di accedere ai tuoi dati attraverso un\'interfaccia di ricerca'

  end

  section_legal 'Informazioni Legali',
    :description => 'Diritti, licenze e privacy' do

    label_group_2 'Diritti',
      :help_text => 'Il tuo diritto di condividere questi dati con altri',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'hai il diritto di pubblicare questi dati come dati aperti?',
      :discussion_topic => :it_publisherRights,
      :help_text => 'Se la tua organizzazione non ha originariamente creato o raccolto questi dati, allora è possibile che tu non abbia il diritto di pubblicarli. Nel caso non fossi sicuro, controlla con chi detiene la proprietà dei dati, perché è necessario il permesso per pubblicarli.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'sì, hai i diritti per pubblicare questi dati come dati aperti',
      :requirement => ['standard_1']
    a_no 'no, non disponi dei titoli per pubblicare questi dati come dati aperti'
    a_unsure 'non sei sicuro di disporre dei diritti necessari per pubblicare questi dati come dati aperti'
    a_complicated 'i diritti su questi dati sono complicati o poco chiari'

    label_standard_1 'Dovresti avere un <strong>chiaro titolo legale per la pubblicazione di questi dati</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'È necessario avere il <strong>diritto a pubblicare questi dati</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Dove si possono trovare dettagli sui rischi che le persone potrebbero incontrare usando questi dati?',
      :discussion_topic => :it_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'rischi nell\'utilizzo di questi dati sono descritti in',
      :help_text => 'Può essere rischioso per le persone utilizzare i dati senza un chiaro titolo legale per farlo. Per esempio, i dati possono essere tirati giù in risposta ad una sfida legale. Fornisci una URL di una pagina che descrive il rischio connesso all\'utilizzo di questi dati.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'URL Documentazione Rischi',
      :string,
      :input_type => :url,
      :placeholder => 'URL Documentazione Rischi',
      :requirement => ['pilot_2']

    label_pilot_2 'Si dovrebbero documentare <strong>i rischi associati all\'utilizzo di questi dati</strong>, così che sia possibile capire come si vuole usarli.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Erano <em>tutti</em> questi dati originariamente creati o raccolti da te?',
      :discussion_topic => :it_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'questi dati erano',
      :help_text => 'Se una parte di questi dati, è stato reperita all\'esterno dell\'organizzazione da parte di altri singoli individui o organizzazioni, allora hai bisogno di dare informazioni aggiuntive sui tuoi diritti di pubblicarlo.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'originariamente creati o generati dal suo curatore'

    q_thirdPartyOrigin 'Alcuni di questi dati sono stati estratti o rielaborati da altri dati?',
      :discussion_topic => :it_thirdPartyOrigin,
      :help_text => 'Un estratto o una minima parte dei dati prodotti da qualcun altro significa ancora che i diritti all\'uso di essi possono essere pregiudicati. Potrebbero esserci anche problemi legali se hai analizzato i loro dati per produrre nuovi risultati.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'sì',
      :requirement => ['basic_3']

    label_basic_3 'Hai indicato che questi dati non sono stati originariamente creati o raccolti da te, non sono raccolti su base volontaria/crowdsourced, quindi devono necessariamente essere stati estratti da o rielaborati usando altre fonti di dati.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Sono <em>tutti </em> le fonti di questi dati già pubblicate come dati aperti?',
      :discussion_topic => :it_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono creati da',
      :help_text => 'Hai il permesso di ripubblicare i dati di qualcun altro se sono rilasciati già sotto una licenza open data o se i loro diritti sono decaduti o sono stati oggetto di rinuncia. Se parte di questi dati non ha queste caratteristiche allora hai bisogno di consulenza legale prima che tu possa pubblicarli.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'fonti di dati aperti',
      :requirement => ['basic_4']

    label_basic_4 'Dovresti consultare un legale <strong>per assicurarti di avere il diritto di pubblicare questi dati</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Alcuni di questi dati sono stati raccolti su base volontaria, ovvero sono crowdsourced?',
      :discussion_topic => :it_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'Alcuni di questi dati sono',
      :help_text => 'se i dati includono informazioni fornite da persone esterne all\'organizzazione, è necessario ottenere il permesso per pubblicare i loro contributi come dati aperti',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'su base volontaria',
      :requirement => ['basic_5']

    label_basic_5 'Hai indicato che i dati non sono stati originariamente creati o raccolte da te, e che non sono stato estratti o rielaborati da altri dati, quindi devono essere stati raccolti su base volontaria.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'I contributori di questi dati hanno usato la loro capacità di giudizio soggettiva?',
      :discussion_topic => :it_crowdsourcedContent,
      :help_text => 'se le persone hanno usato la loro creatività o capacità di giudizio soggettiva per contribuire alla creazione dei dati risultano dunque titolari di diritto d\'autore sul proprio lavoro. Per esempio, scrivere una descrizione o decidere se includere o meno alcuni dati in un dataset richiederebbe un certo livello di soggettività. Così coloro che hanno contribuito devono trasferire o rinunciare ai propri diritti, o concederti in licenza i dati prima che tu possa pubblicarli.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'sì'

    q_claUrl 'Dov\'è il Contributor Licence Ageement (CLA)?',
      :discussion_topic => :it_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La Contributor Licence Agreement (Accordo di licenza del contributore) è in',
      :help_text => 'inserisci un link a un accordo che dimostra che i contributori acconsentono al riutilizzo dei loro dati. Un CLA trasferirà i diritti del contributore stesso a te, lo esenterà dai suoi diritti, o ti concederà in licenza i dati in modo che tu li possa pubblicare.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'la URL del Contributor Licence Agreement (Accordo di licenza del contributore)',
      :string,
      :input_type => :url,
      :placeholder => 'la URL del Contributor Licence Agreement (Accordo di licenza del contributore)',
      :required => :required

    q_cldsRecorded 'Tutti i contributori hanno accettato il Contributor Licence Agreement (CLA)?',
      :discussion_topic => :it_cldsRecorded,
      :help_text => 'Controlla che tutti i collaboratori si impegnano a un CLA prima di riutilizzare o ripubblicare i loro contributi. Si consiglia di tenere un registro di chi ha dato contributi e se non sono d\'accordo per il CLA.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'no'
    a_true 'sì',
      :requirement => ['basic_6']

    label_basic_6 'È necessario per te ottenere <strong>che i contributori accettino un Contributor Licence Agreement</strong> (CLA) che ti conferisce il diritto di pubblicare il loro lavoro come open data.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Dove descrivi le fonti di questi dati?',
      :discussion_topic => :it_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Le fonti di questi dati sono descritti in',
      :help_text => 'Inserisci un\'URL che documenti le fonti dalle quali i dati sono stati acquisiti da (la loro provenienza) e i diritti sotto cui si pubblicano i dati. Questo aiuta le persone a capire la provenienza dei dati.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'URL Documentazione Fonti dei dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL Documentazione Fonti dei dati',
      :requirement => ['pilot_3']

    label_pilot_3 'Dovresti documentare <strong>la provenienza dei dati e le condizioni d\'uso sotto cui si pubblicano</strong>, permettendo così alle persone di poter utilizzare parti che provenivano da soggetti terzi.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'la documentazione sulle fonti di questi dati è fornita anche in formato processabile dai computer?',
      :discussion_topic => :it_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Il curatore ha pubblicato',
      :help_text => 'Informazioni sulle fonti dei dati dovrebbero essere leggibili in modo che le persono possano comprenderle che, così come in un formato di metadati che i computer siano in grado di elaborare. Quando tutti fanno così, ciò aiut agli altri a scoprire come utilizzare gli stessi dati aperti possono essere utilizzati e giustificano la loro pubblicazione in corso.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'dati processabili dai computer sulle fonti di questi dati',
      :requirement => ['standard_2']

    label_standard_2 'Dovresti <strong>includere dati in formato processabile dai computer sulle fonti di questi dati</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Licensing',
      :help_text => 'come dare alle persone il permesso di utilizzare questi dati',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Dove hai pubblicato la dichiarazione dei diritti per questo set di dati?',
      :discussion_topic => :it_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'La dichiarazione dei diritti è in',
      :help_text => 'Inserisci l\'URL di una pagina che descrive le condizioni d\'uso di questo set di dati. Questa dovrebbe includere un riferimento alla sua licenza, requisiti di attribuzione, e una Dichiarazione sui diritti relativi alle banche dati e ai diritti d\'autore. Una dichiarazione dei diritti d\'uso aiuta le persone a capire quello che possono e non possono fare con i dati.'
    a_1 'URL Dichiarazione dei diritti di utilizzo',
      :string,
      :input_type => :url,
      :placeholder => 'URL Dichiarazione dei diritti di utilizzo',
      :requirement => ['pilot_4']

    label_pilot_4 'Dovresti <strong>pubblicare una dichiarazione dei diritti</strong> che fornisca dettagli sul diritto d\'autore, i diritti sulle banche dati, le licenze e come le persone dovrebbero dare attribuzione ai dati.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'sotto quale licenza può la gente riutilizzare questi dati?',
      :discussion_topic => :it_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono disponibili sotto',
      :help_text => 'Ricorda che chi raccoglie in origine, crea, verifica o presenta un database automaticamente ottiene i diritti su di esso. Ci può essere anche copyright sull\'organizzazione e la selezione dei dati. Così le persone hanno bisogno di un atto di cessione o di una licenza che dimostra che essi possono utilizzare i dati e spiega come possono farlo legalmente. Elenchiamo le licenze più comuni qui, se non ci fossero diritti connessi alle banche dati o diritti d\'autore, nel caso fossero scaduti, o si fosse verificata unacessione degli stessi, scegli \'Non applicabile\'.',
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
    a_odc_odbl 'Open Data Commons Open Database License (ODbL)',
      :text_as_statement => 'Open Data Commons Open Database License (ODbL)'
    a_odc_pddl 'Open Data Commons Public Domain Dedication e Licenza (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication e Licenza (PDDL)'
    a_iodl 'Italian Open Data License v1.0',
      :text_as_statement => 'Italian Open Data License v1.0'
    a_iodl_2_0 'Italian Open Data License v2.0',
      :text_as_statement => 'Italian Open Data License v2.0'
    a_na 'Non applicabile',
      :text_as_statement => ''
    a_other 'Altro...',
      :text_as_statement => ''

    q_dataNotApplicable 'Perché non si applica una licenza a questi dati?',
      :discussion_topic => :it_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati non sono concesso in licenza in quanto',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'non ci sono diritti d\'autore o diritti su banche dati su questi dati',
      :text_as_statement => 'non ci sono diritti in esso',
      :help_text => 'i diritti sulle banche dati si applicano se hai impiegato notevoli sforzi per la loro raccolta, verifica o presentazione. Non si possono rivendicare diritti sulle banche di dati se, ad esempio, i dati vengono creati da zero, presentati in modo strutturato, e non verificati. Hai diritto d\'autore, se hai selezionano gli elementi dei dati o li hai organizzati in modo non ovvio.'
    a_expired 'diritto d\'autore e diritti su banche dati sono scaduti',
      :text_as_statement => 'i diritti sono scaduti',
      :help_text => 'i diritti sulle banche dati durano dieci anni. Se i dati sono stati modificati più di dieci anni fa, quindi i diritti sulle banche dati decadono. Il diritto d\'autore dura per un determinato periodo di tempo, sia in base al numero di anni trascorsi dalla morte del suo creatore o dalla sua pubblicazione. Il copyright è improbabile che sia scaduto.'
    a_waived 'il diritto d\'autore e i diritti relativi alle banche di dati sono stati ceduti',
      :text_as_statement => '',
      :help_text => 'Ciò significa che nessuno detiene i diritti e tutti possono fare ciò che vogliono con questi dati.'

    q_dataWaiver 'Quale tipologia di cessione si utilizza per cedere i diritti sui dati?',
      :discussion_topic => :it_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'I diritti sui dati sono stati ceduti con',
      :help_text => 'Hai bisogno di una dichiarazione per mostrare alle persone i diritti che sono stati ceduti in modo che capiscano che possono fare ciò che vogliono con questi dati. Tipologie standard di cessione dei diritti già esistono, come PDDL e CCZero, ma è possibile scrivere la propria servendosi di una consulenza legale.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication e Licenza ( PDDL )',
      :text_as_statement => 'Open Data Commons Public Domain Dedication e Licenza ( PDDL )'
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Altro...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Dove è la rinuncia dei diritti sui dati?',
      :discussion_topic => :it_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Diritti sui dati sono stati revocati con',
      :help_text => 'Fornisci un URL per la rinuncia disponibile al pubblico così che le persone possano verificare la gente può verificare la revoca dei diritti sui dati.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'URL Rinuncia',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL Rinuncia'

    q_otherDataLicenceName 'Qual è il nome della licenza?',
      :discussion_topic => :it_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono disponibili sotto',
      :help_text => 'se si utilizza una licenza diversa, è necessario che tu fornisca il nome così che si possa leggerla sul tuo certificato Open Data.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Nome di un\'altra licenza',
      :string,
      :required => :required,
      :placeholder => 'Nome di un\'altra licenza'

    q_otherDataLicenceURL 'Dove è la licenza?',
      :discussion_topic => :it_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Questa licenza è a',
      :help_text => 'Fornisci un URL per la licenza, affinché si possa leggere sul Certificato Open Data e verificare che sia disponibile al pubblico.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'URL Altra licenza',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL Altra licenza'

    q_otherDataLicenceOpen 'la licenza è una licenza aperta?',
      :discussion_topic => :it_otherDataLicenceOpen,
      :help_text => 'se non siete sicuri su cosa sia una licenza aperta, leggete la <a href="http://opendefinition.org/">Open Knowledge Definition </a>. Quindi, scegliete la licenza dalla lista <a href="http://licenses.opendefinition.org/">delle licenze aperte dell\'Open Definition Advisory Board </a>. Se la licenza non fosse in questa lista, non è aperta o non è stata ancora valutata.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'sì',
      :requirement => ['basic_7']

    label_basic_7 '
                  <strong>È necessario pubblicare i dati aperti sotto una licenza aperta</strong> in modo che le persone possano usarli.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'C\'è diritto di autore sul contenuto di questi dati?',
      :discussion_topic => :it_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Ci sono',
      :pick => :one,
      :required => :required
    a_norights 'no, i dati contengono solo cifre e numeri',
      :text_as_statement => 'nessun diritto sul contenuto dei dati',
      :help_text => 'Non vi è alcun diritto d\'autore su informazioni oggettive. Se i dati non contengono alcun contenuto creato attraverso sforzo intellettuale, non ci sono diritti sul contenuto.'
    a_samerights 'sì, ei diritti sono tutti in mano alla stessa persona o organizzazione',
      :text_as_statement => '',
      :help_text => 'Scegli questa opzione se il contenuto dei dati è stato creato interamente da o trasferito alla stessa persona o organizzazione.'
    a_mixedrights 'sì, e i diritti sono detenuti da persone o organizzazioni diverse',
      :text_as_statement => '',
      :help_text => 'In alcuni dati, i diritti in diversi record sono detenuti da persone o organizzazioni diverse. Anche le informazioni sui diritti devono essere mantenute nei dati.'

    q_explicitWaiver 'è il contenuto dei dati contrassegnati come dominio pubblico?',
      :discussion_topic => :it_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'il contenuto è stato',
      :help_text => 'Il contenuto può essere contrassegnato come di pubblico dominio utilizzando il <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark </a>. Questo aiuta la gente a scoprire che può essere liberamente riutilizzato.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'contrassegnato come pubblico dominio',
      :requirement => ['standard_3']

    label_standard_3 'Dovresti<strong>contrassegnare contenuti di dominio pubblico come dominio pubblico</strong> in modo che le persone sappiano di poterli riutilizzare.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Sotto quale licenza altri possono riutilizzare i contenuti?',
      :discussion_topic => :it_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Il contenuto è disponibile sotto',
      :help_text => 'Ricorda che chi spende sforzo intellettuale nella creazione di contenuti acquisisce automaticamente i diritti su di essi, ma i contenuti creativi non includono elementi concretii. Per questo è necessaria una rinuncia o una licenza che dimostri che essi possono utilizzare il contenuto e che spieghi come possono farlo legalmente. Elenchiamo le licenze più comuni qui, se non vi fosse alcun diritto d\'autore sul contenuto, se fosse scaduto, se non si fosse verificato atto di rinuncia, scegli \'Non applicabile\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Creative Commons Attribuzione',
      :text_as_statement => 'Creative Commons Attribuzione'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike',
      :text_as_statement => 'Creative Commons Attribution Share-Alike'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_iodl 'Italian Open Data License v1.0',
      :text_as_statement => 'Italian Open Data License v1.0'
    a_iodl_2_0 'Italian Open Data License v2.0',
      :text_as_statement => 'Italian Open Data License v2.0'
    a_na 'Non applicabile',
      :text_as_statement => ''
    a_other 'Altro...',
      :text_as_statement => ''

    q_contentNotApplicable 'Perché non si applica una licenza al contenuto dei dati?',
      :discussion_topic => :it_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Il contenuto di questi dati non è concesso in licenza a causa',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'non c\'è diritto di autore sul contenuto di questi dati',
      :text_as_statement => 'non vi è alcun diritto d\'autore',
      :help_text => 'Il diritto di autore si applica al contenuto soltanto se al momento della creazione hai impiegato sforzo di tipo intellettuale, ad esempio, scrivendo il testo che è all\'interno dei dati. Non si puo\' rivendicare alcun diritto d\'autore se il contenuto contiene solo fatti.'
    a_expired 'il diritto di autore è scaduto',
      :text_as_statement => 'il diritto di autore è scaduto',
      :help_text => 'IL diritto d\'autore dura per un determinato periodo di tempo, si basa sul numero di anni dopo la morte del suo creatore o la sua pubblicazione. Si dovrebbe verificare se il contenuto è stato creato o pubblicato, perché se era molto tempo fa, il copyright potrebbe essere scaduto.'
    a_waived 'Il diritto d\'autore è stato revocato',
      :text_as_statement => '',
      :help_text => 'questo significa che nessuno detiene diritti d\'autore e tutti possono fare ciò che vogliono con questi dati.'

    q_contentWaiver 'Quale rinuncia si usa per rinunciare al diritti d\'autore?',
      :discussion_topic => :it_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Il diritto d\'autore è stata stato revocato con',
      :help_text => 'Hai bisogno di una dichiarazione da mostrare alle persone rispetto a quello che hai fatto, in modo da capire che possono fare ciò che vogliono con questi dati. Rinunce standard già esistenti come CCZero ma si può scrivere il proprio con la consulenza legale.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Altro...',
      :text_as_statement => 'Altro...'

    q_contentOtherWaiver 'Dove è la rinuncia al diritto d\'autore?',
      :discussion_topic => :it_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Il diritto d\'autore è stato ceduto con',
      :help_text => 'Inserisci una URL dove la propria deroga ai diritti d\'autore sia a disposizione del pubblico affinché le persone possano controllare che la tua deroga sul copyright.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'URL Rinuncia',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL Rinuncia'

    q_otherContentLicenceName 'Qual è il nome della licenza?',
      :discussion_topic => :it_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Il contenuto è disponibile sotto',
      :help_text => 'se si utilizza una licenza diversa, fornisci il suo nome, così che la gente possa verificarlo sul tuo Certificato Open Data.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Nome Licenza',
      :string,
      :required => :required,
      :placeholder => 'Nome Licenza'

    q_otherContentLicenceURL 'Dove è la licenza?',
      :discussion_topic => :it_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'La licenza sul contenuto è',
      :help_text => 'Dare un URL per la patente, così la gente può vedere sul vostro Apri Certificato di dati e verificare che sia disponibile al pubblico.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL licenza',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL licenza'

    q_otherContentLicenceOpen 'La licenza è una licenza aperta?',
      :discussion_topic => :it_otherContentLicenceOpen,
      :help_text => 'se non siete sicuri su cosa sia una licenza aperta, leggete la <a href="http://opendefinition.org/">Open Knowledge Definition</a> . Quindi, scegliete la licenza dalla lista <a href="http://licenses.opendefinition.org/">delle licenze aperte dell\'Open Definition Advisory Board </a>. Se la licenza non fosse in questa lista, non è aperta o non è stata ancora valutata.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'sì',
      :requirement => ['basic_8']

    label_basic_8 '
                     <strong>È necessario pubblicare i dati aperti sotto una licenza aperta</strong> in modo che le persone possano utilizzarli.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Dove si trovano spiegazioni sui diritti e le licenze relative al contenuto?',
      :discussion_topic => :it_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'I diritti e le licenze dei contenuti sono spiegati in',
      :help_text => 'Inserisci l\'URL di una pagina il modo in cui ci si può informare sui diritti e le licenze su una parte del contenuto dei dati.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'URL Descrizione diritti su Contenuto',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL Descrizione diritti su Contenuto'

    q_copyrightStatementMetadata 'La tua dichiarazione sui diritti include versioni processabili dai computer di',
      :discussion_topic => :it_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La dichiarazione dei diritti comprende i dati relativi',
      :help_text => 'È buona prassi incorporare le informazioni sui diritti in formati leggibili dall\'elaboratore in modo tale da permettere agli utenti di attribuirti automaticamente questi dati quando li utilizzano.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'Licenza di dati',
      :text_as_statement => 'la sua licenza sui dati',
      :requirement => ['standard_4']
    a_contentLicense 'licenza d\'uso sul contenuto',
      :text_as_statement => 'la sua licenza sul contenuto',
      :requirement => ['standard_5']
    a_attribution 'testo di attribuzione',
      :text_as_statement => 'quale testo di attribuzione utilizzare',
      :requirement => ['standard_6']
    a_attributionURL 'URL attribuzione',
      :text_as_statement => 'Quale link su attribuzione inserire',
      :requirement => ['standard_7']
    a_copyrightNotice 'avviso o dichiarazione di diritto d\'autore',
      :text_as_statement => 'un avviso di ditirro d\'autore o dichiarazione',
      :requirement => ['exemplar_1']
    a_copyrightYear 'anno copyright',
      :text_as_statement => 'l\'anno del copyright',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'titolare del copyright',
      :text_as_statement => 'il titolare del copyright',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'anno diritto relativo alla base di dati',
      :text_as_statement => 'Anno del diritto sulla base di dati',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'titolare dei diritti sulla base di dati',
      :text_as_statement => 'titolare dei diritti sulla base di dati',
      :requirement => ['exemplar_5']

    label_standard_4 'È necessario fornire <strong>dati processabili dai computer nella tua dichiarazione dei diritti sulla licenza</strong> per questi dati, in modo che gli strumenti possono automaticamente utilizzarli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti sulla licenza per i contenuti</strong> di questi dati, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti sul testo da utilizzare quando stai citando i dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti circa l\'URL dove collegarsi quando stai citando questi dati</strong>, in modo che gli strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti circa la dichiarazione o avviso di copyright su questi dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti circa l\'anno del copyright sui dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti del titolare del copyright sui dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti sull\'anno dei diritti sulla base di dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'Dovresti fornire <strong>dati in formato processabile dai computer nella tua dichiarazione dei diritti del titolare dei diritti sulla base di dati</strong>, in modo che strumenti automatizzati possano utilizzarli.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Privacy',
      :help_text => 'come si protegge la privacy delle persone',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'singoli individui possono essere identificati partendo da questi dati?',
      :discussion_topic => :it_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati contengono',
      :pick => :one,
      :required => :pilot
    a_not_personal 'no, i dati non riguardano le persone o le loro attività',
      :text_as_statement => 'Nessun dato relativo a persone singole',
      :help_text => 'Ricorda che gli individui possono essere ancora identificati, anche se i dati non li riguardano direttamente. Ad esempio, i dati sul flusso del traffico stradale se combinati con i modelli di pendolarismo di un singolo individuo potrebbero rivelare informazioni su quella persona.'
    a_summarised 'no, i dati sono stati resi anonimi aggregando i singoli in gruppi, in modo che non possano essere distinto da altre persone nel gruppo',
      :text_as_statement => 'dati aggregati',
      :help_text => 'controlli informativi statistici possono aiutare a fare in modo che gli individui non siano identificabili all\'interno di dati aggregati.'
    a_individual 'sì, c\'è il rischio che i singoli siano identificati, per esempio da parte di terzi che hanno accesso a informazioni extra',
      :text_as_statement => 'informazioni che potrebbero identificare i singoli individui',
      :help_text => 'Alcuni dati su persone singole sono legittimi come le retribuzioni del pubblico impiego o la spesa pubblica per esempio.'

    q_statisticalAnonAudited 'Il vostro processo di anonimizzazione è stato indipendentemente sottoposto a revisione?',
      :discussion_topic => :it_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Il processo di anonimizzazione è stato',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'sottoposto a revisione indipendente',
      :requirement => ['standard_8']

    label_standard_8 'Dovresti <strong>assicurarti che il tuo processo di anonimizzazione sia indipendente</strong> per accertasri che il rischio di identificazione per i singoli sia ridotto.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Si è cercato di ridurre o eliminare la possibilità di identificazione per i singoli individui?',
      :discussion_topic => :it_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'questi dati sui singoli sono stati',
      :help_text => 'L\'anonimizzazione riduce il rischio per i singoli individui di essere identificati partendo dai dati pubblicati. La tecnica migliore da utilizzare dipende dal tipo di dati che si hanno.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'anonimizzati'

    q_lawfulDisclosure 'Sei autorizzato a pubblicare questi dati sui singoli individui nei modi richiesti e consentiti dalla legge?',
      :discussion_topic => :it_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Per legge, questi dati sui singoli individui',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'deve essere pubblicati',
      :requirement => ['pilot_5']

    label_pilot_5 'Dovresti <strong>pubblicare dati personali senza anonimizzazione se sei autorizzato a farlo come richiesto e consentito dalla legge</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Dove documenti il diritto di pubblicare i dati relativi a singoli individui?',
      :discussion_topic => :it_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'Il diritto di pubblicare questi dati sui singoli individui è documentato in'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL sulla logica relativa al rilascio dei dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL sulla logica relativa al rilascio dei dati',
      :requirement => ['standard_9']

    label_standard_9 'Dovresti <strong>documentare quali sono i tuoi diritti di pubblicare dati relativi a singoli individui</strong> per le persone che usano i tuoi dati e per quelle che subiscono limitazioni.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Hai valutato i rischi di divulgazione di dati personali?',
      :discussion_topic => :it_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'Il curatore ha',
      :help_text => 'Una valutazione di rischio misura i rischi per la privacy dei singoli individui individui nei tuoi dati, nonché l\'uso e la divulgazione di tali informazioni.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'non effettuato una valutazione del rischio privacy'
    a_true 'sì',
      :text_as_statement => 'effettuato una valutazione del rischio privacy',
      :requirement => ['pilot_6']

    label_pilot_6 'dovresti <strong>valutare i rischi di divulgazione di dati personali</strong> se si pubblicano dati relativi a persone.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Dove è pubblicata la tua valutazione di rischio?',
      :discussion_topic => :it_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La valutazione dei rischi è pubblicata in',
      :help_text => 'Inserisci un URL da dove le persone possono controllare come hai valutato i rischi per la privacy dei singoli individui. Questo può essere redatto o riassunto se contiene informazioni sensibili.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL sulla valutazione del rischio',
      :string,
      :input_type => :url,
      :placeholder => 'URL sulla valutazione del rischio',
      :requirement => ['standard_10']

    label_standard_10 'Dovresti <strong>pubblicare la tua valutazione del rischio privacy</strong>, in modo che le persone capiscano come è stato valutato il rischio di divulgazione dei dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'La vostra valutazione di rischi è stata oggetto di revisione indipendente?',
      :discussion_topic => :it_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'La valutazione dei rischi è stata',
      :help_text => 'È buona norma controllare se la vostra valutazione dil rischio è stata effettuata correttamente. Verifiche indipendenti da parte di specialisti o di terzi tendono ad essere più rigorose e imparziali.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'sottoposto a revisione indipendente',
      :requirement => ['standard_11']

    label_standard_11 'Dovresti <strong>sottoporre la tua valutazione del rischio ad una revisione indipendente</strong> per assicurarti che sia stata effettuata correttamente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Dov\'è l\'informativa sulla privacy per gli individui affetti dai tuoi dati?',
      :discussion_topic => :it_individualConsentURL,
      :display_on_certificate => true,
      :text_as_statement => 'Gli individui affetti da questi dati ricevono questa informativa sulla privacy',
      :help_text => 'Quando si raccolgono dati relativi a singoli individui persone è necessario comunicare loro come verranno utilizzati i dati. Le persone che utilizzano i tuoi dati ne hanno bisogno per assicurarsi che siano in conformità con la legislazione sulla protezione dei dati.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL Informativa Privacy',
      :string,
      :input_type => :url,
      :placeholder => 'URL Informativa Privacy',
      :requirement => ['pilot_7']

    label_pilot_7 'Dovresti <strong>comunicare per quali ragioni le persone menzionate nei tuoi dati hanno dato il loro consenso per l\'utilizzo dei loro dati</strong> in modo che la gente possa utilizzare i dati per le stesse finalità conformemente alla normativa sulla protezione dei dati.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'C\'è qualcuno nella tua organizzazione che è responsabile per la protezione dei dati?',
      :discussion_topic => :it_dpStaff,
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'sì'

    q_dbStaffConsulted 'Li avete coinvolti nel processo di valutazione del rischio?',
      :discussion_topic => :it_dbStaffConsulted,
      :display_on_certificate => true,
      :text_as_statement => 'Il responsabile della protezione dei dati',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'è stato consultato',
      :requirement => ['pilot_8']

    label_pilot_8 'Dovresti <strong>coinvolgere la persona responsabile per la protezione dei dati</strong> nella propria organizzazione prima di pubblicare questi dati.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Il vostro approccio all\'anonimizzazione è stato sottoposto a una revisione indipendente?',
      :discussion_topic => :it_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'L\' anonimizzazione dei dati è stata',
      :help_text => 'È buona norma assicurarsi che il processo di rimozione dei dati personali identificabili funzioni correttamente. Verifiche indipendenti effettuate da specialisti o da terzi tendono ad essere più rigorose e imparziali.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'sottoposto a revisione indipendente',
      :requirement => ['standard_12']

    label_standard_12 'Dovresti <strong>assicurarti che il processo di anonimizzazione sia sottoposto a verifica indipendente</strong> da parte di un esperto per assicurarsi che risulti appropriato per i tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Informazioni pratiche',
    :description => 'Reperibilità, precisione, qualità e garanzie' do

    label_group_6 'Reperibilità',
      :help_text => 'Come aiutare le persone a trovare i tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Il tuo sito web principale ha un link ai tuoi dati?',
      :discussion_topic => :onWebsite,
      :help_text => 'E\' più facile trovare i dati se sono collegati a partire dal tuo sito web principale.',
      :pick => :one
    a_false 'no'
    a_true 'sì',
      :requirement => ['standard_13']

    label_standard_13 'Dovresti <strong>assicurarti che le persone possano trovare i dati a partire dal tuo sito web principale </strong> per facilitarne l\'accesso',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Pagina Web' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Nel tuo sito web, qual\'è la pagina che dà accesso ai dati?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'il sito web collega i dati da',
        :help_text => 'Dai al tuo sito web principale una URL che dà accesso a questi dati',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'URL della pagina Web',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL della pagina Web'

    end

    q_listed 'I tuoi dati fanno parte di un elenco di dati?',
      :discussion_topic => :listed,
      :help_text => 'In generale è più facile trovare i dati quando fanno parte di un catalogo di dati come ad esempio quelli accademici, del settore pubblico o della sanità oppure quando appaiono in risultati di ricerca pertinenti.',
      :pick => :one
    a_false 'no'
    a_true 'sì',
      :requirement => ['standard_14']

    label_standard_14 'Dovresti <strong>fare in modo che le persone possano trovare i tuoi dati quando li cercano </strong>all\'interno di elenchi specifici.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Elenco' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Dove sono elencati?',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'I dati fanno parte di questa collezione',
        :help_text => 'Attribuisci una URL che specifichi dove si trovano i dati. Ad esempio, data.gov.uk ( se si tratta di dati del settore pubblico nel Regno Unito ), hub.data.ac.uk (se si tratta di dati accademici del Regno Unito) o una URL per i risultati del motore di ricerca.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Elenco di URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Elenco di URL'

    end

    q_referenced 'Le tue pubbblicazioni fanno riferimento a questi dati?',
      :discussion_topic => :referenced,
      :help_text => 'Quando fai riferimento ai tuoi dati nelle tue pubblicazioni, come nel caso di relazioni, presentazioni o blog, dai più contesto ed aiuti le persone a trovare e comprendere più facilmente i tuoi dati',
      :pick => :one
    a_false 'no'
    a_true 'sì',
      :requirement => ['standard_15']

    label_standard_15 'Dovresti <strong>far riferimento a questi dati a partire dalle tue pubblicazioni</strong> in modo che le persone possano venire a conoscenza della loro esistenza e contesto.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Riferimenti' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Dove sono menzionati i tuoi dati?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Questi dati sono menzionati in',
        :help_text => 'Dai una URL ad un documento che citi o faccia riferimento a questi dati.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL di riferimento',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL di riferimento'

    end

    label_group_7 'Precisione',
      :help_text => 'Come mantieni i tuoi dati aggiornati',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'I dati dietro all\'API vengono modificati?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'I dati dietro all\'API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'no, l\'API dà accesso a dei dati che non cambiano',
      :text_as_statement => 'non cambieranno',
      :help_text => 'Alcune API rendono più facile l\'accesso a un gruppo di dati che non cambia, soprattutto quando ce ne sono molti.'
    a_changing 'sì, l\'API dà accesso a dei dati che cambiano nel corso del tempo',
      :text_as_statement => 'cambieranno',
      :help_text => 'Alcune API danno accesso a dei dati che sono costantemente messi a giorno e che sono in continua evoluzione'

    q_timeSensitive 'I tuoi dati diventeranno obsoleti?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'La precisione o la rilevanza di questi dati sarà',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'sì, questi dati diventeranno obsoleti',
      :text_as_statement => 'diventeranno obsoleti',
      :help_text => 'Ad esempio, i dati sulle fermate degli autobus diventeranno obsoleti nel momento in cui alcune fermate verranno spostate o delle nuove create.'
    a_timestamped 'sì, questi dati diventeranno obsoleti; ma questa informazione verrà indicata.',
      :text_as_statement => 'diventeranno obsoleti ma verrà indicato',
      :help_text => 'Ad esempio, le statistiche demografiche di solito includono il periodo in cui sono state rilevate.',
      :requirement => ['pilot_9']
    a_false 'no, questi dati non contegono nessuna informazione di carattere temporale',
      :text_as_statement => 'non diventeranno obsoleti',
      :help_text => 'Ad esempio, i risultati di un esperimento non diverranno mai obsoleti perché i dati indicano dei risultati riportati a seguito di risultati riscontrati.',
      :requirement => ['standard_16']

    label_pilot_9 '
                        <strong>Quando pubblichi i tuoi dati dovresti indicare il periodo di riferimento </strong> così la gente sa quando i dati diventeranno obsoleti.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'Dovresti <strong>pubblicare gli aggiornamenti dei dati che contengono informazioni che variano nel tempo</strong> per evitare che diventino obsoleti',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Questi dati cambiano almeno una volta al giorno?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati cambiano',
      :help_text => 'Indica se i dati cambiano quasi tutti i giorni. Quando i dati cambiano frequentemente rischiano di diventare obsoleti altrettanto rapidamente e la gente deve sapere se li metti a giorno e con quale frequenza.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'Si, almeno una volta al giorno'

    q_seriesType 'Di che tipo di pacchetti di dati si tratta?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono una serie di',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'Copie della banca dati ad intervalli regolari',
      :text_as_statement => 'Copie della banca dati',
      :help_text => 'Scegli se pubblichi ad intervalli regolari copie di tutta la tua banca dati. Quando fai un\'estrazione della banca dati, è utile dare accesso ad un flusso di informazione che segnali eventuali modifiche della banca dati, così le persone possono mantenere le proprie copie aggiornate.'
    a_aggregate 'Aggregazioni di dati variabili pubblicati ad intervalli regolari',
      :text_as_statement => 'Aggregazioni di dati variabili',
      :help_text => 'Scegli se crei nuovi pacchetti di dati ad intervalli regolari. Puoi scegliere questo approccio se i dati non possono essere pubblicati in formato aperto o se pubblichi solo dati nuovi rispetto all pubblicazione precedente.'

    q_changeFeed 'è disponibile un flusso d\'informazioni che notifichi le modifiche fatte su questi dati?',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'Un flusso d\'informazione che notifichi le modifiche fatte su questi dati.',
      :help_text => 'Informa le persone se fornisci un flusso d\'informazioni che notifica le modifiche che hanno un impatto su questi dati. I flussi d\'informazioni possono essere in RSS, Atom o formati personalizzati.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'è disponibile',
      :requirement => ['exemplar_6']

    label_exemplar_6 'Dovresti <strong>fornire un flusso d\'informazioni che notifichi le modifiche apportate ai tuoi dati</strong> così le persone possono mantenere le loro copie aggiornate e corrette.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Ogni quanto crei un aggiornamento?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Vengono pubblicati degli aggiornamenti su questi dati',
      :help_text => 'Questo determina i criteri che rendono obsoleti questi dati prima che le persone possano ottenere un aggiornamento.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'meno di una volta al mese',
      :text_as_statement => 'meno di una volta al mese'
    a_monthly 'almeno ogni mese',
      :text_as_statement => 'almeno ogni mese',
      :requirement => ['pilot_10']
    a_weekly 'almeno ogni settimana',
      :text_as_statement => 'almeno ogni settimana',
      :requirement => ['standard_17']
    a_daily 'almeno ogni giorno',
      :text_as_statement => 'almeno ogni giorno',
      :requirement => ['exemplar_7']

    label_pilot_10 'Dovresti <strong>creare un aggiornamento ogni mese</strong> così le persone possono mantenere le loro copie aggiornate e corrette.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Dovresti <strong>creare un aggiornamento ogni settimana</strong> così le persone possono mantenere le loro copie aggiornate e corrette.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'Dovresti <strong>creare un aggiornamento ogni giorno</strong> così le persone possono mantenere le proprie copie correttamente aggiornate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Qual\' è il tempo tra il momento in cui un pacchetto di dati viene creato e il momento della sua pubblicazione ?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'Il tempo tra la creazione e la pubblicazione di questi dati è di',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'più lungo del divario fra le due versioni',
      :text_as_statement => 'più lungo del divario fra le due versioni',
      :help_text => 'Ad esempio, se crei una nuova versione del pacchetto di dati ogni giorno, scegliere questa opzione se ci vuole più di un giorno per essere pubblicato.'
    a_reasonable 'più o meno come il divario fra le pubblicazioni',
      :text_as_statement => 'più o meno come il divario fra le pubblicazioni',
      :help_text => 'Ad esempio, se si crea una nuova versione del pacchetto di dati ogni giorno, scegliere questa opzione se ci vuole circa un giorno per essere pubblicato.',
      :requirement => ['pilot_11']
    a_good 'meno della metà del divario che esiste fra le versioni',
      :text_as_statement => 'meno della metà del divario che esiste fra le versioni',
      :help_text => 'Ad esempio, se si crea una nuova versione del pacchetto di dati ogni giorno, scegliere questa opzione se ci vogliono meno di dodici ore per essere pubblicato.',
      :requirement => ['standard_18']
    a_minimal 'non vi è nessun ritardo oppure il ritardo è minimo',
      :text_as_statement => 'minimo',
      :help_text => 'Scegliere questa opzione se pubblichi nel giro di pochi secondi o pochi minuti.',
      :requirement => ['exemplar_8']

    label_pilot_11 'Dovresti fare in modo che <strong>ci sia un ritardo ragionevole tra il momento di creazione e quello di pubblicazione di un pacchetto di dati </strong> corrispondente ad un divario inferiore a quello che esiste tra le due pubblicazioni , così le persone mantengono le proprie copie correttamente aggiornate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Dovresti <strong>avere un lasso di tempo limitato tra il momento di creazione e quello di pubblicazione di un pacchetto di dati</strong> tale da corrispondere a meno della metà del divario fra le diverse pubblicazioni, così la gente mantiene le proprie copie correttamente aggiornate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'Dovresti <strong>avere un ritardo minimo o inesistente tra il momento di creazione e quello di pubblicazione di un pacchetto di dati</strong> così che le persone possano mantenere le loro copie correttamente aggiornate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Pubblichi anche delle estrazioni di questi pacchetti di dati?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'Il gestore pubblica',
      :help_text => 'Un dump è un\'estrazione del pacchetto intero di dati in un file che la gente può scaricare. Questo consente alle persone di fare delle analisi differenti rispetto a quelli possibili attraverso un accesso API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'Estrazioni (dump) dei dati',
      :requirement => ['standard_19']

    label_standard_19 'Dovresti <strong>far scaricare l\'intero pacchetto di dati</strong> così da permettere delle analisi più complete ed accurate avendo tutti i dati a disposizione.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'Con che frequenza crei un\'estrazione della banca dati?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Vengono creati delle estrazioni della banca dati',
      :help_text => 'Dare un accesso più rapido a quelle parti di pacchetti di dati che vengono modificate più frequentemente permette di utilizzare questa informazione prima e con i dati più aggiornati.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'meno di una volta al mese',
      :text_as_statement => 'meno di una volta al mese'
    a_monthly 'almeno ogni mese',
      :text_as_statement => 'almeno ogni mese',
      :requirement => ['pilot_12']
    a_weekly 'entro una settimana dal momento in cui ogni cambiamento viene introdotto',
      :text_as_statement => 'entro una settimana dal momento in cui ogni cambiamento viene introdotto',
      :requirement => ['standard_20']
    a_daily 'entro un giorno dal momento in cui un cambiamento viene introdotto',
      :text_as_statement => 'entro un giorno dal momento in cui un cambiamento viene introdotto',
      :requirement => ['exemplar_9']

    label_pilot_12 'Si dovrebbe <strong>creare una nuova estrazione della banca dati ogni mese</strong> così che le persone possano accedere ai dati più recenti.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Si dovrebbe <strong>creare una nuova estrazione della banca dati entro una settimana dal momento in cui una modifica viene introdotta</strong> per garantire un accesso a dei dati sempre aggiornati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'Dovresti <strong>creare un nuova estrazione della banca dati entro un giorno dal momento in cui una modifica viene introdotta</strong> per garantire un accesso a dei dati sempre aggiornati.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'I tuoi dati verranno corretti se hanno degli errori?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Gli errori in questi dati sono',
      :help_text => 'E\' buona pratica correggere gli errori nei dati, soprattutto se li usi tu stesso. Quando si apportano le correzioni, la gente deve esserne informata.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'corretti',
      :requirement => ['standard_21']

    label_standard_21 'Dovresti <strong>correggere i dati quando le persone riportano degli errori</strong> in modo che tutti possano beneficiare dei miglioramenti apportati in termine di precisione.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Qualità',
      :help_text => 'Quanta gente può contare sui tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Dove riporti i problemi qualitativi di questi dati?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La qualità dei dati è documentata in',
      :help_text => 'Attribuisci una URL dove le persone possono trovare informazioni sulla qualità dei tuoi dati. Le persone accettano l\'esistenza di errori dovuti a malfunzionamenti delle apparecchiature o errori che accadono in fase di migrazione di un sistema. Dovresti essere aperto alle osservazioni fatte sulla qualità dei dati, così la gente può giudicare quanto fare affidamento su tali dati.'
    a_1 'URL della documentazione relativa alla qualità dei dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL della documentazione relativa alla qualità dei dati',
      :requirement => ['standard_22']

    label_standard_22 'Dovresti<strong>documentare i problemi noti sulla qualità dei dati </strong> in modo che le persone possano decidere quanto fidarsi dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Dov\'è descritto il procedimento usato per il controllo qualità?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'I procedimenti usati per il controllo qualità sono descritti in',
      :help_text => 'Dai una URL che permette allle persone di conoscere i controlli che vengono effettuati sui dati, sia automatici che manuali. Questo rassicura le persone e fa loro capire che prendi sul serio la qualità dei dati ed incoraggi miglioramenti a beneficio di tutti.'
    a_1 'URL che dà accesso alla descrizione del procedimento usato per il controllo qualità',
      :string,
      :input_type => :url,
      :placeholder => 'URL che dà accesso alla descrizione del procedimento usato per il controllo qualità',
      :requirement => ['exemplar_10']

    label_exemplar_10 'Dovresti <strong>documentare il procedimentousato per fare il controllo sulla qualità dei dati</strong> in modo che le persone possano decidere quanto fidarsi dei tuoi dati.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garanzie',
      :help_text => 'Quanta gente può dipendere dalla disponibilità dei tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Fai dei backup paralleli?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'I dati sono',
      :help_text => 'Fare dei backup paralleli regolari aiuta a garantire che i dati non vengano persi in caso di incidenti.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'il backup è fatto parallelamente',
      :requirement => ['standard_23']

    label_standard_23 'Dovresti <strong>fare dei backup paralleli</strong> in modo che i dati non vengano persi se si verifica un incidente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Dove descrivi le garanzie sulla disponibilità del servizio?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'La disponibilità del servizio è descritta in',
      :help_text => 'Dai una URL alla pagina che descrive il tipo di garanzie che offri alle persone. Per esempio potresti offrire un uptime garantito del 99,5 %, o potresti non fornire alcuna garanzia.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL che documenta la disponibilità del servizio',
      :string,
      :input_type => :url,
      :placeholder => 'URL che documenta la disponibilità del servizio',
      :requirement => ['standard_24']

    label_standard_24 'Dovresti <strong>descrivere quali garanzie offri sulla disponibilità del servizio</strong> in modo che le persone sappiano quanto possono fare affidamento su di esso.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Dove dai informazioni sullo status attuale del servizio?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Lo status del servizio è disponibile a',
      :help_text => 'Dai la URL che informa la gente sullo status attuale del tuo servizio, compresi eventuali difetti, se ne sei a conoscenza.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL sullo status del servizio',
      :string,
      :input_type => :url,
      :placeholder => 'URL sullo status del servizio',
      :requirement => ['exemplar_11']

    label_exemplar_11 'Dovresti <strong>avere una pagina sullo status del servizio</strong> che dice alla gente quale sia lo status del tuo servizio.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Per quanto tempo questi dati saranno disponibili?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'I dati sono disponibili',
      :pick => :one
    a_experimental 'Potrebbero scomparire in qualsiasi momento',
      :text_as_statement => 'Sono disponibili in modo sperimentale e potrebbero scomparire in qualsiasi momento'
    a_short 'Sono disponibili in via sperimentale, ma lo saranno per circa un altro anno',
      :text_as_statement => 'Sono disponibili sperimentalmente più o meno per un anno',
      :requirement => ['pilot_13']
    a_medium 'Rientrano nei tuoi piani a medio termine, quindi dovrebbero essere disponibili per un paio di anni',
      :text_as_statement => 'per almeno un paio di anni',
      :requirement => ['standard_25']
    a_long 'Fanno parte delle tue attività quotidiane, quindi rimarranno disponibili per molto tempo',
      :text_as_statement => 'per molto tempo',
      :requirement => ['exemplar_12']

    label_pilot_13 'Dovresti <strong>dare garanzie che i tuoi dati siano disponibili in questa forma per almeno un anno</strong> in modo che le persone possano decidere quanto fare affidamento sui tuoi dati.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Dovresti <strong>garantire che i tuoi dati siano disponibili in questo modo nel medio termine</strong> in modo che le persone possano decidere quanto fidarsi dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 'Dovresti <strong>garantire che i tuoi dati siano disponibili in questa forma nel lungo termine</strong> in modo che le persone possano decidere quanto fidarsi dei tuoi dati.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Informazioni tecniche',
    :description => 'Luoghi, formati e fiducia' do

    label_group_11 'Luoghi',
      :help_text => 'Il modo in cui le persone possono accedere ai tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Dove si trova il tuo pacchetto di dati?',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono pubblicati in',
      :help_text => 'Dai una URL al pacchetto di dati stesso. Per essere disponibili in un formato aperto i dati dovrebbero essere collegati direttamente sul web, così la gente può facilmente trovarli e riutilizzarli.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'URL del pacchetto di dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL del pacchetto di dati',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'Devi <strong>fornire una URL ai dati o una URL alla loro documentazione</strong> in modo che la gente possa trovare questa informazione.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'Dovresti <strong>avere una URL che dia un collegamento diretto ai dati stessi</strong> in modo che le persone possano accedervi facilmente.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Come si fa a pubblicare una serie di dati relativa agli stessi pacchetti di dati?',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'Come un\'unica URL che viene regolarmente aggiornata',
      :help_text => 'Scegli questa opzione se c\'è una URL che permette alle persone di scaricare la versione più recente del pacchetto di dati.',
      :requirement => ['standard_26']
    a_template 'Una URLunica e coerente per ogni versione',
      :help_text => 'Scegli questa opzione se la tua URL del pacchetto di dati segue uno schema regolare che include la data di pubblicazione, ad esempio, una URL che inizia con \'2013 - 04\'. Questo aiuta le persone a capire quanto spesso si pubblicano i dati e di scrivere script che recuperano quelli nuovi ogni volta che vengono rilasciati.',
      :requirement => ['pilot_15']
    a_list 'come una lista di versioni pubblicate',
      :help_text => 'Scegli questa opzione se disponi di una lista di pacchetti di dati in una pagina Web o un feed (come Atom o RSS) con link per ogni versione pubblicata e relativi dettagli. Questo aiuta le persone a capire quanto spesso si pubblicano i dati e di scrivere script che recuperano quelli nuovi ogni volta che vengono pubblicati.',
      :requirement => ['standard_27']

    label_standard_26 'Dovresti <strong>avere una URL unica e persistente per scaricare la versione attuale dei dati</strong> in modo che le persone possano accedervi facilmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Dovresti <strong>utilizzare un modello coerente per le URL delle diverse versioni pubblicate</strong> in modo che le persone possano scaricarle automaticamente.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'Dovresti <strong>avere un documento o un feed con un elenco di versioni pubblicate disponibili</strong>, così la gente può creare script per scaricarle tutte.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Devi <strong>fornire l\'accesso ai diversi aggiornamenti dei tuoi dati tramite una URL</strong> che dia la versione attuale, una serie di URL o una pagina di documentazione in modo che le persone possano trovare l\'informazione.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Dove si trova il pacchetto di dati attuale?',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'L\'attuale pacchetto di dati è disponibile su',
      :help_text => 'Inserisci un\'unica URL per la versione più recente del pacchetto di dati. Il contenuto di questa URL dovrebbe cambiare ogni volta che una nuovo aggiornamento viene pubblicato.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'URL del pacchetto di dati attuale',
      :string,
      :input_type => :url,
      :placeholder => 'URL del pacchetto di dati attuale',
      :required => :required

    q_versionsTemplateUrl 'Quale formato di URL viene utilizzato dagli aggiornamenti dei pacchetti di dati?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Gli aggiornamenti che vengono pubblicati seguono questo modello coerente di URL',
      :help_text => 'Questa è la struttura della URL quando pubblichi delle versioni differenti. Usa ` { variabile } ` per indicare le parti della URL che cambiano, per esempio, ` http://example.com/data/monthly/mydata- { AA } { MM }. Csv `',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'URL del modello utilizzato per identificare gli aggiornamenti',
      :string,
      :input_type => :text,
      :placeholder => 'URL del modello utilizzato per identificare gli aggiornamenti',
      :required => :required

    q_versionsUrl 'Dov\'è la lista dei pacchetti di dati pubblicati?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Gli aggiornamenti di questi dati sono elencati su',
      :help_text => 'Inserisci la URL della pagina o di un flusso d\'informazioni con l\'elenco dei pacchetti di dati processabili dal computer. Utilizzare la URL della prima pagina che dovrebbe collegare le altre pagine.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'URL della lista degli aggiornamenti',
      :string,
      :input_type => :url,
      :placeholder => 'URL della lista degli aggiornamenti',
      :required => :required

    q_endpointUrl 'Dove si trova l\'endpoint della tua API?',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Il servizio endpoint API è',
      :help_text => 'Dai una URL che sia il punto di partenza degli script per accedere alla tua API. In questa pagina ci dovrebbe essere un documento di descrizione del servizio che aiuta lo script a capire quali servizi esistono.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'La URL dell\'endpoint',
      :string,
      :input_type => :url,
      :placeholder => 'La URL dell\'endpoint',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 '
                     <strong>È necessario fornire sia un URL di endpoint di API o un URL della sua documentazione</strong> in modo che le persone possano trovare questa informazione.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Dovresti <strong>avere un documento che descrive il servizio o il punto di accesso unico per la vostra API</strong> per permettere alle persone di accedervi.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Come si pubblica un\'estrazione della banca dati?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'con una unica URL che viene regolarmente aggiornata',
      :help_text => 'Scegli questa opzione se c\'è una URL attraverso la quale le persone possono scaricare la versione più recente dell\'estrazione della banca dati.',
      :requirement => ['standard_29']
    a_template 'come una URL coerente per ogni aggiornamento',
      :help_text => 'Scegli questa opzione se la tua URL dell\'estrazione della banca dati segue uno schema regolare che include la data di pubblicazione, ad esempio una URL che inizia con \'2013 - 04\'. Questo aiuta le persone a capire quanto spesso i dati sono pubblicati, e di scrivere script che recuperano quelli nuovi ogni volta che vengono pubblicati.',
      :requirement => ['exemplar_13']
    a_list 'come una lista di versioni pubblicate',
      :help_text => 'Scegli questa opzione se disponi di un elenco di estrazioni della banca dati in una pagina Web o un flusso d\'informazioni (come Atom o RSS ) con link a ogni singola versione assieme ai suoi dettagli. Questo aiuta le persone a capire quanto spesso pubblichi i dati, e di scrivere script che recuperano i nuovi dati ogni volta che vengono pubblicati.',
      :requirement => ['exemplar_14']

    label_standard_29 'Dovresti <strong>avere un\'unica URL persistente per scaricare l\'attuale estrazione della banca dati </strong> per permettere alle persone di trovare quest\'informazione.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 'Dovresti <strong>utilizzare un modello coerente per le URL dell\'estrazione della banca dati</strong> in modo che le persone possano scaricarli automaticamente.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 'Dovresti <strong>avere un documento o un flusso d\'informazioni con un elenco delle estrazioni della banca dati disponibili</strong>, così la gente può creare script per scaricarli tutti.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Dov\'è la più recente estrazione della banca dati?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'L\'estrazione più recente della banca dati è sempre disponibile presso',
      :help_text => 'Inserisci la URL dell\'ultima estrazione della banca dati. Il contenuto di questa URL dovrebbe cambiare ogni volta che una nuova estrazione della banca dati è stata creata.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'URL dell\'estrazione più recente',
      :string,
      :input_type => :url,
      :placeholder => 'URL dell\'estrazione più recente',
      :required => :required

    q_dumpsTemplateUrl 'Qual è il formato URL seguito dall\'estrazione della banca dati?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'L\'estrazione della banca dati segue lo schema corrente della URL',
      :help_text => 'Questa è la struttura della URL quando diverse versioni vengono pubblicate. Usa ` { variabile } ` per indicare le parti della URL che cambiano, per esempio, ` http://example.com/data/monthly/mydata- { AA } { MM }. Csv `',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'URL del modello dell\'estrazione',
      :string,
      :input_type => :text,
      :placeholder => 'URL del modello dell\'estrazione',
      :required => :required

    q_dumpsUrl 'Dov\'è il tuo elenco delle disponibili estrazioni della banca dati?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'un elenco delle estrazioni della banca dati si trova su',
      :help_text => 'Inserisci una URL di una pagina o di un flusso d\'informazioni con l\'elenco dell\'estrazioni della banca dati processabile dal computer. Utilizzare la URL della prima pagina che dovrebbe collegare alle altre pagine.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'URL dell\'elenco delle estrazioni',
      :string,
      :input_type => :url,
      :placeholder => 'URL dell\'elenco delle estrazioni',
      :required => :required

    q_changeFeedUrl 'Dove si trova il tuo flusso di informazioni che indica le modifiche apportate ai dati?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Un feed di modifiche a tali dati è disponibile su',
      :help_text => 'Dai una URL ad una pagina o ad un flusso d\'informazioni che fornisca un elenco delle estrazioni precedenti della banca dati, processabili dal computer. Utilizza la URL della prima pagina che dovrebbe collegare alle altre pagine.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'URL del feed relativo alle modifiche',
      :string,
      :input_type => :url,
      :placeholder => 'URL del feed relativo alle modifiche',
      :required => :required

    label_group_12 'Formati',
      :help_text => 'Diverse modalità per lavorare con i tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Questi dati sono processabili dal computer?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati sono',
      :help_text => 'La gente preferisce formati che siano facilmente processabili dal computer, perché aumentano la velocità e precisione di trattamento dei dati. Per esempio, una fotocopia scannerizzata di un foglio di calcolo non può essere processata dal computer; al contrario un file CSV lo è.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'processabili dal computer',
      :requirement => ['pilot_16']

    label_pilot_16 'Dovresti <strong>fornire i dati in un formato che sia processabile dal computer</strong> per permettere una facile elaborazione dei dati.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Questi dati sono disponibili in un formato standard aperto?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'Il formato di questi dati è',
      :help_text => 'Gli standard aperti sono creati attraverso un procedimento equo, trasparente e collaborativo. Chiunque li può utilizzare e grazie al sostegno di cui godono è più facile condividere i dati con più persone. Ad esempio, XML, CSV e JSON sono standard aperti.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'formato standard aperto',
      :requirement => ['standard_30']

    label_standard_30 'Dovresti <strong>fornire i dati in un formato standard aperto</strong> in modo che le persone possano utilizzare strumenti ampiamente disponibili per elaborare i dati più facilmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Che tipo di dati pubblichi?',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'documenti che possono essere letti dalle persone',
      :help_text => 'Scegli questa opzione se i dati sono usufruiti dall\'uomo. Per esempio, documenti politici, white paper, report e verbali delle riunioni. Questi di solito hanno una loro propria struttura, ma sono principalmente a carattere testuale.'
    a_statistical 'dati statistici, come conteggi, medie e percentuali',
      :help_text => 'Scegli questa opzione se i dati sono di tipo numerico come conteggi, medie, percentuali o statistiche. Ad esempio, come risultati del censimento, informazioni sul flusso ed il traffico o statistiche sulla criminalità.'
    a_geographic 'informazioni geografiche, come punti e confini',
      :help_text => 'Scegli questa opzione se i dati possono essere tracciati su una mappa come punti, confini o linee.'
    a_structured 'altri tipi di dati strutturati',
      :help_text => 'Scegli questa opzione se i dati sono strutturati in altri modi. Come i dettagli di un evento, orari ferroviari, contatti o qualsiasi cosa che può essere interpretata come dati, analizzata e presentata in diversi modi.'

    q_documentFormat 'I tuoi documenti processabili dal computer includono formati che',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'I documenti sono pubblicati',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'descrivere la struttura semantica come HTML, DocBook o Markdown',
      :text_as_statement => 'in formato semantico',
      :help_text => 'questi formati etichettano strutture come capitoli, voci e tabelle che rendono più facile la creazione automatica di sommari e glossari. Permettono di applicare ai documenti stili diversi modificandone l\'aspetto.',
      :requirement => ['standard_31']
    a_format 'descrivi l\'informazione sulla formattazione come OOXML o PDF',
      :text_as_statement => 'in un formato di visualizzazione',
      :help_text => 'questi formati enfatizzano l\'apparenza dei documenti come lo stile di formattazione, i colori e il posizionamento dei vari elementi all\'interno della pagina. Sono facilmente utilizzabili dall\'uomo, ma non sono facili da processare dal computer e neanche cambiarne lo stile.',
      :requirement => ['pilot_17']
    a_unsuitable 'non sono pensati per documenti come Excel, JSON o CSV',
      :text_as_statement => 'in un formato non adatto per i documenti',
      :help_text => 'Questi formati sono adatti per formati tabulari o strutturati.'

    label_standard_31 'Dovresti<strong>pubblicare i documenti in un formato che esponga la struttura semanticamente</strong> in modo che la gente possa visualizzare l\'informazione con stili diversi.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'Dovresti <strong>pubblicare i documenti in un formato che sia sato pensato specificamente per loro</strong> in modo che siano facili da processare.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'I tuoi dati statistici includono i formati che',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'I dati statistici sono pubblicati',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'esponi la struttura dei dati statistici hypercube come <a href="http://sdmx.org/">SDMX</a> or <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a>
                     ',
      :text_as_statement => 'in un formato statistico',
      :help_text => 'osservazioni individuali in hypercubes riferiscono a una misura particolare e ad un insieme di dimensioni. Ogni osservazione può anche essere collegata ad annotazioni che danno più contesto. Formati come <a href="http://sdmx.org/">SDMX</a> and <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> sono progettati per esprimere questa struttura.',
      :requirement => ['exemplar_15']
    a_tabular 'trattare i dati statistici come una tabella, come CSV',
      :text_as_statement => 'in un formato di dati tabulare',
      :help_text => 'Questi formati organizzano i dati statistici in una tabella composta da righe e colonne. Questa struttura non offre il contesto hypercube sottostante, ma è facile da processare.',
      :requirement => ['standard_32']
    a_format 'focus sul formato dei dati tabulari come Excel',
      :text_as_statement => 'in un formato per le presentazioni',
      :help_text => 'I fogli di calcolo utilizzano la formattazione come il testo in corsivo, in grassetto o rientro all\'interno dei campi per descrivere l\'aspetto e la struttura sottostante. Questo styling aiuta le persone a comprendere il significato dei dati, ma lo rende meno adatto per essere processato dal computer.',
      :requirement => ['pilot_18']
    a_unsuitable 'non sono adatti per dati statistici o tabulari come Word o PDF',
      :text_as_statement => 'in un formato non adatto per i dati statistici',
      :help_text => 'Questi formati non sono adatti per dati statistici perché oscurano la struttura sottostante dei dati.'

    label_exemplar_15 'Dovresti<strong>pubblicare dati statistici in un formato che esponga dimensioni e misure</strong> in modo che siano facili da analizzare.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Dovresti <strong>pubblicare i dati tabulari in un formato che espone le tabelle di dati</strong> in modo che siano facili da analizzare.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'Dovresti <strong>pubblicare i dati tabulari in un formato pensato per questo scopo</strong> in modo che siano facili da processare.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'I tuoi dati geografici includono formati che',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'I dati geografici sono pubblicati',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'sono ideati per dati geografici, come <a href="http://www.opengeospatial.org/standards/kml/">KML</a> or <a href="http://www.geojson.org/">GeoJSON</a>
                     ',
      :text_as_statement => 'in un formato per dati geografici',
      :help_text => 'Questi formati descrivono punti, linee e confini, ed espongono strutture nei dati che rendono più facile il trattamento automatico.',
      :requirement => ['exemplar_16']
    a_generic 'conserva i dati strutturati come JSON, XML o CSV',
      :text_as_statement => 'in un formato generico',
      :help_text => 'Qualsiasi formato che conservi dati normali strutturati in grado di esprimere anche i dati geografici, in particolare se conserva solo dati sui punti.',
      :requirement => ['pilot_19']
    a_unsuitable 'non sono ideati per dati geografici come Word o PDF',
      :text_as_statement => 'in un formato adatto per i dati geografici',
      :help_text => 'Questi formati non sono adatti per i dati geografici, perché oscurano la struttura sottostante dei dati.'

    label_exemplar_16 'Dovresti <strong>pubblicare i dati geografici in un formato ideato per questo scopo</strong> in modo che le persone possano utilizzare strumenti che sono già disponibili per elaborare questa informazione.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'Dovresti<strong>pubblicare i dati geografici come dati strutturati</strong> in modo che siano facili da elaborare.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'I tuoi dati strutturati includono formati che',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'I dati strutturati vengono pubblicati',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'sono ideati per dati strutturati come JSON, XML, Turtle o CSV',
      :text_as_statement => 'in un formato di dati strutturati',
      :help_text => 'Questi formati organizzano i dati in una struttura di base che da dei valori ad un insieme noto di proprietà. Questi formati sono facilmente processabili in modo automatico dai computer.',
      :requirement => ['pilot_20']
    a_unsuitable 'non sono ideati per i dati strutturati come Word o PDF',
      :text_as_statement => 'in un formato non adatto per i dati strutturati',
      :help_text => 'Questi formati non sono ideati per questo tipo di dati, perché oscurano la loro struttura di base.'

    label_pilot_20 'Dovresti<strong>pubblicare dati strutturati in un formato che sia stato ideato per questo scopo</strong> in modo che i dati siano facile da processare.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'I vostri dati utilizzano identificatori persistenti?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'I dati comprendono',
      :help_text => 'I dati fanno solitamente riferimento a cose reali come scuole o strade o utilizzano uno schema di codificazione. Se i dati provenienti da fonti diverse utilizzano lo stesso identificatore persistente ed unico per individuare la stessa cosa, le persone possono facilmente combinare risorse diverse per creare dati più utili. Gli identificatori possono essere GUIDs, DOI o URL.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'identificatori persistenti',
      :requirement => ['standard_33']

    label_standard_33 'Dovresti <strong>utilizzare identificatori i valori che sono presenti nei dati</strong> in modo che possano essere facilmente collegati ad altri dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Gli identificatori presenti nei tuoi dati possono essere utilizzati per trovare informazioni addizionali?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Gli identificatori persistenti',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no, gli identificatori non possono essere usati per trovare informazioni aggiuntive',
      :text_as_statement => ''
    a_service 'sì, le persone possono utilizzare un servizio per risolvere gli identificatori',
      :text_as_statement => 'risolvere utilizzando un servizio',
      :help_text => 'E\' possibile utilizzare servizi online, come GUIDs o DOIs, per dare delle informazioni sugli identificatori,che non possono essere direttamente accessibili allo stesso modo delle URL.',
      :requirement => ['standard_34']
    a_resolvable 'sì, gli identificatori sono delle URL che si risolvono per dare delle informazioni',
      :text_as_statement => 'risolvono perché sono delle URL',
      :help_text => 'Le URL sono utili sia per le persone che per i computer. La gente può mettere una URL nel browser e leggere ulteriori informazioni, come <a href="http://opencorporates.com/companies/gb/08030289">companies</a> and <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">postcodes</a>. I computer possono anche elaborare queste informazioni usando script per accedere ai dati sottostanti.',
      :requirement => ['exemplar_17']

    label_standard_34 'Dovresti <strong>fornire un servizio per risolvere gli identificatori utilizzati</strong> in modo che le persone possano trovare informazioni aggiuntive.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 'Dovresti<strong>collegare ad una pagina web le informazioni su ciascuno dei valori presenti nei tuoi dati</strong> in modo che le persone possano facilmente trovare e condividere queste informazioni.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Dove è il servizio che viene utilizzato per risolvere gli identificatori?',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Il servizio di risoluzione dell\'identificatore si trova su',
      :help_text => 'Il servizio di risoluzione dovrebbe usare un identificatore come parametro di query e restituire alcune informazioni sulla cosa che si identifica.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'URL del servizio di risoluzione dell\'identificatore',
      :string,
      :input_type => :url,
      :placeholder => 'URL del servizio di risoluzione dell\'identificatore',
      :requirement => ['standard_35']

    label_standard_35 'Dovresti <strong>avere una URL che permetta di risolvere gli identificatori</strong> in modo che il computer possa trovare la maggior quantità possible di informazioni rilevanti.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Sono disponibili informazioni di terze parti nei tuoi dati pubblicati sul web?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'A volte altre persone che non puoi controllare forniscono delle URL sui valori presenti nei tuoi dati. Ad esempio, i dati possono avere codici di avviamento postale che puntano al sito Ordnance Survey.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'sì'

    q_reliableExternalUrls 'Sono affidabili le informazioni di queste parti terze?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'se una parte terza fornisce delle URL pubbliche sui valori che si trovano nei tuoi dati, ha probabilmente adottato delle misure per garantire la qualità e l\'affidabilità di questi dati. Questa è un\'indicazione di quanto ti fidi della loro procedura per farlo. Cerca il loro certificato di dati aperto o segni distintivi analoghi per decidere.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'sì'

    q_externalUrls 'I tuoi dati utilizzano le URL di tali parti terze?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'Le URL di parti terze sono',
      :help_text => 'E\' consigliabile utilizzare delle URL di parti terze che risolvono delle informazioni sui valori presenti nei tuoi dati. Questo riduce la duplicazione e aiuta le persone a combinare i dati provenienti da fonti diverse per renderli più utili.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'fanno riferimento a questi dati',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Dovresti <strong>utilizzare le URL delle informazioni di parti terze </strong> in modo che sia facile combinare questa informazione con altri dati che utilizzano tali URL.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Fiducia',
      :help_text => 'In che misura è possibile fidarsi dei tuoi dati?',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Dai accesso ai tuoi dati in un formato che sia processabile dal computer?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'La provenienza di questi dati è',
      :help_text => 'Questo fa riferimento a come i tuoi dati sono stati creati ed elaborati prima della loro pubblicazione. Questo tipo d\'informazione crea fiducia nei dati pubblicati, perché la gente può risalire a come sono stati gestiti nel tempo.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'sì',
      :text_as_statement => 'processabile dal computer',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Dovresti <strong>fornire il percorso che stabilisce la provenienza dei tuoi dati in un formato processabile dai computer</strong> in modo che le persone possano risalire al modo in cui i tuoi dati sono stati elaborati.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Dove descrivi il modo in cui la gente può verificare che i dati ricevuti provengono da te?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Questi dati possono essere verificati utilizzando',
      :help_text => 'se fornisci dei dati importanti, le persone dovrebbero essere in grado di verificare che quello che ricevono sia lo stesso di quello che hai pubblicato. Ad esempio, è possibile firmare digitalmente i dati pubblicati, per verificare che i dati non siano stati manomessi.'
    a_1 'URL del procedimento di verifica',
      :string,
      :input_type => :url,
      :placeholder => 'URL del procedimento di verifica',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Dovresti <strong>descrivere il modo in cui le persone possono controllare che i dati ricevuti siano gli stessi di quelli che hai pubblicato</strong> in modo che possano fidarsi.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Informazione Sociale',
    :description => 'Documentazione, supporto e servizi' do

    label_group_15 'Documentazione',
      :help_text => 'come aiutare le persone a capire il contesto e il contenuto dei tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'La tua documentazione include dei dati che sono processabili dal computer per :',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La documentazione include dati che sono processabili dal computer',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'titolo',
      :text_as_statement => 'titolo',
      :requirement => ['standard_36']
    a_description 'descrizione',
      :text_as_statement => 'descrizione',
      :requirement => ['standard_37']
    a_issued 'data di pubblicazione',
      :text_as_statement => 'data di pubblicazione',
      :requirement => ['standard_38']
    a_modified 'data di modifica',
      :text_as_statement => 'data di modifica',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'frequenza degli aggiornamenti',
      :text_as_statement => 'frequenza degli aggiornamenti',
      :requirement => ['standard_40']
    a_identifier 'identificatore',
      :text_as_statement => 'identificatore',
      :requirement => ['standard_41']
    a_landingPage 'pagina di destinazione',
      :text_as_statement => 'pagina di destinazione',
      :requirement => ['standard_42']
    a_language 'lingua',
      :text_as_statement => 'lingua',
      :requirement => ['standard_43']
    a_publisher 'editore',
      :text_as_statement => 'editore',
      :requirement => ['standard_44']
    a_spatial 'copertura spaziale / geografica',
      :text_as_statement => 'copertura spaziale / geografica',
      :requirement => ['standard_45']
    a_temporal 'copertura temporale',
      :text_as_statement => 'copertura temporale',
      :requirement => ['standard_46']
    a_theme 'tema/i',
      :text_as_statement => 'tema/i',
      :requirement => ['standard_47']
    a_keyword 'parola/e chiave o tag (s)',
      :text_as_statement => 'parola/e chiave o tag (s)',
      :requirement => ['standard_48']
    a_distribution 'distribuzione/i',
      :text_as_statement => 'distribuzione/i'

    label_standard_36 'Dovresti <strong>includere un titolo che sia processabile dai computer nella tua documentazione</strong> in modo che la gente sappia come farvi riferimento.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Dovresti <strong>includere nella tua documentazione una descrizione dei dati che sia processabile dal computer</strong> in modo che la gente sappia che cosa contiene.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Dovresti <strong>includere nella tua documentazione la data di pubblicazione dei dati in un formato che sia che sia processabile dal computer</strong> in modo che la gente possa conoscere la tempestività della pubblicazione.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Dovresti <strong>includere nella tua documentazione l\'ulitma data di modifica dei dati in une formato che sia processabile dai computer </strong> in modo che le persone possano accedere ai dati più recenti.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Dovresti <strong>fornire nella tua documentazione i metadati sulla data di pubblicazione degli aggiornamenti in un formato che sia processabile dal computer</strong>, così la gente sa quanto spesso i dati vengono aggiornati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Dovresti <strong>includere nella tua documentazione una URL canonica per i dati in un formato che sia processabile dal computer </strong> in modo che la gente sappia come accedere in modo sistematico ai dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Dovresti <strong>includere una URL canonica alla documentazione stessa che sia processabile dal computer </strong> in modo che la gente sappia come accedervi in modo sistematico.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Dovresti <strong>includere nella tua documentazione la versione linguistica dei tuoi dati che sia processabile dal computer</strong> in modo che le persone interessate a questo tipo d\'informazione possano capirla facilmente.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Dovresti <strong>indicare l\'editore di dati nella tua documentazione processabile dal computer</strong>, così la gente può decidere quanto fidarsi dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Dovresti <strong>includere nella tua documentazione processabile dal computer la copertura geografica </strong> in modo che le persone possano capire quale sia il perimetro d\'applicazione dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Dovresti <strong>includere nella tua documentazione processabile dal computer il lasso temporale coperto dai tuoi dati</strong> in modo che le persone possano capire quale sia il perimetro d\'applicazione dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Dovresti <strong>includere nella tua documentazioneprocessabile dal computer il soggetto dei tuoi dati </strong> in modo che la gente possa capire quale sia il contenuto dei tuoi dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Dovresti <strong>includere nella tua documentazione processabile dal computer delle parole chiave o dei tags </strong> per aiutare la gente a cercare tra i dati in modo efficace.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'La tua documentazione comprende dei metadati che sono processabili dai computer per ogni distribuzione su :',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'La documentazione di ogni distribuzione comprende dati che sono processabili dal computer per',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'titolo',
      :text_as_statement => 'titolo',
      :requirement => ['standard_49']
    a_description 'descrizione',
      :text_as_statement => 'descrizione',
      :requirement => ['standard_50']
    a_issued 'data di pubblicazione',
      :text_as_statement => 'data di pubblicazione',
      :requirement => ['standard_51']
    a_modified 'data di modifica',
      :text_as_statement => 'data di modifica',
      :requirement => ['standard_52']
    a_rights 'dichiarazione dei diritti d\'applicazione',
      :text_as_statement => 'dichiarazione dei diritti d\'applicazione',
      :requirement => ['standard_53']
    a_accessURL 'URL per accedere ai dati',
      :text_as_statement => 'una URL per accedere ai dati',
      :help_text => 'Questi metadati devono essere utilizzati quando i dati non possono essere scaricati, come una API per esempio.'
    a_downloadURL 'URL per scaricare il pacchetto di dati',
      :text_as_statement => 'una URL per scaricare il pacchetto dei dati'
    a_byteSize 'dimensione in byte',
      :text_as_statement => 'dimensione in byte'
    a_mediaType 'tipo di download multimediale',
      :text_as_statement => 'tipo di download multimediale'

    label_standard_49 'Dovresti <strong>includere nella tua documentazione dei titoli che siano processabili dal computer </strong>, così la gente sa come citare ogni distribuzione di dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Dovresti <strong>includere nella tua documentazione delle descrizioni che siano processabili dal computer</strong>, così la gente sa quello che è contenuto in ogni distribuzione di dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Dovresti <strong>includere nella tua documentazione la data di pubblicazione in un formato che sia processabile dal computer</strong>, così la gente può valutare in che misura la distribuzione è aggiornata.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'dovresti <strong>includere nella tua documentazione la data di modifica in un formato che sia processabile dal computer l</strong> perché così le persone sanno se la loro copia di dati è aggiornata.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Dovresti <strong>includere un link sui tipi di diritti d\'applicazione sui dati in un formato che sia processabile dai computer</strong>, così la gente sa che cosa può fare con tali dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Dove si trova la documentazione tecnica dei dati?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'La documentazione tecnica dei dati è in'
    a_1 'URL della documentazione tecnica',
      :string,
      :input_type => :url,
      :placeholder => 'URL della documentazione tecnica',
      :requirement => ['pilot_21']

    label_pilot_21 'Dovresti <strong>fornire la documentazione tecnica dei dati</strong> in modo che le persone possano capire come usarli.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'I formati dei dati utilizzano vocabolari o schemate?',
      :discussion_topic => :vocabulary,
      :help_text => 'formati come CSV, JSON, XML o Turtle usano vocabolari personalizzati o schemate che indicano quali colonne o proprietà contegono i dati.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'sì'

    q_schemaDocumentationUrl 'Dove si trova la documentazione sui vocabolari usati dai vostri dati?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'I vocabolari utilizzati da questi dati sono documentati in'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'URL dello schema della documentazione',
      :string,
      :input_type => :url,
      :placeholder => 'URL dello schema della documentazione',
      :requirement => ['standard_54']

    label_standard_54 'Dovresti <strong>documentare tutti i vocabolari che usi all\'interno dei tuoi dati</strong> in modo che la gente sappia come interpretare quest ainformazione.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Ci sono dei codici che vengono usati in questi dati?',
      :discussion_topic => :codelists,
      :help_text => 'se i tuoi dati utilizzano dei codici per fare riferimento a cose come le aree geografiche, categorie di spesa o le malattie, bisogna spiegarlo.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'sì'

    q_codelistDocumentationUrl 'Dove sono documentati i codici che si trovano nei tuoi dati?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'I codici che si trovano in questi dati sono documentati in'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'URL della documentazione della Codelist',
      :string,
      :input_type => :url,
      :placeholder => 'URL della documentazione della Codelist',
      :requirement => ['standard_55']

    label_standard_55 'Dovresti<strong>documentare i codici utilizzati all\'interno dei tuoi dati </strong> in modo che la gente sappia come interpretarli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Supporto',
      :help_text => 'come comunichi con le persone che utilizzano i tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Dove si trovano le istruzioni per contattare qualcuno a cui porre delle domande inerenti a questo pacchetto di dati ?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Scopri come contattare qualcuno a proposito di questi dati su',
      :help_text => 'Attribuisci una URL ad una pagina che descrive come fare per contattare qualcuno se si hanno domande su questi dati.'
    a_1 'Documentazione sui contatti',
      :string,
      :input_type => :url,
      :placeholder => 'Documentazione sui contatti',
      :requirement => ['pilot_22']

    label_pilot_22 'Dovresti <strong>fornire informazioni sui punti di contatto relativi ai tuoi dati per le persone che vogliono inviare delle domande</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Dove si possono trovare delle informazioni su come migliorare il modo in cui i tuoi dati vengono pubblicati?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Scopri come suggerire dei miglioramenti per la pubblicazione dei dati a'
    a_1 'URL sui suggerimenti per migliorare la pubblicazione dei dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL sui suggerimenti per migliorare la pubblicazione dei dati',
      :requirement => ['pilot_23']

    label_pilot_23 'Dovresti <strong>dare delle istruzioni su come proporre miglioramenti</strong> sul modo di pubblicare i dati in modo da poter scoprire di che cosa ha bisogno la gente.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Dove si possono inviare domande relative a questioni di privacy?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Scopri dove inviare domande sulla privacy'
    a_1 'Documentazione sul punto di contatto relativi alla privacy',
      :string,
      :input_type => :url,
      :placeholder => 'Documentazione sul punto di contatto relativi alla privacy',
      :requirement => ['pilot_24']

    label_pilot_24 'Dovresti <strong>fornire informazioni sul punto di contatto a cui inviare domande relative a questioni di privacy </strong> e la divulgazione di dati personali.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Usi i social media per connetterti con le persone che usano i tuoi dati?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'no'
    a_true 'sì',
      :requirement => ['standard_56']

    label_standard_56 'Dovresti <strong>utilizzare i social media per contattare le persone che usano i tuoi dati </strong> e scoprire come vengono utilizzati',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Profilo' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Attraverso quali profili di social media le persone possono contattarti?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Contattare il curatore attraverso questi social media',
        :help_text => 'Dai la URL dei tuoi profili dei social media, come il tuo profilo su Twitter o Facebook.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'URL del Social Media',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL del Social Media'

    end

    q_forum 'Dove si può discutere di questo pacchetto di dati?',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Puoi discutere di questi dati su',
      :help_text => 'Inserisci la URL del forum o della mailing list, dove le persone possono discutere dei tuoi dati.'
    a_1 'URL del Forum o Mailing List',
      :string,
      :input_type => :url,
      :placeholder => 'URL del Forum o Mailing List',
      :requirement => ['standard_57']

    label_standard_57 'Dovresti <strong>indicare dove si può discutere dei tuoi dati</strong> e darsi sostegno a vicenda.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Dove possiamo trovare il modo di richiedere correzioni sui tuoi dati?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Scopri come richiedere correzioni dei dati su',
      :help_text => 'Dai una URL dove le persone possono segnalare degli errori che hanno trovato nei tuoi dati.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL sulle istruzioni inerenti alle correzioni',
      :string,
      :input_type => :url,
      :placeholder => 'URL sulle istruzioni inerenti alle correzioni',
      :requirement => ['standard_58']

    label_standard_58 'Dovresti <strong>fornire istruzioni su come segnalare gli errori</strong> nei dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Dov\'è possibile ottenere informazioni sulle notificazioni delle correzioni fatte ai tuoi dati?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Scopri come ottenere le notificazioni sulle correzioni fatte ai dati',
      :help_text => 'Dai una URL in cui si descrive come le notificazioni sulle correzioni vengono condivise con la gente.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL sulle notificazioni relative alle correzioni fatte sui dati',
      :string,
      :input_type => :url,
      :placeholder => 'URL sulle notificazioni relative alle correzioni fatte sui dati',
      :requirement => ['standard_59']

    label_standard_59 'Dovresti <strong>fornire una mailing list o un flusso d\'informazioni sugli aggiornamenti fatti</strong> così che le persone possano utilizzarli per mantenere aggiornate le loro copie dei dati.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Hai qualcuno che costruisce attivamente una comunità attorno a questi dati?',
      :discussion_topic => :engagementTeam,
      :help_text => 'Un comunità si impegnerà attraverso i social media, blog, e organizzerà hackdays o concorsi per incoraggiare le persone ad utilizzare i dati.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'sì',
      :requirement => ['exemplar_21']

    label_exemplar_21 'Dovresti <strong>costruire una comunità che si interessi ai tuoi dati</strong> per favorirne un uso più ampio.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Dov\'è la loro home page?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'L\'impegno della comunità è gestito da',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'URL della home page del Community Engagement Team',
      :string,
      :input_type => :url,
      :placeholder => 'URL della home page del Community Engagement Team',
      :required => :required

    label_group_17 'Servizi',
      :help_text => 'come dai accesso agli strumenti necessari per poter lavorare con i tuoi dati',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Dov\'à la lista degli strumenti necessari per lavorare con i tuoi dati ?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Gli strumenti per aiutare l\'utilizzo di questi dati sono elencati in',
      :help_text => 'Dai una URL che da la lista degli strumenti che conosci o raccomandi alla gente per poter lavorare con i tuoi dati.'
    a_1 'URL degli strumenti',
      :string,
      :input_type => :url,
      :placeholder => 'URL degli strumenti',
      :requirement => ['exemplar_22']

    label_exemplar_22 'Dovresti <strong>fornire un elenco di software e altri strumenti facilmente reperibili</strong> in modo che le persone possano ottenere rapidamente gli strumenti necessari per lavorare con i tuoi dati.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
