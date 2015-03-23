survey 'GR',
  :full_title => 'Greece',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>Αυτό το ερωτηματολόγιο αυτο-αξιολόγησης δημιουργεί ένα πιστοποιητικό ανοιχτών δεδομένων και ένα σήμα που μπορείτε να δημοσιεύσετε έτσι ώστε να ενημερωθούν όλοι σχετικά με τα ανοικτά δεδομένα. Επίσης, οι απαντήσεις σας θα χρησιμοποιηθούν για να μάθουμε το πώς οι οργανισμοί δημοσιεύουν ανοιχτά δεδομένα.</p><p>Απατώντας σε αυτά τα ερωτήματα θα φανούν οι προσπάθειές συμμόρφωσης σας με την σχετική νομοθεσία. Θα πρέπει επίσης να ελέγθεί σχετικά και με άλλους νόμους και πολιτικές που εφαρμόζονται στον τομέα σας.</p><p>
         <strong>Δεν χρειάζεται να απαντήσετε σε όλες τις ερωτήσεις για να πάρετε το πιστοποιητικό.</strong> Απλά απαντήστε αυτές που μπορείτε.</p><p>
         <strong></strong>
      </p>' do

  translations :en => :default
  section_general 'General Information',
    :description => '',
    :display_header => false do

    q_dataTitle 'What\'s this data called?',
      :discussion_topic => :dataTitle,
      :help_text => 'People see the name of your open data in a list of similar ones so make this as unambiguous and descriptive as you can in this tiny box so they quickly identify what\'s unique about it.',
      :required => :required
    a_1 'Data Title',
      :string,
      :placeholder => 'Data Title',
      :required => :required

    q_documentationUrl 'Where is it described?',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'This data is described at',
      :help_text => 'Give a URL for people to read about the contents of your open data and find more detail. It can be a page within a bigger catalog like data.gov.uk.'
    a_1 'Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Documentation URL',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'You should have a <strong>web page that offers documentation</strong> about the open data you publish so that people can understand its context, content and utility.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'You must have a <strong>web page that gives documentation</strong> and access to the open data you publish so that people can use it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Who publishes this data?',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'This data is published by',
      :help_text => 'Give the name of the organisation who publishes this data. It’s probably who you work for unless you’re doing this on behalf of someone else.',
      :required => :required
    a_1 'Data Publisher',
      :string,
      :placeholder => 'Data Publisher',
      :required => :required

    q_publisherUrl 'What website is the data published on?',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The data is published on',
      :help_text => 'Give a URL to a website, this helps us to group data from the same organisation even if people give different names.'
    a_1 'Publisher URL',
      :string,
      :input_type => :url,
      :placeholder => 'Publisher URL'

    q_releaseType 'What kind of release is this?',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'a one-off release of a single dataset',
      :help_text => 'This is a single file and you don’t currently plan to publish similar files in the future.'
    a_collection 'a one-off release of a set of related datasets',
      :help_text => 'This is a collection of related files about the same data and you don’t currently plan to publish similar collections in the future.'
    a_series 'ongoing release of a series of related datasets',
      :help_text => 'This is a sequence of datasets with planned periodic updates in the future.'
    a_service 'a service or API for accessing open data',
      :help_text => 'This is a live web service that exposes your data to programmers through an interface they can query.'

  end

  section_legal 'Νομικές Πληροφορίες',
    :description => 'Δικαιώματα, χορήγηση αδειών και ιδιωτικότητα' do

    label_group_2 'Δικαιώματα',
      :help_text => 'το δικαίωμά σας να μοιραστείτε αυτά τα δεδομένα με άλλους',
      :customer_renderer => '/partials/fieldset'

    q_publisherRights 'Έχετε το δικαίωμα να δημοσιεύσετε αυτά τα δεδομένα ως ανοικτά;',
      :discussion_topic => :gr_publisherRights,
      :help_text => 'Αν ο οργανισμός σας δεν είχε αρχικά δημιουργήσει ή συγκεντρώσει αυτά τα δεδομένα τότε μπορεί να μην έχετε το δικαίωμα να τα δημοσιεύσετε. Αν δεν είστε σίγουροι, επικοινωνήστε με τον κάτοχο των δεδομένων, επειδή θα χρειαστείτε την άδειά του.',
      :requirement => ['basic_2'],
      :pick => :one,
      :required => :required
    a_yes 'ναι, έχετε το δικαίωμα να τα δημοσιεύσετε ως ανοικτά',
      :requirement => ['standard_1']
    a_no 'Όχι, δεν έχετε το δικαίωμα να δημοσιεύσετε αυτά τα δεδομένα ως ανοικτά'
    a_unsure 'δεν είστε βέβαιος για το αν έχετε το δικαίωμα να δημοσιεύσετε αυτά τα δεδομένα ως ανοικτά'
    a_complicated 'τα δικαιώματα αυτών των δεδομένων είναι περίπλοκα ή ασαφή'

    label_standard_1 'Θα πρέπει να έχετε ένα <strong>σαφές νομικό δικαίωμα που να επιτρέπει την δημοσίευση των δεδομένων αυτών</strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_1'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '!=', :a_yes

    label_basic_2 'Πρέπει να έχετε το <strong>δικαίωμα δημοσίευσης των δεδομένων αυτών</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_2'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_no

    q_rightsRiskAssessment 'Ποιοι είναι λεπτομερώς οι κίνδυνοι που κάποιος μπορεί να αντιμετωπίσει αν χρησιμοποιήσει τα δεδομένα αυτά;',
      :discussion_topic => :gr_rightsRiskAssessment,
      :display_on_certificate => true,
      :text_as_statement => 'Οι κίνδυνοι για τη χρήση αυτών των δεδομένων που περιγράφονται στο',
      :help_text => 'Μπορεί να είναι επικίνδυνο για κάποιον να χρησιμοποιήσει δεδομένα χωρίς να έχει σαφή δικαιώματα. Για παράδειγμα, τέτοια δεδομένα θα μπορούσαν να μην ληφθούν υπ\'όψιν σε ένα δικαστήριο. Να δίνετε μια διεύθυνση συνδέσμου(URL) σελίδας που να περιγράφει τον κίνδυνο από την χρήση αυτών των δεδομένων.'
    dependency :rule => 'A'
    condition_A :q_publisherRights, '==', :a_complicated
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης Κινδύνου',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης Κινδύνου',
      :requirement => ['pilot_2']

    label_pilot_2 'Θα πρέπει να τεκμηριώνετε <strong>τους κινδύνους που συνδέονται με την χρήση αυτών των δεδομένων</strong>, έτσι ώστε ο καθένας να μπορεί να βρει μια λύση σχετικά και με το πως θα ήθελε να τα χρησιμοποιήσει.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_2'
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_complicated
    condition_B :q_rightsRiskAssessment, '==', {:string_value => '', :answer_reference => '1'}

    q_publisherOrigin 'Ήταν <em>όλα</em> αυτά τα δεδομένα αρχικώς δημιουργημένα ή συγκεντρωμένα από εσάς;',
      :discussion_topic => :gr_publisherOrigin,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα ήταν',
      :help_text => 'Εάν οποιοδήποτε τμήμα αυτών των δεδομένων που δεν προήλθε από τον οργανισμό σας αλλά από άλλα άτομα ή οργανισμούς, τότε θα πρέπει να δοθούν επεπλέον πληροφορίες σχετικά με τα δικαιώματά σας για δημοσίευση.',
      :pick => :one,
      :required => :required
    dependency :rule => '(A or B)'
    condition_A :q_publisherRights, '==', :a_yes
    condition_B :q_publisherRights, '==', :a_unsure
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'αρχικά δημιουργήθηκε ή παράχθηκε από τον επιμελητή'

    q_thirdPartyOrigin 'Ήταν κάποια από αυτά τα δεδομένα παραγμένα ή υπολογισμένα από άλλα δεδομένα;',
      :discussion_topic => :gr_thirdPartyOrigin,
      :help_text => 'Ένα απόσπασμα ή μικρότερο μέρος των δεδομένων κάποιου άλλου μπορεί να επηρεάσει τα δικαιώματα για την χρήση του. Ενδέχεται επίσης να υπάρξουν νομικά ζητήματα, αν τα αναλύσετε και βγάλετε νέα αποτελέσματα.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_3']

    label_basic_3 'Δηλώσατε ότι τα δεδομένα αυτά δεν δημιουργήθηκαν ούτε συγκεντρώθηκαν από εσάς αλλά ούτε και σας παραδώθηκαν μέσω πληθοπορισμού, οπότε θα πρέπει να έχουν εξαχθεί ή παραχθεί από άλλες πηγές δεδομένων',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_3'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_false
    condition_D :q_thirdPartyOrigin, '!=', :a_true

    q_thirdPartyOpen 'Έχουν <em>όλες</em> οι πηγές αυτών των δεδομένων ήδη δημοδιευθεί ως ανοικτά δεδομένα;',
      :discussion_topic => :gr_thirdPartyOpen,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα δημιουργήθηκαν από',
      :help_text => 'Επιτρέπεται να αναδημοσιεύσετε δεδομένα κάποιου άλλου τα οποία είναι ανοικτά ή εάν τα δικαιώματά τους έχουν λήξει ή αρθεί. Εάν δεν ισχύει αυτό για κάποιο μέρος των δεδομένων τότε θα χρειαστείτε νομικές συμβουλές πριν μπορέσετε να τα δημοσιεύσετε.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'πηγές ανοικτών δεδομένων',
      :requirement => ['basic_4']

    label_basic_4 'Θα πρέπει να λάβετε <strong>νομικές συμβουλές για να βεβαιωθείτε οτί έχετε το δικαίωμα να δημοσιεύσετε αυτά τα στοιχεία</strong>.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_4'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_true
    condition_D :q_thirdPartyOpen, '==', :a_false
    condition_E :q_thirdPartyOpen, '==', :a_false

    q_crowdsourced 'Ήταν κάποια από αυτά τα δεδομένα από πληθοπορισμό(crowdsourcing);',
      :discussion_topic => :gr_crowdsourced,
      :display_on_certificate => true,
      :text_as_statement => 'Μερικά από αυτά τα δεδομένα είναι',
      :help_text => 'Εάν τα δεδομένα περιλαμβάνουν στοιχεία προερχόμενα απο ανθρώπους εκτός του οργανισμού σας, θα πρέπει να έχετε την άδειά τους για να τα δημοσιεύσετε ως ανοικτά.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'από πληθοπορισμό',
      :requirement => ['basic_5']

    label_basic_5 'Δηλώσατε ότι τα δεδομένα δεν δημιουργήθηκαν αρχικά από εσάς ούτε συλλέχθηκαν ή υπολογίστηκαν από άλλα δεδομένα, γι\'αυτό θα πρέπει να είναι απο πληθοπορισμό(crowdsourcing).',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_5'
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_thirdPartyOrigin, '==', :a_false
    condition_D :q_crowdsourced, '!=', :a_true

    q_crowdsourcedContent 'Μήπως οι συνεισφέροντες σε αυτά τα δεδομένα χρησιμοποίησαν την κρίση τους;',
      :discussion_topic => :gr_crowdsourcedContent,
      :help_text => 'Αν κάποιοι χρησιμοποίησαν την δημιουργικότητα ή την κρίση τους για να συνεισφέρουν δεδομένα τότε έχουν τα δικαιώματα του έργου τους. Για παράδειγμα, γράφοντας μια περιγραφή ή αποφασίζοντας για το αν θα συμπεριληφθούν ή όχι κάποια δεδομένα απαιτεί κρίση. Έτσι οι συνεισφέροντες πρέπει να μεταφέρουν ή να παραιτηθούν από τα δικαιώματά τους, ή να δώσουν την άδεια σε εσάς πριν μπορέσετε να το δημοσιεύσετε.',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_claUrl 'Που είναι η Άδεια Συνεισφέροντος(CLA);',
      :discussion_topic => :gr_claUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Η Άδεια Συνεισφέροντος(CLA) είναι',
      :help_text => 'Δώστε ένα σύνδεσμο που να οδηγεί στο συμφωνητικού όπου φαίνεται πως οι συνεισφέροντες σας επιτρέπουν να επαναχρησιμοποιειτε τα δεδομένα τους. H CLA είτε θα μεταφέρει τα δικαιώματα σε εσάς, ή θα παραιτείται απο αυτά, είτε θα σας δίνει την άδεια δημοσίευσης τους.',
      :help_text_more_url => 'http://en.wikipedia.org/wiki/Contributor_License_Agreement',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    a_1 'Σύνδεσμος(URL) Άδεια Συνεισφέροντος(CLA)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Άδεια Συνεισφέροντος(CLA)',
      :required => :required

    q_cldsRecorded 'Έχουν όλοι οι συνεισφέροντες αποδεχθεί την Άδεια Συνεισφέροντος(CLA);',
      :discussion_topic => :gr_cldsRecorded,
      :help_text => 'Ελέγξτε ότι όλοι οι συνεισφέροντες έχουν αποδεχθεί την CLA πριν επαναχρησιμοποιήσετε ή επαναδημοσιεύσετε την συνεισφορά τους. Θα πρέπει να κρατήσετε αρχείο με τους συνεισφέροντες και για το αν έχουν αποδεχθεί ή όχι την CLA.',
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

    label_basic_6 'Θα πρέπει <strong>οι συνεισφέροντες να αποδεχθούν μια Άδεια Συνεισφέροντος(CLA)</strong>, που θα σας δίνει το δικαίωμα να δημοσιεύετε την εργασία τους ως ανοιχτα δεδομένα.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_6'
    dependency :rule => 'A and B and C and D and E'
    condition_A :q_publisherRights, '==', :a_unsure
    condition_B :q_publisherOrigin, '==', :a_false
    condition_C :q_crowdsourced, '==', :a_true
    condition_D :q_crowdsourcedContent, '==', :a_true
    condition_E :q_cldsRecorded, '==', :a_false

    q_sourceDocumentationUrl 'Που περιγράφονται οι πηγές των δεδομένων;',
      :discussion_topic => :gr_sourceDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Οι πηγές των εν λόγω δεδομένων περιγράφονται στο',
      :help_text => 'Δώστε την διεύθυνση συνδέσμου(URL) όπου τεκμηριώνεται η προέλευση των δεδομένων και τα δικαιώματα που απορρέουν από αυτά για να τα δημοσιεύσετε. Αυτό βοηθά τους ανθρώπους να κατανοήσουν το από που έρχονται τα δεδομένα αυτά.'
    dependency :rule => 'A'
    condition_A :q_publisherOrigin, '==', :a_false
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης Πηγών Δεδομένων',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης Πηγών Δεδομένων',
      :requirement => ['pilot_3']

    label_pilot_3 'Θα πρέπει να τεκμηριώσετε <strong>την προέλευση των δεδομένων και τα δικαιώματα υπό τα οποία εσείς τα δημοσιεύετε</strong>, έτσι ώστε κάποιος να μπορεί να είναι βέβαιος ότι μπορεί να χρησιμοποιήσει τα μέρη που προέρχονται από τρίτους.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_3'
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_sourceDocumentationMetadata 'Είναι η τεκμηρίωση σχετικά με τις πηγών δεδομένων, επίσης σε μορφή αναγνωρίσιμη από μηχανές;',
      :discussion_topic => :gr_sourceDocumentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Ο επιμελητής έχει δημοσιεύσει',
      :help_text => 'Οι πληροφορίες σχετικά με τις πηγές των δεδομένων θα πρέπει να είναι αναγνωρίσιμες απο τους ανθρώπους ώστε να μπορούν να τις καταλάβουν καθώς αλλά και σε μορφή που να περιλαμβάνει μεταδεδομένα ώστε να μπορούν οι υπολογιστές να τις επεξεργαστούν. Όταν όλοι κάνουν το ίδιο, βοηθά στο να βρίσκουμε πως τα ίδια ανοικτά δεδομένα χρησιμοποιούνται και αιτιολογούν την εν εξελίξει δημοσίευσή τους.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ανγνωρίσιμα από τις μηχανές δεδομένα σχετικά με τις πηγές αυτών των δεδομένων',
      :requirement => ['standard_2']

    label_standard_2 'Θα πρέπει να <strong>συμπεριλάβετε αναγνώσιμα από τη μηχανή δεδομένα σχετικά με τις πηγές των δεδομένων αυτών </strong>.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_2'
    dependency :rule => 'A and B and C'
    condition_A :q_publisherOrigin, '==', :a_false
    condition_B :q_sourceDocumentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_sourceDocumentationMetadata, '==', :a_false

    label_group_3 'Αδειοδότηση',
      :help_text => 'πως δίνετε σε άλλους την άδεια να χρησιμοποιήσουν αυτά τα δεδομένα',
      :customer_renderer => '/partials/fieldset'

    q_copyrightURL 'Που έχετε ανακοινώσει την δήλωση δικαιωμάτων για το σύνολο των δεδομένων αυτών;',
      :discussion_topic => :gr_copyrightURL,
      :display_on_certificate => true,
      :text_as_statement => 'Η δήλωση δικαιωμάτων είναι στο',
      :help_text => 'Δώστε την διεύθυνση συνδέσμου(URL) όπου περιγράφεται το δικαίωμα επαναχρησιμοποίησης αυτών των δεδομένων. Αυτό θα πρέπει να περιλαμβάνει μια αναφορά στην άδεια χρήσης της, τις απαιτήσεις απόδοσης, καθώς και μια δήλωση σχετικά με τα πνευματικά δικαιώματα. Μια δήλωση δικαιωμάτων βοηθά στο να γίνει κατανοητό τι μπορεί ή δεν μπορεί κάποιος να κάνει με τα αυτά τα δεδομένα.'
    a_1 'Σύνδεσμος(URL) Δήλωσης Δικαιωμάτων',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Δήλωσης Δικαιωμάτων',
      :requirement => ['pilot_4']

    label_pilot_4 'Θα πρέπει να <strong>δημοσιεύσετε την δήλωση δικαιωμάτων </strong>που θα περιγράφει με λεπτομέρειες τα πνευματικά δικαιώματα, την χορήγηση αδειών καθώς και το πως θα δίνεται η αναφορά σε αυτά τα δεδομένα.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_4'
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dataLicence 'Υπό ποιες άδειες μπορεί κάποιος να επαναχρησιμοποιήσει αυτά τα δεδομένα;',
      :discussion_topic => :gr_dataLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα είναι διαθέσιμα υπό',
      :help_text => 'Θυμηθείτε ότι όποιος αφιερώνει διανοητική προσπάθεια για τη δημιουργία περιεχομένου, παίρνει αυτόματα δικαιώματα πάνω του. Δημιουργικό περιεχόμενο περιλαμβάνει την οργάνωση και την επιλογή των στοιχείων εντός των δεδομένων, αλλά δεν περιλαμβάνει τα στοιχεία. Έτσι κάποιος θα χρειαστεί μια παραίτηση ή άδεια για αυτά, που να αποδεικνύει ότι μπορεί να τα χρησιμοποιήσει και να εξηγεί την νομιμότητα τους. Παραθέτουμε τις πιο συνηθισμένες άδειες εδώ; εάν δεν υπάρχει κανένα πνευματικό δικαίωμα σε δεδομένα, έχει λήξει ή έχετε παραιτηθεί από αυτά, επιλέξτε «Δεν ισχύει».',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    a_cc_by 'Creative Commons Αναφορά',
      :text_as_statement => 'Creative Commons Αναφορά'
    a_cc_by_sa 'Creative Commons Αναφορά - Παρόμοια διανομή',
      :text_as_statement => 'Creative Commons Αναφορά - Παρόμοια διανομή'
    a_cc_zero 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)',
      :text_as_statement => 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)'
    a_odc_by 'Open Data Commons Attribution License',
      :text_as_statement => 'Open Data Commons Attribution License'
    a_odc_odbl 'Open Data Commons Open Database License (ODbL)',
      :text_as_statement => 'Open Data Commons Open Database License (ODbL)'
    a_odc_pddl 'Open Data Commons Public Domain Dedication and License (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and License (PDDL)'
    a_na 'δεν εφαρμόζεται',
      :text_as_statement => ''
    a_other 'Άλλο...',
      :text_as_statement => ''

    q_dataNotApplicable 'Γιατί δεν έχουν κάποια άδεια αυτά τα δεδομένα;',
      :discussion_topic => :gr_dataNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα δεν έχουν άδεια επειδή',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_na
    a_norights 'δεν υπάρχει κανένα πνευματικό δικαίωμα σε αυτά τα δεδομένα',
      :text_as_statement => 'δεν υπάρχει κανένα πνευματικό δικαίωμα σε αυτά',
      :help_text => 'Δικαιώματα πνευματικής ιδιοκτησίας εφαρμόζονται στα δεδομένα μόνο εαν χρειάστηκε πνευματική προσπάθεια δημιουργώντας κάτι που βρίσκεται μέσα σε αυτά, για παράδειγμα, γράφοντας το κείμενο μέσα στα δεδομένα, ή αποφασίζοντας αν συγκεκριμένα δεδομένα θα συμπεριληφθούν. Δεν υπάρχουν πνευματικά δικαιώματα εάν τα δεδομένα περιέχουν μόνο δεδομένα που δεν χρειάστηκε κρίση για το αν θα συμπεριληφθούν ή όχι.'
    a_expired 'τα πνευματικά δικαιώματα έχουν λήξει',
      :text_as_statement => 'τα πνευματικά δικαιώματα έχουν λήξει',
      :help_text => 'Τα πνευματικά δικαιώματα διαρκούν για ένα συγκεκριμένο χρονικό διάστημα, με βάση είτε τον αριθμό των ετών μτά τον θάνατο του δημιουργού είτε της δημοσίευσής του. Θα πρέπει να ελέγξετε για το πότε το περιεχόμενο είχε δημιουργηθεί ή δημοσιευθεί επειδή εάν αυτό είχε συμβεί πριν πολύ καιρό τότε μπορεί τα πνευματικά δικαιώματα να έχουν λήξει.'
    a_waived 'τα πνευματικά δικαιώματα έχουν αρθεί',
      :text_as_statement => '',
      :help_text => 'Αυτό σημαίνει πως κανείς δεν κατέχει πνευματικά δικαιώματα και ο καθένας μπορεί να κάνει ότι θέλει με αυτά τα δεδομένα.'

    q_dataWaiver 'Ποια άρση χρησιμοποιείτε για να παραιτηθείτε απο τα πνευματικά δικαιώματα αυτών των δεδομένων;',
      :discussion_topic => :gr_dataWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δικαιώματα σε αυτά τα δεδομένα έχουν αρθεί με',
      :help_text => 'Θα χρειαστεί να κάνετε μια δήλωση για να δείξετε ότι τα πνευματικά δικαιώματα έχουν αρθεί, έτσι ώστε άλλοι να γνωρίζουν ότι μπορούν να κάνουν ότι θέλουν με τα δεδομένα αυτά. Πρότυπα παραίτησης υπάρχουν ήδη ώς PDDL και CCZero αλλά μπορείτε να γράψετε και την δική σας με ωομικές συμβουλές.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    a_pddl 'Open Data Commons Public Domain Dedication and Licence (PDDL)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_cc0 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)',
      :text_as_statement => 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)'
    a_other 'Άλλο...',
      :text_as_statement => ''

    q_dataOtherWaiver 'Πού είναι η παραίτηση των πνευματικών δικαιωμάτων στα δεδομένα;',
      :discussion_topic => :gr_dataOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δικαιώματα στα δεδομένα έχουν αρθεί με',
      :help_text => 'Δώστε ένα σύνδεσμο(URL) της δημόσια διαθέσιμης παραίτησής σας, έτσι ώστε να μπορεί να ελεγχθεί η άρση των πνευματικών δικαιωμάτων στα δεδομένα.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_dataLicence, '==', :a_na
    condition_B :q_dataNotApplicable, '==', :a_waived
    condition_C :q_dataWaiver, '==', :a_other
    a_1 'Σύνδεσμος(URL) Παραίτησης',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Σύνδεσμος(URL) Παραίτησης'

    q_otherDataLicenceName 'Ποιο είναι το όνομα της άδειας;',
      :discussion_topic => :gr_otherDataLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα είναι διαθέσιμα υπό',
      :help_text => 'Εάν χρησιμοποιείτε μια διαφορετική άδεια, χρειαζόμαστε το όνομα της έτσι ώστε κάποιος να μπορεί να δει το Πιστοποιητικό Ανοικτών Δεδομένων.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Άλλο Όνομα Άδειας',
      :string,
      :required => :required,
      :placeholder => 'Άλλο Όνομα Άδειας'

    q_otherDataLicenceURL 'Πού είναι η άδεια;',
      :discussion_topic => :gr_otherDataLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Η άδεια αυτή είναι σε',
      :help_text => 'Δώστε μια διεύθυνση(URL) για την άδεια, έτσι ώστε κάποιος να μπορεί να δει το Πιστοποιητικό Ανοικτών Δεδομένων και να ελέγξει ότι έιναι δημόσια διαθέσιμο.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_1 'Σύνδεσμος(URL) Άλλης Άδειας',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Σύνδεσμος(URL) Άλλης Άδειας'

    q_otherDataLicenceOpen 'Είναι η άδεια μια ανοικτή άδεια;',
      :discussion_topic => :gr_otherDataLicenceOpen,
      :help_text => 'Αν δεν είστε σίγουροι για το τι είναι μια ανοιχτή άδεια τότε διαβάστε στο <a href="http://licenses.opendefinition.org/">Open Definition Advisory Board open licence list </a>. Εάν η άδεια δεν είναι στη λίστα τους, τότε είτε δεν είναι ανοιχτή, είτε δεν έχει αξιολογηθεί ακόμα.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A'
    condition_A :q_dataLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_7']

    label_basic_7 'Θα πρέπει να <strong>δημοσιεύετε ανοιχτά δεδομένα, με ανοιχτή άδεια </strong> έτσι ώστε όλοι να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_7'
    dependency :rule => 'A and B'
    condition_A :q_dataLicence, '==', :a_other
    condition_B :q_otherDataLicenceOpen, '==', :a_false

    q_contentRights 'Υπάρχουν κάποια πνευματικά δικαιώματα στο περιεχόμενο αυτών των δεδομένων;',
      :discussion_topic => :gr_contentRights,
      :display_on_certificate => true,
      :text_as_statement => 'Υπάρχουν',
      :pick => :one,
      :required => :required
    a_norights 'Όχι, τα δεδομένα περιέχουν μόνο στοιχεία και αριθμούς',
      :text_as_statement => 'κανένα δικαίωμα στο περιεχόμενο των δεδομένων',
      :help_text => 'Δεν υπάρχουν πνευματικά δικαίωματα σε πραγματικά στοιχεία. Εάν τα δεδομένα δεν περιέχουν οποιοδήποτε στοιχείο που να δημιουργήθηκε μέσα από την πνευματική προσπάθεια, τότε δεν υπάρχουν δικαιώματα πάνω στα δεδομένα.'
    a_samerights 'Ναι, και τα δικαιώματα όλων κατέχονται από το ίδιο πρόσωπο ή οργανισμό',
      :text_as_statement => '',
      :help_text => 'Επιλέξτε αυτή την επιλογή αν το περιεχόμενο των δεδομένων δημιουργήθηκε εξ\'ολοκλήρου απο το ίδιο πρόσωπο ή οργανισμό ή μεταφέρονται σε αυτό.'
    a_mixedrights 'Ναι, και τα δικαιώματα κατέχονται από διαφορετικούς ανθρώπους ή οργανισμούς',
      :text_as_statement => '',
      :help_text => 'Σε ορισμένα δεδομένα, τα δικαιώματα σε διαφορετικές εγγραφές κατέχονται από διαφορετικά άτομα ή οργανισμούς. Πληροφορίες σχετικά με τα δικαιώματα θα πρέπει επίσης να διατηρούνται μέσα στα δεδομένα.'

    q_explicitWaiver 'Είναι το περιεχόμενο των δεδομένων επισημασμένο ως δημόσιος τομέας;',
      :discussion_topic => :gr_explicitWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Το περιεχόμενο έχει',
      :help_text => 'Το περιεχόμενο μπορεί να επισημανθεί ως δημόσιος τομέας με τη χρήση του <a href="http://creativecommons.org/publicdomain/">Creative Commons Σήμα Δημόσιου Τομέα </a>. Αυτό βοηθά όλους να γνωρίζουν ότι μπορούν να τα επαναχρησιμοποιήσουν ελεύθερα.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_norights
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'επισημασμένο ως δημόσιος τομέας',
      :requirement => ['standard_3']

    label_standard_3 'Θα πρέπει να <strong>σηματοδοτήσετε ως δημόσιο τομέα περιεχόμενο που ανήκει στο δημόσιο τομέα </strong> έτσι ώστε ο κόσμος να γνωρίζουν ότι μπορεί να το επαναχρησιμοποιήσει.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_3'
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_norights
    condition_B :q_explicitWaiver, '==', :a_false

    q_contentLicence 'Υπό ποια άδεια μπορεί κάποιος να επαναχρησιμοποιήσει το περιεχόμενο;',
      :discussion_topic => :gr_contentLicence,
      :display_on_certificate => true,
      :text_as_statement => 'Το περιεχόμενο διατίθεται υπό',
      :help_text => 'Θυμηθείτε ότι όποιος αφιερώνει διανοητική προσπάθεια για την δημιουργία κάποιου περιεχομένου παίρνει αυτόματα τα δικαιώματα πάνω του, αλλά αυτό το δημιουργικό περιεχόμενο δεν περιλαμβάνει γεγονότα. Έτσι κάποιος θα χρειαστεί μια παραίτηση ή άδεια η οποία να αποδεικνύει ότι μπορεί να το χρησιμοποιήσει και να εξηγεί πως μπορεί να το κάνει νόμιμα. Παραθέτουμε τις πιο συνηθισμένες άδειες εδώ; αν δεν υπάρχουν πνευματικά δικαιώματα στο περιεχόμενο, είτε έχουν λήξει είτε έχετε παραιτηθεί από αυτά, τότε επιλέξτε \'Δεν εφαρμόζεται\'.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_samerights
    a_cc_by 'Creative Commons Αναφορά',
      :text_as_statement => 'Creative Commons Αναφορά'
    a_cc_by_sa 'Creative Commons Αναφορά - Παρόμοια διανομή',
      :text_as_statement => 'Creative Commons Αναφορά - Παρόμοια διανομή'
    a_cc_zero 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)',
      :text_as_statement => 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)'
    a_na 'Δεν εφαρμόζεται',
      :text_as_statement => ''
    a_other 'Άλλο',
      :text_as_statement => ''

    q_contentNotApplicable 'Γιατί δεν ισχύει κάποια άδεια για το περιεχόμενο αυτών των δεδομένων;',
      :discussion_topic => :gr_contentNotApplicable,
      :display_on_certificate => true,
      :text_as_statement => 'Το περιεχόμενο σε αυτά τα δεδομένα, δεν έχει την άδεια, επειδή',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    a_norights 'δεν υπάρχουν πνευματικά δικαιωμάτα στο περιεχόμενο αυτών των δεδομένων',
      :text_as_statement => 'δεν υπάρχουν πνευματικά δικαιωμάτα',
      :help_text => 'Δικαιώματα πνευματικής ιδιοκτησίας ισχύουν μόνο για το περιεχόμενο αν αναλώθηκε πνευματική προσπάθεια δημιουργώντας αυτό, για παράδειγμα, γράφοντας το κείμενο που είναι μέσα στα δεδομένα. Δεν υπάρχουν πνευματικά δικαιώματα, αν το περιεχόμενο περιέχει μόνο τα γεγονότα.'
    a_expired 'τα πνευματικά δικαιώματα έχουν λήξει',
      :text_as_statement => 'τα πνευματικά δικαιώματα έχουν λήξει',
      :help_text => 'Τα πνευματικά δικαιώματα διαρκούν για ένα συγκεκριμένο χρονικό διάστημα, με βάση είτε τον αριθμό των ετών μτά τον θάνατο του δημιουργού είτε της δημοσίευσής του. Θα πρέπει να ελέγξετε για το πότε το περιεχόμενο είχε δημιουργηθεί ή δημοσιευθεί επειδή εάν αυτό είχε συμβεί πριν πολύ καιρό τότε μπορεί τα πνευματικά δικαιώματα να έχουν λήξει.'
    a_waived 'τα πνευματικά δικαιώματα έχουν αρθεί',
      :text_as_statement => '',
      :help_text => 'Αυτό σημαίνει ότι κανείς δεν κατέχει πνευματικά δικαιώματα και ο καθένας μπορεί να κάνει ό, τι θέλει με αυτά τα δεδομένα.'

    q_contentWaiver 'Ποια παραίτηση χρησιμοποιείτε για την άρση πνευματικών δικαιωμάτων;',
      :discussion_topic => :gr_contentWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Τα πνευματικά δικαιώματα έχουν αρθεί με',
      :help_text => 'Χρειάζεται μια δήλωση για να δείξετε στους άλλους ότι το έχετε κάνει αυτό, ούτως ώστε να καταλάβουν ότι μπορούν να κάνουν ότι θέλουν με αυτά τα δεδομένα. Πρότυπα παραιτήσεων υπάρχουν ήδη όπως το CCZero αλλά μπορείτε να συντάξετε και το δικό σας με τη βοήθεια νομικών συμβουλών.',
      :pick => :one,
      :required => :required,
      :display_type => 'dropdown'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    a_cc0 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)',
      :text_as_statement => 'Creative Commons Εκχώρηση ως Κοινό Κτήμα (CCZero)'
    a_other 'Άλλο',
      :text_as_statement => 'Άλλο'

    q_contentOtherWaiver 'Που είναι η άρση των πνευματικών δικαιωμάτων;',
      :discussion_topic => :gr_contentOtherWaiver,
      :display_on_certificate => true,
      :text_as_statement => 'Τα πνευματικά δικαιώματα έχουν αρθεί με',
      :help_text => 'Δώστε ένα σύνδεσμο URL της δικής σας δημόσια διαθέσιμης παραίτησης, ώστε οποιοσδήποτε να μπορεί να ελέγξει ότι όντως παραιτείστε από τα πνευματικά δικαιώματα.',
      :required => :required
    dependency :rule => 'A and B and C and D'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_na
    condition_C :q_contentNotApplicable, '==', :a_waived
    condition_D :q_contentWaiver, '==', :a_other
    a_1 'Σύνδεσμος(URL) Παραίτησης',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Σύνδεσμος(URL) Παραίτησης'

    q_otherContentLicenceName 'Ποιό είναι το όνομα της άδειας;',
      :discussion_topic => :gr_otherContentLicenceName,
      :display_on_certificate => true,
      :text_as_statement => 'Το περιεχόμενο είναι διαθέσιμο υπό',
      :help_text => 'Εάν χρησιμοποιείτε μια διαφορετική άδεια, χρειαζόμαστε το όνομα της έτσι ώστε κάποιος να μπορεί να δει το Πιστοποιητικό Ανοικτών Δεδομένων.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Όνομα Άδειας',
      :string,
      :required => :required,
      :placeholder => 'Όνομα Άδειας'

    q_otherContentLicenceURL 'Που είναι η άδεια;',
      :discussion_topic => :gr_otherContentLicenceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Το περιεχόμενο της άδειας είναι στο',
      :help_text => 'Δώστε μια διεύθυνση(URL) για την άδεια, έτσι ώστε κάποιος να μπορεί να δει το Πιστοποιητικό Ανοικτών Δεδομένων και να ελέγξει ότι έιναι δημόσια διαθέσιμο.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_1 'Σύνδεσμος(URL) Άδειας',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Σύνδεσμος(URL) Άδειας'

    q_otherContentLicenceOpen 'Είναι η άδεια μια ανοικτή άδεια;',
      :discussion_topic => :gr_otherContentLicenceOpen,
      :help_text => 'Αν δεν είστε σίγουροι για το τι είναι μια ανοιχτή άδεια τότε διαβάστε στο <a href="http//opendefinition.org/">Open Knowledge Definition</a> definition. Στη συνέχεια, επιλέξτε την άδεια σας από την <a href="http//licenses.opendefinition.org/">Open Definition Advisory Board open licence list</a>. Εάν η άδεια δεν είναι στη λίστα τους, τότε είτε δεν είναι ανοιχτή, είτε δεν έχει αξιολογηθεί ακόμα.',
      :help_text_more_url => 'http://opendefinition.org/',
      :pick => :one,
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    a_false 'no'
    a_true 'yes',
      :requirement => ['basic_8']

    label_basic_8 'Θα πρέπει να <strong>δημοσιεύετε ανοιχτά δεδομένα με ανοιχτή άδεια </strong>έτσι ώστε άλλοι να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_8'
    dependency :rule => 'A and B and C'
    condition_A :q_contentRights, '==', :a_samerights
    condition_B :q_contentLicence, '==', :a_other
    condition_C :q_otherContentLicenceOpen, '==', :a_false

    q_contentRightsURL 'Που εξηγούνται τα δικαιώματα και η αδειοδότηση του περιεχομένου;',
      :discussion_topic => :gr_contentRightsURL,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δικαιώματα και η αδειοδότηση του περιεχομένου εξηγούνται στο',
      :help_text => 'Δώστε μια διεύθυνση URL σελίδας όπου περιγράφετε το πως κάποιος μπορεί να βρει τα δικαιώματα και τις άδειες ενός κομματιού από το περιεχόμενο των δεδομένων.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_contentRights, '==', :a_mixedrights
    a_1 'Σύνδεσμος(URL) Περιγραφής Δικαιωμάτων Περιεχομένου (Content Rights Description)',
      :string,
      :input_type => :url,
      :required => :required,
      :placeholder => 'Σύνδεσμος(URL) Περιγραφής Δικαιωμάτων Περιεχομένου (Content Rights Description)'

    q_copyrightStatementMetadata 'Περιλαμβάνει η δήλωση των δικαιωμάτων σας αναγνώσιμες από την μηχανή εκδόσεις;',
      :discussion_topic => :gr_copyrightStatementMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Η δήλωση των δικαιωμάτων περιλαμβάνει δεδομένα σχετικά με',
      :help_text => 'Είναι καλή πρακτική να ενσωματώσετε πληροφορίες σχετικά με τα δικαιώματα σε μορφές αναγνώσιμες απο την μηχανή, έτσι ώστε οι άλλοι να μπορούν αυτόματα να σας αποδώσουν πίσω τα δεδομένα όταν τα χρησιμοποιούν.',
      :help_text_more_url => 'https://github.com/theodi/open-data-licensing/blob/master/guides/publisher-guide.md',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    a_dataLicense 'άδεια δεδομένων',
      :text_as_statement => 'η άδεια των δεδομένων του',
      :requirement => ['standard_4']
    a_contentLicense 'άδεια περιεχομένου',
      :text_as_statement => 'η άδεια του περιεχομένου του',
      :requirement => ['standard_5']
    a_attribution 'απόδοση κειμένου',
      :text_as_statement => 'ποια απόδοση κειμένου να χρησιμοποιηθεί',
      :requirement => ['standard_6']
    a_attributionURL 'Σύνδεσμος(URL) απόδοσης',
      :text_as_statement => 'ποια σύνδεση απόδοσης να δωθεί',
      :requirement => ['standard_7']
    a_copyrightNotice 'σημείωση πνευματικών δικαιωμάτων ή δήλωση',
      :text_as_statement => 'μια σημείωση πνευματικών δικαιωμάτων ή δήλωση',
      :requirement => ['exemplar_1']
    a_copyrightYear 'έτος των πνευματικών δικαιωμάτων',
      :text_as_statement => 'το έτος των πνευματικών δικαιωμάτων',
      :requirement => ['exemplar_2']
    a_copyrightHolder 'κάτοχος των πνευματικών δικαιωμάτων',
      :text_as_statement => 'ο κάτοχος των πνευματικών δικαιωμάτων',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'χρονολογία των δικαιωμάτων της βάσης δεδομένων',
      :text_as_statement => 'η χρονολογία των δικαιωμάτων της βάσης δεδομένων',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'κάτοχος των δικαιωμάτων της βάσης δεδομένων',
      :text_as_statement => 'ο κάτοχος των δικαιωμάτων της βάσης δεδομένων',
      :requirement => ['exemplar_5']

    label_standard_4 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με την άδεια </strong> για αυτά τα δεδομένα,έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_dataLicense

    label_standard_5 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με την άδεια για το περιεχόμενο</strong> για αυτά τα δεδομένα, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_contentLicense

    label_standard_6 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με το κείμενο που θα χρησιμοποιηθεί όταν αναφέρεται στα δεδομένα</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_6'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attribution

    label_standard_7 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με το σύνδεσμο(URL) της σύνδεσής του όταν παραθέτονται αυτά τα δεδομένα</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_7'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_attributionURL

    label_exemplar_1 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με την σημείωση πνευματικών δικαιωμάτων ή δήλωση αυτών των δεδομένων</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_1'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightNotice

    label_exemplar_2 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με το έτος των πνευματικών δικαιωμάτων αυτών των δεδομένων</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_2'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightYear

    label_exemplar_3 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με τον κάτοχο των πνευματικών δικαιωμάτων αυτών των δεδομένων</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_3'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_copyrightHolder

    label_exemplar_4 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με τη χρονολογία των δικαιωμάτων της βάσης δεδομένων αυτών των δεδομένων</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_4'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightYear

    label_exemplar_5 'Θα πρέπει να δώσετε <strong>αναγώσιμα απο την μηχανή δεδομένα στη δήλωση των δικαιωμάτων σας σχετικά με τον κάτοχο των δικαιωμάτων της βάσης δεδομένων αυτών των δεδομένων</strong>, έτσι ώστε αυτόματα εργαλεία να μπορούν να τα χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_5'
    dependency :rule => 'A and B'
    condition_A :q_copyrightURL, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_copyrightStatementMetadata, '!=', :a_databaseRightHolder

    label_group_4 'Ιδιωτικότητα και προστασία δεδομένων προσωπικού χαρακτήρα',
      :help_text => 'Πώς να προστατέψετε την ιδιωτικότητα των ανθρώπων',
      :customer_renderer => '/partials/fieldset'

    q_dataPersonal 'Μπορούν να αναγνωριστούν άτομα από αυτά τα δεδομένα;',
      :discussion_topic => :gr_dataPersonal,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα περιέχουν',
      :pick => :one,
      :required => :pilot
    a_not_personal 'Όχι, τα δεδομένα δεν είναι για ανθρώπους ή τις δραστηριότητές τους',
      :text_as_statement => 'δεν υπάρχουν στοιχεία για τα άτομα',
      :help_text => 'Να θυμάστε ότι τα άτομα μπορούν ακόμα να προσδιορίζονται ακόμη και αν τα δεδομένα δεν είναι άμεσα γι \'αυτούς. Για παράδειγμα, τα δεδομένα ροής της οδικής κυκλοφορίας σε συνδυασμό με τα σχέδια μετακίνησης ενός ατόμου θα μπορούσαν να αποκαλύψουν πληροφορίες σχετικά με το εν λόγω πρόσωπο.'
    a_summarised 'όχι, τα δεδομένα έχουν καταστεί ανώνυμα με τη συγκέντρωση των ατόμων σε ομάδες, έτσι δεν μπορούν να διακριθούν από άλλα άτομα στην ομάδα',
      :text_as_statement => 'συσσωρευμένα δεδομένα',
      :help_text => 'Συστήματα στατιστικού ελέγχου διασφαλίζουν ότι δεν είναι δυνατός ο προσδιορισμός του προσώπου με τη χρήση συσσωρευμένων δεδομένων.'
    a_individual 'ναι, υπάρχει ο κίνδυνος ταυτοποίησης προσώπων, για παράδειγμα, από τρίτους που έχουν πρόσβαση σε επιπλέον πληροφορίες',
      :text_as_statement => 'πληροφορίες που θα μπορούσαν να προσδιορίσουν άτομα',
      :help_text => 'Κάποια στοιχεία είναι νόμιμα για άτομα όπως αμοιβές δημοσίων υπαλλήλων ή δημόσιων δαπανών για παράδειγμα.'

    q_statisticalAnonAudited 'Έχει η διαδικασία της ανωνυμοποίησης σας υποβληθεί σε ανεξάρτητο έλεγχο;',
      :discussion_topic => :gr_statisticalAnonAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Η διαδικασία της ανωνυμοποίησης έχει',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_summarised
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ελέγχονται ανεξάρτητα',
      :requirement => ['standard_8']

    label_standard_8 'Θα πρέπει <strong>η διαδικασία της ανωνυμοποίησης σας ελέγχονται ανεξάρτητα </strong> για να εξασφαλίσει ότι μειώνει τον κίνδυνο των ατόμων που ήδη ταυτοποιηθει.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_8'
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_summarised
    condition_B :q_statisticalAnonAudited, '==', :a_false

    q_appliedAnon 'Έχετε προσπαθήσει να μειώσετε ή να καταργήσετε τη δυνατότητα των ατόμων να εντοπιστούν;',
      :discussion_topic => :gr_appliedAnon,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα σχετικά με άτομα ήταν',
      :help_text => 'Η ανωνυμοποίηση μειώνει τον κίνδυνο προσδιορισμού ατόμων στα δεδομένα που δημοσιεύετε. Η καλύτερη τεχνική για να χρησιμοποιήσετε εξαρτάται από το είδος των δεδομένων που έχετε.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ανωνυμοποίηση'

    q_lawfulDisclosure 'Απαιτείται ή επιτρέπεται από το νόμο να δημοσιεύσετε αυτά τα δεδομένα σχετικά με άτομα;',
      :discussion_topic => :gr_lawfulDisclosure,
      :display_on_certificate => true,
      :text_as_statement => 'Σύμφωνα με το νόμο, αυτά τα στοιχεία για άτομα',
      :help_text => 'Θα πρέπει να <strong>δημοσιεύετε προσωπικά δεδομένα χωρίς ανωνυμοποίηση αν σας απαιτείται ή επιτρέπεται να το πράξετε από το νόμο </strong>.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'πρέπει να δημοσιεύονται',
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

    q_lawfulDisclosureURL 'Πού τεκμηριώνετε το δικαίωμά σας να δημοσιεύετε στοιχεία για άτομα;',
      :discussion_topic => :gr_lawfulDisclosureURL,
      :display_on_certificate => true,
      :text_as_statement => 'Το δικαίωμα να δημοσιεύσει δεδομένα σχετικά με άτομα είναι ήδη καταχωρημένο στην'
    dependency :rule => 'A and B and C'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_1 'Σύνδεσμος(URL) Disclosure Rationale',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Disclosure Rationale',
      :requirement => ['standard_9']

    label_standard_9 'Θα πρέπει να <strong>τεκμηριώνετε το δικαίωμά σας να δημοσιεύετε στοιχεία για άτομα </strong> ως προς αυτούς που χρησιμοποιούν τα δεδομένα σας και για εκείνους που πλήττονται από τη κοινολόγηση.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_9'
    dependency :rule => 'A and B and C and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_false
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_lawfulDisclosureURL, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentExists 'Έχετε εκτιμήσει τους κινδύνους αποκάλυψης προσωπικών δεδομένων;',
      :discussion_topic => :gr_riskAssessmentExists,
      :display_on_certificate => true,
      :text_as_statement => 'Ο επιμελητής έχει',
      :help_text => 'Μια εκτίμηση κινδύνου μετρά τους κινδύνους για την προστασία της ιδιωτικότητας των ατόμων στα δεδομένα σας, καθώς και τη χρήση και την αποκάλυψη των εν λόγω πληροφοριών.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'δεν πραγματοποίησε εκτίμηση των κινδύνων της ιδιωτικότητας'
    a_true 'yes',
      :text_as_statement => 'πραγματοποίησε εκτίμηση των κινδύνων της ιδιωτικότητας',
      :requirement => ['pilot_6']

    label_pilot_6 'Θα πρέπει να <strong>εκτιμήσετε τους κινδύνους αποκάλυψης προσωπικών δεδομένων </strong> αν δημοσιεύετε δεδομένα σχετικά με άτομα.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_6'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_false

    q_riskAssessmentUrl 'Που δημοσιεύθηκε η εκτίμηση κινδύνου σας',
      :discussion_topic => :gr_riskAssessmentUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Η εκτίμηση κινδύνου δημοσιεύεται στο',
      :help_text => 'Δώστε μια διεύθυνση URL όπου κάποιος θα μπορεί να ελέγξει τον τρόπο που έχετε εκτιμήσει τους κινδύνους της ιδιωτικότητας των ατόμων. Αυτό μπορεί να αναθεωρηθεί ή περιληφθεί, εάν περιέχει ευαίσθητες πληροφορίες.'
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_1 'Σύνδεσμος(URL) Εκτίμησης Κινδύνου (Risk Assessment)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Εκτίμησης Κινδύνου (Risk Assessment)',
      :requirement => ['standard_10']

    label_standard_10 'Θα πρέπει να <strong>δημοσιεύσετε την εκτίμηση κινδύνου της ιδιωτικότητας </strong> έτσι ώστε οι άνθρωποι να μπορούν να καταλάβουν πώς έχετε εκτιμήσε τους κινδύνους αποκάλυψης των δεδομένων.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_10'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_riskAssessmentAudited 'Έχει η αξιολόγηση κινδύνου σας υποβληθεί σε ανεξάρτητο έλεγχο;',
      :discussion_topic => :gr_riskAssessmentAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Η εκτίμηση κινδύνου έχει',
      :help_text => 'Είναι καλή πρακτική να ελέγχετε ότι η εκτίμηση του κινδύνου σας έγινε σωστά. Ανεξάρτητοι έλεγχοι από ειδικούς ή τρίτους τείνουν να είναι πιο αυστηροί και αμερόληπτοι.',
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
      :text_as_statement => 'ανεξάρτητα ελεγμένο',
      :requirement => ['standard_11']

    label_standard_11 'Θα πρέπει να <strong>έχει η εκτίμηση του κινδύνου σας ελέγθεί ανεξάρτητα </strong> για να βεβαιωθείτε ότι έχει εκτελεστεί σωστά.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_11'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_riskAssessmentUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_F :q_riskAssessmentAudited, '==', :a_false

    q_individualConsentURL 'Πού είναι το σημείωμα Ιδιωτικότητας και προστασίας δεδομένων προσωπικού χαρακτήρα για τα άτομα που πλήττονται από τα δεδομένα σας;',
      :discussion_topic => :gr_individualConsentURL,
      :display_on_certificate => true,
      :text_as_statement => 'Τα άτομα που επηρεάζονται από αυτά τα δεδομένα έχουν αυτό το σημείωμα Ιδιωτικότητας και προστασίας δεδομένων προσωπικού χαρακτήρα',
      :help_text => 'Όταν συλλέγετε δεδομένα σχετικά με άτομα πρέπει να τους πείτε πώς θα χρησιμοποιηθούν αυτά τα δεδομένα. Οι άνθρωποι που χρησιμοποιούν τα δεδομένα σας, το χρειάζονται αυτό για να βεβαιωθούν ότι συμμορφώνονται με το νόμο περί προστασίας δεδομένων (Data Protection Act).'
    dependency :rule => 'A and (B or C) and D and E'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    a_1 'Σύνδεσμος(URL) Σημειώματος Ιδιωτικότητας και προστασίας δεδομένων προσωπικού χαρακτήρα',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Σημειώματος Ιδιωτικότητας και προστασίας δεδομένων προσωπικού χαρακτήρα',
      :requirement => ['pilot_7']

    label_pilot_7 'Θα πρέπει να <strong>πείτε στον κόσμο για ποιούς σκοπούς τα άτομα στα δεδομένα σας έδωσαν τη συγκατάθεσή τους σε εσάς να χρησιμοποιήσετε τα στοιχεία τους </strong>. Έτσι ώστε να χρησιμοποιούνται τα δεδομένα σας για τους ίδιους σκοπούς και να συμμορφώνονται με το νόμο περί προστασίας δεδομένων (Data Protection Act).',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_7'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_lawfulDisclosure, '!=', :a_true
    condition_F :q_individualConsentURL, '==', {:string_value => '', :answer_reference => '1'}

    q_dpStaff 'Υπάρχει κάποιος στον οργανισμό σας ο οποίος είναι υπεύθυνος για την προστασία των δεδομένων;',
      :discussion_topic => :gr_dpStaff,
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_dbStaffConsulted 'Τους έχετε εμπλέξει στη διαδικασία Εκτίμησης των Επιπτώσεων Προστασίας Δεδομένων Προσωπικού Χαρακτήρα (Privacy Impact Assessment process);',
      :discussion_topic => :gr_dbStaffConsulted,
      :display_on_certificate => true,
      :text_as_statement => 'Το άτομο που είναι υπεύθυνο για την προστασία των δεδομένων',
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
      :text_as_statement => 'διαβουλεύθηκε',
      :requirement => ['pilot_8']

    label_pilot_8 'Θα πρέπει να <strong>περιλάβετε το πρόσωπο που είναι υπεύθυνο για την προστασία των δεδομένων </strong> στον οργανισμό σας πριν από τη δημοσίευση αυτών των δεδομένων.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_8'
    dependency :rule => 'A and (B or C) and D and E and F'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    condition_E :q_dpStaff, '==', :a_true
    condition_F :q_dbStaffConsulted, '==', :a_false

    q_anonymisationAudited 'Έχει η προσέγγιση ανωνυμοποίησής σας υποβληθεί σε ανεξάρτητο έλεγχο;',
      :discussion_topic => :gr_anonymisationAudited,
      :display_on_certificate => true,
      :text_as_statement => 'Η ανωνυμοποίηση των δεδομένων έχει',
      :help_text => 'Είναι καλή πρακτική να βεβαιωθείτε ότι η διαδικασία αφαίρεσης προσωπικά αναγνωρίσιμων δεδομένων λειτουργεί σωστά. Ανεξάρτητοι έλεγχοι από ειδικούς ή τρίτους τείνουν να είναι πιο αυστηροί και αμερόληπτοι.',
      :pick => :one
    dependency :rule => 'A and (B or C) and D'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    condition_D :q_riskAssessmentExists, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ελέγχονται ανεξάρτητα',
      :requirement => ['standard_12']

    label_standard_12 'Θα πρέπει <strong>η διαδικασία ανωνυμοποίησής σας να ελέγχεται ανεξάρτητα </strong> από έναν εμπειρογνώμονα για να εξασφαλιστεί ότι είναι κατάλληλη για τα δεδομένα σας.',
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

    label_group_6 'Findability',
      :help_text => 'how you help people find your data',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Is there a link to your data from your main website?',
      :discussion_topic => :onWebsite,
      :help_text => 'Data can be found more easily if it is linked to from your main website.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 'You should <strong>ensure that people can find the data from your main website</strong> so that people can find it more easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'Web Page' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Which page on your website links to the data?',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'The website links to the data from',
        :help_text => 'Give a URL on your main website that includes a link to this data.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'Web page URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Web page URL'

    end

    q_listed 'Is your data listed within a collection?',
      :discussion_topic => :listed,
      :help_text => 'Data is easier for people to find when it\'s in relevant data catalogs like academic, public sector or health for example, or when it turns up in relevant search results.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 'You should <strong>ensure that people can find your data when they search for it</strong> in locations that list data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Listing' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Where is it listed?',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'The data appears in this collection',
        :help_text => 'Give a URL where this data is listed within a relevant collection. For example, data.gov.uk (if it\'s UK public sector data), hub.data.ac.uk (if it\'s UK academia data) or a URL for search engine results.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Listing URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Listing URL'

    end

    q_referenced 'Is this data referenced from your own publications?',
      :discussion_topic => :referenced,
      :help_text => 'When you reference your data within your own publications, such as reports, presentations or blog posts, you give it more context and help people find and understand it better.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_15']

    label_standard_15 'You should <strong>reference data from your own publications</strong> so that people are aware of its availability and context.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Reference' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Where is your data referenced?',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'This data is referenced from',
        :help_text => 'Give a URL to a document that cites or references this data.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'Reference URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Reference URL'

    end

    label_group_7 'Accuracy',
      :help_text => 'how you keep your data up-to-date',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Does the data behind your API change?',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'The data behind the API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'no, the API gives access to unchanging data',
      :text_as_statement => 'will not change',
      :help_text => 'Some APIs just make accessing an unchanging dataset easier, particularly when there\'s lots of it.'
    a_changing 'yes, the API gives access to changing data',
      :text_as_statement => 'will change',
      :help_text => 'Some APIs give instant access to more up-to-date and ever-changing data'

    q_timeSensitive 'Will your data go out of date?',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'The accuracy or relevance of this data will',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'yes, this data will go out of date',
      :text_as_statement => 'go out of date',
      :help_text => 'For example, a dataset of bus stop locations will go out of date over time as some are moved or new ones created.'
    a_timestamped 'yes, this data will go out of date over time but it’s time stamped',
      :text_as_statement => 'go out of date but it is timestamped',
      :help_text => 'For example, population statistics usually include a fixed timestamp to indicate when the statistics were relevant.',
      :requirement => ['pilot_9']
    a_false 'no, this data does not contain any time-sensitive information',
      :text_as_statement => 'not go out of date',
      :help_text => 'For example, the results of an experiment will not go out of date because the data accurately reports observed outcomes.',
      :requirement => ['standard_16']

    label_pilot_9 'You should <strong>put timestamps in your data when you release it</strong> so people know the period it relates to and when it will expire.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'You should <strong>publish updates to time-sensitive data</strong> so that it does not go stale.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Does this data change at least daily?',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'This data changes',
      :help_text => 'Tell people if the underlying data changes on most days. When data changes frequently it also goes out of date quickly, so people need to know if you also update it frequently and quickly too.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'at least daily'

    q_seriesType 'What type of dataset series is this?',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'This data is a series of',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'regular copies of a complete database',
      :text_as_statement => 'copies of a database',
      :help_text => 'Choose if you publish new and updated copies of your full database regularly. When you create database dumps, it\'s useful for people to have access to a feed of the changes so they can keep their copies up to date.'
    a_aggregate 'regular aggregates of changing data',
      :text_as_statement => 'aggregates of changing data',
      :help_text => 'Choose if you create new datasets regularly. You might do this if the underlying data can\'t be released as open data or if you only publish data that\'s new since the last publication.'

    q_changeFeed 'Is a feed of changes available?',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'A feed of changes to this data',
      :help_text => 'Tell people if you provide a stream of changes that affect this data, like new entries or amendments to existing entries. Feeds might be in RSS, Atom or custom formats.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'is available',
      :requirement => ['exemplar_6']

    label_exemplar_6 'You should <strong>provide a feed of changes to your data</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'How often do you create a new release?',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'New releases of this data are made',
      :help_text => 'This determines how out of date this data becomes before people can get an update.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'less than once a month',
      :text_as_statement => 'less than once a month'
    a_monthly 'at least every month',
      :text_as_statement => 'at least every month',
      :requirement => ['pilot_10']
    a_weekly 'at least every week',
      :text_as_statement => 'at least every week',
      :requirement => ['standard_17']
    a_daily 'at least every day',
      :text_as_statement => 'at least every day',
      :requirement => ['exemplar_7']

    label_pilot_10 'You should <strong>create a new dataset release every month</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'You should <strong>create a new dataset release every week</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'You should <strong>create a new dataset release every day</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'How long is the delay between when you create a dataset and when you publish it?',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'The lag between creation and publication of this data is',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'longer than the gap between releases',
      :text_as_statement => 'longer than the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes more than a day for it to be published.'
    a_reasonable 'about the same as the gap between releases',
      :text_as_statement => 'about the same as the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes about a day for it to be published.',
      :requirement => ['pilot_11']
    a_good 'less than half the gap between releases',
      :text_as_statement => 'less than half the gap between releases',
      :help_text => 'For example, if you create a new version of the dataset every day, choose this if it takes less than twelve hours for it to be published.',
      :requirement => ['standard_18']
    a_minimal 'there is minimal or no delay',
      :text_as_statement => 'minimal',
      :help_text => 'Choose this if you publish within a few seconds or a few minutes.',
      :requirement => ['exemplar_8']

    label_pilot_11 'You should <strong>have a reasonable delay between when you create and publish a dataset</strong> that is less than the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'You should <strong>have a short delay between when you create and publish a dataset</strong> that is less than half the gap between releases so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'You should <strong>have minimal or no delay between when you create and publish a dataset</strong> so people keep their copies up-to-date and accurate.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Do you also publish dumps of this dataset?',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'The curator publishes',
      :help_text => 'A dump is an extract of the whole dataset into a file that people can download. This lets people do analysis that\'s different to analysis with API access.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'dumps of the data',
      :requirement => ['standard_19']

    label_standard_19 'You should <strong>let people download your entire dataset</strong> so that they can do more complete and accurate analysis with all the data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'How frequently do you create a new database dump?',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Database dumps are created',
      :help_text => 'Faster access to more frequent extracts of the whole dataset means people can get started quicker with the most up-to-date data.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'less frequently than once a month',
      :text_as_statement => 'less frequently than once a month'
    a_monthly 'at least every month',
      :text_as_statement => 'at least every month',
      :requirement => ['pilot_12']
    a_weekly 'within a week of any change',
      :text_as_statement => 'within a week of any change',
      :requirement => ['standard_20']
    a_daily 'within a day of any change',
      :text_as_statement => 'within a day of any change',
      :requirement => ['exemplar_9']

    label_pilot_12 'You should <strong>create a new database dump every month</strong> so that people have the latest data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'You should <strong>create a new database dump within a week of any change</strong> so that people have less time to wait for the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'You should <strong>create a new database dump within a day of any change</strong> so that people find it easier to get the latest data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Will your data be corrected if it has errors?',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Any errors in this data are',
      :help_text => 'It\'s good practice to fix errors in your data especially if you use it yourself. When you make corrections, people need to be told about them.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'corrected',
      :requirement => ['standard_21']

    label_standard_21 'You should <strong>correct data when people report errors</strong> so everyone benefits from improvements in accuracy.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Quality',
      :help_text => 'how much people can rely on your data',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Where do you document issues with the quality of this data?',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Data quality is documented at',
      :help_text => 'Give a URL where people can find out about the quality of your data. People accept that errors are inevitable, from equipment malfunctions or mistakes that happen in system migrations. You should be open about quality so people can judge how much to rely on this data.'
    a_1 'Data Quality Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Data Quality Documentation URL',
      :requirement => ['standard_22']

    label_standard_22 'You should <strong>document any known issues with your data quality</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Where is your quality control process described?',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Quality control processes are described at',
      :help_text => 'Give a URL for people to learn about ongoing checks on your data, either automatic or manual. This reassures them that you take quality seriously and encourages improvements that benefit everyone.'
    a_1 'Quality Control Process Description URL',
      :string,
      :input_type => :url,
      :placeholder => 'Quality Control Process Description URL',
      :requirement => ['exemplar_10']

    label_exemplar_10 'You should <strong>document your quality control process</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Guarantees',
      :help_text => 'how much people can depend on your data’s availability',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Do you take offsite backups?',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'The data is',
      :help_text => 'Taking a regular offsite backup helps ensure that the data won\'t be lost in the case of accident.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'backed up offsite',
      :requirement => ['standard_23']

    label_standard_23 'You should <strong>take a result offsite backup</strong> so that the data won\'t be lost if an accident happens.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Where do you describe any guarantees about service availability?',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Service availability is described at',
      :help_text => 'Give a URL for a page that describes what guarantees you have about your service being available for people to use. For example you might have a guaranteed uptime of 99.5%, or you might provide no guarantees.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Service Availability Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Service Availability Documentation URL',
      :requirement => ['standard_24']

    label_standard_24 'You should <strong>describe what guarantees you have around service availability</strong> so that people know how much they can rely on it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Where do you give information about the current status of the service?',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Service status is given at',
      :help_text => 'Give a URL for a page that tells people about the current status of your service, including any faults you are aware of.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Service Status URL',
      :string,
      :input_type => :url,
      :placeholder => 'Service Status URL',
      :requirement => ['exemplar_11']

    label_exemplar_11 'You should <strong>have a service status page</strong> that tells people about the current status of your service.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'How long will this data be available for?',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'The data is available',
      :pick => :one
    a_experimental 'it might disappear at any time',
      :text_as_statement => 'experimentally and might disappear at any time'
    a_short 'it\'s available experimentally but should be around for another year or so',
      :text_as_statement => 'experimentally for another year or so',
      :requirement => ['pilot_13']
    a_medium 'it\'s in your medium-term plans so should be around for a couple of years',
      :text_as_statement => 'for at least a couple of years',
      :requirement => ['standard_25']
    a_long 'it\'s part of your day-to-day operations so will stay published for a long time',
      :text_as_statement => 'for a long time',
      :requirement => ['exemplar_12']

    label_pilot_13 'You should <strong>guarantee that your data will be available in this form for at least a year</strong> so that people can decide how much to rely on your data.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'You should <strong>guarantee that your data will be available in this form in the medium-term</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 'You should <strong>guarantee that your data will be available in this form in the long-term</strong> so that people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Technical Information',
    :description => 'Locations, formats and trust' do

    label_group_11 'Locations',
      :help_text => 'how people can access your data',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Where is your dataset?',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'This data is published at',
      :help_text => 'Give a URL to the dataset itself. Open data should be linked to directly on the web so people can easily find and reuse it.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dataset URL',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'You must <strong>provide either a URL to your data or a URL to documentation</strong> about it so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'You should <strong>have a URL that is a direct link to the data itself</strong> so that people can access it easily.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'How do you publish a series of the same dataset?',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current dataset.',
      :requirement => ['standard_26']
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your dataset URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['pilot_15']
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of datasets on a web page or a feed (like Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['standard_27']

    label_standard_26 'You should <strong>have a single persistent URL to download the current version of your data</strong> so that people can access it easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'You should <strong>use a consistent pattern for different release URLs</strong> so that people can download each one automatically.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'You should <strong>have a document or feed with a list of available releases</strong> so people can create scripts to download them all.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'You must <strong>provide access to releases of your data through a URL</strong> that gives the current version, a discoverable series of URLs or through a documentation page so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Where is your current dataset?',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The current dataset is available at',
      :help_text => 'Give a single URL to the most recent version of the dataset. The content at this URL should change each time a new version is released.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'Current Dataset URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dataset URL',
      :required => :required

    q_versionsTemplateUrl 'What format do dataset release URLs follow?',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Releases follow this consistent URL pattern',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'Version Template URL',
      :string,
      :input_type => :text,
      :placeholder => 'Version Template URL',
      :required => :required

    q_versionsUrl 'Where is your list of dataset releases?',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Releases of this data are listed at',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of datasets. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'Version List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Version List URL',
      :required => :required

    q_endpointUrl 'Where is the endpoint for your API?',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The API service endpoint is',
      :help_text => 'Give a URL that\'s a starting point for people\'s scripts to access your API. This should be a service description document that helps the script to work out which services exist.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Endpoint URL',
      :string,
      :input_type => :url,
      :placeholder => 'Endpoint URL',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'You must <strong>provide either an API endpoint URL or a URL to its documentation</strong> so that people can find it.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'You should <strong>have a service description document or single entry point for your API</strong> so that people can access it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'How do you publish database dumps?',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'as a single URL that\'s regularly updated',
      :help_text => 'Choose this if there\'s one URL for people to download the most recent version of the current database dump.',
      :requirement => ['standard_29']
    a_template 'as consistent URLs for each release',
      :help_text => 'Choose this if your database dump URLs follow a regular pattern that includes the date of publication, for example, a URL that starts \'2013-04\'. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['exemplar_13']
    a_list 'as a list of releases',
      :help_text => 'Choose this if you have a list of database dumps on a web page or a feed (such as Atom or RSS) with links to each individual release and its details. This helps people to understand how often you release data, and to write scripts that fetch new ones each time they\'re released.',
      :requirement => ['exemplar_14']

    label_standard_29 'You should <strong>have a single persistent URL to download the current dump of your database</strong> so that people can find it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 'You should <strong>use a consistent pattern for database dump URLs</strong> so that people can can download each one automatically.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 'You should <strong>have a document or feed with a list of available database dumps</strong> so people can create scripts to download them all',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Where is the current database dump?',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The most recent database dump is always available at',
      :help_text => 'Give a URL to the most recent dump of the database. The content at this URL should change each time a new database dump is created.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'Current Dump URL',
      :string,
      :input_type => :url,
      :placeholder => 'Current Dump URL',
      :required => :required

    q_dumpsTemplateUrl 'What format do database dump URLs follow?',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Database dumps follow the consistent URL pattern',
      :help_text => 'This is the structure of URLs when you publish different releases. Use `{variable}` to indicate parts of the template URL that change, for example, `http://example.com/data/monthly/mydata-{YY}{MM}.csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'Dump Template URL',
      :string,
      :input_type => :text,
      :placeholder => 'Dump Template URL',
      :required => :required

    q_dumpsUrl 'Where is your list of available database dumps?',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'A list of database dumps is at',
      :help_text => 'Give a URL to a page or feed with a machine-readable list of database dumps. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'Dump List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Dump List URL',
      :required => :required

    q_changeFeedUrl 'Where is your feed of changes?',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'A feed of changes to this data is at',
      :help_text => 'Give a URL to a page or feed that provides a machine-readable list of the previous versions of the database dumps. Use the URL of the first page which should link to the rest of the pages.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'Change Feed URL',
      :string,
      :input_type => :url,
      :placeholder => 'Change Feed URL',
      :required => :required

    label_group_12 'Formats',
      :help_text => 'how people can work with your data',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Is this data machine-readable?',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'This data is',
      :help_text => 'People prefer data formats which are easily processed by a computer, for speed and accuracy. For example, a scanned photocopy of a spreadsheet would not be machine-readable but a CSV file would be.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :requirement => ['pilot_16']

    label_pilot_16 'You should <strong>provide your data in a machine-readable format</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Is this data in a standard open format?',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'The format of this data is',
      :help_text => 'Open standards are created through a fair, transparent and collaborative process. Anyone can implement them and there’s lots of support so it’s easier for you to share data with more people. For example, XML, CSV and JSON are open standards.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'a standard open format',
      :requirement => ['standard_30']

    label_standard_30 'You should <strong>provide your data in an open standard format</strong> so that people can use widely available tools to process it more easily.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'What kind of data do you publish?',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'human-readable documents',
      :help_text => 'Choose this if your data is meant for human consumption. For example; policy documents, white papers, reports and meeting minutes. These usually have some structure to them but are mostly text.'
    a_statistical 'statistical data like counts, averages and percentages',
      :help_text => 'Choose this if your data is statistical or numeric data like counts, averages or percentages. Like census results, traffic flow information or crime statistics for example.'
    a_geographic 'geographic information, such as points and boundaries',
      :help_text => 'Choose this if your data can be plotted on a map as points, boundaries or lines.'
    a_structured 'other kinds of structured data',
      :help_text => 'Choose this if your data is structured in other ways. Like event details, railway timetables, contact information or anything that can be interpreted as data, and analysed and presented in multiple ways.'

    q_documentFormat 'Do your human-readable documents include formats that',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Documents are published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'describe semantic structure like HTML, Docbook or Markdown',
      :text_as_statement => 'in a semantic format',
      :help_text => 'These formats label structures like chapters, headings and tables that make it easy to automatically create summaries like tables of contents and glossaries. They also make it easy to apply different styles to the document so its appearance changes.',
      :requirement => ['standard_31']
    a_format 'describe information on formatting like OOXML or PDF',
      :text_as_statement => 'in a display format',
      :help_text => 'These formats emphasise appearance like fonts, colours and positioning of different elements within the page. These are good for human consumption, but aren\'t as easy for people to process automatically and change style.',
      :requirement => ['pilot_17']
    a_unsuitable 'aren\'t meant for documents like Excel, JSON or CSV',
      :text_as_statement => 'in a format unsuitable for documents',
      :help_text => 'These formats better suit tabular or structured data.'

    label_standard_31 'You should <strong>publish documents in a format that exposes semantic structure</strong> so that people can display them in different styles.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'You should <strong>publish documents in a format designed specifically for them</strong> so that they\'re easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Does your statistical data include formats that',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Statistical data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'expose the structure of statistical hypercube data like <a href="http://sdmx.org/">SDMX</a> or <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a>',
      :text_as_statement => 'in a statistical data format',
      :help_text => 'Individual observations in hypercubes relate to a particular measure and a set of dimensions. Each observation may also be related to annotations that give extra context. Formats like <a href="http://sdmx.org/">SDMX</a> and <a href="http://www.w3.org/TR/vocab-data-cube/">Data Cube</a> are designed to express this underlying structure.',
      :requirement => ['exemplar_15']
    a_tabular 'treat statistical data as a table like CSV',
      :text_as_statement => 'in a tabular data format',
      :help_text => 'These formats arrange statistical data within a table of rows and columns. This lacks extra context about the underlying hypercube but is easy to process.',
      :requirement => ['standard_32']
    a_format 'focus on the format of tabular data like Excel',
      :text_as_statement => 'in a presentation format',
      :help_text => 'Spreadsheets use formatting like italic or bold text, and indentation within fields to describe its appearance and underlying structure. This styling helps people to understand the meaning of your data but makes it less suitable for computers to process.',
      :requirement => ['pilot_18']
    a_unsuitable 'aren\'t meant for statistical or tabular data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for statistical data',
      :help_text => 'These formats don\'t suit statistical data because they obscure the underlying structure of the data.'

    label_exemplar_15 'You should <strong>publish statistical data in a format that exposes dimensions and measures</strong> so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'You should <strong>publish tabular data in a format that exposes tables of data</strong> so that it\'s easy to analyse.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'You should <strong>publish tabular data in a format designed for that purpose</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Does your geographic data include formats that',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Geographic data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'are designed for geographic data like <a href="http://www.opengeospatial.org/standards/kml/">KML</a> or <a href="http://www.geojson.org/">GeoJSON</a>',
      :text_as_statement => 'in a geographic data format',
      :help_text => 'These formats describe points, lines and boundaries, and expose structures in the data which make it easier to process automatically.',
      :requirement => ['exemplar_16']
    a_generic 'keeps data structured like JSON, XML or CSV',
      :text_as_statement => 'in a generic data format',
      :help_text => 'Any format that stores normal structured data can express geographic data too, particularly if it only holds data about points.',
      :requirement => ['pilot_19']
    a_unsuitable 'aren\'t designed for geographic data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for geographic data',
      :help_text => 'These formats don\'t suit geographic data because they obscure the underlying structure of the data.'

    label_exemplar_16 'You should <strong>publish geographic data in a format designed that purpose</strong> so that people can use widely available tools to process it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'You should <strong>publish geographic data as structured data</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Does your structured data include formats that',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Structured data is published',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'are designed for structured data like JSON, XML, Turtle or CSV',
      :text_as_statement => 'in a structured data format',
      :help_text => 'These formats organise data into a basic structure of things which have values for a known set of properties. These formats are easy for computers to process automatically.',
      :requirement => ['pilot_20']
    a_unsuitable 'aren\'t designed for structured data like Word or PDF',
      :text_as_statement => 'in a format unsuitable for structured data',
      :help_text => 'These formats don\'t suit this kind of data because they obscure its underlying structure.'

    label_pilot_20 'You should <strong>publish structured data in a format designed that purpose</strong> so that it\'s easy to process.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Does your data use persistent identifiers?',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'The data includes',
      :help_text => 'Data is usually about real things like schools or roads or uses a coding scheme. If data from different sources use the same persistent and unique identifier to refer to the same things, people can combine sources easily to create more useful data. Identifiers might be GUIDs, DOIs or URLs.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'persistent identifiers',
      :requirement => ['standard_33']

    label_standard_33 'You should <strong>use identifiers for things in your data</strong> so that they can be easily related with other data about those things.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Can the identifiers in your data be used to find extra information?',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'The persistent identifiers',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no, the identifiers can\'t be used to find extra information',
      :text_as_statement => ''
    a_service 'yes, there is a service that people can use to resolve the identifiers',
      :text_as_statement => 'resolve using a service',
      :help_text => 'Online services can be used to give people information about identifiers such as GUIDs or DOIs which can\'t be directly accessed in the way that URLs are.',
      :requirement => ['standard_34']
    a_resolvable 'yes, the identifiers are URLs that resolve to give information',
      :text_as_statement => 'resolve because they are URLs',
      :help_text => 'URLs are useful for both people and computers. People can put a URL into their browser and read more information, like <a href="http://opencorporates.com/companies/gb/08030289">companies</a> and <a href="http://data.ordnancesurvey.co.uk/doc/postcodeunit/EC2A4JE">postcodes</a>. Computers can also process this extra information using scripts to access the underlying data.',
      :requirement => ['exemplar_17']

    label_standard_34 'You should <strong>provide a service to resolve the identifiers you use</strong> so that people can find extra information about them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 'You should <strong>link to a web page of information about each of the things in your data</strong> so that people can easily find and share that information.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Where is the service that is used to resolve the identifiers?',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'The identifier resolution service is at',
      :help_text => 'The resolution service should take an identifier as a query parameter and give back some information about the thing it identifies.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'Identifier Resolution Service URL',
      :string,
      :input_type => :url,
      :placeholder => 'Identifier Resolution Service URL',
      :requirement => ['standard_35']

    label_standard_35 'You should <strong>have a URL through which identifiers can be resolved</strong> so that more information about them can be found by a computer.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Is there third-party information about things in your data on the web?',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Sometimes other people outside your control provide URLs to the things your data is about. For example, your data might have postcodes in it that link to the Ordnance Survey website.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Is that third-party information reliable?',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'If a third-party provides public URLs about things in your data, they probably take steps to ensure data quality and reliability. This is a measure of how much you trust their processes to do that. Look for their open data certificate or similar hallmarks to help make your decision.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Does your data use those third-party URLs?',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'Third-party URLs are',
      :help_text => 'You should use third-party URLs that resolve to information about the things your data describes. This reduces duplication and helps people combine data from different sources to make it more useful.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'referenced in this data',
      :requirement => ['exemplar_18']

    label_exemplar_18 'You should <strong>use URLs to third-party information in your data</strong> so that it\'s easy to combine with other data that uses those URLs.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Trust',
      :help_text => 'how much trust people can put in your data',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Do you provide machine-readable provenance for your data?',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'The provenance of this data is',
      :help_text => 'This about the origins of how your data was created and processed before it was published. It builds trust in the data you publish because people can trace back how it has been handled.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'machine-readable',
      :requirement => ['exemplar_19']

    label_exemplar_19 'You should <strong>provide a machine-readable provenance trail</strong> about your data so that people can trace how it was processed.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Where do you describe how people can verify that data they receive comes from you?',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'This data can be verified using',
      :help_text => 'If you deliver important data to people they should be able to check that what they receive is the same as what you published. For example, you can digitally sign the data you publish, so people can tell if it has been tampered with.'
    a_1 'Verification Process URL',
      :string,
      :input_type => :url,
      :placeholder => 'Verification Process URL',
      :requirement => ['exemplar_20']

    label_exemplar_20 'You should <strong>describe how people can check that the data they receive is the same as what you published</strong> so that they can trust it.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Social Information',
    :description => 'Documentation, support and services' do

    label_group_15 'Documentation',
      :help_text => 'how you help people understand the context and content of your data',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Does your data documentation include machine-readable data for:',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'The documentation includes machine-readable data for',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'title',
      :text_as_statement => 'title',
      :requirement => ['standard_36']
    a_description 'description',
      :text_as_statement => 'description',
      :requirement => ['standard_37']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :requirement => ['standard_38']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'frequency of releases',
      :text_as_statement => 'release frequency',
      :requirement => ['standard_40']
    a_identifier 'identifier',
      :text_as_statement => 'identifier',
      :requirement => ['standard_41']
    a_landingPage 'landing page',
      :text_as_statement => 'landing page',
      :requirement => ['standard_42']
    a_language 'language',
      :text_as_statement => 'language',
      :requirement => ['standard_43']
    a_publisher 'publisher',
      :text_as_statement => 'publisher',
      :requirement => ['standard_44']
    a_spatial 'spatial/geographical coverage',
      :text_as_statement => 'spatial/geographical coverage',
      :requirement => ['standard_45']
    a_temporal 'temporal coverage',
      :text_as_statement => 'temporal coverage',
      :requirement => ['standard_46']
    a_theme 'theme(s)',
      :text_as_statement => 'theme(s)',
      :requirement => ['standard_47']
    a_keyword 'keyword(s) or tag(s)',
      :text_as_statement => 'keyword(s) or tag(s)',
      :requirement => ['standard_48']
    a_distribution 'distribution(s)',
      :text_as_statement => 'distribution(s)'

    label_standard_36 'You should <strong>include a machine-readable data title in your documentation</strong> so that people know how to refer to it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'You should <strong>include a machine-readable data description in your documentation</strong> so that people know what it contains.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'You should <strong>include a machine-readable data release date in your documentation</strong> so that people know how timely it is.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'You should <strong>include a machine-readable last modification date in your documentation</strong> so that people know they have the latest data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'You should <strong>provide machine-readable metadata about how frequently you release new versions of your data</strong> so people know how often you update it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'You should <strong>include a canonical URL for the data in your machine-readable documentation</strong> so that people know how to access it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'You should <strong>include a canonical URL to the machine-readable documentation itself</strong> so that people know how to access to it consistently.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'You should <strong>include the data language in your machine-readable documentation</strong> so that people who search for it will know whether they can understand it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'You should <strong>indicate the data publisher in your machine-readable documentation</strong> so people can decide how much to trust your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'You should <strong>include the geographic coverage in your machine-readable documentation</strong> so that people understand where your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'You should <strong>include the time period in your machine-readable documentation</strong> so that people understand when your data applies to.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'You should <strong>include the subject in your machine-readable documentation</strong> so that people know roughly what your data is about.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'You should <strong>include machine-readable keywords or tags in your documentation</strong> to help people search within the data effectively.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Does your documentation include machine-readable metadata for each distribution on:',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'The documentation about each distribution includes machine-readable data for',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'title',
      :text_as_statement => 'title',
      :requirement => ['standard_49']
    a_description 'description',
      :text_as_statement => 'description',
      :requirement => ['standard_50']
    a_issued 'release date',
      :text_as_statement => 'release date',
      :requirement => ['standard_51']
    a_modified 'modification date',
      :text_as_statement => 'modification date',
      :requirement => ['standard_52']
    a_rights 'rights statement',
      :text_as_statement => 'rights statement',
      :requirement => ['standard_53']
    a_accessURL 'URL to access the data',
      :text_as_statement => 'a URL to access the data',
      :help_text => 'This metadata should be used when your data isn\'t available as a download, like an API for example.'
    a_downloadURL 'URL to download the dataset',
      :text_as_statement => 'a URL to download the dataset'
    a_byteSize 'size in bytes',
      :text_as_statement => 'size in bytes'
    a_mediaType 'type of download media',
      :text_as_statement => 'type of download media'

    label_standard_49 'You should <strong>include machine-readable titles within your documentation</strong> so people know how to refer to each data distribution.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'You should <strong>include machine-readable descriptions within your documentation</strong> so people know what each data distribution contains.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'You should <strong>include machine-readable release dates within your documentation</strong> so people know how current each distribution is.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'You should <strong>include machine-readable last modification dates within your documentation</strong> so people know whether their copy of a data distribution is up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'You should <strong>include a machine-readable link to the applicable rights statement</strong> so people can find out what they can do with a data distribution.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Where is the technical documentation for the data?',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'The technical documentation for the data is at'
    a_1 'Technical Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Technical Documentation URL',
      :requirement => ['pilot_21']

    label_pilot_21 'You should <strong>provide technical documentation for the data</strong> so that people understand how to use it.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Do the data formats use vocabularies or schemas?',
      :discussion_topic => :vocabulary,
      :help_text => 'Formats like CSV, JSON, XML or Turtle use custom vocabularies or schemas which say what columns or properties the data contains.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Where is documentation about your data vocabularies?',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The vocabularies used by this data are documented at'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'Schema Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Schema Documentation URL',
      :requirement => ['standard_54']

    label_standard_54 'You should <strong>document any vocabulary you use within your data</strong> so that people know how to interpret it.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Are there any codes used in this data?',
      :discussion_topic => :codelists,
      :help_text => 'If your data uses codes to refer to things like geographical areas, spending categories or diseases for example, these need to be explained to people.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Where are any codes in your data documented?',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'The codes in this data are documented at'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'Codelist Documentation URL',
      :string,
      :input_type => :url,
      :placeholder => 'Codelist Documentation URL',
      :requirement => ['standard_55']

    label_standard_55 'You should <strong>document the codes used within your data</strong> so that people know how to interpret them.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Support',
      :help_text => 'how you communicate with people who use your data',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Where can people find out how to contact someone with questions about this data?',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to contact someone about this data at',
      :help_text => 'Give a URL for a page that describes how people can contact someone if they have questions about the data.'
    a_1 'Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Contact Documentation',
      :requirement => ['pilot_22']

    label_pilot_22 'You should <strong>provide contact information for people to send questions</strong> about your data to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Where can people find out how to improve the way your data is published?',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to suggest improvements to publication at'
    a_1 'Improvement Suggestions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Improvement Suggestions URL',
      :requirement => ['pilot_23']

    label_pilot_23 'You should <strong>provide instructions about how suggest improvements</strong> to the way you publish data so you can discover what people need.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Where can people find out how to contact someone with questions about privacy?',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Find out where to send questions about privacy at'
    a_1 'Confidentiality Contact Documentation',
      :string,
      :input_type => :url,
      :placeholder => 'Confidentiality Contact Documentation',
      :requirement => ['pilot_24']

    label_pilot_24 'You should <strong>provide contact information for people to send questions about privacy</strong> and disclosure of personal details to.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Do you use social media to connect with people who use your data?',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 'You should <strong>use social media to reach people who use your data</strong> and discover how your data is being used',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Account' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Which social media accounts can people reach you on?',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Contact the curator through these social media accounts',
        :help_text => 'Give URLs to your social media accounts, like your Twitter or Facebook profile page.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'Social Media URL',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Social Media URL'

    end

    q_forum 'Where should people discuss this dataset?',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Discuss this data at',
      :help_text => 'Give a URL to your forum or mailing list where people can talk about your data.'
    a_1 'Forum or Mailing List URL',
      :string,
      :input_type => :url,
      :placeholder => 'Forum or Mailing List URL',
      :requirement => ['standard_57']

    label_standard_57 'You should <strong>tell people where they can discuss your data</strong> and support one another.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Where can people find out how to request corrections to your data?',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to request data corrections at',
      :help_text => 'Give a URL where people can report errors they spot in your data.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Instructions URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Instructions URL',
      :requirement => ['standard_58']

    label_standard_58 'You should <strong>provide instructions about how people can report errors</strong> in your data.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Where can people find out how to get notifications of corrections to your data?',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Find out how to get notifications about data corrections at',
      :help_text => 'Give a URL where you describe how notifications about corrections are shared with people.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Correction Notification URL',
      :string,
      :input_type => :url,
      :placeholder => 'Correction Notification URL',
      :requirement => ['standard_59']

    label_standard_59 'You should <strong>provide a mailing list or feed with updates</strong> that people can use to keep their copies of your data up-to-date.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Do you have anyone who actively builds a community around this data?',
      :discussion_topic => :engagementTeam,
      :help_text => 'A community engagement team will engage through social media, blogging, and arrange hackdays or competitions to encourage people to use the data.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_21']

    label_exemplar_21 'You should <strong>build a community of people around your data</strong> to encourage wider use of your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Where is their home page?',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Community engagement is done by',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'Community Engagement Team Home Page URL',
      :string,
      :input_type => :url,
      :placeholder => 'Community Engagement Team Home Page URL',
      :required => :required

    label_group_17 'Services',
      :help_text => 'how you give people access to tools they need to work with your data',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Where do you list tools to work with your data?',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Tools to help use this data are listed at',
      :help_text => 'Give a URL that lists the tools you know or recommend people can use when they work with your data.'
    a_1 'Tool URL',
      :string,
      :input_type => :url,
      :placeholder => 'Tool URL',
      :requirement => ['exemplar_22']

    label_exemplar_22 'You should <strong>provide a list of software libraries and other readily-available tools</strong> so that people can quickly get to work with your data.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
