survey 'DE',
  :full_title => 'Germany',
  :default_mandatory => 'false',
  :status => 'beta',
  :description => '<p><strong>Hierbei handelt es sich um eine Voreinstellung für EU-Staten und muss für Deutschland angepasst werden. Bitte helfen Sie uns. Kontakt: <a href="mailto:certificate@theodi.org">certificate@theodi.org</a></strong></p><p>Dieser Fragebogen zur Selbsteinschätzung erzeugt ein Open Data Zertifikate und ein Badge, das sie veröffentlichen können, um Nutzer über Ihre Daten zu informieren. Wir nutzen ihre Antworten auch, um zu verstehen, wie Organisationen offene Daten veröffentlichen.</p><p>Wenn Sie diese Fragen beantworten, bezeugt das Ihr Bemühen, den einschlägigen rechtlichen Regelungen zu entsprechen. Sie sollten auch kontrollieren, welche anderen Gesetze und Regeln für Ihren Bereich gelten.</p><p><strong>Sie müssen nicht alle Fragen beantworten um ein Zertifikat zu erhalten.</strong></p>' do

  translations :en => :default
  section_general 'Allgemeine Informationen',
    :description => '',
    :display_header => false do

    q_dataTitle 'Wie werden die Daten bezeichnet?',
      :discussion_topic => :dataTitle,
      :help_text => 'Dieser Name wird in einer Liste von ähnlichen Daten angezeigt. Er sollte daher so eindeutig und anschaulich sein, wie es in dieser kleinen Box möglich ist, so dass schnell klar wird, worin die Daten sich von anderen unterscheiden.',
      :required => :required
    a_1 'Bezeichnung der Daten',
      :string,
      :placeholder => 'Bezeichnung der Daten',
      :required => :required

    q_documentationUrl 'Wo sind die Daten beschrieben?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Beschreibung der Daten befindet sich unter',
      :help_text => 'Geben Sie eine URL an, an der Nutzer sich über die Inhalte der Daten detaillierter informieren können. Dabei kann es sich auch um eine Seite in einem größeren Katalog wie govdata.de handeln.'
    a_1 'URL der Dokumentation',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Dokumentation',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Sie sollten <strong>eine Web-Seite haben, die Dokumentation über die von Ihnen veröffentlichent offenen Daten bereitstellt</strong>, so dass die Nutzer ihren Kontext, Inhalt und Nutzen verstehen können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Sie müssen ein Webseite haben <strong>die Dokumentation und Zugang zu den von Ihnen veröffentlichten offenen Daten bereitstellt</strong>, damit die Nutzer sie weiterverwenden können.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Wer veröffentlicht die Daten?',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten werden veröffentlicht von…',
      :help_text => 'Geben Sie den Namen der Organisation an, die die Daten veröffentlicht. Dies ist wahrscheinlich diejenige, für die Sie tätig sind, es sei denn, Sie tun es in Vertretung einer anderen.',
      :required => :required
    a_1 'Herausgeber der Daten',
      :string,
      :placeholder => 'Herausgeber der Daten',
      :required => :required

    q_publisherUrl 'Auf welcher Web-Site sind die Daten veröffentlicht?',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten werden veröffentlicht unter…',
      :help_text => 'Geben Sie eine URL an, die uns hilft die Daten einer Organisation zusammenzufassen, auch wenn Nutzer sie unterschiedliche bezeichnen.'
    a_1 'URL des Herausgebers',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Herausgebers'

    q_releaseType 'Welche Art Release (Einzelveröffenlichtung, Sammlung, Zeitreihe, Websservice) ist das?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'eine einmalige Datenveröffentlichung',
      :help_text => 'Dies ist ein einzelner Satz von Daten und Sie planen nicht, in Zukunft ähnliche Datensätze zu veröffentlichen.'
    a_collection 'eine einzelne Veröffentlichung einer Gruppe zusammenhängender Datensätze',
      :help_text => 'Dies ist eine Sammlun von Datensätzen mit zusammenhängen Daten, Sie planen jedoch nicht in Zukunft ähnliche Sammlungen zu veröffentlichen.'
    a_series 'fortlaufende Veröffentlichung von mit einander in Bezug stehenden Datensätzen.',
      :help_text => 'Eine Abfolge von Datensätzen mit geplanten periodischen Updates.'
    a_service 'Ein Dienst oder eine API für den Zugriff auf offene Daten.',
      :help_text => 'Dies ist ein produktiver Web-Service die Daten Entwicklern durch eine Schnittstelle zugänglich mach, die sie abfragen können.'

  end

  section_legal 'Rechtliche Information',
    :description => 'Rechte, Lizenzvergabe und Datenschutz' do

    label_group_2 'Rechte',
      :help_text => 'Ihre, Rechte, diese Daten anderen zu überlassen',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Besitzen Sie die Rechte, diese Daen als offene Daten (Open Data) zu veröffentlichen?',
      :discussion_topic => :de_publisherRights,
      :help_text => 'Wenn Ihre Organisation die Daten nicht ursprünglich erzeugt oder erhoben hat, verfügen Sie möglicherweise nicht über das Recht, sie zu veröffentlichen. Wenn Sie unsicher sind, erkundigen Sie sich beim Besitzer der Daten, denn Sie benötigen für die Veröffentlicheung dessen Einwilligung.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'Ja, Sie besitzen die notwendigen Rechte, um diese Daten als offene Daten ("open data") zu publizieren.',
      :requirement => ['standard_1']
    a_no 'Nein, Sie sind nicht berechtigt, die Daten als "offen" (Open Data) zu veröffentlichen.'
    a_unsure 'Sie sind sich nicht sicher, ob Sie berechtigt sind, die Daten als "offen" (Open Data) zu veröffentlichen.'
    a_complicated 'Die Rechte an diesen Daten sind komplex oder unklar'

    label_standard_1 'Sie sollten <strong>eindeutig berechtigt sein, die Daten als "offen" zu publizieren</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'Sie müssen <strong>das Recht besitzen, diese Daten zu veröffentlichen</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Wo beschreiben Sie die Risiken, die Nutzer unter Umständen eingehen, wenn sie die Daten nuzten?',
      :discussion_topic => :de_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'Risks in using this data are described at',
      :help_text => 'Daten zu nutzen, ohne dazu das klare Recht zu besitzen, kann Risiken beinhalten. So kann z.B. gerichtlich verlangt werden, die Daten aus dem Netz zu nehmen. Geben Sie die URL einer Seite an, die die Risiken beim Nutzen der Daten beschreibt.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'URL der Risikodokumentation',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Risikodokumentation',
      :requirement => ['pilot_2']

    label_pilot_2 'Dokumentieren Sie nach Möglichkeit <strong>Risiken, die mit der Nutzung der Daten verbunden sind.</strong>, so dass Nutzer herausfinden können, wie sie die Daten weiterverwenden wofllen.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Wurden <em>alle</em>Daten ursprünglich von Ihnen erzeugt oder erhoben?',
      :discussion_topic => :de_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten wurden',
      :help_text => 'Wenn irgend ein Teil der Daten nicht aus Ihrer Organisation, sondern von anderen Personen oder Organisationen stammt, müssen Sie zusätzliche Informationen über Ihre Rechte zur Veröffentlichung bereitstellen.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'ursprünglich vom Herausgeber erzeugt oder erhoben'

    q_thirdPartyOrigin 'Wurden Teile der Daten aus anderen Daten extrahiert oder berechnet?',
      :discussion_topic => :de_thirdPartyOrigin,
      :help_text => 'Ein Auszug oder kleiner Teil von Daten anderer Personen kann bedeuten, dass Ihre Rechte zur Veröffenlichung eingeschränkt sind. Rechtliche Fragen können auch entstehen, wenn Sie die Daten anderer analysiert haben, um neue Ergebnisse zu erzeugen.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['basic_3']

    label_basic_3 'Sie haben angegeben, dass diese Daten ursprünglich nicht von Ihnen erzeugt oder erhoben wurden und auch nicht durch Crowdsourcing entstanden sind. Die Daten müssen also aus anderen Datenquellen extrahiert oder berechnet worden sein.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Wurden <em>alle</em> Datenquellen schon als offene Daten (Open Data) veröffentlicht?',
      :discussion_topic => :de_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'This data is created from',
      :help_text => 'Sie dürfen, die Daten anderer weiter verbreiten, wenn sie mit einer Open Data Lizenz veröffentlicht wurden, oder die Urheberrechte ausgelaufen oder aufgegeben worden sind. Trifft dies auf irgend einen Teil der Daten nicht zu, benötigen rechtliche Beratung, bevor Sie die Daten veröffentlichen können.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'offene Ausgangsdaten',
      :requirement => ['basic_4']

    label_basic_4 'Sie sollten <strong>Rechtsberatung wahrnehmen, um sicherzustellen, dass Sie das Recht besitzen, die Daten zu veröffentlichen</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Ist ein Teil der Daten durch "Crowdsourcing" entstanden?',
      :discussion_topic => :de_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'Teile der Daten sind',
      :help_text => 'Wenn die Daten Informationen enthalten, die Personen außerhalb ihrer Organisation beigetragen haben, benötigen Sie deren Zustimmung, um ihren Beitrag als offene Daten zu verbreiten.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'crowdsourced',
      :requirement => ['basic_5']

    label_basic_5 'Sie haben angegeben, dass die Daten ursprünglich nicht von Ihnen erzeugt oder erhoben wurden und nicht aus Daten anderer erzeugt oder berechnet wurden, die Daten müssen daher durch "Crowdsourcing" entstanden sein.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Waren die Beitragenden schöpferisch tätig?',
      :discussion_topic => :de_crowdsourcedContent,
      :help_text => 'Wenn Personen ihre Kreativtät gebrauchen oder eigene Ideen zum Ausdruck gebracht haben, so haben Sie an Ihrem Werk die Urheberrechte. Die Abfassung einer Beschreibung oder die Entscheidung darüber, ob ein bestimmter Datensatz in eine Datensammlung eingeschlossen werden soll, sind Beispiele dafür, dass die Datensammlung durch die Beitragenden persönlich gestaltet wurden und die Beiträge daher Werkcharakter besitzen. Die Beitragenden müssen daher Nutzungsrechte einräumen oder auf Ihre Rechte verzichten, bevor Sie die Daten publizieren können.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'Nein'
    a_true 'Ja'

    q_claUrl 'Wo findet man die Lizenzvereinbarung für Beitragende (Contributor Licence Agreement (CLA))?',
      :discussion_topic => :de_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The Contributor Licence Agreement is at',
      :help_text => 'Geben Sie die URL einer Vereinbarung an, die die Zustimmung zur Weiterverwendung der Daten enthält. Die Vereinbarung wird  einen Verzicht auf die Verwertungsrechte oder die Einräumung von Nutzungsrechten beinhalten, die es Ihnen erlauben, die Daten zu veröffentlichen.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'URL der Lizenzvereinbarung für Beitragende',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Lizenzvereinbarung für Beitragende',
      :required => :required

    q_cldsRecorded 'Haben alle Beitragenden der Lizenzbereinbarung für Beitragende (CLA) zugestimmt?',
      :discussion_topic => :de_cldsRecorded,
      :help_text => 'Kontrollieren Sie, dass die Zustimmung aller Beitragenden zur CLA vorliegt, bevor Sie ihre Beiträge veröffentlichen oder weiterverwenden. Sie sollten die einzelnen Beitragenden und ihre Zustimmung zur CLA dokumentieren.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['basic_6']

    label_basic_6 'Sie müssen <strong>die Beitragenden dafür gewinnen, der CLA zuzustimmen</strong> die Ihnen erlaubt, ihre Beiträge als Open Data zu publizieren.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Wo beschreiben Sie die Quellen dieser Daten?',
      :discussion_topic => :de_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Datenquellen finden sich beschrieben unter',
      :help_text => 'Geben Sie die URL einer Seite an, die dokumentiert, woher die Daten stammen (Ihre Herkunft) und mit welchen Rechten Sie sie veröffentlichen. Dies hilft den Nutzern den Ursprung der Daten zu verstehen.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'die URL der Dokumentation der Datenquellen',
      :text,
      :input_type => :url,
      :placeholder => 'die URL der Dokumentation der Datenquellen',
      :requirement => ['pilot_3']

    label_pilot_3 'Sie sollten dokumentieren <strong>woher die Daten kamen und mit welchen Rechten Sie sie veröffentlichen</strong>, so das die Nutzer sicher sind, die Beiträge Dritter nutzen zu dürfen.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Stellen Sie die Dokumentation der Datenquellen auch in maschinenlesbarem Format bereit?',
      :discussion_topic => :de_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Der Herausgeber hat publiziert',
      :help_text => 'Information über die Datenquellen sollte für Menschen lesbar sein, so dass Nutzer sie verstehen können, aber auch in einem Metadaten-Format voliegen, dass Computer verarbeiten können. Wenn alle dies tun, hilft es, zu erkennen, wie offene Daten genutzt werden und ihre Veröffentlichung in der Zukunft zu rechtfertigen.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'maschinenlesbare Daten über die Quellen dieser Daten',
      :requirement => ['standard_2']

    label_standard_2 'Sie sollten <strong>maschinenlesbare Daten über die Datenherkunft bereitstellen</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Lizenzvergabe',
      :help_text => 'Wie Nutzer die Erlaubnis erhalten, diese Daten zu nutzen',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Wo sind die Nutzungsbestimmungen für diese Daten veröffentlicht?',
      :discussion_topic => :de_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'Die Nutzungsbestimmungen finden sich unter',
      :help_text => 'Geben Sie die URL einer Seite an, die die Nutzungsbedingungen für diese Daten spezifiziert. Diese sollten einen Verweis auf die Lizenz, die Bestimmungen zur Namensnennung und Hinweise zu Urheberrechten einschließlich evtl. Datenbankurheberrechten umfassen. Explizite Nutzungsbestimmungen erleichtern es den Nutern, zu verstehen, was sie mit den Daten tun bzw. nicht tun können.'
    a_1 'URL der Nutzungsbestimmungen',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Nutzungsbestimmungen',
      :requirement => ['pilot_4']

    label_pilot_4 'Sie sollten<strong>Nutzungsbestimmungen publizieren.</strong>die genau die Urheberrechte, Urheberherstellerrechte, Lizenzen und die obligatorische Namensnennung bestimmt.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Im Rahmen welcher Lizenz können Nutzer die Daten weiterverwenden?',
      :discussion_topic => :de_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Diese Daten können von Nutzern im Rahmen der folgenden Lizenz weiterverwendet weren',
      :help_text => 'Beachten Sie, dass jeder der eine Datensammlung erhebt, anlegt, überprüft oder darstellt, automatiscjh Urheberrechte daran erwirbt. Auch die Auswahl oder Anordnung von Daten ist urheberrechtlich geschützt. Daher benötigen die Nutzer eine Lizenz oder Verzichtserklärung, die belegt, dass sie die Daten verwenden können und erklärt, wie sie dies rechtmäßig tun können. Wir führen hier die gebräuchlichsten Lizenzen auf. Wenn es keine (Datenbank-)Urheberrechte gibt, sie ausgelaufen sind, oder Sie darauf verzichten, wählen Sie bitte  "nicht anwendbar".',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc_by 'Creative Commons Namensnennung',
      :text_as_statement => 'Creative Commons Namensnennung'
    a_cc_by_sa 'Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen',
      :text_as_statement => 'Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_odc_by 'Open Data Commons Attribution License',
      :text_as_statement => 'Open Data Commons Attribution License'
    a_odc_odbl 'Open Data Commons Open Database License (ODbL)',
      :text_as_statement => 'Open Data Commons Open Database License (ODbL)'
    a_odc_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_na 'Nicht anwendbar',
      :text_as_statement => ''
    a_other 'andere…',
      :text_as_statement => ''

    q_dataNotApplicable 'Warum sind auf diese Daten keine LIzenzen anwendbar?',
      :discussion_topic => :de_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Diese Daten werden nicht lizensiert, denn',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'An diesen Daten bsteht kein (Datenbank-)Urheberrecht oder Leistungsschutzrecht für Datenbanken',
      :text_as_statement => 'niemand besitzt Urheberrechte an den Daten',
      :help_text => 'Leistungsschutzrechte für eine Datenbank bestehen, wenn für die Beschaffung, Überprüfung oder Darstellung der Daten eine nach Art oder Umfang wesentliche Investition notwendig ist. So gibt es keine Urheber- oder Datenschutzrechte, wenn die Daten völlig neu erzeugt werden, in einer naheliegenden Weise dargestellt und in keiner Weise überprüft werden. Ein Leistungsschutzrecht existiert, wenn Sie die einzelnen Daten auswählen oder in einer neuen, nicht naheliegenden liegenden Weise (an-)ordnen.'
    a_expired 'Urheber- und Leistungsschutzrechte sind ausgelaufen',
      :text_as_statement => 'der Urheberrechtschutzt ist abgelaufen',
      :help_text => 'Leistungsschutzrechte für Datenbanken laufen nach 10 Jahren aus. Wenn die die Daten zuletzt vor mehr als 10 Jahren geändert wurden, dann sind die Leistungsschutzrechte ausgelaufen. Urheberrechte gelten für eine bestimmte Zeit, ausgehend von der Anzahl von Jahren, die seit der Publikation der Daten oder dem Tod ihres des Erstellers vergangen sind. Es ist unwahrscheinlich, dass Urheberrechte ausgelaufen sind.'
    a_waived 'Auf die Urheber- und Leistungsschutzrechte für die Datensammlung wurde verzichtet.',
      :text_as_statement => '',
      :help_text => 'Dies bedeutet, dass niemand Rechte an den Daten besitzt, und jeder mit ihnen machen kann, was er will.'

    q_dataWaiver 'Welche Verzichtserklärung haben Sie genutzt, um auf die Rechte an den Daten zu verzichten?',
      :discussion_topic => :de_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Auf die Rechte an diesen Daten wurde verzichtet durch',
      :help_text => 'Sie benötigen ein Erklärung, die den Nutzern zeigt, dass auf die Rechte an den Daten verzichtet wurden, so dass sie mit ihnen tun können, was immer sie wollen. Standardisierte Verzichtserklärungen existieren, aber Sie können Ihren eigenen rechtliche Erklärunge abfassen.',
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
    a_other 'Anderes',
      :text_as_statement => ''

    q_dataOtherWaiver 'Wo findet sich die Verzichtserklärung für die Rechte an den Daten?',
      :discussion_topic => :de_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Die Verzichtserklärung für die Rechte an diesen Daten findet sich unter',
      :help_text => 'Geben Sie eine URL an, unter der die Verzichtserklärung öffentlich einsehbar ist, damit die Nutzer überprüfen können, dass auf die Rechte an den Daten verzichtet wurde.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'URL der Verzichtserklärung',
      :text,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL der Verzichtserklärung'

    q_otherDataLicenceName 'Wie lautet der Name der Lizenz?',
      :discussion_topic => :de_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Diese Daten können  im Rahmen der folgenden Lizenz von anderen weiterverwendet werden',
      :help_text => 'Wenn Sie eine andere Lizenz benutzen, benötigen wir deren Namen, so dass die Nutzer diesen auf Ihrem Open Data Zertifikat sehen können.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Name der sonstigen Lizenz',
      :string,
      :required => :required,
      :placeholder => 'Name der sonstigen Lizenz'

    q_otherDataLicenceURL 'Wo findet sich die Lizenz?',
      :discussion_topic => :de_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Die Lizenzbestimmungen finden sich unter',
      :help_text => 'Geben Sie eine URL für die Lizenz an, damit die Nutzer diese auf dem Open Data Zertifikat finden und ihre öffentliche Verfügbarkeit prüfen können.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'URL der sonstigen Lizenz',
      :text,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL der sonstigen Lizenz'

    q_otherDataLicenceOpen 'Ist die Lizenz eine offene Lizenz?',
      :discussion_topic => :de_otherDataLicenceOpen,
      :help_text => 'Wenn sie nicht sicher sind, was eine offene Lizenz ist, dann lesen Sie <a href="http://opendefinition.org/">die Open Knowledge Definition</a>. Als nächstes wählen Sie eine Lizenz aus <a href="http://licenses.opendefinition.org/">der Liste offener Lizenzen des Open Definition Advisory Boards</a>. Wenn eine Lizenz auf dieser Liste fehlt, wurde sie noch nicht geprüft.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['basic_7']

    label_basic_7 'Sie müssen <strong>Die Daten mit einer offenen Lizenz veröffentlichen</strong>, damit die Nutzer sie verwenden können.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'Gibt es Urheberrechte am Inhalt der Daten?',
      :discussion_topic => :de_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Es gibt',
      :pick => :one,
      :required => :required
    a_norights 'nein, die Daten enthalten nur Fakten und Zahlen',
      :text_as_statement => 'keine Rechte am Inhalt der Daten.',
      :help_text => 'Es gibt kein Urheberrecht an Sachinformationen. Wenn die Daten keinen Inhalt beinhalten, der durch intellectuelle Anstrengung erzeugt wurde, gibt es keine Urheberrechte am Inhalt.'
    a_samerights 'Ja, und die Rechte werden alle von der selben Person oder Organisation gehalten.',
      :text_as_statement => '',
      :help_text => 'Wählen Sie diese Option, wenn der Inhalt komplett von einer Person oder Organisation geschaffen oder übertragen wurde.'
    a_mixedrights 'Ja, und die Rechte werden von unterschiedlichen Personen oder Organisationen gehalten.',
      :text_as_statement => '',
      :help_text => 'Bei manchen Daten halten unterschiedliche Personen oder Organisationen die Rechte an verschiedenen Datensätzen. In diesem Fall müssen auch Informationen über die Rechte in den Daten vorhanden sein.'

    q_explicitWaiver 'Ist der Inhalt der Daten als gemeinfrei gekennzeichnet?',
      :discussion_topic => :de_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Die Inhalte wurden',
      :help_text => 'Inhalte können als gemeinfrei gekennzeichnet sein durch die <a href="http://creativecommons.org/publicdomain/">Creative Commons Public Domain Mark</a>Dies lässt die Nutzer wissen, dass Sie die Daten frei verwenden können.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'als gemeinfrei gekennzeichnet',
      :requirement => ['standard_3']

    label_standard_3 'Sie sollten <strong>gemeinfreie Inhalte als solche kennzeichnen</strong>, so dass Nutzer erkennen, dass Sie sie weiterverwenden dürfen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Im Rahmen welcher Lizenz können Nutzer die Inhalte weiterverwenden?',
      :discussion_topic => :de_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Die Inhalte sind im Rahmen der folgenden Lizenz verfügbar',
      :help_text => 'Beachten Sie, dass jeder, der mittels interlektueller Tätigkeit schöpferisch Inhalte einer Datensammlung  erzeugt , automatiscjh Urheberrechte daran erwirbt. Reinen Fakten fehlt jedoch die notwendige Schopfungs. Daher benötigen die Nutzer eine Verzichtserklärung oder eine Lizenz , die belegt, dass Sie die Daten weiterverwenden können, und wie  sie dies rechtmäßig tun könnendddddddddddddddd. Wir führen hier die gebräuchlichsten Lizenzen auf. Wenn es keine (Datenbank-)Urheberrechte gibt, sie ausgelaufen sind, oder Sie darauf verzichten, wählen Sie bitte  "nicht anwendbar".',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Creative Commons Namensnennung',
      :text_as_statement => 'Creative Commons Namensnennung'
    a_cc_by_sa 'Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen',
      :text_as_statement => 'Creative Commons Namensnennung - Weitergabe unter gleichen Bedingungen'
    a_cc_zero 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_na 'Nicht anwendbar',
      :text_as_statement => ''
    a_other 'Andere…',
      :text_as_statement => ''

    q_contentNotApplicable 'Warum ist keine Lizenz auf den Inhalt der Daten anwendbar?',
      :discussion_topic => :de_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Dien Inhalte der Daten sind nicht lizensiert, denn',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'Für die Inhalte dieser Daten existiert kein Urheberrecht',
      :text_as_statement => 'es existieren keine Urheberrechte',
      :help_text => 'Urheberrecht ist auf Inhalte nur anwendbar, wenn diese von der individuellen intellektuellen Leistung des Schöpfers geprägt sind, wie z.B. bei verfassten Texten innerhalb der Daten. Es gibt keinen Urheberrechtsschutz, wenn der Inhalt lediglich Fakten enthält.'
    a_expired 'der Urheberrechtschutz ist ausgelaufen',
      :text_as_statement => 'die Urheberrechte sind abgelaufen',
      :help_text => 'Urheberrechte gelten für eine festgelegte Zeitspanne, ausgehend von der Anzahl von Jahren, die seit der Publikation der Daten oder dem Tod ihres des Erstellers vergangen sind.  Sie sollten prüfen, wann der Inhalt geschaffen oder veröffentlicht wurde, denn wenn dies lange her, könnte der Urheberrechtsschutz ausgelaufen sein.'
    a_waived 'auf die Urheberrechte wurde verzichtet',
      :text_as_statement => '',
      :help_text => 'Dies bedeutet, dass niemand Urheberrechte hat und jeder mit den Daten tun kann, was ihm beliebt.'

    q_contentWaiver 'Welche Verzichtserklärung nutzen Sie, um auf die Nutzungs- und Verwertungsrechte zu verzichten.',
      :discussion_topic => :de_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Auf die Urheberrechte wurde verzichtet durch',
      :help_text => 'Sie benötigen eine Erklärung, um den Nutzern zu zeigen, dass Sie den Verzicht erklärt haben, damit diese verstehen, dass sie mit den Daten tun können, was sie wollen. Es gibt bereits standardisierte Verzichtserklärungen wie CCZero, aber Sie können auch Ihren eigenen Rechtstext schreiben.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons CCZero',
      :text_as_statement => 'Creative Commons CCZero'
    a_other 'Andere…',
      :text_as_statement => 'Andere…'

    q_contentOtherWaiver 'Wo findet sich die Verzichtserklärung für die Urheberrechte?',
      :discussion_topic => :de_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Die Verzichtserklärung für die Urheberrechte findet sich unter',
      :help_text => 'Geben Sie die URL für die Ihe eigene öffentlich verfügbare Verzichtserklärung an, so dass Nutzer prüfen könne, das Sie damit auf ihre Rechte verzichten.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'URL der Verzichtserklärung',
      :text,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL der Verzichtserklärung'

    q_otherContentLicenceName 'Was lautet der Name der Lizenz?',
      :discussion_topic => :de_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Die Inhalte können im Rahmen der folgenden Lizenz weiterverwendet werden',
      :help_text => 'Wenn Sie eine andere Lizenz nutzen, benötigen wir deren Namen, so dass er Nutzern auf dem Open Data Zertifikat angezeigt werden kann.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Name der sonstigen Lizenz',
      :string,
      :required => :required,
      :placeholder => 'Name der sonstigen Lizenz'

    q_otherContentLicenceURL 'Wo findet sich die Lizenz?',
      :discussion_topic => :de_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Die Lizenz für die Inhalte findet sich unter',
      :help_text => 'Geben Sie eine URL für die Lizenz an, damit die Nutzer diese auf dem Open Data Zertifikat finden und ihre öffentliche Verfügbarkeit prüfen können.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'URL der sonstigen Lizenz',
      :text,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL der sonstigen Lizenz'

    q_otherContentLicenceOpen 'Ist die Lizenz eine offene Lizenz?',
      :discussion_topic => :de_otherContentLicenceOpen,
      :help_text => 'Wenn sie nicht sicher sind, was eine offene Lizenz ist, dann lesen Sie <a href="http://opendefinition.org/">die Open Knowledge Definition.</a> Als nächstes wählen Sie ihre Lizenz aus <a href="http://licenses.opendefinition.org/">der Liste offener Lizenzen der Open Definition Advisory Boards</a>. Wenn eine Lizenz auf dieser Liste fehlt, wurde sie noch nicht geprüft.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['basic_8']

    label_basic_8 'Sie müssen <strong>offene Daten als offene Daten (Open Data) publizieren</strong>, so dass die Nutzer sie weiterverwenden dürfen.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Wo sind die Rechte und die Lizenzvergabe der Inhalte ihrer Daten erklärt?',
      :discussion_topic => :de_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'Die Rechte und die Lizenzvergabe sind erklärt unter',
      :help_text => 'Geben Sie die URL einer Seite an, auf der beschrieben ist, wie jemand sich über die Rechte und die Lizenzvergabe für die Inhalte der Daten informieren kann?',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'URL der Erläuterung der Rechte an den Inhalten',
      :text,
      :input_type => :url,
      :required => :required,
      :placeholder => 'URL der Erläuterung der Rechte an den Inhalten'

    q_copyrightStatementMetadata 'Enhalten Ihre Nutzungsbedingungen eine maschinenlesbare Version',
      :discussion_topic => :de_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Die Nutzungsbestimmungen enhält Daten zu',
      :help_text => 'Es ist bewährte Praxis, Informationen zu den Urheber- und Nutzungsrechten maschinenlesbar einzubetten, so dass Nutzer die Daten automatisch zu Ihnen in Bezug setzen können, wenn Sie diese nutzen.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'Datenlizenz',
      :text_as_statement => 'der Datenlizenz',
      :requirement => ['standard_4']
    a_contentLicense 'Inhaltslizenz',
      :text_as_statement => 'der Lizenz für die Inhalte',
      :requirement => ['standard_5']
    a_attribution 'Form der Namensnennung',
      :text_as_statement => 'den Text für die obligatorische Namensnennung des Rechteinhabers',
      :requirement => ['standard_6']
    a_attributionURL 'URL für Namensnennung',
      :text_as_statement => 'den Verweis für die obligatorische Namensnennung des Urhebers',
      :requirement => ['standard_7']
    a_copyrightNotice 'Urheberrechts-Hinweis (copyright notice)',
      :text_as_statement => 'den Urheberrechtshinweis (copyright notice)',
      :requirement => ['exemplar_1']
    a_copyrightYear 'Copyright Jahr',
      :text_as_statement => 'das Urheberrechtsjahr',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'Rechteinhaber',
      :text_as_statement => 'den Inhaber der Urheberrechte',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'Datenbankherstellerrechtsjahr',
      :text_as_statement => 'das Datenbankherstellerjahr',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'Inhaber des Datenbankherstellerrechts',
      :text_as_statement => 'den Inhaber des Datenbankherstellerrechts',
      :requirement => ['exemplar_5']

    label_standard_4 'Sie sollten in Ihren Nutzungsbedingungen <strong>die Lizenzinformationen für die Daten maschinenlesbar bereitstellen</strong>, so dass diese automatisiert ausgelesen werden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Sie sollten in ihren Nutzungsbedingungen <strong>die Lizenzinformationen für die Inhalte ihrer Daten maschinenlesbar bereitstellen</strong>, so dass diese automatisiert ausgelesen werden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Sie sollten in Ihren Nutzungsbedingungen <strong>den bei der obligatorischen Namensnennung zu nutzenden Text maschinenlesbar bereitstellen</strong>, so dass dieser automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Sie sollten in Ihren Nutzungsbedingungen <strong>die bei der obligatorischen Namensnennung zu nutzende URL maschinenlesbar bereitstellen</strong>, so dass dieser automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Sie sollten in Ihren Nutzungsbedingungen <strong>den Urheberrechtshinweis maschinenlesbar bereitstellen</strong>, so dass er automatisiert ausgelesen werden kann. ',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Sie sollten in Ihren Nutzungsbedingungen <strong>die Jahreszahl des Urheberrechts maschinenlesbar bereitstellen</strong>, so dass sie automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Sie sollten in Ihren Nutzungsbedingungen <strong>den Rechteinhaber maschinenlesbar bereitstellen</strong>, so dass er automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'Sie sollten in Ihren Nutzungsbedingungen <strong>das Jahr des Datenbankherstellerrechts maschinenlesbar bereitstellen,</strong> so dass es automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'Sie sollten in Ihren Nutzungsbedingungen <strong>den Inhaber des Datenbankherstellerrechts maschinenlesbar bereitstellen,</strong> so dass er automatisiert ausgelesen werden kann.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Datenschutz',
      :help_text => 'Wie sie personenbezogene Daten schützen',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Können die Daten auf Personen bezogen werden?',
      :discussion_topic => :de_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten enthalten',
      :pick => :one,
      :required => :pilot
    a_not_personal 'Nein, die Daten beziehen sich nicht auf Personen oder ihre Handlungen',
      :text_as_statement => 'keine personenbezogenen Daten',
      :help_text => 'Beachten Sie, dass Personen auch dann anhand von Daten identifiziert werden können, wenn diese sich nicht direkt auf sie beziehen. So könnten Verkehrsflussdaten etwas über eine Person aussagen, wenn man Sie mit dem individuellen Muster des Pendlerverhaltens dieser Person kombiniert.'
    a_summarised 'Nein, die Daten wurden anonymisiert, indem Individualdaten zu Gruppen aggregiert wurden, so dass nicht nicht zwischen den Personen innerhalb der Gruppe unterschieden werden kann.',
      :text_as_statement => 'aggregierte Daten über Personen',
      :help_text => 'Statistische Offenlegungskotrollen können dabei helfen, sicherzustellen, dass konkrete Personen in aggregierten Daten nicht identifiziert werden können.'
    a_individual 'Ja, es besteht das Risiko, dass Personen von Dritten mit Zugang zu weiteren Informationen identifiziert werden können.',
      :text_as_statement => 'Informationen, die konkreten Personen zugeordnet werden könnten',
      :help_text => 'Manche personenbezogenen Daten dürfen veröffentlicht werden. Beispiele sind dienstliche Kontaktdaten von Personen, die aufgrund ihrer Funktion öffentliche Stellen nach außen repräsentieren oder die Nebeneinkünfte von Bundestagsabgeordneten.'

    q_statisticalAnonAudited 'Wurde der Prozess der Anonymisierung unabhängig auditiert?',
      :discussion_topic => :de_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Der Anonymisierungsprozess wurde',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'unabhängig auditiert',
      :requirement => ['standard_8']

    label_standard_8 'Sie sollten <strong>Ihren Anonymisierungs-Prozess unabhängig auditieren lassen</strong>, um sicherzustellen, dass er das Risiko der Reidentifizierung von Personen reduziert.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Haben Sie die Möglichkeit, konkete Personen zu identifizieren beseitigt oder reduziert?',
      :discussion_topic => :de_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'Diese personenbezgoenen Daten wurden',
      :help_text => 'Anonymisierung reduziert das Risiko, dass durch die von Ihnen veröffentlichten Daten personen identifiziert werden können. Die beste Technik hängt von der Art der vorhandenen Daten ab.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'anonymisiert'

    q_lawfulDisclosure 'Besteht die gesetzliche Pflicht oder Erlaubnis, diese personenbezogenen Daten zu veröffentlichen?',
      :discussion_topic => :de_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Es ist gesetzlich vorgeschrieben oder erlaubt, dass diese Daten',
      :help_text => 'Es kann gesetzlich vorgeschrieben sein, bestimmte personenbezogene Daten zu veröffentlichen, z. B. die Namen von Geschäftsführeren mancher Unternehmen. Oder Sie verfügen über die Erlaubnis der betroffenen Personen, diese Informationen über sie zu veröffentlichen.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'veröffentlicht werden können',
      :requirement => ['pilot_5']

    label_pilot_5 'Sie sollten<strong>personenbezogene Daten ohne Anonymisierung nur veröffentlichen, wenn dies gesetzlich vorgeschrieben oder erlaubt ist</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_5'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_false

    q_lawfulDisclosureURL 'Wo dokumentieren Sie Ihr Recht, personenbezogene Daten zu veröffentlichen?',
      :discussion_topic => :de_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'Die gesetziche Ermächtigung zur Veröffentlichung der Daten ist veröffentlicht unter'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'URL der Ermächtigung zur Veröffentlichtung',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Ermächtigung zur Veröffentlichtung',
      :requirement => ['standard_9']

    label_standard_9 'Sie sollten <strong>die Rechtsgrundlage der Veröffentlichung personenbezogener Daten dokumentieren.</strong>sowohl für die Nutzer Ihrer Daten als auch für die davon betroffenen Personen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Haben Sie die Risiken der Veröffentlichung personenbezogener Daten abgeschätzt?',
      :discussion_topic => :de_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'Der Herausgeber hat',
      :help_text => 'Eine Risikobewertung beurteilt die in den Daten, ihrer Benutzung und Offenlegung enthaltenen  datenschutzrechtlichen Risiken.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'Nein',
      :text_as_statement => 'keine Risikoabschätzung hinsichtlich des Datenschutzes durchgeführt'
    a_true 'Ja',
      :text_as_statement => 'eine Risikoabschätzung hinsichtlich des Datenschutzes durchgeführt',
      :requirement => ['pilot_6']

    label_pilot_6 'Sie sollten <strong>die Risiken der Veröffentlichung personenbezogener Daten abschätzen</strong>, wenn Sie die Daten einzelner Personen veröffentlichen.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Wo ist Ihre Risikobewertung publiziert?',
      :discussion_topic => :de_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Risikoabschätzung findet sich unter',
      :help_text => 'Geben Sie die URL der Seite an, auf der die Nutzer kontrollieren können, wie Sie die Datenschutzrisiken beurteilt haben. Dies kann in überarbeiteter oder summarischer Form geschehen, wenn die Abschätzung sensible Information enthält.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'URL der Risikoabschätzung',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Risikoabschätzung',
      :requirement => ['standard_10']

    label_standard_10 'Sie sollten <strong>Ihre Risikobewertung veröffentlichen,</strong> so dass die Nutzer Ihrer Daten verstehen können, wie Sie die Risiken der Offenlegung der Daten abgeschätzt haben.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Wurde Ihre Risikoabschätzung unabhängig auditiert?',
      :discussion_topic => :de_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Die Risikoabschätzung wurde',
      :help_text => 'Es ist bewährte Praxis, überprüfen zu lassen, ob Ihre Risikoabschäzung korrekt durchgeführt wurde. Unabhängige Audits durch Spezialisten oder Dritte sind häufig gründlicher und unvoreingenommener.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'unabhängig auditiert',
      :requirement => ['standard_11']

    label_standard_11 'Sie sollten <strong>Ihre Risikoabschätzung unabhängig auditieren lassen</strong>, um sicherzustellen, das sie korrekt durchgeführt wurde. ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Wo befindet sich der die Datenschutzerklärung für die von Ihren Daten betroffenen Personen?',
      :discussion_topic => :de_individualConsentURL,
      :display_on_certificate => true,
      :text_as_statement => 'von den Daten Betroffene wurden mittels der folgenden Erklärung zum Datenschutz unterrichtet',
      :help_text => 'Wenn Sie Daten über einzelne, konkrete Personen sammeln, müssen Sie ihnen mitteilen, wie die Daten verwandt werden. Nutzer, die Ihre Daten verwenden, benötigen diese Angaben, um sicherzustellen, dass sie den datenschutzrechtlichen Vorschriften nachkommen.'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    a_1 'URL der Erklärung zum Datenschutz',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Erklärung zum Datenschutz',
      :requirement => ['pilot_7']

    label_pilot_7 'Sie sollten <strong>den Nutzern mitteilen, zu welchen Nutzungszwecken die von Ihren Daten betroffenen Personen ihr Einverständnis gegeben haben</strong>, damit sie die Daten für den selben Zweck nutzen, die datenschutzrechtlichen Vorschriften einhalten. ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    condition_F :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Gibt es in Ihrer Organisation jemanden, der für den Datenschutz zuständig ist?',
      :discussion_topic => :de_dpStaff,
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'Nein'
    a_true 'Ja'

    q_dbStaffConsulted 'Haben Sie die Zuständigen in die Risikobewertung einbezogen?',
      :discussion_topic => :de_dbStaffConsulted,
      :display_on_certificate => true,
      :text_as_statement => 'Datenschutzbeauftragter',
      :pick => :one
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'wurde einbezogen',
      :requirement => ['pilot_8']

    label_pilot_8 'Sie sollten <strong>die für den Datenschutz in Ihrer Organisation Zuständigen einbeziehen</strong>, bevor Sie diese Daten veröffentlichen.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Wurde ihre Methode der Anonymisierung unabhängig auditiert?',
      :discussion_topic => :de_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Die Anonymisierung der Daten wurde',
      :help_text => 'Es ist bewährte Praxis, sicherzustellen, dass Ihr Methode, den personenbezug ihrer Daten zu eliminieren, zuverlässig funktioniert. Unabhängige Audits durch Spezialisten oder Dritte sind häufig gründlicher und unvoreingenommener.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'unabhängig auditiert',
      :requirement => ['standard_12']

    label_standard_12 'Sie sollten <strong>Ihre Anonymisierungsverfahren unabhängig durch einen Experten auditieren lassen.</strong>, um sicherzustellen, dass er für Ihre Daten geeignet ist .',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_12'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_anonymisationAudited, '==', :a_false

  end

  section_practical 'Practical Information',
    :description => 'Findability, accuracy, quality and guarantees' do

    label_group_6 'Auffindbarkeit',
      :help_text => 'wie Nutzer ihre Daten finden können',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Gibt es einen Link zu den Daten von Ihrem (Haupt) Webauftritt?',
      :discussion_topic => :onWebsite,
      :help_text => 'Daten können besser gefunden werden, wenn Sie sie in Ihrem (Haupt-)Webauftritt verlinken.',
      :pick => :one
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['standard_13']

    label_standard_13 'Sie sollten <strong>sicherstellen, dass Nutzer die Daten auf ihrem (Haupt-)Webauftritt finden können</strong>, so dass die Nutzer sie leichter finden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Web Page' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Welche Seite in Ihrem Webauftritt verlinkt die Daten?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'Die Website verlinkt die Daten auf der Seite…',
        :help_text => 'Geben Sie die URL einer Seite ihres Webauftritts an, die die Daten verlinkt.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'URL im Webauftritt',
        :text,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL im Webauftritt'

    end

    q_listed 'Sind die Daten Bestandteil einer Sammlung?',
      :discussion_topic => :listed,
      :help_text => 'Daten können besser gefunden werden, wenn Sie in relevanten Datenkatalogen (z. B. akademischen oder solchen der Verwaltung oder des Gesundheitswesens) aufgeführt sind bzw. dort in Suchergebnissen gelistet werden.',
      :pick => :one
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['standard_14']

    label_standard_14 'Sie sollten <strong>sicherstellen, dass Nutzer Ihre Daten finden, wenn sie danach in Datenlisten suchen</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listing' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Wo wird der Datensatz aufgeführt',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'Die Daten finden sich im Katalog…',
        :help_text => 'Geben Sie die URL des Katalogs (Bespiele sind GovData.de (wenn es sich um deutsche Verwaltungsdaten handelt) oder mds.datacite.org (für Forschungsdaten) oder die URL für Suchmaschinenergebnisse an.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'URL des Katalogs',
        :text,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL des Katalogs'

    end

    q_referenced 'Werden die Daten in ihren eigenen Publikationen genannt?',
      :discussion_topic => :referenced,
      :help_text => 'Wenn Sie ihre Daten in eigenen Publikationen wie Berichten, Präsenationen oder Blog-Beiträgen nennen, verschaffen Sie ihnen mehr Kontext und sie können leichter gefunden und verstanden werden.',
      :pick => :one
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['standard_15']

    label_standard_15 'Sie sollten <strong>Ihre Daten in eigenen Publikationen nennen</strong>, so dass Nutzer von ihrer Verfügbarkeit und ihrem Kontext erfahren.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Zitat' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Wo wird ihr Datensatz genannt?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Die Daten werden zitiert unter ',
        :help_text => 'Geben Sie die URL des Dokuments an, dass Ihren Datensatz referenziert.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'URL der verweisenden Seite',
        :text,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL der verweisenden Seite'

    end

    label_group_7 'Fehlerfreiheit',
      :help_text => 'wie halten Sie ihre Daten aktuell',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Ändern sich die Daten hinter ihrer API?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten hinter der API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'nein, die API ergmöglicht den Zugang zu unveränderlichen Daten',
      :text_as_statement => 'werden sich nicht ändern',
      :help_text => 'Manche APIs erleichtern den Zugang zu unveränderlichen (Massen-)Daten.>'
    a_changing 'ja, die API ermöglicht den Zugriff auf veränderliche Daten',
      :text_as_statement => 'werden sich ändern',
      :help_text => 'Manche APIs erlauben den Zugang zu aktuelleren und sich stets verändernden Daten'

    q_timeSensitive 'Werden die Daten veralten?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'Die Genauigkeit oder Bedeutsamkeit dieser Daten',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'Ja, die Daten werden veralten',
      :text_as_statement => 'wird veralten',
      :help_text => 'Ein Datensatz von Bushaltestellen wird mit der Zeit veralten, wenn die Haltestellen verlegt oder neue geschaffen werden.'
    a_timestamped 'ja, der Datensatz wird veralten, enthält aber Zeitstempel',
      :text_as_statement => 'wird veralten, enthält aber Zeitstempel',
      :help_text => 'Bevölkerungsstatistiken enthalten z. B. in der Regel einen Zeitstempel, an dem erkannbar ist, wann die Statistik zutraf.',
      :requirement => ['pilot_9']
    a_false 'Nein, die Daten enthalten keine zeitabhängigen Informationen.',
      :text_as_statement => 'veraltet nicht',
      :help_text => 'Die Ergebnisse eines Experiments veralten z.B. nicht, weil die Daten genau die beobachteten Ergebnisse wiedergben.',
      :requirement => ['standard_16']

    label_pilot_9 'Sie sollten <strong>Ihren Daten Zeitstempel hinzufügen, wenn Sie sie veröffentlichen</strong>, damit die Nutzer wiessen, auf welche Zeitspanne sie sich beziehen, und wann sie ungültig werden.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 ' Sie sollten <strong>Updates für zeitabhängige Daten veröffenlichten</strong>, damit sie nicht veralten.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Ändern sich Ihre Daten mindestens täglich?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Diese Daten ändern sich',
      :help_text => 'Teilen Sie den Nutzern mit, wenn sich die zugrundeliegenden Daten an den meisten Tagen ändern. Wenn Daten sich häufig ändern, veralten sie auch schnell, so dass Nutzer wissen müssen, ob Sie die Änderungen häufig und rasch nachvollziehen.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'mindestens täglich'

    q_seriesType 'Um welchen Typ von Datenserie handelt es sich?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Diese Daten sind eine Serie von',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'normale Kopien einer kompletten Datenbank',
      :text_as_statement => 'Kopien einer Datenbank',
      :help_text => 'Auswählen, wenn Sie regelmäßig neue und und aktualisierte Kopien ihrer kompletten Datenbank veröffentlichen. Wenn Sie Datenbankabzüge erzeugen, ist es für vorteilhaft, wenn die Nutzer Zugang zu einem Feed der Änderungen haben, so dass Sie ihre Kopien aktuell halten können.'
    a_aggregate 'regelmäßige Zusammenstellungen geändeter Daten',
      :text_as_statement => 'Aggregate veränderlicher Daten',
      :help_text => 'Auswählen, wenn Sie regelmäßig neue Datensätze anlegen. Dies könnten sie tun, wenn die zugrundeliegenden Daten nicht als offene Daten veröffentlicht werden können, oder wenn Sie nur Daten veröffentlichen wollen, die seit der letzten Publikation neu hinzugekommen sind.'

    q_changeFeed 'Steht ein Feed der Änderungen zur Verfügung?',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'Ein Feed der Änderungen an diesen Daten',
      :help_text => 'Teilen Sie mit, ob Sie einen Feed der Änderungen zur Verfügung stellen, die diese Daten betreffen, z.B. neue Einträge oder Ergänzungen bestehender Einträge. Das Format des Feeds kann z.B. RSS oder Atom sein.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'steht zur Verfügung',
      :requirement => ['exemplar_6']

    label_exemplar_6 'Sie sollten <strong>einen Feed der Änderungen bereitstellen</strong>, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Sie oft stellen Sie eine neu Version bereit?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Neue Versionen dieser Daten werden bereitgestellt',
      :help_text => 'Dies legt fest, wie sehr diese Daten veralten, befor die Nutzer ein Update erhalten.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'seltener als einmal im Monat',
      :text_as_statement => 'seltener als einmal im Monat'
    a_monthly 'wenigstens einmal im Monat',
      :text_as_statement => 'wenigstens einmal im Monat',
      :requirement => ['pilot_10']
    a_weekly 'wenigstens einmal in der Woche',
      :text_as_statement => 'wenigstens einmal in der Woche',
      :requirement => ['standard_17']
    a_daily 'wenigstens täglich',
      :text_as_statement => 'wenigstens täglich',
      :requirement => ['exemplar_7']

    label_pilot_10 'Sie sollten <strong>jeden Monat eine neue Version bereitstellen</strong>, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Sie sollten <strong>jede woche eine neue Version veröffentlichen</strong>, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 ' Sie sollten <strong>täglich eine Neue Version veröffentlichen</strong>, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Wie groß ist der Verzug zwischen der Anlage eines neuen Datensatzes und seiner Publikation?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'Der Verzug zwischen der Anlage eines neuen Datensatzes und seiner Publikation ist',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'Größer als der Abstand zwischen den Versionen',
      :text_as_statement => 'Größer als der Abstand zwischen den Versionen',
      :help_text => 'Auswählen, wenn  z.B. jeden Tag eine Version der Daten entsteht, es aber mehr als einen Tag dauert, bis Sie publiziert wird.'
    a_reasonable 'ungefähr so lang wie der Abstand zwischen den Versionen',
      :text_as_statement => 'ungefähr so lang wie der Abstand zwischen den Versionen',
      :help_text => 'Auswählen, wenn  z.B. jeden Tag eine neue Version der Daten entsteht, und die Publikation etwa einen Tag benötigt.',
      :requirement => ['pilot_11']
    a_good 'weniger als die Hälfte des Abstands der Versionen',
      :text_as_statement => 'weniger als die Hälfte des Abstands der Versionen',
      :help_text => 'Auswählen, wen Sie jeden Tag einen neuen Datensatz erzeugen, und weniger als 12 Stunden für die Publikation benötigen.',
      :requirement => ['standard_18']
    a_minimal 'geringfügiger oder kein Verzug',
      :text_as_statement => 'minimal',
      :help_text => 'Auswählen, wenn zwischen Anlage und Publikation der Daten wenige Sekunden oder Minuten vergehen.',
      :requirement => ['exemplar_8']

    label_pilot_11 'Sie sollten<strong>zwischen der Anlage und der Publikation der Daten nicht weniger Zeit vergehen lassen,</strong> als den zeitlichen Abstand zwischen zwei Versionen, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Sie sollten <strong>zwischen zwischen Anlage und Publikation der Daten nur eine kurze Zeit vergehen lassen</strong>, die weniger als die Hälfte des Abstands zwischen zwei Versionen beträgt, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'Sie sollten <strong>zwischen Anlage und Publikation der Daten nur einen geringfügigen oder gar keinen Verzug haben</strong>, damit Nutzer ihre Kopien aktuell und fehlerfrei halten können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Veröffentlichen Sie Abzuge dieses Datensatzes?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'Der Herausgeber veröffentlicht',
      :help_text => 'Ein Abzug ist ein Extrakt des gesamten Datenbestands, den die Nutzer als Datei herunterladen können. Dies erlaubt andere Analysen als ein API Zugang.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'Abzüge der Daten',
      :requirement => ['standard_19']

    label_standard_19 ' Sie sollten <strong>es ermöglichen, den gesamten Datenbestand herunterzuladen</strong>, so dass umfassendere und genauere Analysen möglich werden, als sie die API erlaubt.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'Wie häufig erzeugen Sie einen Abzug des Datenbestaands?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Datenbankabzüge werden erstellt',
      :help_text => 'Eine schnellerer Zugang zu häufgeren Abzügen des ganzen Datenbestandes führt dazu, dass die Nutzer mit den aktuellsten Daten arbeiten können.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'seltener als einmal im Monat',
      :text_as_statement => 'seltener als einmal im Monat'
    a_monthly 'mindestes jeden Monat',
      :text_as_statement => 'mindestes jeden Monat',
      :requirement => ['pilot_12']
    a_weekly 'höchstens eine Woche nach jeder Änderung',
      :text_as_statement => 'höchstens eine Woche nach jeder Änderung',
      :requirement => ['standard_20']
    a_daily 'innerhalb eines Tages nach jeder Änderung',
      :text_as_statement => 'innerhalb eines Tages nach jeder Änderung',
      :requirement => ['exemplar_9']

    label_pilot_12 'Sie sollten <strong>jeden Monat einen Datenbankabzug erzeugen</strong>, so dass die Nutzer über die neuesten Daten verfügen.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Sie sollten <strong>nach jeder Änderung innerhalb einer Woche einen Datenbankabzug erzeugen</strong>, so dass die Nutzer weniger lang auf die neuesten Daten warten müssen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'Sie sollten <strong>nach jeder Änderung innerhalb eines Tages einen Datenbankabzug erzeugen</strong>, so dass es den Nutzern leicht fällt, zu den neuesten Daten zu gelangen.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Werden Ihre Daten korrigiert, wenn sie Fehler haben?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Fehler in diesen Daten werden',
      :help_text => 'Es ist gute Praxis, Fehler in Ihren Daten zu beheben, besonders wenn Sie selbst damit arbeiten. Wenn Sie Korrekturen vornehmen, müssen die Nutzer davon erfahren.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'korrigiert',
      :requirement => ['standard_21']

    label_standard_21 'Sie sollten <strong>Daten korrigieren, wenn Nutzer Fehler melden</strong>, so dass alle von der Steigerung der Genauigkeit profitiert.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Qualität',
      :help_text => 'wie sehr sich Nutzer auf Ihre Daten verlassen können',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Wo dokumentieren sie Probleme mit der Qualität dieser Daten?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Datenqualität ist dokumentiert unter',
      :help_text => 'Geben Sie eine URL an, wo sich Nutzer über die Qualität Ihrer Daten informieren können. Nutzer aktzeptieren, dass Fehler aufgrund von Gerätestörungen oder Irrtümern bei Systemwechseln unvermeidlich sind. Sie offen über die Qualität der Daten informieren, so dass die Nutzer beurteilen können, wie sehr sich darauf verlassen können.'
    a_1 'URL der Dokumentation der Datenqualität',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Dokumentation der Datenqualität',
      :requirement => ['standard_22']

    label_standard_22 'Sie sollten <strong>alle bekanten Probleme mit der Qualität ihrer Daten dokumentieren</strong>, so dass die Nutzer entscheiden können, wie sehr sie Ihren Daten trauen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Wo findet sich Ihr Qualitätssicherungsprozess beschrieben?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Qualitätsicherheitsprozesse werden beschrieben unter',
      :help_text => 'Geben Sie eine URL an, wo Nutzer sich über laufende automatische oder manuelle Kontrollen ihrer Daten unterrichten können. Dies  gibt ihnen die Sicherheit, dass Sie die Qualität ernst nehmen und fördert Verbesserungen, die allen nützen.'
    a_1 'URL der Beschreibung der Qualitätssicherungsprozesse',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Beschreibung der Qualitätssicherungsprozesse',
      :requirement => ['exemplar_10']

    label_exemplar_10 'Sie sollten <strong>Ihren Qualitätssicherungsprozess dokumentieren</strong>, so dass die Nutzer entscheiden können, wie sehr sie Ihren Daten trauen.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Garantien',
      :help_text => 'wie sehr sich Nutzer auf die Verfügbarkeit Ihrer Daten verlassen können',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Sichern Sie ihre Daten an einem anderen Ort (offsite)?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten werden',
      :help_text => 'Die regelmäßige Sicherung der Daten an einem externen Ort vermeidet ihren Verlust im Falle eines Unfalls.',
      :pick => :one
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'örtich getrennt gesichert',
      :requirement => ['standard_23']

    label_standard_23 ' Sie sollten <strong>Ihre Ergebnisse extern sichern,</strong> damit Sie die Daten nicht verloren gehen, wenn ein Unfall geschieht.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Wo beschreiben Sie etwaige Garantien hinsichtlich der Diensteverfügbarkeit?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Verfüfbarkeit der Dienste wird beschrieben unter',
      :help_text => 'Geben Sie eine URL an, die beschreibt, welche Verfügbarkeit Ihres Dienstes Sie Nutzern garantieren. Sie können zum Beispiel eine Verfügbarkeit von 99.5% garantieren, oder explizit keine Verfügbarkeit zusichern.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL der Dokumentation der Diensteverfügbarkeit',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Dokumentation der Diensteverfügbarkeit',
      :requirement => ['standard_24']

    label_standard_24 'Sie sollten <strong>beschreiben, welche Garantien hinsichtlich der Verfügbarkeit Ihres Dienstes Sie übernehmen.</strong>, so dass die Nutzer wissen, wie sehr sie sich auf Ihre Daten verlassen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Wo informieren Sie über den aktuellen Status Ihres Dienstes?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Der Status des Dienstes ist verfügbar unter',
      :help_text => 'Geben Sie eine URL an, die Nutzer darüber unterrichtet, wie der aktuelle Status ihres Dienstes ist einschließlich Ihnen bekannter Störungen.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL des Status des Dienstes',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Status des Dienstes',
      :requirement => ['exemplar_11']

    label_exemplar_11 'Sie sollten <strong>eine Status Seite für Ihren Dienst anbieten</strong>, die den Nutzern den aktuellen Status Ihres Dienstes mitteilt.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Wie lang werden diese Daten erreichbar sein?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten sind erreichbar',
      :pick => :one
    a_experimental 'Sie können jederzeit verschwinden',
      :text_as_statement => 'versuchsweise verfügbar und können jederzeit verschwinden'
    a_pilot 'Sie sind versuchsweise verfügbar und dies für etwa ein weiteres Jahr',
      :text_as_statement => 'versuchsweise verfügbar und können jederzeit vwerschwinden',
      :requirement => ['pilot_13']
    a_medium 'Sie gehören zu Ihren mittelfristigen Plänen und sind daher für einige Jahre verfügbar',
      :text_as_statement => 'mindestens für einige Jahr',
      :requirement => ['standard_25']
    a_long 'Sie gehören zu Ihrem Alltagsgeschäft und werden lanfristig erhältlich bleiben.',
      :text_as_statement => 'für lange Zeit',
      :requirement => ['exemplar_12']

    label_pilot_13 'Sie sollten <strong>garantieren, dass Ihre Daten für etwa ein Jahr in dieser Form verfügbar sein werden</strong>, so dass die Nutzer entscheiden können, wie sehr sie sich auf Ihre Daten verlassen',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_pilot
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Sie sollten <strong>zusichern, dass Ihre Daten in dieser Form mittelfristig verfügbar bleiben werden</strong>, so dass die Nutzer entscheiden können, wie sehr sie Ihren Daten trauen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 'Sie sollten <strong>garantieren, dass Ihre Daten in dieser Form langfristig verfügbar bleiben</strong>, so dass die Nutzer entscheiden können, wie sehr sie Ihren Daten trauen.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Technische Information',
    :description => 'Speicherorte, Formate und Vertrauenswürdigkeit' do

    label_group_11 'Locations',
      :help_text => 'Wie Nutzer Zugang zu Ihren Daten erhalten',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Wo befindet sich Ihr Datensatz',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten werden veröffentlicht unter',
      :help_text => 'Geben Sie eine URL zum Datensatz selbst an. Offene Daten sollten im Netz direkt verlinkt sein, so dass Nutzer sie leicht finden und weiterverwenden können.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'URL des Datensatzes',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Datensatzes',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'Sie müssen <strong>eine URL entweder zu Ihren Daten oder zur Dokumentation angeben</strong>, so dass die Nutzer sie finden können.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'Sie sollten <strong> eine URL angeben, die den Datensatz direkt verlinkt</strong>, so dass Nutzer ihn leicht erreichen können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Wie veröffentlichen Sie eine Serie des selben Datensatzes',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'Unter der selben URL, die auf die regelmäßig aktualisierten Daten verlinkt',
      :help_text => 'Auswählen, wenn es eine einzige URL gibt, unter der die Nutzer die aktuellste Version des Datensatzes erreichen.',
      :requirement => ['standard_26']
    a_template 'als konsistente URLs für jede Version',
      :help_text => 'Auswählen, wenn Ihre Datensatz-URLs einem regemäßigen Muster folgen, das das Datum der Veröffentlichung enthält, z. B. eine URL die mit \'2013-04\' beginnt. Dies erleichtert es Nutzern zu verstehen, wie oft Sie Daten bereitstellen und Skripte zu schreiben, die neue Datensätze  nach ihrer Veröffentlichung abrufen.>',
      :requirement => ['pilot_15']
    a_list 'eine Liste der Veröffentlichungen',
      :help_text => 'Auswählen, wenn Sie auf einer Webseite oder in einem Feed (wie Atom oder RSS) eine Liste einzelnen Versionen mit Links zu den zugehörigen Details bereitstellen. Dies erleichtert es Nutzern zu verstehen, wie oft Sie Daten bereitstellen und Skripte zu schreiben, die neue Datensätze  nach ihrer Veröffentlichung abrufen.',
      :requirement => ['standard_27']

    label_standard_26 'Sie sollten <strong>die jeweils aktuellste Version der Daten unter einer einzigen persistenten URL zum herunterladen anbieten</strong>, so dass Nutzer ihn leicht erreichen können. ',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Sie sollten <strong>eine konsistentes Muster für die einzelnen URLs der Versionen benutzen</strong>, so dass die Nutzer jede einzelne automatisch herunterladen können. ',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 ' Sie sollten <strong>Ein Dokument oder einen Feed mit den verfügbaren Versionen bereitstellen</strong>, so dass Nutzer Skripte schreiben können, um alle herunterzuladen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Sie müssen <strong>mittels einer URL Zugang zu den Daten bereitstellen</strong>, entweder zur aktuellen Version oder  durch eine entdeckbare Serie von URLs oder durch eine Dokumentations-Seite, damit Nutzer die Daten finden können.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Wo ist Ihr aktueller Datensatz zu finden',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Der aktuelle Datensatz findet sich unter',
      :help_text => 'Geben Sie eine einzige URL zur aktuellsten Version des Datensatzes an. Der unter dieser URL zu findende Inhalt sollte sich ändern, sobald eine neue Version veröffentlicht wird.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'URL des aktuellen Datensatzes',
      :text,
      :input_type => :url,
      :placeholder => 'URL des aktuellen Datensatzes',
      :required => :required

    q_versionsTemplateUrl 'Welches Format besitzen die URLs der Datensatz-Versionen?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die URLs der Versionen folgen diesem Muster',
      :help_text => 'Hierbei handelt es sich um die Struktur der URLS, unter denen Sie unterschiedliche Versionen veröffentlichen. Benutzen Sie `{variable}` um die veränderlichen Teile des Musters der URL zu bezeichnen, z. B. `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'URL-Template der Versionen',
      :string,
      :input_type => :text,
      :placeholder => 'URL-Template der Versionen',
      :required => :required

    q_versionsUrl 'Wo ist die Liste der Datensatz-Versionen zu finden?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Liste der Versionen findet sich unter',
      :help_text => 'Geben Sie eine URL einer Seite oder eines Feeds mit einer maschinenlesbaren Liste der Datensätze an. Nutzen Sie die URL der ersten Seite, die auf den Rest der Seiten verweisen sollte.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'URL der Versionenliste',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Versionenliste',
      :required => :required

    q_endpointUrl 'Wo befindet sich der Endpoint Ihrer Anwendungsprogrammschnittstellen (API) ?',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Der Endpoint der API ist',
      :help_text => 'Geben Sie eine URL an, die einen Ausgangspunkt für Nutzerskripte zur Verwendung ihrer Daten darstellt. Dabei sollte es sich um eine Beschreibung des Dienstes handeln, die den Skripten bei der Ermittlung der vorhandenen Services hilft.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'URL des Endpoints',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Endpoints',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Sie müssen <strong>Entweder die URL des API Endpoints oder die URL seiner Dokumentation angeben</strong>, so dass die Nutzer sie finden können.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Sie sollten <strong>eine Beschreibung des Dienstes oder einen einzigen Eingangspunkt für die API bereitstellen</strong>, so dass sie für die Nutzer zugänglich ist.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Wie veröffentlichen Sie Datenbank-Abzüge?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'als einzelne URL, die regelmäßig aktualisiert wird',
      :help_text => 'Auswählen, wenn es für die Nutzer nur eine URL gibt, unter der Sie die aktuellste Version des letzten Datenbank-Abzugs herunterladen können.',
      :requirement => ['standard_29']
    a_template 'als eine konsistente URL für jede Version',
      :help_text => 'Auswählen, wenn Ihre URLs der Datenbank-Abzüge einem regemäßigen Muster folgen, das das Datum der Veröffentlichung enthält, z. B. eine URL die mit \'2013-04\' beginnt. Dies erleichtert es Nutzern zu verstehen, wie oft Sie Daten bereitstellen und Skripte zu schreiben, die neue Datensätze  nach ihrer Veröffentlichung abrufen.',
      :requirement => ['exemplar_13']
    a_list 'als Liste der Versionen',
      :help_text => 'Auswählen, wenn Sie auf einer Webseite oder in einem Feed (wie Atom oder RSS) eine Liste der Datenbank-Abzuüge mit Links zu den einzelnen Versionen und den zugehörigen Details bereitstellen. Dies erleichtert es Nutzern zu verstehen, wie oft Sie Daten bereitstellen und Skripte zu schreiben, die neue Datensätze  nach ihrer Veröffentlichung abrufen.',
      :requirement => ['exemplar_14']

    label_standard_29 'Sie sollten <strong>eine einzelne persistente URL bereitstellen für das Herunterladen des aktuellen Abzugs Ihrer Datenbank bereitstellen</strong>, so dass die Nutzer sie finden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 'Sie sollten <strong>ein konsistentes Muster für die URLs der Datenbank-Abzüge nutzen</strong>, so dass die Nutzer jeden einzelnen automatisch herunterladen können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 'Sie sollten <strong>ein Dokument oder einen Feed mit einer Liste der verfügbaren Datenbank-Abzüge bereitstellen</strong>, so dass Nutzer Skripte schreiben können, um alle heruterzuladen.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Wo ist der aktuelle Datenbank-Abzug zu finden?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Der aktuellste Datenbank-Abzug findet stets unter',
      :help_text => 'Geben Sie eine einzige URL zur aktuellsten Abzug Ihrer Datenbank. Der unter dieser URL zu findende Inhalt sollte sich ändern, sobald eine neuer Datenbank-Abzug veröffentlicht wird.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'URL des aktuellen Abzugs',
      :text,
      :input_type => :url,
      :placeholder => 'URL des aktuellen Abzugs',
      :required => :required

    q_dumpsTemplateUrl 'Welches Format besitzen die URLs der Datenbank-Abzüge?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Datenbank-Abzuge folgen dem regemäßigen Muster',
      :help_text => 'Hierbei handelt es sich um die Struktur der URLS, unter denen Sie unterschiedliche Versionen veröffentlichen. Benutzen Sie `{variable}` um die veränderlichen Teile des Musters der URL zu bezeichnen, z. B. `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'Vorlage für die URLs der Datenbankabzüge',
      :string,
      :input_type => :text,
      :placeholder => 'Vorlage für die URLs der Datenbankabzüge',
      :required => :required

    q_dumpsUrl 'Wo ist die Liste der verfügbaren Datenbank-Abzüge zu finden?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'A list of database dumps is at',
      :help_text => 'Geben Sie eine URL einer Seite oder eines Feeds mit einer maschinenlesbaren Liste der Datenbankabzüge an. Nutzen Sie die URL der ersten Seite, die auf den Rest der Seiten verweisen sollte.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'URL der Liste der Abzüge',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Liste der Abzüge',
      :required => :required

    q_changeFeedUrl 'Wo ist der Feed mit den Änderungen zu finden?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Ein Feed mit Änderungen an diesen Daten findet sich unter',
      :help_text => 'Geben Sie eine URL einer Seite oder eines Feeds mit einer maschinenlesbaren Liste der früheren Datenbank-Abzüge an. Nutzen Sie die URL der ersten Seite, die auf den Rest der Seiten verweisen sollte.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'URL des Feeds der Änderungen',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Feeds der Änderungen',
      :required => :required

    label_group_12 'Formate',
      :help_text => 'wie Nutzer mit Ihren Daten arbeiten können',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Sind diese Daten maschinenlesbar?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten sind',
      :help_text => 'Nutzer bevorzugen Datenformate, die sich leicht (vor allem schneller und fehlerfreier) mit dem Computer verarbeiten lassen. So ist die Photokopie einer Tabellenkalkulation im Gegensatz zu einer CSV-Datei nicht maschinenlesbar.',
      :pick => :one
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'maschinenlesbar',
      :requirement => ['pilot_16']

    label_pilot_16 'Sie sollten <strong>Ihre Daten in einem maschinenlesbaren Format zur Verfügung stellen</strong>, so dass sie leicht zu verarbeiten sind.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Liegen die Daten in einem standardisierten offen Format vor?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'Das Format der Daten ist',
      :help_text => 'Offene Formate werden durch einen fairen, transparenten und kollaborativen Prozess geschaffen. Jeder kann sie umsetzen und es gibt umfangreiche Unterstützung, so dass es für Sie leichter ist, Daten mehr Nutzern zur Verfügung zu stellen. Beispiele für offene Standards sind XML, CSV und JSON.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'ein standardisiertes offenes Format',
      :requirement => ['standard_30']

    label_standard_30 'Sie sollten <strong>Ihre Daten in einem standardisierten offenen Format bereitstellen</strong>, so dass Nutzer sie leichter verarbeiten können, indem sie weit verbreitete Werkzeuge verwenden.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Welcher Art Daten stellen sie bereit',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'menschen lesbare Dokumente',
      :help_text => 'Auswählen, wenn die Daten für die Lektüre durch Menschen gedacht ist. Dazu zählen z.B. Positionspapiere, Berichte und Besprechungsprotokolle. Sie besitzen meist eine gewisse Struktur, bestehen aber vor allem aus Text.'
    a_statistical 'statistische Daten wie Zählungen, Durchschnitte und Prozentanteile',
      :help_text => 'Auswählen wenn die Daten numerische oder statistische Daten wie Zählungen, Durchschnitte oder Prozentanteile darstellen. Beispiele sind Volkszählungsergebnisse, Verkehrszählungen oder Kriminalstatistiken.'
    a_geographic 'geographische informationen wie Punkte und Grenzen',
      :help_text => 'Auswählen, wenn Ihre Daten auf Karten als Punkte, Grenzen oder Linien abgebildet werden könnte.'
    a_structured 'andere Arten strukturierter Daten',
      :help_text => 'Auswählen, wenn Ihre Daten in anderer Weise strukuriert sind. Veranstaltungsinformationen, Eisenbahnfahrpläne, Kontaktdaten oder alles was as Daten interpretiert, analysiert und in viefältiger Weise präsentiert werden kann.'

    q_documentFormat 'Enthalten ihre menschenlesbaren Dokumente Formate, die',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Dokumente werden veröffentlich',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'semantische Strukturen beschreiben (z. B. HTML, Docbook oder Markdown)',
      :text_as_statement => 'in einem semantischen Format',
      :help_text => 'Diese Formate kennzeichnen Strukturen wie Kapitel, Überschriften oder Tabellen, die es erleichtern, automatisch Zusammenfassungen wie Inhaltsverzeichnisse oder Glossare zu erstellen. Sie machen es leicht, auf die Dokumente unterschiedliche Stiele anzuwenden, die deren Aussehen verändern.',
      :requirement => ['standard_31']
    a_format 'Formatierungshinweise geben, wie OOXML oder PDF',
      :text_as_statement => 'in einem Darstellungsformat',
      :help_text => 'Diese Formate betonen das Erscheinungsbild durch Schriftarten, Farben oder die Positionierung der unterschiedlichen Element auf der Seite. Dies ist gut für die Lektüre durch Menschen, erschweren es aber den Nutzern die Daten automatisch zu verarbeiten oder den Stil zu verändern.',
      :requirement => ['pilot_17']
    a_unsuitable 'nicht für Dokumente bestimmt sind, wie Excel, JSON oder CSV',
      :text_as_statement => 'in einem für Dokumente ungeeigneten Format',
      :help_text => 'Diese Formate sind für tabellierte oder strukturierte Daten besser geeignet.'

    label_standard_31 'Sie sollten <strong>Dokumente veröffentlichen, die semantische Strukturen freilegen</strong>, so dass Nutzer sie in verschiedenen Stilen anzeigen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 ' Sie sollten <strong>Dokumente in einem Format veröffentlichen, dass speziell für diese entworfen wurde</strong>, so dass sie leicht zur verarbeiten sind.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Enthalten Ihre statistischen Daten Formate, die',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Statistische Daten werden veröffentlicht',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'die Strukturen statistscher Hypercube Daten freilegen wie <a href="http://sdmx.org/">SDMX</a> oder <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a>',
      :text_as_statement => 'in einem statistischen Datenformat',
      :help_text => 'Individuelle Beobachtungen in Hypercubes beziehen sich auf ein bestimmtes Maß und einen Satz von Diemensionen beziehen. Jede Beobachtung kann auch auf Annotationen bezogen sein, die ihnen Kontext geben. Formate wie <a href="http://sdmx.org/">SDMX</a> und <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> wurden entworfen, um diese zugrundeliegende Struktur auszudrücken.',
      :requirement => ['exemplar_15']
    a_tabular 'statistische Daten wie CSV als Tabelle behandeln',
      :text_as_statement => 'in einem Tabellenformat',
      :help_text => 'Diese Formate ordnen statische Daten in eine Tablle aus Reihen und Spalten ein. Dadurch geht der Kontext des zugrundelegenden Hypercubes verloren, die Daten sind jedoch leicht zu verarbeiten.',
      :requirement => ['standard_32']
    a_format 'sich wie Excel auf das Format tabellarischer Daten fokussieren',
      :text_as_statement => 'in einem Präsentationsformat',
      :help_text => 'Tabellenkalkulationen benutzen Formatierungen wie kursiven oder fetten Text und Einzüge in den Feldern um die zugrundeliegende Struktur zu beschreiben. Diese Gestaltung hilft Menschen beim Verständnis Ihrer Daten, macht die Daten aber für die Verarbeitung durch Computer weniger geeignet.',
      :requirement => ['pilot_18']
    a_unsuitable 'nicht für statistische oder tabellarische Daten bestimmt sind, wei Word oder PDF',
      :text_as_statement => 'in einem für statistische Daten ungeeigneten Format',
      :help_text => 'These formats don\'t suit statistical data because they obscure the underlying structure of the data.'

    label_exemplar_15 ' Sie sollten <strong>statistische Daten in Formaten veröffentlichen die Dimensionen und Maße freilegen</strong>, so dass sie leicht zu analysieren sind.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Sie sollten <strong>tabellarische Daten in Formaten veröffentlichen, die die Datentabellen freilegen</strong>, so dass sie liecht zu analysieren sind.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'Sie sollten <strong>tabellarische Daten in einem Format veröffentlichen, das für diesen Zweck geschaffen wurde</strong>, so dass sie leicht zu verarbeiten sind.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Enthalten Ihre geographischen Daten Formate, die',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Geograpische Daten werden veröffentlicht',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'für geographische Daten entworfen wurden wie <a href="http://www.opengeospatial.org/standards/kml/">KML</a> oder <a href="http://www.geojson.org/">GeoJSON</a>',
      :text_as_statement => 'in einem Geodatenformat',
      :help_text => 'Diese Formate beschreiben Punkte, Linien und Grenzen, und legen Strukturen in den Daten frei, wodurch  sie leichter automatisch zu verarbeiten sind.',
      :requirement => ['exemplar_16']
    a_generic 'Daten strukturiert halten, wie JSON, XML oder CSV',
      :text_as_statement => 'in a generischen Datenformat',
      :help_text => 'Jedes Format dass normale strukturierte Daten enthält kann auch geographische Daten ausdrücken, insbesondere wenn es Daten zu Punkten enthält.',
      :requirement => ['pilot_19']
    a_unsuitable 'nicht für geographische Daten entworfen wurden wie Word oder PDF',
      :text_as_statement => 'in einem für geographische Daten ungeeigneten Format',
      :help_text => 'Diese Formate passen nicht zu geographischen Daten, weil sie die zugrunde liegende Struktur der Daten verschleiern.'

    label_exemplar_16 'Sie sollten <strong>geographische Daten in Formaten veröffentlichen, die für diese Zweck geschaffen wurden.</strong>, so dass Nutzer weit verbreitete Werkzeuge zur Verarbeitung verwenden können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 ' Sie sollten <strong>geographische Daten als strukturierte Daten publizieren</strong>, so dass sie leicht zu verarbeiten sind.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Enthalten Ihre strukturierten Daten Formate, die',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Strukturierte Daten werden veröffentlicht',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'für strukturierte Daten entworfen wurden wie JSON, XML, Turtle oder CSV',
      :text_as_statement => 'in einem strukturierten Datenformat',
      :help_text => 'Diese Formate organisieren Daten grundsätzlich in einer Struktur von Dingen, die für eine bestimmte Gruppe von Eigenschaften bestimmte Ausprägungen (Werte) besitzen Diese Formate können von Computern leicht verarbeitet werden.',
      :requirement => ['pilot_20']
    a_unsuitable 'nicht für strukturierte Daten geschaffen wurden wie Word oder PDF',
      :text_as_statement => 'In einem für strukturierte Daten ungeeigneten Format',
      :help_text => 'Diese Formate sind für diese Art von Daten nicht geeignet weil Sie die zugrundeliegende Struktur verschleiern.'

    label_pilot_20 'Sie sollten <strong>strukturierte Daten in einem Format speichern, dass zu diesem Zweck geschaffen wurde</strong>, so dass sie leicht zu verarbeiten sind.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Nutzen Ihre Daten persistente Bezeichner?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten enthalten',
      :help_text => 'Daten beziehen sich in der Regel auf reale Dinge wie Schulen, Strßen oder sie benutzen ein Codierschema. Wenn Daten verschiedener Quellen dieselben persistenten und eindeutigen Bezeichner verwenden um dieselben Dinge zu bezeichen, können Nutzer die Quellen kombinieren um noch nützlichere Daten zu erzugen. Solche Bezeichner können GUIDs, DOIS order URLs sein.',
      :pick => :one
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'dauerhafte Identifkatoren',
      :requirement => ['standard_33']

    label_standard_33 'Sie sollten <strong>in Ihren Daten Bezeichner für Dinge verwenden</strong>, so dass sie leicht zu anderen Daten über diese Dinge n Bezug gesetzt werden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Können die Bezeichner in Ihren Daten genutzt werden, um weitere Information zu finden?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Die dauerhaften Identifikatoren',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'nein, die Bezeichner können nicht genutzt werden, um weitere Information zu finden.',
      :text_as_statement => ''
    a_service 'Ja, es gibt einen Dienst, den Nutzer zur Auflösung der Bezeichner nutzen können.',
      :text_as_statement => 'werden mittels eines Dienstes aufgelöst',
      :help_text => 'Online-Dienste können genutzt werden, um Nutzern Informationen über Bezeichner wie GUIDs oder DOIs zu verschaffen, die im Gegensatz zur URLs nicht direkt zugänglich sind.',
      :requirement => ['standard_34']
    a_resolvable 'ja, die Bezeicher sind URLs, die bei  Auflösung  Informationen bereitstellen',
      :text_as_statement => 'werden als URLs aufgelösten',
      :help_text => 'URLs sind sowohl für Menschen wie Computer nützlich. Nutzer können die  URL in Ihren Browser einegeben und weitere Information lesen, wie <a href="http://opencorporates.com/companies/gb/08030289">Unternehmen</a> und <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">Postleitzahlen</a>. Computer können diese zusätzlichen Informationen verarbeiten, indem sie Skripte nutzen, um auf die zugrundeliegenden Daten zuzugreifen.',
      :requirement => ['exemplar_17']

    label_standard_34 'Sie sollten <strong>einen Dienst zur Auflösung der Bezeichner bereitstellen</strong>, so dass Nutzer weitere Information zu ihnen finden können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 'Sie sollten <strong>einen Link auf eine Webseite für jedes Ding in Ihren Daten setzen.</strong>, so dass Nutzer die Informatin leichter finden und verbreiten können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Wo findet sich der Dienst zur Auflösung der Bezeichner?',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Der Dienst zur Aufösung der Identifkatoren findet sich unter',
      :help_text => 'Der Dienst zur Auflösung der Bezeichner, sollte den Bezeichner als Parameter einer Abfrage akzeptieren und Informationen zum von ihm bezeichneten Objekt zurückgeben.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'URL des Dienstes zur Auflösung der Identifikatoren',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Dienstes zur Auflösung der Identifikatoren',
      :requirement => ['standard_35']

    label_standard_35 'Sie sollten <strong>eine URL angeben, mittels derer die Bezeichner aufgelöst werden können.</strong>, so dass durch Computer mehr Informationen über sie gefunden werden kann.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Wird im Netz von dritter Seite Information über die Objekte in Ihren Daten bereitgestellt?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Manchmal werden von anderen außerhalb Ihres Einflussbereichs URLs für die Objekte in Ihren Daten bereitgestellt. So werden von der GeoNames-Datenbank über 8 Millionen geographische Namen mit einer festen URL als Web-Ressource eindeutig identifiziert.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'Nein'
    a_true 'Ja'

    q_reliableExternalUrls 'Ist die Information von dritter Seite verlässlich?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'Wenn Dritte öffentliche URLs für Objekte in Ihren Daten bereitstellen, werden sie wahrscheinlich Schritte unternehmen, um die Qualität und Verlässlichkeit der Daten sicherzustellen. Dies ist ein Maß dafür wie sehr Sie den entsprechenden Prozessen vertrauen. Achten Sie bei Ihren Entscheidungen auf ihre Open Data Zertifikate oder ähnliche Kennzeichen.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'Nein'
    a_true 'Ja'

    q_externalUrls 'Benutzen Ihre Daten diese URLs von dritter Seite?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'Auf URLs von dritter Seite',
      :help_text => 'Sie sollten URLs von Dritter Seite, die die Bezeichner in Ihren Daten auflösen und zusätzliche Informationen erschließen, benutzen. Dies verringert Duplikationen und hilft Nutzern dabei, Daten unterschiedlicher Quellen zu verknüpfen und dadurch aufzuwerten.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'referenced in this data',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Sie sollten <strong>in Ihren Daten URLs für Informationen von Dritter Seite verwenden</strong>, so dass sie leicht mit anderen Daten kombiniert werden können, die diese URLs verwenden.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Vertrauenswürdigkeitt',
      :help_text => 'wieviel Vertrauen Nutzer in Ihre Daten setzen können',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Stellen Sie maschinenlesbare Herkunftsangaben für Ihre Daten zur Verfügung?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'Die Herkunft der Daten ist',
      :help_text => 'Die Daten enthalten Angaben darüber wie die Daten vor ihrer Veröffentlichung erzeugt und verarbeitet wurden, Dies schafft vertrauen in die Daten, weil die Nutzer ihre Behandlung zurückverfolgen können.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'Nein',
      :text_as_statement => ''
    a_true 'Ja',
      :text_as_statement => 'maschinenlesbar angegeben',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Sie sollten <strong>einen maschinenlesbaren Herkunfts-Pfad für ihre Daten zur Verfügung stellen</strong>, so dass Nutzer nachvollziehen können, wie sie verarbeitet wurden.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Wo beschreiben Sie, wie Nutzer überprüfen können, dass die Daten, die sie erhalten, korrekt sind?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Die Daten können verifiziert werden mittels',
      :help_text => 'Wenn Sie Nutzern wichtige Daten zur Verfügung stellen, sollten sie in die Lage versetzt werden, zu prüfen, ob die Daten die sie erhalten, dieselben sind, die von Ihnen veröffentlicht wurden. Sie könnten die Daten, die Sie veröffentlichen z. B. elektronisch signieren um sicherzustllen, das Sie nicht manipuliert wurden.'
    a_1 'URL eines Verifikationsverfahrens',
      :text,
      :input_type => :url,
      :placeholder => 'URL eines Verifikationsverfahrens',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Sie sollten <strong>beschreiben, wie Nutzer prüfen können, ob die Daten, die sie erhalten, dieselben sind, die von Ihnen veröffentlicht wurden</strong>, so dass sie ihnen vertrauen können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Soziale Information',
    :description => 'Dokumentation, Support und Services' do

    label_group_15 'Dokumentation',
      :help_text => 'wie Sie den Nutzern helfen, den Kontext und den Inhalt Ihrer Daten zu verstehen',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Enthält Ihre Dokumentation maschinenlesbare Daten für:',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Die Dokumentation enthält maschinenlesbare Daten für ',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'Titel',
      :text_as_statement => 'Titel',
      :requirement => ['standard_36']
    a_description 'Beschreibung',
      :text_as_statement => 'Beschreibung',
      :requirement => ['standard_37']
    a_issued 'Veröffentlichungsdatum',
      :text_as_statement => 'Veröffentlichungsdatum',
      :requirement => ['standard_38']
    a_modified 'Änderungsdatum',
      :text_as_statement => 'Änderungsdatum',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'Veröffentlichungsfrequenz',
      :text_as_statement => 'Veröffentlichungsfrequenz',
      :requirement => ['standard_40']
    a_identifier 'Bezeichner',
      :text_as_statement => 'Bezeichner',
      :requirement => ['standard_41']
    a_landingPage 'Landing Page',
      :text_as_statement => 'Landing Page',
      :requirement => ['standard_42']
    a_language 'Sprache',
      :text_as_statement => 'Sprache',
      :requirement => ['standard_43']
    a_publisher 'Herausgeber',
      :text_as_statement => 'Herausgeber',
      :requirement => ['standard_44']
    a_spatial 'räumliche/geographische Abdeckung',
      :text_as_statement => 'räumliche/geographische Abdeckung',
      :requirement => ['standard_45']
    a_temporal 'zeitliche Abdeckung',
      :text_as_statement => 'zeitliche Abdeckung',
      :requirement => ['standard_46']
    a_theme 'Them(a)/(en)',
      :text_as_statement => 'Them(a)/(en)',
      :requirement => ['standard_47']
    a_keyword 'Schlagworte oder Tags',
      :text_as_statement => 'Schlagworte oder Tags',
      :requirement => ['standard_48']
    a_distribution 'Distribution(en)',
      :text_as_statement => 'Distribution(en)'

    label_standard_36 'Sie sollten <strong>einen maschinenlesbaren Daten Titel in Ihre Dokumentation einschließen</strong>, so dass Nutzer wissen, wie sie die Daten referenzieren sollen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Sie sollten <strong>eine maschinenlesbare Datenbeschreibung in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, was sie enthalten.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Sie sollten <strong>ein maschinenlesbares Veröffentlichungsdatum in Ihrer Dokumentation einschließen</strong>, so dass die Nutzer wissen, wie aktuell sie sind.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Sie sollten <strong>ein maschinenlesbares Änderungsdatum in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, dass sie über die aktuellsten Daten verfügen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Sie sollten <strong>maschinenlesbare Metadaten zur Verfügung stellen, wie oft neue Versionen Ihrer Daten veröffentlicht werden.</strong>, so dass die Nutzer wissen, wie oft Sie die Daten aktualisieren.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Sie sollten <strong>eine bevorzugte Internet-Adresse (Canonoical URL) in ihrer maschinenlesbaren Dokumentation einschließen</strong>, so dass die Nutzer wissen, wie sie konsistent darauf zugreifen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Sie sollten <strong>in Ihre maschinenlesbare Dokumentation eine bevorzugte Web-Adresse (Canonical URL) zur Dokumentation selbst einschließen.</strong>, so dass die Nutzer wissen, wie konsistent darauf zugreifen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Sie sollten <strong>die Sprache der Daten in der maschinenlesbaren Dokumentation einschließen</strong>, so dass Nutzer, die danach suchen, wissen, ob sie die Daten verstehen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Sie sollten <strong>den Herausgeber der Daten in Ihre maschinenlesbaren Dokumentation einschließen</strong>, so dass die Nutzer entscheiden können, wie sehr sie Ihren daten vertrauen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Sie sollten <strong>die geographische Abdeckung in Ihre maschinenlesbare Dokumentation einschließen</strong>,  so dass die Nuter verstehen, auf welches Gebiet sich Ihre Daten beziehen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Sie sollten <strong>den Zeitraum in Ihre maschinenlesbare Dokumentation einschließen</strong>, so dass die Nutzer verstehen, auf welche Zeit sich Ihre Daten beziehen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Sie sollten <strong>das Thema in Ihre maschinenlesbare Dokumentation einschließen</strong>, so dass die Nutzer grob verstehen, worum es bei Ihren Daten geht.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Sie sollten <strong>maschinenlesbare Schlagworte oder Tags in Ihre Dokumentation einschließen</strong>, so dass Nutzer, effektiv nach den Daten suchen können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Enthält Ihre Dokumentation maschinenlesbare Metadaten über:',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Die Dokumentation jeder Distribution entält maschinenlesbare Angaben für ',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'Titel',
      :text_as_statement => 'Titel',
      :requirement => ['standard_49']
    a_description 'Beschreibung',
      :text_as_statement => 'Beschreibung',
      :requirement => ['standard_50']
    a_issued 'Veröffentlichungsdatum',
      :text_as_statement => 'Veröffentlichungsdatum',
      :requirement => ['standard_51']
    a_modified 'Änderungsdatum',
      :text_as_statement => 'Änderungsdatum',
      :requirement => ['standard_52']
    a_rights 'Nutzungsbedingungen',
      :text_as_statement => 'Nutzungsbedingungen',
      :requirement => ['standard_53']
    a_accessURL 'URL für den Zugang zu den Daten',
      :text_as_statement => 'eine URL für den Zugang zu den Daten',
      :help_text => 'Diese Metadaten sollten genutzt werden, wenn Ihre Daten nicht zum Herunterladen zur Verfügung stehen (wie eine API oder ein Beispiel).'
    a_downloadURL 'URL zum Download des Datensatzes',
      :text_as_statement => 'eine URL zum Herunterladen der Daten'
    a_byteSize 'Größe in Bytes',
      :text_as_statement => 'Größe in Bytes'
    a_mediaType 'Typ des herunterzuladenden Mediums',
      :text_as_statement => 'Typ des herunterzuladenden Mediums'

    label_standard_49 'Sie sollten <strong>maschinenlesbare Titel in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, wie sie jede Distribution referenzieren können.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Sie sollten <strong>maschinen lesbare Beschreibunen in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, was jede Distribution enthält.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Sie sollten <strong>maschinenlesbare Veröffentlichungsdaen in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, wie aktuell jede Distribution ist.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'Sie sollten <strong>maschinenlesbare Daten der letzten Änderung in Ihre Dokumentation einschließen</strong>, so dass die Nutzer wissen, ob ihre Kopie einer Daten-Distribution aktuell ist.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Sie sollten <strong>einen maschinenlesbaren Verweis auf die einschlägigen Nutzungsbedingungen einschließen</strong>, so dass die Nutzer herausfinden können, was Sie mit jeder Daten-Distribution tun dürfen.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Wo befindet sich die technische Dokumentation der Daten?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'Die technische Dokumantation der Daten findet sich unter'
    a_1 'URL der technischen Dokumtation',
      :text,
      :input_type => :url,
      :placeholder => 'URL der technischen Dokumtation',
      :requirement => ['pilot_21']

    label_pilot_21 'Sie sollten <strong>eine technische Dokumentation der Daten bereitstellen</strong>, so das die Nutzer wissen, wie sie die Daten nutzen können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Verwenden die Daten Vokabularien oder Schemata?',
      :discussion_topic => :vocabulary,
      :help_text => 'Formate wie CSV, JSON, XML oder Turtle nutzen eigene Vokabulareien oder Schemata, die festlegen, welche Spalten oder Eigenschaften die Daten enthalten.',
      :pick => :one,
      :required => :standard
    a_false 'Nein'
    a_true 'Ja'

    q_schemaDocumentationUrl 'Wo findet sich die Dokumentation der Daten-Vokabularien?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die in den Daten verwandten Vokabulare sind dokumtnetiert unter'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'URL des Schemas',
      :text,
      :input_type => :url,
      :placeholder => 'URL des Schemas',
      :requirement => ['standard_54']

    label_standard_54 'Sie sollten <strong>alle Vokabularien, die Sie in Ihren Daten benutzen, dokumentieren</strong>, so dass die Nutzer wissen, wie die Daten zu interpretieren sind.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Nutzen Ihre Daten Schlüssellisten?',
      :discussion_topic => :codelists,
      :help_text => 'Wenn Ihre Daten Schlüssellisten für Objekte wie geographische Gebiete, Ausgabekategorien oder Krankheiten benutzt, müssen diese den Nutzern erklärt werden.',
      :pick => :one,
      :required => :standard
    a_false 'Nein'
    a_true 'Ja'

    q_codelistDocumentationUrl 'Wo sind die in den Daten verwandten Schlüssel in Ihren Daten dokumentiert?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Die Schlüssel für die Daten sind dokumentiert unter'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'URL der Schlüsselliste',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Schlüsselliste',
      :requirement => ['standard_55']

    label_standard_55 'Sie sollten <strong>die Schlüssel in Ihren Daten dokumentieren</strong>, so dass die Nutzer wissen, wie sie zu interpretieren sind.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Support',
      :help_text => 'wie Sie mit den Nutzern Ihrer Daten kommunizieren',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Wo können Nutzer einen Ansprechpartner für Ihre Fragen zu den Daten finden?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Einen Ansprechpartner zu diesen Daten finden Sie unter',
      :help_text => 'Geben Sie die URL einer Seite an, die beschreibt wie Nutzer einen Ansprechparter kontaktieren können, wenn sie Fragen zu den Daten haben.'
    a_1 'URL der Kontaktinformationen',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Kontaktinformationen',
      :requirement => ['pilot_22']

    label_pilot_22 'Sie sollten <strong>Kontakinformationen für die Nutzer bereitstellen</strong>, damit diese Fragen einsenden können.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Wo können Nutzer Angaben finden, wie die Art der Veröffentlichung Ihrer Daten verbessert werden könnte?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Wie sie Verbesserungen dieser Daten vorschlagen können erfahren Sie unter'
    a_1 'URL für Verbesserungsvorschläge',
      :text,
      :input_type => :url,
      :placeholder => 'URL für Verbesserungsvorschläge',
      :requirement => ['pilot_23']

    label_pilot_23 'Sie sollten <strong>Hinweise dazu geben, wie Verbesserungen vorgeschlagen werden können</strong>, damit Sie entdecken können, welche Anforderungen die Nutzer haben.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Wo können Nutzer herausfinden, wen sie bei Fragen zum Datenschutz ansprechen können?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Wohin sie sich mit Fragen zum Datenschutz wenden können, erfahren Sie unter'
    a_1 'URL der Datenschutzhinweise',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Datenschutzhinweise',
      :requirement => ['pilot_24']

    label_pilot_24 'Sie sollten <strong>Kontaktinformationen eines Ansprechpartners für Fragen zum Datenschutz und der Offenlegung personenbezogener Daten bereitstellen</strong>.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Nutzen Sie "soziale Medien", um mit den Nutzern Ihrer Daten in Kontakt zu treten?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['standard_56']

    label_standard_56 'Sie sollten <strong>"soziale Medien" nutzen, um die Nutzer Ihrer Daten zu erreichen</strong>, und zu entdecken, wie Ihre Daten genutzt werden.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Konto (Account)' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Welche Konten bei sozialen Medien, können die Nutzer für den Kontakt zu Ihnen nutzen?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Treten Sie mit dem Herausgeber über diese Kanäle in den sozialen Medien in Kontakt',
        :help_text => 'Geben Sie URLs zu Ihren Auftritten in sozialen Medien (wie ihre Twitter oder Facebook-Seiten)',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'URL des Social Media Kanals',
        :text,
        :input_type => :url,
        :required => :required,
        :placeholder => 'URL des Social Media Kanals'

    end

    q_forum 'Wo können Nutzer diesen Datensatz diskutieren?`',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Diskutieren Sie über die Daten unter',
      :help_text => 'Geben Sie eine URL zu einem Forum oder einer Mailing-Liste an, wo über Ihre Daten diskutiert werden kann.'
    a_1 'URL eines Forums oder einer Mailing-Liste',
      :text,
      :input_type => :url,
      :placeholder => 'URL eines Forums oder einer Mailing-Liste',
      :requirement => ['standard_57']

    label_standard_57 'Sie sollten <strong>den Nutzern mitteilen, wo sie über Ihre Daten diskutieren und sich gegenseitig unterstützen können</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Wo kann man herausfinden, wie man Korrekturen Ihrer Daten verlangen kann?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Wie Sie Korrekturen der Daten verlangen können erfahren Sie unter',
      :help_text => 'Geben Sie eine URL an, wo man Fehler in den Daten melden kann, die man in Ihren Daten findet.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL der Anleitung für Korrekturverlangen',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Anleitung für Korrekturverlangen',
      :requirement => ['standard_58']

    label_standard_58 'Sie sollten <strong>erläutern, wie man Fehler in Ihren Daten melden kann</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Wo kann man sich sich informieren, wie man Benachritigungen erhält, wenn Ihre Daten korrigiert werden?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Wie Sie Mitteilungen über Datenkorrekturen erhalten erfahren Sie unter',
      :help_text => 'Geben Sie eine URL an, wo Sie beschreiben, wie man benachrichtigt werden kann, wenn Sie über Datenkorrekturen berichten.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'URL für Mitteilungen zu Datenkorrekturen',
      :text,
      :input_type => :url,
      :placeholder => 'URL für Mitteilungen zu Datenkorrekturen',
      :requirement => ['standard_59']

    label_standard_59 'Sie sollten <strong>eine Mailing-Liste oder einen Feed für Aktualisierungen einrichten</strong>, den Nutzer verwenden können, um ihre Kopien Ihrer Daten aktuell zu halten.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Gibt es jemanden bei Ihnen, der aktiv eine "Community" zu diesen Daten aufbaut?',
      :discussion_topic => :engagementTeam,
      :help_text => 'A community engagement team will engage through social media, blogging, and arrange hackdays or competitions to encourage people to use the data.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'Nein'
    a_true 'Ja',
      :requirement => ['exemplar_21']

    label_exemplar_21 'Sie sollten <strong>Eine "Community" zu Ihren Daten aufbauen</strong>, um eine umfangreichere Nutzung Ihrer Daten zu fördern.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Wo befindet sich deren Homepage?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Um die Beteiligung der "Community" kümmert sich',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'URL der Homepage für die Beteiligung der "Community"',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Homepage für die Beteiligung der "Community"',
      :required => :required

    label_group_17 'Service',
      :help_text => 'Wie Sie Nutzern Zugang zu Werkzeugen geben, die sie zur Arbeit mit Ihren Daten benötigen',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Wo führen Sie Werkzeuge für die Arbeit mit Ihren Daten auf?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Eine Liste der Werkzeuge ("Tools", die die Nutzung der Daten unterstützen können, findet sich unter',
      :help_text => 'Geben Sie eine URL an, die Werzeuge aufführt, die Sie kennen oder Nutzern für die Arbeit mit Ihren Daten empfehlen.'
    a_1 'URL der Werkzeugliste',
      :text,
      :input_type => :url,
      :placeholder => 'URL der Werkzeugliste',
      :requirement => ['exemplar_22']

    label_exemplar_22 'Sie sollten <strong> eine Liste von Software-Bibliotheken oder anderen fertig verfügbaren Werkzeugen anbieten</strong>, so dass die Nutzer schnell mit der Arbeit mit ihren Daten beginnen können.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
