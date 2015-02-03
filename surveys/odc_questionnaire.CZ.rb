survey 'CZ',
  :full_title => 'Czech Republic',
  :default_mandatory => 'false',
  :status => 'beta',
  :description => '<p>Na základě tohoto sebehodnotícího dotazníku vám vygenerujeme certifikát otevřených dat a doprovodnou visačku. Obojí můžete využít k propagaci svých otevřených dat a my získáme lepší představu o tom, jak instituce a organizace zveřejňují svá data.</p><p>Zodpovězením těchto otázek prokazujete svou snahu vyhovět relevantním zákonům, především občanskému zákoníku, autorskému zákonu a zákonu na ochranu osobních údajů. Snažte se sami zjistit, jestli se na váš případ nevztahují nějaké další zákony a předpisy.</p><p><strong>Pro získání certifikátu nemusíte odpovídat na všechny otázky.</strong> Odpovězte tam, kde můžete.</p>' do

  translations :en => :default
  section_general 'Obecné informace',
    :description => '',
    :display_header => false do

    q_dataTitle 'Jaký je název datové sady?',
      :discussion_topic => :dataTitle,
      :help_text => 'Uživatelé název uvidí v seznamu podobných zdrojů, takže se snažte, aby text názvu nebyl příliš dlouhý a zároveň byl unikátní a výstižný, aby se podle něj dalo rychle zorientovat.',
      :required => :required
    a_1 'Název datové sady',
      :string,
      :placeholder => 'Název datové sady',
      :required => :required

    q_documentationUrl 'Kde je zveřejněna dokumentace?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumentace',
      :help_text => 'Uveďte adresu, na které mohou uživatelé vašich dat získat podrobnější informace. Může jít například o záznam v nějakém datovém katalogu.'
    a_1 'URL dokumentace',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 '
               <strong>Měli byste zveřejnit dokumentaci dat</strong>, aby uživatelé získali lepší představu o jejich obsahu, kontextu a možnostech využití.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 '
               <strong>Aby lidé mohli vaše data využít, je třeba zveřejnit jejich dokumentaci a odkaz na data samotná.</strong>
            ',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Kdo data publikuje?',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Poskytovatel',
      :help_text => 'Uveďte název organizace, která data publikuje.',
      :required => :required
    a_1 'název poskytovatele',
      :string,
      :placeholder => 'název poskytovatele',
      :required => :required

    q_publisherUrl 'Webová stránka poskytovatele',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Web poskytovatele',
      :help_text => 'Uveďte prosím URL webu poskytovatele. To pomáhá identifikaci dat pocházejících od stejných poskytovatelů.'
    a_1 'Web poskytovatele',
      :string,
      :input_type => :url,
      :placeholder => 'Web poskytovatele'

    q_releaseType 'Co přesně zveřejňujete?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'jedna datová sada (jednorázová publikace)',
      :help_text => 'Jedná se o jeden dataset a nečekáte, že byste výhledově zveřejňovali další podobné datasety.'
    a_collection 'několik souvisejících datových sad (jednorázová publikace)',
      :help_text => 'Jde o několik datových sad a nečekáte, že byste výhledově zveřejňovali další podobné datové sady.'
    a_series 'několik souvisejících datových sad (průběžná aktualizace)',
      :help_text => 'Jde o několik datových sad, které budete v budoucnu aktualizovat.'
    a_service 'službu nebo API pro přístup k otevřeným datům',
      :help_text => 'Jde o webovou službu, přes kterou jde data získat automatizovaně.'

  end

  section_legal 'Právní informace',
    :description => 'Práva, licencování a ochrana osobních údajů' do

    label_group_2 'práva',
      :help_text => 'Vaše právo zveřejnit data',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Máte právo tato data zveřejnit?',
      :discussion_topic => :cz_publisherRights,
      :help_text => 'Pokud jste data sami nevytvořili nebo nenasbírali, nemusíte mít právo je zveřejnit. Pokud si nejste jisti, obraťte se na původního vlastníka dat; ke zveřejnění dat budete pravděpodobně potřebovat jeho svolení.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'Ano, máme právo zveřejnit tato data jako otevřená.',
      :requirement => ['standard_1']
    a_no 'Ne, nemáme právo ke zveřejnění těchto dat jako otevřených.'
    a_unsure 'Nejsme si jisti, jestli máme právo data zveřejnit.'
    a_complicated 'Práva k těmto datům jsou nejasná nebo složitá.'

    label_standard_1 '
                     <strong>Ke zveřejnění dat byste měli mít nezpochybnitelné právo.</strong>
                  ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 '
                  <strong>Je nezbytné, abyste disponovali právy ke zveřejnění těchto dat.</strong>
               ',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Kde popisujete právní rizika, se kterými je užití dat spojeno?',
      :discussion_topic => :cz_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'Právní rizika spojená s užitím dat',
      :help_text => 'Užití dat bez nezpochybnitelných práv je riskantní – například se může stát, že budete data muset přestat data poskytovat na základě stížnosti. Uveďte URL stránky, na které se uživatelé o podobných rizicích dozví.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'URL dokumentace',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace',
      :requirement => ['pilot_2']

    label_pilot_2 '
                  <strong>Měli byste popsat možná rizika spojená s užitím vašich dat</strong>, aby se uživatelé mohli rozhodnout, jestli a jak je mohou užít.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Vycházeli jste <em>výhradně</em> z otevřených dat?',
      :discussion_topic => :cz_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'Zdroje dat',
      :help_text => 'Cizí data můžete publikovat pouze v případě, že byla zveřejněna pod otevřenou licencí, práva původního držitele vypršela nebo si jich držitel vzdal. Pokud to pro sebemenší část dat neplatí, musíte se před jejich zveřejněním poradit s právníky.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'výhradně otevřená data'

    q_thirdPartyOrigin 'Vznikla část dat vytěžením nebo zpracováním cizích dat?',
      :discussion_topic => :cz_thirdPartyOrigin,
      :help_text => 'I výtah, případně malá část použitého cizího textu, může mít vliv na Vaše práva k užití. Stejně tak v případě, že jste analyzovali cizí data a vytvořili výstup odlišný od původních dat.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_3']

    label_basic_3 'Uvedli jste, že jste data nevytvořili ani samostaně nesesbírali (včetně formy crowdsourcingu), takže musela vzniknout vytěžením nebo zpracováním cizích datových zdrojů.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Vycházeli jste <em>výhradně</em> z otevřených dat?',
      :discussion_topic => :cz_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'Zdroje dat',
      :help_text => 'Cizí data můžete publikovat pouze v případě, že byla zveřejněna pod otevřenou licencí, práva původního držitele vypršela nebo si jich držitel vzdal. Pokud to pro sebemenší část dat neplatí, musíte se před jejich zveřejněním poradit s právníky.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'výhradně otevřená data',
      :requirement => ['basic_4']

    label_basic_4 '
                           <strong>Měli byste se poradit s právníky, abyste měli jistotu, že data můžete publikovat.</strong>
                        ',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Vznikla nějaká část dat pomocí crowdsourcingu?',
      :discussion_topic => :cz_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'Crowdsourcing',
      :help_text => 'Pokud nějaká část dat pochází od osob mimo vaši organizaci, musíte si od nich vyžádat svolení k publikování dat pod otevřenou licencí.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ano, aspoň část dat vznikla crowdsourcingem',
      :requirement => ['basic_5']

    label_basic_5 'Uvedli jste, že data původně nepochází od Vás a nevznikla ani výběrem nebo zpracováním cizích dat, takže musela vzniknout pomocí crowdsourcingu.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Dá se práce přispěvatelů považovat za tvůrčí?',
      :discussion_topic => :cz_crowdsourcedContent,
      :help_text => 'Na tvůrčí práci vyžadující jedinečný úsudek autora mají přispěvatelé autorská práva. Příkladem tvůrčí práce je například psaní popisků nebo i rozhodování o tom, kterou část zdrojových dat vybrat do výsledné datové sady. Pokud taková data chcete publikovat, přispěvatelé se musí vzdát svých autorských práv, převést je na vás, nebo vám data licencovat.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl 'Kde máte vystavenou přispěvatelskou licenční dohodu (CLA)?',
      :discussion_topic => :cz_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Přispěvatelská licenční dohoda (CLA)',
      :help_text => 'Uveďte odkaz na dokument, ve kterém vám přispěvatelé dovolují užití svých dat. Konkrétně se přispěvatelé mohou vzdát svých autorských práv, převést je na vás, nebo vám udělit licenci k jejich užití.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'URL licenční dohody',
      :string,
      :input_type => :url,
      :placeholder => 'URL licenční dohody',
      :required => :required

    q_cldsRecorded 'Souhlasili všichni přispěvatelé s přispěvatelskou licenční dohodou (CLA)?',
      :discussion_topic => :cz_cldsRecorded,
      :help_text => 'Abyste mohli zveřejnit cizí příspěvky, musí jejich autoři souhlasit s přispěvatelskou licenční dohodou (CLA). Měli byste si vést seznam jednotlivých přispěvatelů a poznačit si, kteří souhlasili s přispěvatelskou licenční dohodou (CLA).',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_6']

    label_basic_6 'Každý přispěvatel musí souhlasit s přispěvatelskou licenční dohodou (CLA)</strong>, ve které vám uděluje právo zveřejnit jeho práci pod otevřenou licencí.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Kde jsou specifikované zdroje dat?',
      :discussion_topic => :cz_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Zdroje dat',
      :help_text => 'Uveďte URL dokumentu, ve kterém popisujete zdroje dat a licenci, která vám umožňuje data zveřejnit.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'URL k dokumentaci datových zdrojů',
      :string,
      :input_type => :url,
      :placeholder => 'URL k dokumentaci datových zdrojů',
      :requirement => ['pilot_3']

    label_pilot_3 '
                  <strong>Měli byste popsat, odkud pochází data a vaše práva je zveřejnit</strong>, aby uživatelé mohli bez obav použít i data pocházející z cizích zdrojů.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Máte dokumentaci o zdrojích dat i ve strojově čitelné podobě?',
      :discussion_topic => :cz_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Strojově čitelné zdroje dat',
      :help_text => 'Informace o zdrojích dat byste měli kromě lidsky srozumitelné podoby zveřejnit i ve strojově čitelném formátu. Díky tomu se dá lépe zjistit, jak jsou data používána, což zároveň vysvětluje jejich opakovanou publikaci.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'zdroje dat jsou strojově čitelné',
      :requirement => ['standard_2']

    label_standard_2 '
                     <strong>Měli byste zveřejnit strojově čitelné informace o zdrojích, ze kterých vaše data pochází.</strong>
                  ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Licence',
      :help_text => 'jaká oprávnění poskytujete k užití těchto dat?',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Kde jste zveřejnili prohlášení o právech k této datové sadě?',
      :discussion_topic => :cz_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'Právní prohlášení',
      :help_text => 'Uveďte URL dokumentu, který popisuje práva k opětovnému užití této datové sady. Dokument by měl odkazovat na text licence, popsat vaše požadavky na uvádění autorství, a obsahovat prohlášení o relevantních autorských a databázových právech. Právní prohlášení pomáhá uživatelům pochopit, co všechno s daty mohou a nemohou dělat.'
    a_1 'URL právního prohlášení',
      :string,
      :input_type => :url,
      :placeholder => 'URL právního prohlášení',
      :requirement => ['pilot_4']

    label_pilot_4 '
               <strong>Měli byste zveřejnit právní prohlášení</strong>, které podrobně popíše autorská a databázová práva spojená s vašimi daty, licenční podmínky a vaše požadavky na uvádění autorství.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Za jakých licence mohou lidé znovu použít tato data?',
      :discussion_topic => :cz_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Licence',
      :help_text => 'Nezapomeňte na to, že k databázi drží práva každý, kdo data původně nasbíral, vytvořil, zkontroloval nebo vybral. Autorská práva mohou vznikat také při reorganizaci dat. Každý uživatel tedy potřebuje licenci k použití dat nebo doklad o tom, že se všichni autoři svých autorských práv vzdali. Do seznamu jsme vybrali nejčastěji používané licence. Pokud žádná autorská ani databázová práva nejsou ve hře, vypršela, nebo se jich autoři vzdali, vyberte možnost „nehodí se“.',
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
    a_odc_pddl 'Open Data Commons Public Domain Dedication and License (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and License (PDDL)'
    a_na 'nehodí se',
      :text_as_statement => ''
    a_other 'Jiná ...',
      :text_as_statement => ''

    q_dataNotApplicable 'Proč se na data nevztahuje žádná licence?',
      :discussion_topic => :cz_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Důvody chybějící licence',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'Na data se nevztahují žádná autorská ani databázová práva',
      :text_as_statement => 'na data se nevztahuje žádná autorskoprávní ochrana',
      :help_text => 'Databázová práva vznikají například vynaložením netriviálního úsilí při sběru, ověřování nebo prezentaci dat. Naopak nevznikají například u dat neověřovaných, vytvořených od nuly, nebo prezentovaných nějakým zjevným způsobem. Autorská práva k datům vznikají například při výběru nebo netriviální reorganizaci dat.'
    a_expired 'autorská a databázová práva vypršela',
      :text_as_statement => 'práva k datům vypršela',
      :help_text => 'Ochrana databázových práv trvá deset let. Pokud se data naposledy měnila před více než deseti lety, databázová práva nejspíš vypršela. Pevnou dobu trvají také autorská majetková práva; lhůta se počítá od úmrtí autora nebo od vydání díla. Stručně řečeno je nepravděpodobné, že by u vašich dat autorská práva vypršela'
    a_waived 'vlastníci se vzdali svých práv',
      :text_as_statement => '',
      :help_text => 'To znamená, že práva nikdo nevlastní a s daty může kdokoliv dělat cokoliv.'

    q_dataWaiver 'Jakým způsobem jste se autorských práv vzdali?',
      :discussion_topic => :cz_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Forma vzdání se autorských práv k datům',
      :help_text => 'Musíte dát uživatelům nějak konkrétně najevo, že jste se práv vzdali a mohou si s daty nakládat podle svého. Můžete použít některý se standardních mechanismů, například PDDL nebo CCZero, nebo napsat vlastní právní dokument.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication and License (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and License (PDDL)'
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Jiný ...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Kde je dokument, kterým se vzdáváte svých autorských práv?',
      :discussion_topic => :cz_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Forma vzdání se autorských práv k datům',
      :help_text => 'Uveďte URL, na kterém si uživatelé vašich dat mohou ověřit, že jste se vzdali svých práv.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'URL dokumentu',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL dokumentu'

    q_otherDataLicenceName 'Jaký je název použité licence?',
      :discussion_topic => :cz_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Data jsou licencována pod',
      :help_text => 'Pokud data zveřejňujete pod jinou než nabízenou licencí, potřebujeme znát její název – bude součástí vašeho certifikátu otevřených dat.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'název licence',
      :string,
      :required => :required,
      :placeholder => 'název licence'

    q_otherDataLicenceURL 'Uveďte URL licence. Bude součástí vašeho certifikátu otevřených dat, aby si licenci mohl kdokoliv přečíst.',
      :discussion_topic => :cz_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Text licence',
      :help_text => 'Uveďte URL licence. Bude součástí vašeho certifikátu otevřených dat, aby si licenci mohl kdokoliv přečíst.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Jde o otevřenou licenci?',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Jde o otevřenou licenci?'

    q_otherDataLicenceOpen 'Jde o otevřenou licenci?',
      :discussion_topic => :cz_otherDataLicenceOpen,
      :help_text => 'Definici „otevřené licence“ najdete na serveru <a href="http://opendefinition.org/od/czech/">OpenDefinition.org</a>. Tamtéž najdete přímo <a href="http://opendefinition.org/licenses/">seznam otevřených licencí</a>. Pokud v něm vaše licence chybí, buď není otevřená, nebo ji ještě nikdo neposoudil.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_7']

    label_basic_7 '
                  <strong>Otevřená data musíte publikovat pod otevřenou licencí</strong>, aby s nimi uživatelé mohli volně nakládat.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'Vztahuje se na obsah dat autorské právo?',
      :discussion_topic => :cz_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Obsah chráněný autorským právem',
      :pick => :one,
      :required => :required
    a_norights 'Ne, data obsahují pouze fakta a čísla.',
      :text_as_statement => 'Žádná relevantní práva k obsahu data',
      :help_text => 'Při licencování dat je občas dobré (nebo přímo nutné) posuzovat zvlášť obsah databáze a zvlášť databázi jako takovou. Tato otázka se vztahuje přímo na obsah databáze. Pokud databáze neobsahuje nic, co by vzniklo tvůrčím úsilím, autorské právo se na její obsah nevztahuje.'
    a_samerights 'ano; držitel práv pouze jeden',
      :text_as_statement => '',
      :help_text => 'Tuto možnost zvolte, pokud je obsah v datech byl celý vytvořen nebo převeden na stejnou osobu nebo organizaci.'
    a_mixedrights 'ano; více různých držitelů práv',
      :text_as_statement => '',
      :help_text => 'Ano, a držitelem práv jsou různé osoby a organizace'

    q_explicitWaiver 'Je obsah dat volným dílem?',
      :discussion_topic => :cz_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Obsah byl',
      :help_text => 'K prohlášení obsahu za volné dílo můžete použít například licenci <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark</a>. Tak se uživatelé snadno dozvědí, že mohou s obsahem dat volně nakládat.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'Je obsah dat volným dílem, tedy Public Domain?',
      :requirement => ['standard_3']

    label_standard_3 '
                  <strong>Pokud je nějaká část obsahu vašich dat volným dílem, měli byste ji zveřejnit pod vhodnou licencí</strong>, aby uživatelé věděli, že s tímto obsahem mohou volně nakládat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Pod jakou licencí zveřejňujete obsah dat?',
      :discussion_topic => :cz_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Licence obsahu',
      :help_text => 'Nezapomeňte, že každé tvůrčí úsilí automaticky vede ke vzniku autorských práv k vytvořenému obsahu (s výjimkou čistě faktických údajů). Pokud tedy uživatelé chtějí váš obsah bez problémů používat, potřebují odpovídající licenci nebo dokument, ve kterém se vzdáváte svých autorských práv. V seznamu uvádíme nejčastěji používané licence. Pokud váš obsah není chráněný autorským právem, práva vypršela nebo jste se jich vzdali, vyberte možnost „nehodí se“.',
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
    a_na 'Nehodí se',
      :text_as_statement => ''
    a_other 'Jiná ...',
      :text_as_statement => ''

    q_contentNotApplicable 'Proč se na obsah dat nevztahuje žádná licence?',
      :discussion_topic => :cz_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Důvody chybějící licence',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'Na obsah dat se nevztahují žádná autorská práva',
      :text_as_statement => 'na obsah se nevztahují autorská práva',
      :help_text => 'Autorská práva vznikají pouze tehdy, když k vytvoření obsahu vynaložíte netriviální tvůrčí úsilí, například psaním popisků. Pokud data obsahují pouze fakta, autorský zákon se na ně nevztahuje.'
    a_expired 'Autorská práva už vypršela.',
      :text_as_statement => 'autorská práva už vypršela',
      :help_text => 'Autorská práva platí pouze omezenou dobu, počítanou buď od vydání díla, nebo od úmrtí autora. Zkontrolujte si datum vzniku a vydání obsahu – pokud je obsah dostatečně starý, autorská práva už mohla vypršet.'
    a_waived 'Autor se svých práv vzdal.',
      :text_as_statement => '',
      :help_text => 'To znamená, že práva nikdo nevlastní a každý si s obsahem může nakládat podle svého.'

    q_contentWaiver 'Forma upuštění od autorských práv k obsahu',
      :discussion_topic => :cz_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Copyright bylo upuštěno s',
      :help_text => 'Pokud jste se autorských práv k obsahu vzdali, musíte to nějak doložit, aby uživatelé věděli, že s obsahem mohou bez rizika nakládat. Autorských práv se můžete vzdát nějakým zavedeným způsobem, třeba pomocí CCZero, ale i vlastním právním dokumentem.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Jiný ...',
      :text_as_statement => 'Jiný ...'

    q_contentOtherWaiver 'Kde je dokument, ve kterém se vzdáváte práv k obsahu?',
      :discussion_topic => :cz_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Forma upuštění od autorských práv k obsahu',
      :help_text => 'Uveďte URL k veřejně dostupnému dokumentu, kterým se vzdáváte práv k obsahu dat. Uživatelé si díky němu mohou ověřit, že je obsah skutečně bez právních závazků.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'URL k právnímu dokumentu',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL k právnímu dokumentu'

    q_otherContentLicenceName 'Jaký je název této licence?',
      :discussion_topic => :cz_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Licence obsahu',
      :help_text => 'Pokud používáte jinou licenci, potřebujeme znát její název, abychom ho mohli uvést na certifikátu otevřených dat.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'název licence',
      :string,
      :required => :required,
      :placeholder => 'název licence'

    q_otherContentLicenceURL 'Kde je plný text této licence?',
      :discussion_topic => :cz_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Text licence k obsahu',
      :help_text => 'Uveďte URL licenčního textu. Bude uvedeno na vašem certifikátu otevřených dat, aby si kdokoliv mohl licenci zkontrolovat.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL k licenci',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL k licenci'

    q_otherContentLicenceOpen 'Jde o otevřenou licenci?',
      :discussion_topic => :cz_otherContentLicenceOpen,
      :help_text => 'Definici „otevřené licence“ najdete na serveru <a href="http://opendefinition.org/od/czech/">OpenDefinition.org</a>. Tamtéž najdete přímo <a href="http://opendefinition.org/licenses/">seznam otevřených licencí</a>. Pokud v něm vaše licence chybí, buď není otevřená, nebo ji ještě nikdo neposoudil.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 '
                     <strong>Data musíte zveřejnit pod otevřenou licencí, aby je ostatní mohli užít.</strong>
                  ',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Kde popisujete právní a licenční podmínky spojené s obsahem dat?',
      :discussion_topic => :cz_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'Právní prohlášení k obsahu dat',
      :help_text => 'Uveďte URL stránky, na které vysvětlujete právní a licenční podmínky spojené s obsahem dat.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'URL právního prohlášení',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL právního prohlášení'

    q_copyrightStatementMetadata 'Které části vašeho právního prohlášení jsou strojově čitelné?',
      :discussion_topic => :cz_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Strojově čitelná data právního prohlášení',
      :help_text => 'Je dobrým zvykem uvádět informace o právech ve strojově čitelné podobě, aby uživatelé vašich dat mohli snadno uvést vaše autorství.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'licence k datům',
      :text_as_statement => 'licence k datům',
      :requirement => ['standard_4']
    a_contentLicense 'licence k obsahu',
      :text_as_statement => 'licence k obsahu',
      :requirement => ['standard_5']
    a_attribution 'způsob uvádění autorství',
      :text_as_statement => 'způsob uvádění autorství',
      :requirement => ['standard_6']
    a_attributionURL 'URL pro uvedení autorství',
      :text_as_statement => 'URL pro uvedení autorství',
      :requirement => ['standard_7']
    a_copyrightNotice 'informace o autorských právech',
      :text_as_statement => 'informace o autorských právech',
      :requirement => ['exemplar_1']
    a_copyrightYear 'letopočet spojený s autorskými právy',
      :text_as_statement => 'letopočet spojený s autorskými právy',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'držitel autorských práv',
      :text_as_statement => 'držitel autorských práv',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'database right year',
      :text_as_statement => 'the database right year',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'database right holder',
      :text_as_statement => 'the database right holder',
      :requirement => ['exemplar_5']

    label_standard_4 '
                        <strong>Informace o licenci dat uvedené v právním prohlášení by měly být strojově čitelné</strong>, aby se daly zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Měli byste zajistit <strong>strojově čitelných údajů ve svém prohlášení práv o povolení k obsahu </strong> z těchto údajů, takže automatické nástroje mohou používat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 '
                        <strong>Požadovaný způsob uvádění autorství, který popisujete v právním prohlášení, by měl být strojově čitelný</strong>, aby se dal zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 '
                        <strong>Požadovaný způsob uvádění autorství, který popisujete v právním prohlášení, by měl být strojově čitelný</strong>, aby se dal zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 '
                        <strong>Informace o autorských právech uvedené v právním prohlášení by měly být strojově čitelné</strong>, aby se daly zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 '
                        <strong>Letopočet, spojený s autorskými právy, uvedený v právním prohlášení, by měl být strojově čitelný</strong>, aby se dal zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 '
                        <strong>Informace o držiteli autorských práv uvedené v právním prohlášení by měly být strojově čitelné</strong>, aby se daly zpracovat automatickými nástroji.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'You should provide <strong>machine-readable data in your rights statement about the database right year for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'You should provide <strong>machine-readable data in your rights statement about the database right holder for the data</strong>, so automatic tools can use it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Ochrana osobních údajů',
      :help_text => 'jak chránit soukromí osob',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Dají se podle vašich dat identifikovat konkrétní osoby?',
      :discussion_topic => :cz_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Ochrana osobních údajů',
      :pick => :one,
      :required => :pilot
    a_not_personal 'Ne, data se netýkají jednotlivců.',
      :text_as_statement => 'nehraje roli, data se netýkají jednotlivců',
      :help_text => 'Nezapomeňte na to, že konkrétní osoba se dá identifikovat i nepřímo. Například byste mohli někoho identifikovat podle statistik dopravního provozu, ve spojení se informacemi o tom, kdy a kam daná osoba dojíždí.'
    a_summarised 'Ne. Jde o agregovaná data, která vznikla spojováním dat o jednotlivcích do větších celků. Jednotlivci jsou v rámci skupiny nerozlišitelní a tudíž anonymní.',
      :text_as_statement => 'nehraje roli, jde o agregovaná data',
      :help_text => 'Skutečná anonymita jednotlivců v agregovaných datech se dá ověřit statistickými metodami.'
    a_individual 'Ano, existuje riziko, že by data mohla vést k identifikaci konkrétních osob, například nějakou třetí stranou disponující souvisejícími daty.',
      :text_as_statement => 'data, která mohou sloužit k identifikaci osob',
      :help_text => 'Některá data o konkrétních osobách se dají zveřejnit bez problémů, například platy státních zaměstnanců – v některých zemích – nebo veřejné výdaje.'

    q_statisticalAnonAudited 'Máte anonymizaci dat oveřenou nezávislým posudkem?',
      :discussion_topic => :cz_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Anonymizace dat',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ověřena nezávislým posudkem',
      :requirement => ['standard_8']

    label_standard_8 '
                  <strong>Měli byste si nechat vypracovat nezávislý posudek anonymizace dat</strong>, abyste minimalizovali riziko, že anonymizovaná data půjdou použít k identifikaci osob.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Pokusili jste se snížit nebo úplně vyloučit riziko identifikace osob podle vašich dat?',
      :discussion_topic => :cz_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'Anonymizace dat',
      :help_text => 'Anonymizace snižuje riziko, že vaše data půjdou zneužít k identifikaci osob. Konkrétní techniky záleží na konkrétní podobě dat.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'data byla anonymizována'

    q_lawfulDisclosure 'Jste ze zákona povinni nebo oprávněni zveřejňovat tato osobní data?',
      :discussion_topic => :cz_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Publikace daná zákonem',
      :help_text => '
                     <strong>Osobní data byste bez anonymizace měli zveřejňovat jen v případech, kdy vám to povoluje nebo nařizuje zákon.</strong>
                  ',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'zveřejnění dat je přikázáno zákonem',
      :requirement => ['pilot_5']

    label_pilot_5 '
                     <strong></strong>
                  ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Který dokument vám umožnuje zveřejnit osobní data?',
      :discussion_topic => :cz_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'Právo ke zveřejnění osobních dat'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL s odůvodněním',
      :string,
      :input_type => :url,
      :placeholder => 'URL s odůvodněním',
      :requirement => ['standard_9']

    label_standard_9 '
                        <strong>Měli byste zveřejnit, odkud plynou vaše práva k publikování osobních údajů</strong>. Usnadníte tím situaci uživatelům svých dat i lidem, kterých se data týkají.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Analyzovali jste rizika spojená se zveřejněním osobních údajů?',
      :discussion_topic => :cz_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'Rizika spojená s osobními údaji',
      :help_text => 'Analýza rizik se týká jak soukromí postižených osob, tak použití a zveřejnění těchto dat.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'poskytovatel neprovedl analýzu rizik'
    a_true 'yes',
      :text_as_statement => 'poskytovatel provedl analýzu rizik',
      :requirement => ['pilot_6']

    label_pilot_6 '
                     <strong>Pokud zveřejňujete osobní data, měli byste analyzovat související rizika.</strong>
                  ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Kde máte analýzu rizik zveřejněnou?',
      :discussion_topic => :cz_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Analýza rizik',
      :help_text => 'Uveďte URL dokumentu, kde si mohou zájemci ověřit vaši analýzu rizik práce s osobními údaji. Pokud analýza obsahuje citlivé informace, můžete ji pouze shrnout nebo příslušné části cenzurovat.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL analýzy rizik',
      :string,
      :input_type => :url,
      :placeholder => 'URL analýzy rizik',
      :requirement => ['standard_10']

    label_standard_10 '
                        <strong>Analýzu rizik spojených s osobními údaji byste měli zveřejnit</strong>, aby se zájemci mohli podívat, nakolik s příslušnými riziky počítáte.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Prošla vaše analýza rizik nezávislým auditem?',
      :discussion_topic => :cz_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Audit analýzy rizik',
      :help_text => 'Je dobrým zvykem nechat si analýzu rizik ještě ověřit. Pečlivější a nestrannější bývá nezávislý audit odborníkem nebo třetí stranou.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'analýza rizik prošla nezávislým auditem',
      :requirement => ['standard_11']

    label_standard_11 '
                           <strong>Analýza rizik by měla projít auditem</strong>, abyste měli jistotu, že je v pořádku.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Where is the privacy notice for individuals affected by your data?',
      :discussion_topic => :cz_individualConsentURL,
      :display_on_certificate => true,
      :text_as_statement => 'Individuals affected by this data have this privacy notice',
      :help_text => 'When you collect data about individuals you must tell them how that data will be used. People who use your data need this to make sure they comply with the Data Protection Act.',
      :help_text_more_url => 'http://www.ico.org.uk/for_organisations/data_protection/the_guide/principle_2'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    a_1 'Privacy Notice URL',
      :string,
      :input_type => :url,
      :placeholder => 'Privacy Notice URL',
      :requirement => ['pilot_7']

    label_pilot_7 'You should <strong>tell people what purposes the individuals in your data consented to you using their data for</strong>. So that they use your data for the same purposes and comply with the Data Protection Act.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    condition_F :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Is there someone in your organisation who is responsible for data protection?',
      :discussion_topic => :cz_dpStaff,
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_dbStaffConsulted 'Have you involved them in the Privacy Impact Assessment process?',
      :discussion_topic => :cz_dbStaffConsulted,
      :display_on_certificate => true,
      :text_as_statement => 'The individual responsible for data protection',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'has been consulted',
      :requirement => ['pilot_8']

    label_pilot_8 'You should <strong>involve the person responsible for data protection</strong> in your organisation before you publish this data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Has your anonymisation approach been independently audited?',
      :discussion_topic => :cz_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'The anonymisation of the data has been',
      :help_text => 'It is good practice to make sure your process to remove personal identifiable data works properly. Independent audits by specialists or third-parties tend to be more rigorous and impartial.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'independently audited',
      :requirement => ['standard_12']

    label_standard_12 'You should <strong>have your anonymisation process audited independently</strong> by an expert to ensure it is appropriate for your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Praktické informace',
    :description => 'Vyhledávání dat, přesnost, kvalita a záruky' do

    label_group_6 'Vyhledávání dat',
      :help_text => 'jak se lidé o vašich datech dozvědí',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Odkazujete na data z domovské stránky Vašeho webu?',
      :discussion_topic => :onWebsite,
      :help_text => 'Pomocí odkazu z domovské stránky Vašeho webu se data lépe hledají.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 '
               <strong>Měli byste na data odkazovat z domovské stránky Vašeho webu </strong>, aby je lidé lépe našli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Odkazy na webu' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Která stránka na vašem webu na data odkazuje?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'Webová stránka s odkazem na data',
        :help_text => 'URL stránky v rámci Vašeho webu, která na data odkazuje.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'URL stránky',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL stránky'

    end

    q_listed 'Jsou vaše data vedená v datovém katalogu?',
      :discussion_topic => :listed,
      :help_text => 'Data se lépe hledají, když jsou uvedená v relevantních katalozích, například akademických a zdravotnických databázích nebo databázích státní správy. Měla by také vyskočit ve výsledcích vyhledávačů na relevantní dotazy.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 '
               <strong>Vaše data by měla být snadno k nalezení všude, kde by je uživatelé mohli hledat.</strong>
            ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Zařazení do datových katalogů' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'V jakém datovém katalogu jsou data vedena?',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'Relevantní datové katalogy',
        :help_text => 'Uveďte URL datového katalogu, ve kterém jsou data zaregistrována. Můžete uvést také URL s výsledky vyhledávání pomocí webového vyhledávače.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'URL datového katalogu',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL datového katalogu'

    end

    q_referenced 'Odkazujete na tato data ve svých publikacích?',
      :discussion_topic => :referenced,
      :help_text => 'Když na data odkazujete ve svých článcích, prezentacích nebo blog postech, vytváříte kontext, který pomáhá datům lépe rozumět.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_15']

    label_standard_15 '
               <strong>Měli byste na data odkazovat ve svých publikacích</strong>. Lidé je snáze najdou a budou zasazena do kontextu.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Odkazy' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Kde se na data odkazujete?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Související publikace',
        :help_text => 'Uveďte URL dokumentu, který se na data odkazuje.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL dokumentu',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL dokumentu'

    end

    label_group_7 'Zajištění aktuálnosti dat',
      :help_text => 'jak zajišťujete aktuálnost dat',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Mění se data, která zpřístupňujete prostřednictvím vašeho API?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'Mění se data zpřístupněná tímto API?',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'ne, API zpřístupňuje data, která se nemění',
      :text_as_statement => 'nemění se',
      :help_text => 'Některá API slouží jen k jednoduššímu přístupu k neměnným datům, například kvůli jejich objemu'
    a_changing 'ano, API zpřístupňuje data, která se mění',
      :text_as_statement => 'mění se',
      :help_text => 'Některá API zpřístupňují průběžně aktualizovaná data.'

    q_timeSensitive 'Budou vaše data v čase zastarávat?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'Včasnost dat',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'ano, tato data časem zastarají',
      :text_as_statement => 'data časem zastarají',
      :help_text => 'Například databáze autobusových zastávek časem zastará, protože některé zastávky zmizí a objeví se nové.'
    a_timestamped 'ano, tato data časem zastarají, ale jsou doplněny informacemi o jejich platnosti',
      :text_as_statement => 'data časem zastarají, ale mají vyznačenou platnost',
      :help_text => 'Například demografické statistiky obvykle mívají vyznačenu časovou platnost. Podle toho se pozná, kdy byly aktuální.',
      :requirement => ['pilot_9']
    a_false 'ne, platnost těchto dat není závislá na čase',
      :text_as_statement => 'data nezastarají',
      :help_text => 'Například výsledky vědeckého experimentu nepřestanou nutně platit jen kvůli tomu, že už jsou staré.',
      :requirement => ['standard_16']

    label_pilot_9 '
                        <strong>Během vydání byste svá data měli opatřit údajem o časové platnosti dat</strong>, aby se poznalo, k jakému období se vztahují a kdy zastarají.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 '
                        <strong>Pokud vaše data závisí na čase, měli byste je aktualizovat</strong>, aby publikovaná data byla aktuální.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Mění se data aspoň jednou denně?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Frekvence změn',
      :help_text => 'Tímto informujete uživatele, zda se data běžně mění ze dne na den. Rychle se měnící data také rychle zastarávají, takže jejich uživatelé potřebují vědět, jestli je dostatečně často aktualizujete.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'data se mění aspoň jednou denně'

    q_seriesType 'Jaký typ datového souboru řadě je to?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Typ aktualizací',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'pravidelně je publikován úplný export všech dat datové sady',
      :text_as_statement => 'úplný export všech dat datové sady',
      :help_text => 'Zvolte, zda pravidelně zveřejňuje nové a aktualizované kopie vaší plné databáze. Při vytváření databáze skládek, je užitečné, aby lidé měli přístup k přívodu změn, aby mohli udržet své kopie aktuální.'
    a_aggregate 'pravidelné agregáty změně dat',
      :text_as_statement => 'agregáty změně dat',
      :help_text => 'Vyberte, pokud pravidelně publikujete exporty, které obsahují úplný export všech dat datové sady, tj. obsahují nové, změněné i nezměněné údaje. Je dobré také nabídnout uživatelům přehled změn (například přes RSS), aby mohli snadno aktualizovat svou kopii dat.'

    q_changeFeed 'pravidelně je publikován export změněných dat',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'export změněných dat',
      :help_text => 'Dejte uživatelům vědět, pokud někde publikujete seznam změn ve svých datech, například nové přírůstky nebo změny stávajících záznamů. Seznam může být publikovaný například jako RSS, Atom, nebo v jiném vhodném formátu.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'je k dispozici',
      :requirement => ['exemplar_6']

    label_exemplar_6 '
                        <strong>Publikujte seznam změn ve svých datech</strong>, aby uživatelé mohli snadno aktualizovat své kopie.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Jak často publikujete nové verze?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Nové verze těchto údajů jsou',
      :help_text => 'Podle tohoto údaje uživatelé poznají, jak moc data zastarají, než vyjde další aktualizace.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'méně než jednou za měsíc',
      :text_as_statement => 'méně než jednou za měsíc'
    a_monthly 'alespoň jednou měsíčně',
      :text_as_statement => 'alespoň jednou měsíčně',
      :requirement => ['pilot_10']
    a_weekly 'alespoň jednou týdně',
      :text_as_statement => 'alespoň jednou týdně',
      :requirement => ['standard_17']
    a_daily 'alespoň jednou denně',
      :text_as_statement => 'alespoň jednou denně',
      :requirement => ['exemplar_7']

    label_pilot_10 '
                           <strong>Publikujte aspoň jednou měsíčně novou verzi</strong>, aby uživatelé měli aktuální a přesná data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Publikujte aspoň jednou týdně novou verzi</strong>, aby uživatelé měli aktuální a přesná data .',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 '
                           <strong>Publikujte aspoň jednou denně novou verzi</strong>, aby uživatelé měli aktuální a přesná data .',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Jak dlouhá je prodleva mezi vytvořením dat a jejich zveřejněním?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'Prodleva mezi vytvořením a zveřejněním dat',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'delší než časový úsek mezi dvěma vydáními',
      :text_as_statement => 'delší než časový úsek mezi dvěma vydáními',
      :help_text => 'Například zdrojová data se mění každý den, ale publikace dat trvá déle než jeden den.'
    a_reasonable 'zhruba stejná jako časový úsek mezi dvěma vydáními',
      :text_as_statement => 'zhruba stejná jako časový úsek mezi dvěma vydáními',
      :help_text => 'Například zdrojová data se mění každý den a zhruba během jednoho dne je také publikujete.',
      :requirement => ['pilot_11']
    a_good 'kratší než polovina časového úseku mezi vydáními',
      :text_as_statement => 'kratší než polovina časového úseku mezi vydáními',
      :help_text => 'Například když se zdrojová data mění každý den a publikace dat vám zabere nanejvýš dvanáct hodin.',
      :requirement => ['standard_18']
    a_minimal 'je minimální nebo žádné zpoždění',
      :text_as_statement => 'prodleva je minimální nebo žádná',
      :help_text => 'Tuto možnost vyberte, pokud nové verze publikujete v řádu minut nebo sekund.',
      :requirement => ['exemplar_8']

    label_pilot_11 '
                        <strong>Mezi vytvořením dat a jejich publikací by měla být přiměřeně krátká prodleva</strong>, menší než je prodleva mezi jednotlivými vydáními, aby uživatelé dat měli aktuální a přesná data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 '
                        <strong>Mezi vytvořením dat a jejich zveřejněním by měla přiměřeně krátká prodleva</strong>, menší než polovina prodlevy mezi jednotlivými vydáními, aby uživatelé dat měli aktuální a přesná data .',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 '
                        <strong>Mezi vytvořením dat a jejich zveřejněním by měla být co nejmenší prodleva</strong>, ideálně nulová, aby uživatelé vždy k dispozici aktuální a přesná data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Zveřejňujete datové soubory ke stažení?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'Datové soubory ke stažení',
      :help_text => 'Datový soubor s exportem obsahem datové sady, který si uživatelé mohou stáhnout. Datové soubory ke stažení umožňují uživatelů s daty pracovat i jinak, než jim dovoluje API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'jsou k dispozici',
      :requirement => ['standard_19']

    label_standard_19 '
                  <strong>Data byste měli publikovat v podobě datových souborů ke stažení</strong>. Umožníte tak uživatelům pracovat s úplnou datovou sadou.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'Jak často publikujete datové soubory ke stažení?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Frekvence publikace datových souborů ke stažení',
      :help_text => 'Častější publikace datových souborů ke stažení umožňuje uživatelům rychlejší přístup k aktuálním datům.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'méně často než jednou měsíčně',
      :text_as_statement => 'méně často než jednou měsíčně'
    a_monthly 'aspoň jednou měsíčně',
      :text_as_statement => 'aspoň jednou měsíčně',
      :requirement => ['pilot_12']
    a_weekly 'nejpozději týden od provedení změn',
      :text_as_statement => 'nejpozději týden od provedení změn',
      :requirement => ['standard_20']
    a_daily 'nejpozději den od provedení změn',
      :text_as_statement => 'nejpozději den od provedení změn',
      :requirement => ['exemplar_9']

    label_pilot_12 '
                              <strong>Publikujete datové soubory ke stažení aspoň jednou měsíčně</strong>, aby uživatelé měli k dispozici aktuální data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 '
                              <strong>Publikujete datové soubory ke stažení nejpozději týden od provedení změn</strong>, ať uživatelé dlouho nečekají na aktuální data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 '
                              <strong>Publikujete datové soubory ke stažení do jednoho dne od provedení změn</strong>, ať mají uživatelé rychlý přístup k aktuálním datům.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Je zajištěna oprava dat v případě, že budou objeveny chyby?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Chyby v datech',
      :help_text => 'Je dobrou praxí opravovat chyby v datech, zvláště pokud data sami používáte. Nezapomeňte na provedené opravy upozornit uživatele.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'budou opravovány',
      :requirement => ['standard_21']

    label_standard_21 '
                     <strong>Měli byste opravit nahlášené chyby</strong>, pomůžete tak všem uživatelům dat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Kvalita dat',
      :help_text => 'kvalita dat ovlivňuje, nakolik se vašim datům dá věřit',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Kde jsou dokumentovány známé nedostatky a chyb v datech?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumentace kvality dat',
      :help_text => 'URL, kde se uživatelé mohou dozvědět podrobnosti o kvalitě vašich dat. Každý chápe, že určitá chybovost je nevyhnutelná, ať už třeba kvůli selhání techniky nebo výpadkům při migraci dat. Buďte ohledně známých nedostatků v datech otevření a zvýšíte tak důvěryhodnost vašich dat.'
    a_1 'URL dokumentace',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace',
      :requirement => ['standard_22']

    label_standard_22 '
               <strong>Známé nedostatky a chyby v datech by měly být dokumentovány a tato dokumentace by měla být zveřejněna</strong>, aby se uživatelé mohli rozhodnout, nakolik na ně mohou spoléhat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Kde máte popsaný svůj systém řízení kvality dat ?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumentace systému řízení kvality dat',
      :help_text => 'Uveďte adresu, kde se uživatelé mohou dozvědět o způsobu kontroly kvality dat, ať již automatizované či ruční. Dáváte tím najevo, že berete kvalitu dat vážně, a motivujete uživatele ke hlášení chyb, což přináší přínosy všem uživatelům.'
    a_1 'URL popisující dokumentace systému řízení kvality dat řízení kvality',
      :string,
      :input_type => :url,
      :placeholder => 'URL popisující dokumentace systému řízení kvality dat řízení kvality',
      :requirement => ['exemplar_10']

    label_exemplar_10 '
               <strong>Měli byste popsat váš způsob zajištění kvality datDokumentujte své procesy pro řízení kvality</strong>, ať se uživatelé vímohou rozhodnout, nakolik mohou vašim datům důvěřovat.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Zajištění',
      :help_text => 'dostupnosti vašich dat',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Zálohujete data v oddělené lokalitě?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'Zálohování dat',
      :help_text => 'Pravidelná záloha v oddělené lokalitě zaručuje, že o data nepřijdete v případě nějaké nehody.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'data jsou zálohována v oddělené lokalitě',
      :requirement => ['standard_23']

    label_standard_23 '
               <strong>Provádějte zálohování svých dat do oddělené lokality</strong>, abyste o ně v případě nehody nepřišli.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Kde je popsána garantovaná úroveň dostupnosti služby?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dostupnost služby',
      :help_text => 'Uveďte URL k dokumentu, který popisuje vámi garantovanou úroveň dostupnosti služby. Můžete například uvést, že garantujete dostupnost 99,5 %, nebo že dostupnost služeb nijak nezaručujete.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL popisující garantovanou úroveň dostupnosti služby',
      :string,
      :input_type => :url,
      :placeholder => 'URL popisující garantovanou úroveň dostupnosti služby',
      :requirement => ['standard_24']

    label_standard_24 '
                  <strong>Měli byste uvést, jaká garantovaná úroveň dostupnosti služby</strong>, aby její uživatelé věděli, nakolik se na ni mohou spolehnout.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Kde se poskytují informace o aktuálním stavu služby?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Aktuální stav služby',
      :help_text => 'Uveďte URL stránky, na které mohou uživatelé najít informace o aktuálním stavu služby, včetně případných výpadků.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL s popisem aktuálního stavu služby',
      :string,
      :input_type => :url,
      :placeholder => 'URL s popisem aktuálního stavu služby',
      :requirement => ['exemplar_11']

    label_exemplar_11 'Měli byste provozovat <strong>informační stránku s údaji o aktuálním stavu vaší služby</strong>, ať mají uživatelé přehled o aktuálním stavu služby.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Jak dlouho budou data dostupná?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'Dlouhodobá dostupnost dat',
      :pick => :one
    a_experimental 'poskytování dat může být kdykoli ukončeno',
      :text_as_statement => 'poskytování dat může být kdykoli ukončeno'
    a_short 'data jsou publikována experimentálně, ale očekává se, že budou publikována alespoň rok',
      :text_as_statement => 'aspoň jeden rok',
      :requirement => ['pilot_13']
    a_medium 've střednědobém výhledu se počítá s publikací dat alespoň v řádu několika let',
      :text_as_statement => 'očekává se, že budou publikována několik let',
      :requirement => ['standard_25']
    a_long 'publikace dat je součástí běžného provozu a počítá se s dlouhodobou dostupností',
      :text_as_statement => 'očekává se, že budou publikována řadu let',
      :requirement => ['exemplar_12']

    label_pilot_13 '
                     <strong>Měli byste se zaručit, že data budou ve stávající podobě k dispozici alespoň jeden rok.</strong>
                  ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 '
                     <strong>Měli byste zaručit, že data ve stávající podobě budou k dispozici v horizontu několika let.</strong>
                  ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 '
                     <strong>Měli byste zaručit, že data v současné podobě budou k dispozici dlouhodobě.</strong>
                  ',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Technické informace',
    :description => 'Umístění, formát a důvěryhodnost' do

    label_group_11 'Umístění',
      :help_text => 'jakým způsobem mohou lidé přistupovat k vašim',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Kde je vaše datová sada k dispozici?',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Odkaz na data',
      :help_text => 'Uveďte přímý odkaz (URL) na data. Na otevřená data by z webu měl vést přímý odkaz, aby je lidé snadno našli a mohli využít.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'přímý odkaz (URL) na data',
      :string,
      :input_type => :url,
      :placeholder => 'přímý odkaz (URL) na data',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 '
                     <strong>Uveďte přímý odkaz (URL) na svá data nebo na jejich dokumentaci.</strong>
                  ',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 '
                     <strong>Měli byste uvést přímý odkaz na data samotná</strong>, ať se k nim lidé snadno dostanou.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Jak publikujete nové datové zdroje datové sady, např. soubory v časové řadě?',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'URL zůstává stejné, ale mění se data dostupná po přistoupení na dané URLn',
      :help_text => 'Tuto možnost vyberte, pokud je aktuální verze dat vždy ke stažení na stejném URL.',
      :requirement => ['standard_26']
    a_template 'je definován vzor URL pro měnící se data',
      :help_text => 'Tuto možnost vyberte, pokud se URL s každého nově publikovaného datového zdroje mění podle definovaného vzoru. Např. zahrnutí data vydání do URL (například „2013-04“). To umožňuje uživatelům pochopit, jak často se data mění, a vytvářet skripty pro pravidelné stahování dat.',
      :requirement => ['pilot_15']
    a_list 'jako seznam zpráv publikujeme seznam publikovaných datových zdrojů',
      :help_text => 'Tuto možnost vyberte, pokud poskytujete webovou stránku nebo feed (například Atom nebo RSS) s odkazy na jednotlivé publikované datové zdroje a podrobnosti o nich. To umožňuje uživatelům pochopit, jak často se data mění, a vytvářet skripty pro pravidelné stahování dat.',
      :requirement => ['standard_27']

    label_standard_26 '
                        <strong>Měli byste stanovit URL, na kterém uživatelé vždy najdou aktuální verzi dat.</strong>
                     ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Pro jednotlivé datové zdroje <strong>by měl být konzistentně používán definovaný vzor URL</strong>, aby je bylo možno stahovat automaticky.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 '
                        <strong>Měl by být publikován dokument nebo feed se seznamem všech publikovaných datových zdrojů</strong>, ať si je lidé mohou snadno automaticky stáhnout.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Je třeba zajistit, že jsou aktuální data dostupná <strong>buď vždy na stálém URL, nebo je pro data využívána posloupnost URL podle definovaného vzoru, nebo na stránce se seznamem publikovaných datových zdrojů</strong>.v',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Kde je umístěna vaše aktuální datová sada?',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Adresa aktuální datové sady',
      :help_text => 'Uveďte URL odkazu na aktuální verzi datové sady. Data na tomto URL by se měla měnit s vydáním každé nové verze.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'URL aktuální datové sady',
      :string,
      :input_type => :url,
      :placeholder => 'URL aktuální datové sady',
      :required => :required

    q_versionsTemplateUrl 'Jaký formát mají URL průběžně publikovaných datových zdrojů?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Formát URL',
      :help_text => 'Uveďte vzor, podle které jsou tvořena URL průběžně publikovaných datových zdrojů. Měnící se části URL můžete vyznačit `{takto}`, například: `http://subjekt.cz/data/mesicne/data-{RR}{MM}.csv`.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'vzor URL',
      :string,
      :input_type => :text,
      :placeholder => 'vzor URL',
      :required => :required

    q_versionsUrl 'Kde publikujete seznam publikovaných datových zdrojů?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'seznamem publikovaných datových zdrojů',
      :help_text => 'Uveďte URL stránky nebo feedu se strojově čitelným seznamem publikovaných datových zdrojů. Pokud má seznam více stránek, uveďte URL první z nich, která by následně měla odkazovat na další.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'URL seznamu publikovaných datových zdrojů',
      :string,
      :input_type => :url,
      :placeholder => 'URL seznamu publikovaných datových zdrojů',
      :required => :required

    q_endpointUrl 'Kořenové URL přístupového bodu vašeho API',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Kořenové URL datového API',
      :help_text => 'Uveďte URL, které odkazuje na přístupový bod vašeho API. Na tomto URL by skripty a aplikace měli získat popis služeb poskytovaných API.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'kořenové URL',
      :string,
      :input_type => :url,
      :placeholder => 'kořenové URL',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Musíte dát k dispozici <strong>kořenové URL přístupového bodu vašeho datového API nebo URL dokumentace</strong>, aby je mohli uživatelé najít.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Měli byste dát k dispozici <strong>dokumentaci popisu služby nebo kořenové URL vašeho datového API</strong>, aby je mohli uživatelé najít .',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Jak publikujete soubory dat ke stažení?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'URL zůstává stejné, ale mění se data dostupná po přistoupení na dané URL',
      :help_text => 'Tuto možnost vyberte, pokud se aktuální export dat v podobě souboru ke stažení dá vždy najít na stejném URL.',
      :requirement => ['standard_29']
    a_template 'je definován vzor URL pro měnící se data',
      :help_text => 'Tuto možnost vyberte, pokud se URL s každého nově publikovaného datového souboru ke stažení mění podle definovaného vzoru. Např. zahrnutí data vydání do URL (například „2013-04“). To umožňuje uživatelům pochopit, jak často se data mění, a vytvářet skripty pro pravidelné stahování dat.',
      :requirement => ['exemplar_13']
    a_list 'publikujeme seznam publikovaných datových souborů ke stažení',
      :help_text => 'Tuto možnost vyberte, pokud poskytujete webovou stránku nebo feed (například Atom nebo RSS) s odkazy na jednotlivé publikované datové soubory ke stažení a podrobnosti o nich. To umožňuje uživatelům pochopit, jak často se data mění, a vytvářet skripty pro pravidelné stahování dat..',
      :requirement => ['exemplar_14']

    label_standard_29 '
                           <strong>Měli byste uživatelům nabídnout jedno stálé URL, na kterém si stáhnou aktuální export dat v podobě souboru ke stažení.</strong>
                        ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 '
                           <strong>URL jednotlivých souborů ke stažení s exportem dat vybírejte podle jasného vzoru</strong>, ať si je lidé mohou stahovat automaticky.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 '
                           <strong>Publikujte dokument nebo feed se seznamem všech souborů ke stažení</strong>, ať si je lidé mohou snadno automaticky stáhnout.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Kde je aktuální soubor ke stažení?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Adresa nejaktuálnějšího souboru ke stažení',
      :help_text => 'Uveďte URL nejaktuálnějšího souboru ke stažení. Soubor dostupný na tomto URL by se měl měnit pokaždé, když provedete nový export dat.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'URL exportovaných dat',
      :string,
      :input_type => :url,
      :placeholder => 'URL exportovaných dat',
      :required => :required

    q_dumpsTemplateUrl 'Jaký formát mají URL jednotlivých datových souborů ke stažení?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Formát URL',
      :help_text => 'Uveďte šablonu, podle které jsou tvořena URL jednotlivých souborů ke stažení. Měnící se části URL můžete vyznačit `{takto}`, například: `http://subjekt.cz/data/mesicne/data-{RR}{MM}.csv`.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'šablona URL',
      :string,
      :input_type => :text,
      :placeholder => 'šablona URL',
      :required => :required

    q_dumpsUrl 'Kde publikujete seznam souborů ke stažení?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Seznam souborů ke stažení',
      :help_text => 'Uveďte URL stránky nebo feedu se strojově čitelným seznamem souborů ke stažení. Pokud má seznam více stránek, uveďte URL první z nich, která by následně měla odkazovat na další.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'URL seznamu souborů ke stažení',
      :string,
      :input_type => :url,
      :placeholder => 'URL seznamu souborů ke stažení',
      :required => :required

    q_changeFeedUrl 'Kde publikujete seznam změn v datech?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Seznam změn',
      :help_text => 'Uveďte odkaz na stránku nebo feed se strojově čitelným seznamem starších souborů ke stažení. Pokud má seznam více stránek, uveďte URL první z nich, která by následně měla odkazovat na další.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'URL seznamu změn v datech',
      :string,
      :input_type => :url,
      :placeholder => 'URL seznamu změn v datech',
      :required => :required

    label_group_12 'Formát',
      :help_text => 'jak lze s vašimi daty pracovat',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Jsou data strojově čitelná?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Strojová čitelnost',
      :help_text => 'Lidé dávají přednost datům, která se dají snadno, rychle a přesně zpracovat počítačem. Například skenovaná kopie tabulky strojově čitelná není, zatímco CSV soubor jednoznačně ano.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'data jsou strojově čitelná',
      :requirement => ['pilot_16']

    label_pilot_16 '
               <strong>Měli byste data poskytovat ve strojově čitelném formátu</strong>, aby se dala snadno zpracovat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Jsou vaše data ve standardizovaném otevřeném formátu?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'Formát dat',
      :help_text => 'Otevřené standardy vznikají v rámci jasného a transparentního procesu spolupráce. Může je implementovat kdokoliv, takže bývají dobře podporované a lépe se sdílí. Mezi otevřené formáty patří například XML, CSV nebo JSON.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'standardizovaný, otevřený',
      :requirement => ['standard_30']

    label_standard_30 '
               <strong>Měli byste svá data publikovat v otevřeném standardizovaném formátu</strong>, aby je ostatní mohli snadno zpracovat pomocí běžně dostupných nástrojů.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Jaký typ dat publikujete?',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'lidsky čitelné dokumenty',
      :help_text => 'Tuto možnost vyberte, pokud jsou vaše data určena pro přímé využití lidmi. Příkladem jsou třeba firemní předpisy, vědecké a novinové články nebo zápisy z porad. I tyto dokumenty mívají nějakou strukturu, ale vesměs jde převážně o text.'
    a_statistical 'statistické údaje, například počty, průměry nebo podíly',
      :help_text => 'Tuto možnost vyberte, pokud jde o statistická nebo obecně číselná data, například počty, průměry nebo podíly. Sem patří například demografické údaje, údaje o dopravě nebo statistiky kriminality.'
    a_geographic 'geografické (prostorové) informace, například body a hranice',
      :help_text => 'Tuto možnost vyberte, pokud se vaše data dají vynést na mapu, například jako body, hranice nebo čáry.'
    a_structured 'jiná strukturovaná data',
      :help_text => 'Tuto možnost vyberte, pokud publikujete strukturovaná data jiného typu, například události, jízdní řády nebo kontakty. Nebo jakákoli jiná data, která lze analyzovat a interpretovat více způsoby.'

    q_documentFormat 'Jaké z následujících vlastností mají vámi publikované dokumenty?',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Formát dokumentů',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'Jsou sémanticky značkované, například pomocí HTML, DocBook nebo Markdown.',
      :text_as_statement => 'sémantické značkování',
      :help_text => 'Sémantické značkování dělí dokument na logické stavební prvky, jako jsou kapitoly, nadpisy nebo tabulky, takže se s nimi snadno automaticky pracuje – například není problém sestavit seznam tabulek nebo rejstřík. Sémantické značkování také usnadňuje formátování dokumentu podle potřeby.',
      :requirement => ['standard_31']
    a_format 'Jsou optimalizované pro zobrazení, například OOXML nebo PDF.',
      :text_as_statement => 'vizuální značkování',
      :help_text => 'Tyto formáty se zabývají především vizuální podobou dokumentu, například písmem, barvami a umístěním prvků na stránce. Hodí se pro běžné čtení dokumentu, ale nejsou vhodné pro automatické zpracování a automatizované změny formátování.',
      :requirement => ['pilot_17']
    a_unsuitable 'Obsahují data ve formátech nevhodných pro dokumenty jako například tabulky Excelu, JSON nebo CSV.',
      :text_as_statement => 'data nevhodná pro dokumenty',
      :help_text => 'Pro tato data je lepší zvolit tabulkové nebo strukturované formáty.'

    label_standard_31 '
                        <strong>Měli byste publikovat sémanticky značkované dokumenty</strong>, aby si je uživatelé mohli snadno přeformátovat a jinak zpracovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 '
                        <strong>Měli byste publikovat dokumenty ve formátu, který je pro dokumenty určený</strong>, protože je pak bude možné zpracovat pomocí nástrojů pro zpracování dokumentů.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'V jakém formátu jsou vaše statistická data?',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Formát statistických dat',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'Ve formátu přímo určeném pro statistická data, například <a href="http://sdmx.org/">SDMX</a> nebo <a href="">Data Cube</a>.',
      :text_as_statement => 'formát přímo určený pro statistická data',
      :help_text => 'Nativní formáty statistických dat jako <a href="http://sdmx.org/">SDMX</a> nebo <a href="">Data Cube</a> umožňují reprezentovat vícerozměrná statistická data ve formě záznamů o jednotlivých pozorováních a k nim přiřazených dimenzích. Každé pozorování může být navíc opatřeno anotací, která poskytuje další kontext.',
      :requirement => ['exemplar_15']
    a_tabular 'V tabulkovém formátu, například CSV.',
      :text_as_statement => 'tabulkový',
      :help_text => 'V tabulkových formátech jsou statistická data reprezentována jako řádky a sloupce tabulky. Snadno se zpracovávají, ale oproti nativním formátům statistických, ale nelze data reprezentovat v tabulkových formátech jako vícerozměrné (multidimenzionální) datové kostky.',
      :requirement => ['standard_32']
    a_format 'V prezentačním formátu s důrazem na formátování, například Excel.',
      :text_as_statement => 'prezentační',
      :help_text => 'V tabulkových procesorech je občas struktura dat vyznačena vizuálně, například pomocí kurzívy nebo tučného písma. Lidem to pomáhá pochopit vztahy mezi jednotlivými částmi dat, ale strojově se dokumenty značkované pouze tímto způsobem zpracovávají obtížně.',
      :requirement => ['pilot_18']
    a_unsuitable 'Ve formátu nevhodném pro statistická nebo tabulková data například Word nebo PDF.',
      :text_as_statement => 'nepříliš vhodný, dokumentový',
      :help_text => 'Zmíněné formáty se k uložení statistických dat příliš nehodí, protože strukturu dat v nich lze strukturu dat vyjádřit obtížně nebo vůbec.'

    label_exemplar_15 '
                        <strong>Statistická data byste měli publikovat ve formátu, který umožňuje reprezentovat jejich vícerozměrnou strukturu</strong> a usnadňuje tak jejich analýzu.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 '
                        <strong>Tabulková data byste měli zveřejňovat v tabulkovém formátu</strong>, aby se dala snadno analyzovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 '
                        <strong>Tabulková data byste měli zveřejňovat v tabulkovém formátu</strong>, aby se dala snadno analyzovat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'V jakém formátu jsou vaše prostorová (geografická) data?',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Formát geografických dat',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'Ve formátu určeném pro prostorová data, například <a href="http://www.opengeospatial.org/standards/kml/">KML</a> nebo <a href="http://www.geojson.org/">GeoJSON</a>.',
      :text_as_statement => 'nativní geografický',
      :help_text => 'Tyto formáty přímo pracují s body, čarami a hranicemi, a umožňují reprezentovat příslušnou strukturu dat, díky čemuž se dobře automatizovaně zpracovávají.',
      :requirement => ['exemplar_16']
    a_generic 'V obecném strukturovaném formátu, například JSON, XML nebo CSV.',
      :text_as_statement => 'obecný strukturovaný',
      :help_text => 'Každý formát pro ukládání strukturovaných dat může posloužit i pro data prostorová, zvlášť pokud jde jen o uložení bodů.',
      :requirement => ['pilot_19']
    a_unsuitable 'Ve formátu nevhodném pro prostorová data, například Word nebo PDF.',
      :text_as_statement => 'nepříliš vhodný',
      :help_text => 'Tyto formáty se k uložení geografických dat nehodí, protože v nich nelze reprezentovat potřebnou strukturu dat.'

    label_exemplar_16 '
                        <strong>Prostorová data byste měli zveřejňovat ve specializovaném formátu pro tento typ dat</strong>, aby je uživatelé mohli snadno zpracovat v aplikacích.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 '
                        <strong>Prostorová data byste měli zveřejňovat alespoň v nějakém strukturovaném formátu</strong>, aby se dala snadno zpracovat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'V jakém formátu jsou vaše strukturovaná data?',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Formát strukturovaných dat',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'Ve formátu určeném pro strukturovaná data, například JSON, XML, Turtle nebo CSV.',
      :text_as_statement => 'vhodný, strukturovaný',
      :help_text => 'Data v těchto formátech jsou reprezentovány jako entity/objekty a jejich vlastnosti. Dají se snadno automaticky zpracovávat.',
      :requirement => ['pilot_20']
    a_unsuitable 'Ve formátu, který není určen pro strukturovaná data jako například Word nebo PDF.',
      :text_as_statement => 'nevhodný, prezentační',
      :help_text => 'Tyto formáty se k uložení strukturovaných dat nehodí, protože v nich nelze reprezentovat strukturu dat, příp. pouze omezeně.'

    label_pilot_20 '
                        <strong>Strukturovaná data byste měli zveřejňovat ve formátu určeném pro strukturovaná data</strong>, aby je bylo možno snadno automatizovaně zpracovat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Používáte v datech persistentní identifikátory?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'Identifikátory objektů',
      :help_text => 'Data zpravidla vypovídají o objektech reálného světa jako například školy nebo, silnice nebo je pro ně může existovat definovaný způsob značení. Pokud se data z různých zdrojů využívají pro označování objektů stejné persistentní a unikátní identifikátory, je pak snadnější propojovat data z různých zdrojů a zvyšovat tak hodnotu dat. Příklady takovýchto identifikátorů jsou např. GUID, DOI nebo URL.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ano, jsou používány persistentní identifikátory (GUID, URL, …)',
      :requirement => ['standard_33']

    label_standard_33 'Měli byste<strong>ve vašich datech používat identifikátory pro označování objektů</strong>, aby vaše data bylo možno snadno kombinovat s jinými daty o stejných objektech.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Lze pomocí Vámi používaných identifikátorů objektů vyhledávat o objektech další údaje?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Navigace pomocí identifikátorů',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'Ne, podle používané identifikátory nelze použít k vyhledávání dalších údajů.',
      :text_as_statement => 'používané identifikátory to neumožňují'
    a_service 'Ano, existuje služba, která identifikátory překládá a umožňuje navigaci na další související informace.',
      :text_as_statement => 'používané identifikátory jsou podporovány službami',
      :help_text => 'Identifikátory GUID nebo DOI nemohou být použity přímo k navigaci mezi zdroji jako je tomu v případě URL, ale lze využití online služeb, které tyto identifikátory překládají a zprostředkují navigaci na související zdroje.',
      :requirement => ['standard_34']
    a_resolvable 'Ano, jako identifikátory jsou použity dereferencovatelné URL.',
      :text_as_statement => 'jsou využity URL jako identifikátory',
      :help_text => 'URL jsou využitelná jak lidmi, tak počítače. Lidé si mohou URL snadno otevřít ve svém prohlížeči a dohledat tak informace třeba o <a href="http://opencorporates.com/companies/gb/08030289">firmě</a> nebo <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">PSČ</a>. Počítače pak např. prostřednictvím skriptů mohou URL využít pro přístup k datům.',
      :requirement => ['exemplar_17']

    label_standard_34 'Pokud používáte identifikátory, které nelze přímo použít k navigaci mezi zdroji, měli byste <strong>poskytnout službu, která umožní navigaci na související zdroje pomocí použitých identifikátorů</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 '
                        <strong>Měli byste uvádět odkazy na webové stránky s informacemi o objektech ve vašich datech</strong>, aby uživatelé mohli snadno najít a sdílet související informace.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Adresa služby pro navigaci pomocí identifikátorů:',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Služba pro navigaci pomocí identifikátorů',
      :help_text => 'Služba by měla na základě identifikátoru zadaného jako parametr dotazu vrátit data o příslušném objektu, který je identifikátorem identifikován.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'URL služby',
      :string,
      :input_type => :url,
      :placeholder => 'URL služby',
      :requirement => ['standard_35']

    label_standard_35 '
                     <strong>Měli byste zpřístupnit URL, na kterém lze podle identifikátorů získat další data o identifikovaných objektech</strong>, aby bylo možno získávání těchto dat automatizovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Existují jinde na webu další informace o objektech, které se vyskytují ve vašich datech?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Je možné, že o stejných objektech, jaké se vyskytují ve vašich datech, jsou na webu dostupné informace třetích stran. Například když máte v databázi PSČ, bylo by možné je využít pro propojení na data na národním geoportálu.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Jsou informace poskytované třetími stranami spolehlivé?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'Pokud jsou ke stejným objektům, jako ve vašich datech, dostupná URL někde jinde na webu je to známka, že se jejich poskytovatel snaží zajistit jejich kvalitu a dostupnost. Tímto hodnotíte, na kolik považujete tato data za spolehlivá. Při hodnocení se můžete se podívat na open data certifikát poskytovatele nebo na obdobnou známku kvality.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Okazujete na tato cizí URL ve svých datech?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'Další informační zdroje',
      :help_text => 'Při využívání URL třetích stran je doporučováno využívat dereferencovatelná URL, která umožňují získat data o objektu po přistoupení na dané URL. Tím se snižuje duplicita dat a je usnadněno kombinování dat z více zdrojů.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'data odkazují na URL z jiných zdrojů',
      :requirement => ['exemplar_18']

    label_exemplar_18 '
                        <strong>Měli byste pomocí URL odkazovat na data třetích stran</strong>. Usnadníte tím kombinování dat s jinými daty, která také využívají tato URL.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Důvěryhodnost',
      :help_text => 'do jaké míry mohou uživatelé vašim datům důvěřovat',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Publikujete strojově čitelná metadata o původu dat?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'Informace o původu dat',
      :help_text => 'Je vhodné publikovat metadata o tom, jak byla data vytvořena a zpracována, než byla publikována. Tím pomáháte posilovat důvěru uživatelů ve vaše data, protože si uživatelé mohou ověřit, jak data vznikla. Více o metadatech o původu naleznete <a href="">zde</a>.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'strojově čitelné metadata o původu dat',
      :requirement => ['exemplar_19']

    label_exemplar_19 '
               <strong>Měli byste publikovat strojově čitelná metadata o původu a zpracování dat</strong>, aby si uživatelé mohli ověřit, jak byla data zpracována.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Jakým způsobem si uživatelé mohou ověřit, že data skutečně pochází od vás?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Ověření původ dat',
      :help_text => 'Pokud zveřejňujete důležitá data, měli byste uživatelům dát možnost ověřit, že data skutečně pochází od vás. Například můžete data digitálně podepsat, aby bylo možné rozpoznat, že data byla pozměněna.'
    a_1 'URL dokumentace způsobu ověření',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace způsobu ověření',
      :requirement => ['exemplar_20']

    label_exemplar_20 '
               <strong>Měli byste zajistit, aby si uživatelé mohli ověřit, že získaná data skutečně odpovídají datům, které publikujete.</strong> Tento krok pomáhá budovat důvěru uživatelů.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Sociální informace',
    :description => 'Dokumentace, podpora a služby' do

    label_group_15 'Dokumentace',
      :help_text => 'pomocí které usnadňujete lidem pochopit kontext a obsah vašich dat',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Jaká metadata publikujete ve strojově čitelné podobě?',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Strojově čitelná metadata',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'název datové sady',
      :text_as_statement => 'název datové sady',
      :requirement => ['standard_36']
    a_description 'popis',
      :text_as_statement => 'popis',
      :requirement => ['standard_37']
    a_issued 'datum publikace',
      :text_as_statement => 'datum publikace',
      :requirement => ['standard_38']
    a_modified 'datum poslední aktualizace datové sady',
      :text_as_statement => 'datum poslední aktualizace datové sady',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'periodicita publikace datové sady',
      :text_as_statement => 'periodicita publikace datové sady',
      :requirement => ['standard_40']
    a_identifier 'identifikátor',
      :text_as_statement => 'identifikátor',
      :requirement => ['standard_41']
    a_landingPage 'URL metadat',
      :text_as_statement => 'URL metadat',
      :requirement => ['standard_42']
    a_language 'jazyk',
      :text_as_statement => 'jazyk',
      :requirement => ['standard_43']
    a_publisher 'poskytovatel',
      :text_as_statement => 'poskytovatel',
      :requirement => ['standard_44']
    a_spatial 'související geografické území',
      :text_as_statement => 'související geografické území',
      :requirement => ['standard_45']
    a_temporal 'související časové období',
      :text_as_statement => 'související časové období',
      :requirement => ['standard_46']
    a_theme 'klasifikace',
      :text_as_statement => 'klasifikace',
      :requirement => ['standard_47']
    a_keyword 'klíčová slova',
      :text_as_statement => 'klíčová slova',
      :requirement => ['standard_48']
    a_distribution 'Datové zdroje (distribuce)',
      :text_as_statement => 'Datové zdroje (distribuce)'

    label_standard_36 '<strong>Měli byste publikovat strojově čitelný název datové sady</strong, aby bylo jasné, jak se data nazývají.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 '
                        <strong>Měli byste publikovat strojově čitelný popis datové sady</strong>, aby bylo zřejmé, jaká data a o čem datová sada obsahuje.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 '
                        <strong>Měli byste publikovat strojově čitelné datum publikace</strong>, aby uživatelé věděli, nakolik jsou data aktuální.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 '
                        <strong>Měli byste publikovat strojově čitelné datum poslední aktualizace datové sady</strong>, aby uživatelé věděli, jestli mají aktuální data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 '
                        <strong>Měli byste publikovat strojově čitelné údaje o periodicitě publikace datové sady</strong>, aby uživatelé věděli, jak často jsou data aktualizována.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 '
                        <strong>Měli byste publikovat strojově čitelné údaje o URL, které identifikátorem datové sady</strong>, aby se k ní uživatelé mohli konzistentně přistupovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 '
                        <strong>Měli byste publikovat strojově čitelné údaje o URL samotných metadat</strong>, aby se k nim uživatelé mohli konzistentně přistupovat .',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 '
                        <strong>Měli byste publikovat strojově čitelné údaje o jazyce datové sady</strong>, aby uživatelé věděli, jestli jim budou rozumět.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 '
                        <strong>Měli byste publikovat strojově čitelné údaje informace o poskytovateli dat</strong>, aby se uživatelé mohli rozhodnout, nakolik jim mohou věřit.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 '
                        <strong>Měli byste publikovat strojově čitelné údaje o tom, k jakému zeměpisnému území se data vztahují, nebo o jakém vypovídají.</strong>
                     ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 '
                        <strong>Měli byste publikovat strojově čitelné údaje o časovém úseku, kterého se data týkají, nebo o kterém vypovídají.</strong>
                     ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 '
                        <strong>Měli byste publikovat strojově čitelným způsobem klasifikovat datovou sadu </strong>, aby uživatelé věděli, čeho se data týkají.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 '
                        <strong>Měli byste publikovat strojově čitelná klíčová slova vztahující se k datové sadě</strong>, aby ji uživatelé mohli lépe vyhledávat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Jaká strojově čitelná metadata o datových zdrojích (distribucích, např. stažitelných souborech datové sady) publikujete?',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Strojově čitelná metadata o datových zdrojích (distribucích)',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'název datového zdroje',
      :text_as_statement => 'název datového zdroje',
      :requirement => ['standard_49']
    a_description 'popis',
      :text_as_statement => 'popis',
      :requirement => ['standard_50']
    a_issued 'datum publikace',
      :text_as_statement => 'datum publikace',
      :requirement => ['standard_51']
    a_modified 'datum aktualizace datového zdroje',
      :text_as_statement => 'datum aktualizace datového zdroje',
      :requirement => ['standard_52']
    a_rights 'podmínky užití',
      :text_as_statement => 'podmínky užití',
      :requirement => ['standard_53']
    a_accessURL 'URL pro přístup k datům',
      :text_as_statement => 'URL pro přístup k datům',
      :help_text => 'Uveďte URL pro přístup k datům v případě, že vaše data nejsou dostupná ve formě souborů ke stažení, ale například jako API.'
    a_downloadURL 'URL datového zdroje',
      :text_as_statement => 'URL datového zdroje'
    a_byteSize 'velikost v bytech',
      :text_as_statement => 'velikost v bytech'
    a_mediaType 'media type dle IANA',
      :text_as_statement => 'media type dle IANA'

    label_standard_49 '
                           <strong>Měli byste publikovat strojově čitelný název datového zdroje</strong>, aby bylo zřejmé, jak se jednotlivé datové zdroje nazývají.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 '
                           <strong>Měli byste publikovat strojově čitelný popis datového zdroje</strong>, aby lidé věděli, co která distribuce obsahuje.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 '
                           <strong>Měli byste publikovat strojově čitelné datum publikace datového zdroje</strong>, aby uživatelé věděli, jak je datový zdroj starý.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 '
                           <strong>Měli byste publikovat strojově čitelné datum poslední aktualizace datového zdroje</strong>, aby lidé věděli, jestli mají aktuální verzi datového zdroje dat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 '
                           <strong>Měli byste publikovat strojově čitelný odkaz na podmínky užití či licenci, pod kterou jsou data publikována</strong>, aby uživatelé věděli, jak mohou s datovým zdrojem nakládat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Kde je umístěna technická dokumentace dat?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'Technická dokumentace'
    a_1 'URL technické dokumentace',
      :string,
      :input_type => :url,
      :placeholder => 'URL technické dokumentace',
      :requirement => ['pilot_21']

    label_pilot_21 '
               <strong>K datům byste měli poskytnout technickou dokumentaci</strong>, aby uživatelé snáze pochopili, jak s daty pracovat.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Mají vaše data definováno schéma?',
      :discussion_topic => :vocabulary,
      :help_text => 'K datům ve formátech typu CSV, JSON, XML nebo Turtle formalizovaným způsobem definovat jejich schéma a popsat tak strukturu sloupců nebo objektů a jejich vlastností.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Kde je umístěna dokumentace schématu?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumentace schématu'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'URL dokumentace schématu',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace schématu',
      :requirement => ['standard_54']

    label_standard_54 '
                  <strong>Všechny slovníky použité v rámci vašich dat by měly být dokumentovány</strong>, aby uživatelé věděli, jak dat správně interpretovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Používáte v datech nějaké číselníky?',
      :discussion_topic => :codelists,
      :help_text => 'Pokud jsou v datech použity číselníky, například pro geografické oblasti, výdajové kategorie nebo diagnózy nemocí, je vhodné je zdokumentovat.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Kde je umístěna dokumentace číselníků?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumentace číselníků'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'URL dokumentaci číselníků',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentaci číselníků',
      :requirement => ['standard_55']

    label_standard_55 '
                  <strong>Číselníky použité v datech byste měli dokumentovat</strong>, aby uživatelé věděli, jak mají data interpretovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Podpora',
      :help_text => '- komunikace s lidmi, kteří vaše data používají',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Kde jsou umístěny informace o tom, jak vás mohou uživatelé dat kontaktovat?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Kontakty',
      :help_text => 'Uveďte URL odkazující na informace o tom, jak vás mohou uživatelé dat kontaktovat v případě, že se chtějí na něco zeptat ohledně publikovaných dat.'
    a_1 'kontaktní URL',
      :string,
      :input_type => :url,
      :placeholder => 'kontaktní URL',
      :requirement => ['pilot_22']

    label_pilot_22 '
               <strong>Měli byste uživatelům dat poskytnout nějaké kontaktní informace</strong>, aby věděli, jak se na vás mohou obrátit v případě dotazů.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Jak mohou uživatelé poskytnout zpětnou vazbu k publikovaným datovým sadám, např. náměty na zlepšení jejich publikace?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Zpětná vazba k publikovaným datovým sadám'
    a_1 'kontaktní URL',
      :string,
      :input_type => :url,
      :placeholder => 'kontaktní URL',
      :requirement => ['pilot_23']

    label_pilot_23 '
               <strong>Měli byste uživatelům dát možnost zasílat připomínky k publikovaným datům a způsobu jejich publikace.</strong> To vám umožní zjistit, co uživatelé potřebují.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Koho mohou uživatelé kontaktovat s dotazy , které se týkají ochranu soukromí a osobních údajů?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Dotazy na ochranu soukromí a osobních údajů'
    a_1 'kontaktní URL',
      :string,
      :input_type => :url,
      :placeholder => 'kontaktní URL',
      :requirement => ['pilot_24']

    label_pilot_24 '
               <strong>Měli byste zveřejnit kontaktní informace pro ty, kteří se potřebují zeptat na otázky ohledně ochrany soukromí a osobních údajů.</strong>
            ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Komunikujete s uživateli svých dat prostřednictvím sociálních sítí?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 '
               <strong>Měli byste s uživateli svých dat komunikovat prostřednictvím sociálních sítí</strong> a zjistit, jak vaše data používají.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Profily na sociálních sítích' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Kde vás lidé najdou na sociálních sítích?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Profily na sociálních sítích',
        :help_text => 'Uveďte URL účtu na nějaké sociální síti, například váš profil na Twitteru nebo Facebooku.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'URL účtu na sociální síti',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL účtu na sociální síti'

    end

    q_forum 'Kde mohou lidé o této datové sadě diskutovat?',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Diskuze',
      :help_text => 'Uveďte URL na fórum nebo poštovní konferenci, kde mohou uživatelé o vašich datech diskutovat.'
    a_1 'URL diskuzního fóra nebo poštovní konference',
      :string,
      :input_type => :url,
      :placeholder => 'URL diskuzního fóra nebo poštovní konference',
      :requirement => ['standard_57']

    label_standard_57 '
               <strong>Měli byste uživatele informovat, kde mohou o vašich datech diskutovat</strong> a navzájem si pomáhat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Jak mohou uživatelé nahlásit chyby v datech?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Kde a jak nahlásit chyby v datech',
      :help_text => 'Uveďte URL, kde mohou uživatelé hlásit chyby ve vašich datech.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'kontaktní URL',
      :string,
      :input_type => :url,
      :placeholder => 'kontaktní URL',
      :requirement => ['standard_58']

    label_standard_58 '
                  <strong>Měli byste uživatele informovat, kde a jak mohou hlásit chyby ve vašich datech.</strong>
               ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Kde a jak se uživatelé mohou dozvědět o chybách ve vašich datech?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Jak informujete o chybách v datech',
      :help_text => 'Uveďte URL, kde popisujete, jakým způsobem informujete uživatele o chybách ve svých datech.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'informační URL',
      :string,
      :input_type => :url,
      :placeholder => 'informační URL',
      :requirement => ['standard_59']

    label_standard_59 '
                  <strong>Měli byste uživatelům poskytnout poštovní konferenci nebo feed, kde budete oznamovat opravy chyb ve svých datech</strong>, aby všichni mohli včas aktualizovat.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Máte někoho, kdo se aktivně stará o komunitu okolo vašich dat?',
      :discussion_topic => :engagementTeam,
      :help_text => 'Tým, který má na starosti komunikaci v oblasti otevřených dat může k většímu zapojení uživatelů využít např. například sociální sítě, blogy, soutěže nebo hackatony.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_21']

    label_exemplar_21 '
               <strong>Měli byste kolem svých dat budovat komunitu</strong> a podporovat tak jejich větší využití.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Kdo se o tuto komunitu stará?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Kdo se stará o komunitu',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'URL komunitního týmu',
      :string,
      :input_type => :url,
      :placeholder => 'URL komunitního týmu',
      :required => :required

    label_group_17 'Služby',
      :help_text => 'nástroje pro práci s daty a informace o nich',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Spravujete seznam nástrojů pro práci s publikovanými daty?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Nástroje pro práci s daty',
      :help_text => 'Uveďte URL, kde uživatelé najdou seznam existujících nebo doporučených nástrojů pro práci s publikovanými daty.'
    a_1 'URL dokumentace nástrojů',
      :string,
      :input_type => :url,
      :placeholder => 'URL dokumentace nástrojů',
      :requirement => ['exemplar_22']

    label_exemplar_22 '
               <strong>Měli byste uživatelům poskytnout seznam vhodných softwarových knihoven a dalších existujících nástrojů</strong> pro rychlou a pohodlnou práci s publikovanými daty.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
