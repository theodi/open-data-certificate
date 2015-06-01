survey 'GR',
  :full_title => 'Greece',
  :default_mandatory => 'false',
  :status => 'alpha',
  :description => '<p>Αυτό το ερωτηματολόγιο αυτο-αξιολόγησης δημιουργεί ένα πιστοποιητικό ανοιχτών δεδομένων και ένα σήμα που μπορείτε να δημοσιεύσετε έτσι ώστε να ενημερώσετε τους άλλους σχετικά με αυτά τα ανοικτά δεδομένα. Επίσης, οι απαντήσεις σας θα χρησιμοποιηθούν για να μάθουμε το πώς οι οργανισμοί δημοσιεύουν ανοιχτά δεδομένα.</p><p>Απατώντας σε αυτά τα ερωτήματα θα φανούν οι προσπάθειές συμμόρφωσης σας με την σχετική νομοθεσία. Θα πρέπει επίσης να ελέγθεί σχετικά και με άλλους νόμους και πολιτικές που εφαρμόζονται στον τομέα σας.</p><p>
         <strong>Δεν χρειάζεται να απαντήσετε σε όλες τις ερωτήσεις για να πάρετε το πιστοποιητικό.</strong> Απλά απαντήστε αυτές που μπορείτε.</p><p>
         <strong></strong>
      </p>' do

  translations :en => :default
  section_general 'Γενικές Πληροφορίες',
    :description => '',
    :display_header => false do

    q_dataTitle 'Πώς ονομάζονται αυτά τα δεδομένα;',
      :discussion_topic => :dataTitle,
      :help_text => 'Οι άνθρωποι βλέπουν το όνομα των ανοιχτών δεδομένων σας σε μια λίστα παρόμοιων με αυτό ονομάτων, οπότε δώστε όνομα όσο πιο σαφές και περιγραφικό μπορείται, μέσα σε αυτό το μικρό κελί, έτσι ώστε να μπορούν γρήγορα να αναγνωρίσουν τι το μοναδικό γι \'αυτό.',
      :required => :required
    a_1 'Τίτλος δεδομένων',
      :string,
      :placeholder => 'Τίτλος δεδομένων',
      :required => :required

    q_documentationUrl 'Πού περιγράφεται αυτό;',
      :discussion_topic => :documentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα περιγράφονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL ώστε να μπορούν να διαβάσουν σχετικά με τα περιεχόμενα των ανοιχτών δεδομένων σας και να βρούν περισσότερες λεπτομέρειες. Μπορεί να είναι μια σελίδα μέσα σε ένα μεγαλύτερο κατάλογο όπως παράδειγμα data.gov.uk.'
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης',
      :requirement => ['pilot_1', 'basic_1']

    label_pilot_1 'Θα πρέπει να έχετε μια <strong>ιστοσελίδα που προσφέρει τεκμηρίωση </strong> για τα ανοιχτά δεδομένα που δημοσιεύεται, έτσι ώστε οι άλλοι να μπορούν να κατανοήσουν το πλαίσιο, το περιεχόμενο και τη χρησιμότητά τους.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '!=', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_basic_1 'Πρέπει να έχετε μια <strong>ιστοσελίδα που δίνει τεκμηρίωση </strong> και πρόσβαση στα ανοικτά δεδομένα που δημοσιεύετε ώστε οι άλλοι να μπορούν να τα χρησιμοποιούν',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_1'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_collection
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_publisher 'Ποιος δημοσιεύει αυτά τα δεδομένα;',
      :discussion_topic => :publisher,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα δημοσιεύτηκαν από',
      :help_text => 'Δώστε το όνομα του οργανισμού που εκδίδει αυτά τα δεδομένα. Είναι πιθανώς ο οργανισμός για τον οποίο εργάζεστε εκτός και αν το κάνετε αυτό για λογαριασμό κάποιου άλλου.',
      :required => :required
    a_1 'Εκδότης δεδομένων',
      :string,
      :placeholder => 'Εκδότης δεδομένων',
      :required => :required

    q_publisherUrl 'Σε ποιά ιστοσελίδα δημοσιεύονται αυτά τα δεδομένα;',
      :discussion_topic => :publisherUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δεδομένα δημοσιεύονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL σε ένα δικτυακό τόπο, αυτό μας βοηθάει να συγκεντρώσουμε δεδομένα από τον ίδιο οργανισμό, ακόμη και αν οι άνθρωποι δίνουν διαφορετικά ονόματα.'
    a_1 'Σύνδεσμος(URL) του Εκδότη',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) του Εκδότη'

    q_releaseType 'Τι είδους έκδοση είναι αυτή;',
      :discussion_topic => :releaseType,
      :pick => :one,
      :required => :required
    a_oneoff 'μια εφάπαξ/μοναδική έκδοση ένος ενιαίου συνόλου δεδομένων',
      :help_text => 'Αυτό είναι ένα μοναδικό αρχείο και δεν σκοπεύετε προς το παρόν να δημοσιεύσετε παρόμοια αρχεία στο μέλλον.'
    a_collection 'μια εφάπαξ/μοναδική έκδοση από ένα σύνολο σχετικών συνόλων δεδομένων',
      :help_text => 'Αυτή είναι μια συλλογή σχετικών αρχείων για τα ίδια δεδομένα και δεν σκοπεύετε να δημοσιεύσετε παρόμοιες συλλογές στο μέλλον.'
    a_series 'τρέχουσα έκδοση μιας σειράς σχετικών συνόλων δεδομένων',
      :help_text => 'Αυτή είναι μια ακολουθία συνόλων δεδομένων με προγραμματισμένες περιοδικές ενημερώσεις στο μέλλον.'
    a_service 'μια υπηρεσία ή ένα API για την πρόσβαση σε ανοιχτά δεδομένα',
      :help_text => 'Αυτή είναι μια ζωντανή διαδικτυακή υπηρεσία που εκθέτει τα δεδομένα σας σε προγραμματιστές μέσω μιας διασύνδεσης ὀπου μπορούν να υποβάλουν ερωτήματα.'

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
    a_no 'όχι, δεν έχετε το δικαίωμα να δημοσιεύσετε αυτά τα δεδομένα ως ανοικτά'
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
      :text_as_statement => 'αρχικώς δημιουργημένα ή παραγμένα από τον επιμελητή'

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
      :help_text => 'Δώστε την διεύθυνση συνδέσμου(URL) όπου περιγράφεται το δικαίωμα επαναχρησιμοποίησης αυτών των δεδομένων. Αυτό θα πρέπει να περιλαμβάνει μια αναφορά στην άδεια χρήσης τους, τις απαιτήσεις απόδοσης, καθώς και μια δήλωση σχετικά με τα πνευματικά δικαιώματα. Μια δήλωση δικαιωμάτων βοηθά στο να γίνει κατανοητό τι μπορεί ή δεν μπορεί κάποιος να κάνει με τα αυτά τα δεδομένα.'
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
    a_cc_by 'Creative Commons Attribution (Αναφορά)',
      :text_as_statement => 'Creative Commons Attribution (Αναφορά)'
    a_cc_by_sa 'Creative Commons Attribution Share-Alike (Αναφορά - Παρόμοια διανομή)',
      :text_as_statement => 'Creative Commons Attribution Share-Alike (Αναφορά - Παρόμοια διανομή)'
    a_cc_zero 'Creative Commons CCZero (Εκχώρηση ως Κοινό Κτήμα)',
      :text_as_statement => 'Creative Commons CCZero (Εκχώρηση ως Κοινό Κτήμα)'
    a_odc_by 'Open Data Commons Attribution License (Open Data Commons Αναφορά)',
      :text_as_statement => 'Open Data Commons Attribution License (Open Data Commons Αναφορά)'
    a_odc_odbl 'Open Data Commons Open Database License (ODbL) (Open Data Commons Άδεια Ανοικτών Βάσεων Δεδομένων)',
      :text_as_statement => 'Open Data Commons Open Database License (ODbL) (Open Data Commons Άδεια Ανοικτών Βάσεων Δεδομένων)'
    a_odc_pddl 'Open Data Commons Public Domain Dedication and License (PDDL) (Open Data Commons Εκχώρηση ως Κοινό Κτήμα)',
      :text_as_statement => 'Open Data Commons Public Domain Dedication and License (PDDL) (Open Data Commons Εκχώρηση ως Κοινό Κτήμα)'
    a_na 'Δεν εφαρμόζεται',
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
      :text_as_statement => 'Η άδεια αυτή είναι στο',
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
    a_norights 'όχι, τα δεδομένα περιέχουν μόνο στοιχεία και αριθμούς',
      :text_as_statement => 'δεν υπάρχουν δικαιώματα στο περιεχόμενο των δεδομένων',
      :help_text => 'Δεν υπάρχουν πνευματικά δικαίωματα σε πραγματικά στοιχεία. Εάν τα δεδομένα δεν περιέχουν οποιοδήποτε στοιχείο που να δημιουργήθηκε μέσα από την πνευματική προσπάθεια, τότε δεν υπάρχουν δικαιώματα πάνω στα δεδομένα.'
    a_samerights 'ναι, και τα δικαιώματα όλων κατέχονται από το ίδιο πρόσωπο ή οργανισμό',
      :text_as_statement => '',
      :help_text => 'Επιλέξτε αυτή την επιλογή αν το περιεχόμενο των δεδομένων δημιουργήθηκε εξ\'ολοκλήρου απο το ίδιο πρόσωπο ή οργανισμό ή μεταφέρονται σε αυτό.'
    a_mixedrights 'ναι, και τα δικαιώματα κατέχονται από διαφορετικούς ανθρώπους ή οργανισμούς',
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
      :text_as_statement => 'επισημανθεί ως δημόσιος τομέας',
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
      :help_text => 'Θυμηθείτε ότι όποιος αφιερώνει διανοητική προσπάθεια για την δημιουργία κάποιου περιεχομένου παίρνει αυτόματα τα δικαιώματα πάνω του, αλλά αυτό το δημιουργικό περιεχόμενο δεν περιλαμβάνει γεγονότα. Έτσι κάποιος θα χρειαστεί μια παραίτηση ή άδεια για αυτά, η οποία να αποδεικνύει ότι μπορεί να τα χρησιμοποιήσει και να εξηγεί πως μπορεί να το κάνει νόμιμα. Παραθέτουμε τις πιο συνηθισμένες άδειες εδώ; αν δεν υπάρχουν πνευματικά δικαιώματα στο περιεχόμενο, είτε έχουν λήξει είτε έχετε παραιτηθεί από αυτά, τότε επιλέξτε \'Δεν εφαρμόζεται\'.',
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
      :text_as_statement => 'την άδεια των δεδομένων του',
      :requirement => ['standard_4']
    a_contentLicense 'άδεια περιεχομένου',
      :text_as_statement => 'την άδεια του περιεχομένου του',
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
      :text_as_statement => 'τον κάτοχο των πνευματικών δικαιωμάτων',
      :requirement => ['exemplar_3']
    a_databaseRightYear 'χρονολογία των δικαιωμάτων της βάσης δεδομένων',
      :text_as_statement => 'τη χρονολογία των δικαιωμάτων της βάσης δεδομένων',
      :requirement => ['exemplar_4']
    a_databaseRightHolder 'κάτοχος των δικαιωμάτων της βάσης δεδομένων',
      :text_as_statement => 'τον κάτοχο των δικαιωμάτων της βάσης δεδομένων',
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
    a_not_personal 'όχι, τα δεδομένα δεν είναι για ανθρώπους ή τις δραστηριότητές τους',
      :text_as_statement => 'δεν περιέχουν στοιχεία για άτομα',
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
      :text_as_statement => 'ελεγθεί ανεξάρτητα',
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
      :text_as_statement => 'Αυτά τα δεδομένα σχετικά με άτομα έχουν',
      :help_text => 'Η ανωνυμοποίηση μειώνει τον κίνδυνο προσδιορισμού ατόμων στα δεδομένα που δημοσιεύετε. Η καλύτερη τεχνική για να χρησιμοποιήσετε εξαρτάται από το είδος των δεδομένων που έχετε.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_dataPersonal, '==', :a_individual
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ανωνυμοποίηθεί'

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
      :text_as_statement => 'Το δικαίωμα δημοσίευσης δεδομένων σχετικά με άτομα είναι ήδη καταχωρημένο στην'
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
      :text_as_statement => 'Ο επιμελητής',
      :help_text => 'Μια εκτίμηση κινδύνου μετρά τους κινδύνους για την προστασία της ιδιωτικότητας των ατόμων στα δεδομένα σας, καθώς και τη χρήση και την αποκάλυψη των εν λόγω πληροφοριών.',
      :pick => :one
    dependency :rule => 'A and (B or C)'
    condition_A :q_dataPersonal, '==', :a_individual
    condition_B :q_appliedAnon, '==', :a_true
    condition_C :q_lawfulDisclosure, '==', :a_true
    a_false 'no',
      :text_as_statement => 'δεν έχει πραγματοποιήσει εκτίμηση των κινδύνων της ιδιωτικότητας'
    a_true 'yes',
      :text_as_statement => 'έχει πραγματοποιήσει εκτίμηση των κινδύνων της ιδιωτικότητας',
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

    label_standard_10 'Θα πρέπει να <strong>δημοσιεύσετε την εκτίμηση κινδύνου της ιδιωτικότητας </strong> έτσι ώστε οι άνθρωποι να μπορούν να καταλάβουν πώς έχετε εκτιμήσει τους κινδύνους αποκάλυψης των δεδομένων.',
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
      :text_as_statement => 'ελεγθεί ανεξάρτητα',
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
      :help_text => 'Όταν συλλέγετε δεδομένα σε σχέση με φυσικά πρόσωπα οφείλεται να τους ενημερώσετε σε σχέση με το σκοπό επεξεργαγασίας των προσωπικών τους δεδομένων. Οι περαιτέρω χρήστες των δεδομένων σας χρειάζεται να έχουν την συγκατάθεση του υποκειμένου επεξεργασίας δεδομένων προσωπικού χαρακτήρα ή άλλη νόμιμη βάση επεξεργασίας (π.χ. υποχρέωση εκ του νόμου) προκειμένου να επεξεργάζονται τα δεδομένα σύμφωνα με τη νομοθεσία για την προστασία δεδομένων προσωπικού χαρακτήρα (Data Protection Act).'
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

    q_dbStaffConsulted 'Τους έχετε εμπλέξει στη διαδικασία Εκτίμησης των Επιπτώσεων από την επεξεργασία Δεδομένων Προσωπικού Χαρακτήρα (Privacy Impact Assessment process);',
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
      :text_as_statement => 'ελεγθεί ανεξάρτητα',
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

  section_practical 'Πρακτικές πληροφορίες',
    :description => 'Ευρεσιμότητα, ακρίβεια, ποιότητα και εγγυήσεις' do

    label_group_6 'Ευρεσιμότητα',
      :help_text => 'πώς βοηθάτε τους άλλους να βρουν τα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_onWebsite 'Υπάρχει σύνδεση προς τα δεδομένα σας από την κύρια ιστοσελίδα σας;',
      :discussion_topic => :onWebsite,
      :help_text => 'Τα δεδομένα μπορούν να βρεθούν πιο εύκολα αν υπάρχει σύνδεσμος από την κύρια ιστοσελίδα σας.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_13']

    label_standard_13 'Θα πρέπει να <strong>εξασφαλίσετε ότι οι άλλοι μπορούν να βρουν τα δεδομένα από την κύρια ιστοσελίδα σας </strong>, έτσι ώστε οι να μπορούν να τα βρίσκουν πιο εύκολα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_13'
    dependency :rule => 'A'
    condition_A :q_onWebsite, '==', :a_false

    repeater 'ιστοσελίδα' do

      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      q_webpage 'Ποια σελίδα στην ιστοσελίδα σας, συνδέεται με τα δεδομένα;',
        :discussion_topic => :webpage,
        :display_on_certificate => true,
        :text_as_statement => 'Ο δικτυακός τόπος που συνδέεται με τα δεδομένα',
        :help_text => 'Δώστε μια διεύθυνση URL στην κύρια ιστοσελίδα σας, που περιλαμβάνει ένα σύνδεσμο προς αυτά τα δεδομένα.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_onWebsite, '==', :a_true
      a_1 'Σύνδεσμος(URL) Ιστοσελίδας',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Σύνδεσμος(URL) Ιστοσελίδας'

    end

    q_listed 'Είναι τα δεδομένα σας καταχωρημένα σε κάποια συλλογή;',
      :discussion_topic => :listed,
      :help_text => 'Τα δεδομένα είναι πιο εύκολο να τα βρεθούν, όταν βρίσκονται σε καταλόγους σχετικών δεδομένων, όπως ακαδημαϊκών, δημόσιου τομέα ή υγείας, για παράδειγμα, ή όταν εμφανίζονται σε συναφή αποτελέσματα αναζήτησης.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_14']

    label_standard_14 'Θα πρέπει να <strong>εξασφαλίσετε ότι οι άλλοι μπορούν να βρουν τα δεδομένα σας όταν τα αναζητούν </strong> σε τοποθεσίες που καταxωρούνται δεδομένα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_14'
    dependency :rule => 'A'
    condition_A :q_listed, '==', :a_false

    repeater 'Καταχώρηση' do

      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      q_listing 'Πού καταχωρείται;',
        :discussion_topic => :listing,
        :display_on_certificate => true,
        :text_as_statement => 'Τα δεδομένα εμφανίζονται σε αυτή τη συλλογή',
        :help_text => 'Δώστε ένα URL όπου αυτά τα δεδομένα παρατίθονται εντός μιας σχετικής συλλογής. Για παράδειγμα, data.gov.uk (αν πρόκειται για δεδομένα δημόσιου τομέα του Ηνωμένου Βασιλείου), hub.data.ac.uk (αν πρόκειται για ακαδημαϊκά βρετανικά δεδομένα) ή μια διεύθυνση URL για αποτελέσματα των μηχανών αναζήτησης.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_listed, '==', :a_true
      a_1 'Σύνδεσμος(URL) Καταχώρησης',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Σύνδεσμος(URL) Καταχώρησης'

    end

    q_referenced 'Γίνεται αναφορά αυτών των δεδομένων από τις δικές σας δημοσιεύσεις;',
      :discussion_topic => :referenced,
      :help_text => 'Όταν αναφέρετε τα δεδομένα σας μέσα στις δικές σας δημοσιεύσεις, όπως εκθέσεις, παρουσιάσεις ή αναρτήσεις blog, δίνεται στα δεδομένα πιο ολοκληρωμένο πλαίσιο και βοηθάτε τους άλλους να τα βρουν και να τα καταλάβουν καλύτερα.',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_15']

    label_standard_15 'Θα πρέπει να δίνετε παραπομπές δεδομένων <strong>από τις δικές σας δημοσιεύσεις </strong> έτσι ώστε οι άλλοι είναι ενήμεροι για τη διαθεσιμότητα και το περιεχόμενό τους.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_15'
    dependency :rule => 'A'
    condition_A :q_referenced, '==', :a_false

    repeater 'Αναφορά' do

      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      q_reference 'Πού αναφέρονται τα δεδομένα σας;',
        :discussion_topic => :reference,
        :display_on_certificate => true,
        :text_as_statement => 'Αυτά τα δεδομένα παραπέπονται από',
        :help_text => 'Δώστε μια διεύθυνση URL ένος εγγράφου που αναφέρει ή παραθέτει αυτά τα δεδομένα.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_referenced, '==', :a_true
      a_1 'Σύνδεσμος(URL) Αναφοράς',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Σύνδεσμος(URL) Αναφοράς'

    end

    label_group_7 'Ακρίβεια',
      :help_text => 'πώς να διατηρείτε τα δεδομένα σας ενημερωμένα',
      :customer_renderer => '/partials/fieldset'

    q_serviceType 'Τα δεδομένα πίσω από το API σας αλλάζουν;',
      :discussion_topic => :serviceType,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δεδομένα πίσω από το API',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_static 'Όχι, το API παρέχει πρόσβαση σε αμετάβλητα δεδομένα',
      :text_as_statement => 'δεν θα μεταβληθούν',
      :help_text => 'Μερικά ΑΡΙ απλά κάνουν τη πρόσβαση σε ένα σύνολο αμετάβλητων δεδομένων, ιδιαίτερα όταν υπάρχουν πολλά από αυτό αυτό.'
    a_changing 'ναι, το API δίνει πρόσβαση σε μεταβλητά δεδομένα',
      :text_as_statement => 'θα μεταβληθούν',
      :help_text => 'Μερικά APIs δίνουν άμεση πρόσβαση σε πιο ενημερωμένα και συνεχώς μεταβαλλόμενα δεδομένα'

    q_timeSensitive 'Θα γίνουν τα δεδομένα αυτά ξεπερασμένα(out of date);',
      :discussion_topic => :timeSensitive,
      :display_on_certificate => true,
      :text_as_statement => 'Η ακρίβεια ή η καταλληλότητα των δεδομένων θα',
      :pick => :one
    dependency :rule => '(A or B or (C and D))'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    a_true 'ναι, αυτά τα δεδομένα θα γίνουν ξεπερασμένα (out of date)',
      :text_as_statement => 'θα ξεπεραστεί (out of date)',
      :help_text => 'Για παράδειγμα, ένα σύνολο δεδομένων των τοποθεσιών των στάσεων λεωφορείου με τη πάροδο του χρόνου θα θεωρείται ανημέρωτο(out of date) καθώς θα μεταβάλλονται και θα δημιουργούνται καινούριες.'
    a_timestamped 'ναι, αυτά τα δεδομένα θα μετατραπούν σε μη ενημερωμένα με τη πάροδο του χρόνου αλλά είναι χρόνο-σημασμένα',
      :text_as_statement => 'θα ξεπεραστεί (out of date) αλλά θα είναι χρόνο-σημασμένη',
      :help_text => 'Για παράδειγμα, τα στατιστικά στοιχεία του πληθυσμού περιλαμβάνουν συνήθως μια σταθερή χρονική σήμανση για να υποδείξει πότε οι στατιστικές ήταν σχετικές.',
      :requirement => ['pilot_9']
    a_false 'όχι, αυτά τα δεδομένα δεν περιέχουν χρονικά ευαίσθητες πληροφορίες',
      :text_as_statement => 'δεν θα ξεπεραστούν (out of date)',
      :help_text => 'Για παράδειγμα, τα αποτελέσματα ενός πειράματος θα παραμείνουν ενημερωμένα, διότι τα δεδομένα περιγράφουν με ακρίβεια τα παρατηρούμενα αποτελέσματα.',
      :requirement => ['standard_16']

    label_pilot_9 'Θα πρέπει να <strong>τεθούν χρονικές σημάνσεις στα δεδομένα σας όταν απελευθερώσετε </strong> έτσι ώστε οι άνθρωποι ξέρουν την περίοδο που αφορά και πότε θα λήξει.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_9'
    dependency :rule => '(A or B or (C and D)) and (E and F)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_timestamped
    condition_F :q_timeSensitive, '!=', :a_false

    label_standard_16 'Θα πρέπει να <strong>δημοσιεύετε ενημερώσεις σε χρονικά ευαίσθητα δεδομένα </strong>, έτσι ώστε να μην παλιώσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_16'
    dependency :rule => '(A or B or (C and D)) and (E)'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_releaseType, '==', :a_collection
    condition_C :q_releaseType, '==', :a_service
    condition_D :q_serviceType, '==', :a_static
    condition_E :q_timeSensitive, '!=', :a_false

    q_frequentChanges 'Μεταβάλλονται τα δεδομένα αυτά σε τουλάχιστον καθημερινή βάση;',
      :discussion_topic => :frequentChanges,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα μεταβάλλονται',
      :help_text => 'Ενημερώστε τους ανθρώπους, αν τα υποκείμενα δεδομένα μεταβάλλονται τις περισσότερες ημέρες. Όταν τα δεδομένα μεταβάλλονται συχνά, επίσης ξεπερνιούνται γρήγορα, και οι άλλοι θα πρέπει να γνωρίζουν εάν μπορείτε να τα ενημερώνετε συχνά και μάλιστα γρήγορα.',
      :pick => :one,
      :required => :pilot
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'τουλάχιστον καθημερινά'

    q_seriesType 'Τι είδους ακολουθία συνόλου δεδομένων είναι αυτή;',
      :discussion_topic => :seriesType,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα είναι μια σειρά από',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_dumps 'τακτικά αντίγραφα μιας πλήρους βάσης δεδομένων',
      :text_as_statement => 'αντίγραφα μιας βάσης δεδομένων',
      :help_text => 'Επιλέξτε αν θέλετε να δημοσιεύσετε νέα και ενημερωμένα αντίγραφα της πλήρους βάσης δεδομένων σας τακτικά. Όταν δημιουργείτε data base dumps, είναι χρήσιμο για τους άλλους να έχουν πρόσβαση σε μια τροφοδότηση των αλλαγών, ώστε να μπορούν να κρατήσουν τα αντίγραφά τους ενημερωμένα.'
    a_aggregate 'τακτικά συσσωματώματα μεταβλητών δεδομένων',
      :text_as_statement => 'συσσωματώματα μεταβλητών δεδομένων',
      :help_text => 'Επιλέξτε εάν θα δημιουργήτε νέα σύνολα δεδομένων τακτικά. Μπορείτε να το κάνετε αυτό αν τα υποκείμενα δεδομένα δεν μπορούν να κυκλοφορήσουν ως ανοιχτά δεδομένα ή αν δημοσιεύετε μόνο δεδομένα που είναι καινούρια αφότου δημοσιεύσατε τελευταία.'

    q_changeFeed 'Υπάρχει διαθέσιμη τροφοδότηση των αλλαγών;',
      :discussion_topic => :changeFeed,
      :display_on_certificate => true,
      :text_as_statement => 'Μια τροφοδότηση μεταβολών σε αυτά τα δεδομένα',
      :help_text => 'Ενημερώστε αν σας παρέχετε ροή των αλλαγών που επηρεάζουν αυτά τα δεδομένα, όπως νέες καταχωρήσεις ή τροποποιήσεις των υφιστάμενων καταχωρήσεων.Οι τροφοδοτήσεις θα μπορούσε να είναι σε RSS, Atom ή προσαρμοσμένες μορφές.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'είναι διαθέσιμη',
      :requirement => ['exemplar_6']

    label_exemplar_6 'Θα πρέπει να <strong>παρέχετε μια τροφοδότηση των αλλαγών των δεδομένων σας </strong> έτσι ώστε οι άλλοι να διατηρούν τα αντίγραφα τους ενημερωμένα και ακριβή.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_6'
    dependency :rule => 'A and B and C and D'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_seriesType, '==', :a_dumps
    condition_D :q_changeFeed, '==', :a_false

    q_frequentSeriesPublication 'Πόσο συχνά δημιουργήτε μια νέα έκδοση;',
      :discussion_topic => :frequentSeriesPublication,
      :display_on_certificate => true,
      :text_as_statement => 'Νέες κυκλοφορίες αυτών των δεδομένων γίνονται',
      :help_text => 'Αυτό καθορίζει πόσο ξεπερασμένα αυτά τα δεδομένα κατέστησαν πριν οι άλλοι μπορούν να αποκτήσουν μια ενημερωμένη έκδοση.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    a_rarely 'λιγότερο από μία φορά το μήνα',
      :text_as_statement => 'λιγότερο από μία φορά το μήνα'
    a_monthly 'τουλάχιστον κάθε μήνα',
      :text_as_statement => 'τουλάχιστον κάθε μήνα',
      :requirement => ['pilot_10']
    a_weekly 'τουλάχιστον κάθε εβδομάδα',
      :text_as_statement => 'τουλάχιστον κάθε εβδομάδα',
      :requirement => ['standard_17']
    a_daily 'τουλάχιστον κάθε μέρα',
      :text_as_statement => 'τουλάχιστον κάθε μέρα',
      :requirement => ['exemplar_7']

    label_pilot_10 'Θα πρέπει να <strong>δημιουργείτε μια νέα έκδοση του συνόλου δεδομένων κάθε μήνα </strong> έτσι ώστε οι άλλοι να διατηρούν τα αντίγραφα τους ενημερωμένα και ακριβή.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_10'
    dependency :rule => 'A and B and (C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_monthly
    condition_D :q_frequentSeriesPublication, '!=', :a_weekly
    condition_E :q_frequentSeriesPublication, '!=', :a_daily

    label_standard_17 'Θα πρέπει να <strong>δημιουργήσετε μια νέα έκδοση του συνόλου δεδομένων κάθε εβδομάδα </strong> έτσι ώστε οι άλλοι να διατηρούν τα αντίγραφα τους ενημερωμένα και ακριβή.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_17'
    dependency :rule => 'A and B and (C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_weekly
    condition_D :q_frequentSeriesPublication, '!=', :a_daily

    label_exemplar_7 'Θα πρέπει να <strong>δημιουργείτε μια νέα έκδοση του συνόλου δεδομένων κάθε μέρα </strong> έτσι ώστε οι άλλοι να διατηρούν τα αντίγραφα τους ενημερωμένα και ακριβή.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_7'
    dependency :rule => 'A and B and (C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_frequentChanges, '==', :a_true
    condition_C :q_frequentSeriesPublication, '!=', :a_daily

    q_seriesPublicationDelay 'Πόσο μεγάλη είναι η καθυστέρηση μεταξύ της δημιουργίας ένος συνόλου δεδομένων και της δημοσιοποίησης της;',
      :discussion_topic => :seriesPublicationDelay,
      :display_on_certificate => true,
      :text_as_statement => 'Η χρονική υστέρηση ανάμεσα στη δημιουργία και τη δημοσίευση των εν λόγω στοιχείων είναι',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_extreme 'περισσότερο από ό, τι το χάσμα μεταξύ των κυκλοφοριών',
      :text_as_statement => 'περισσότερο από ό, τι το χάσμα μεταξύ των κυκλοφοριών',
      :help_text => 'Για παράδειγμα, εάν δημιουργείτε μια νέα έκδοση του συνόλου δεδομένων κάθε μέρα, επιλέξτε αυτό αν χρειάζεται περισσότερο από μία ημέρα για να δημοσιευθεί.'
    a_reasonable 'περίπου η ίδια (καθυστέρηση) με το χρόνο μεταξύ των εκδόσεων',
      :text_as_statement => 'περίπου η ίδια (καθυστέρηση) με το χρόνο μεταξύ των εκδόσεων',
      :help_text => 'Για παράδειγμα, εάν δημιουργείτε μια νέα έκδοση του συνόλου δεδομένων κάθε μέρα, επιλέξτε το, εάν χρειάζεται περίπου μια ημέρα για να δημοσιευθεί.',
      :requirement => ['pilot_11']
    a_good 'λιγότερο από το ήμισυ του κενού μεταξύ των κυκλοφοριών',
      :text_as_statement => 'λιγότερο από το ήμισυ του κενού μεταξύ των κυκλοφοριών',
      :help_text => 'Για παράδειγμα, εάν δημιουργείτε μια νέα έκδοση του συνόλου δεδομένων κάθε μέρα, επιλέξτε το, αν χρειάζεται λιγότερο από δώδεκα ώρες για να δημοσιευθεί.',
      :requirement => ['standard_18']
    a_minimal 'υπάρχει ελάχιστη ή καμία καθυστέρηση',
      :text_as_statement => 'ελάχιστη',
      :help_text => 'Επιλέξτε αυτό αν δημοσιεύσετε μέσα σε λίγα δευτερόλεπτα ή μερικά λεπτά.',
      :requirement => ['exemplar_8']

    label_pilot_11 'Θα πρέπει να <strong>υπάρχει μια λογική καθυστέρηση από τη στιγμή που θα δημιουργήσετε και θα δημοσιεύσετε ένα σύνολο δεδομένων </strong> που είναι μικρότερο από το χρονική διάρκεια(χάσμα) μεταξύ των εκδόσεων, ώστε οι άλλοι να κρατήσουν τα αντίγραφα τους ενήμερα και ακριβή.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_11'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_reasonable
    condition_C :q_seriesPublicationDelay, '!=', :a_good
    condition_D :q_seriesPublicationDelay, '!=', :a_minimal

    label_standard_18 'Θα πρέπει να <strong>έχετε μια μικρή καθυστέρηση από τη στιγμή που θα δημιουργήσετε και θα δημοσιεύσετε ένα σύνολο δεδομένων </strong> που είναι λιγότερο από το ήμισυ του χρόνου μεταξύ των εκδόσεων, ώστε οι άλλοι να κρατήσουν τα αντίγραφα τους ενήμερα και ακριβή.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_18'
    dependency :rule => 'A and (B and C)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_good
    condition_C :q_seriesPublicationDelay, '!=', :a_minimal

    label_exemplar_8 'Θα πρέπει να <strong>έχετε ελάχιστη ή καμία καθυστέρηση από τη στιγμή που θα δημιουργήσετε και θα (ή μέχρι να) δημοσιεύσετε ένα σύνολο δεδομένων </strong>, ώστε οι άλλοι να διατηρήσουν τα αντίγραφα τους ενήμερα και ακριβή.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_8'
    dependency :rule => 'A and (B)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_seriesPublicationDelay, '!=', :a_minimal

    q_provideDumps 'Έχετε επίσης δημοσιεύσει τμήματα(dumps) αυτού του συνόλου δεδομένων;',
      :discussion_topic => :provideDumps,
      :display_on_certificate => true,
      :text_as_statement => 'Ο επιμελητής δημοσιεύει',
      :help_text => 'Ένα τμήμα είναι ένα απόσπασμα από το σύνολο του συνόλου δεδομένων σε ένα αρχείο που οι άλλοι μπορούν να κατεβάσουν. Αυτό επιτρέπει στους χρήστες να κάνουν ανάλυση που είναι διαφορετική από την ανάλυση μέσω ενός API.',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'τμήματα(dumps) των δεδομένων',
      :requirement => ['standard_19']

    label_standard_19 'Θα πρέπει να <strong>αφήνετε τους άλλους να κατεβάζουν ολόκληρο το σύνολο δεδομένων σας </strong> έτσι ώστε να μπορούν να κάνουν πιο πλήρη και ακριβή ανάλυση με όλα τα δεδομένα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_19'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_false

    q_dumpFrequency 'Πόσο συχνά δημιουργείτε μια ένα νέο τμήμα στη βάση δεδομένων;',
      :discussion_topic => :dumpFrequency,
      :display_on_certificate => true,
      :text_as_statement => 'Τμήματα βάσεων δεδομένων δημιουργούνται',
      :help_text => 'Ταχύτερη πρόσβαση στις πιο συχνές εξαγωγές αποσπάσμάτων του συνόλου δεδομένων σημαίνει ότι οι άλλοι μπορούν να ξεκινήσουν πιο γρήγορα με τα περισσότερο ενημερωμένα δεδομένα.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    a_rarely 'λιγότερο συχνά από μία φορά το μήνα',
      :text_as_statement => 'λιγότερο συχνά από μία φορά το μήνα'
    a_monthly 'τουλάχιστον κάθε μήνα',
      :text_as_statement => 'τουλάχιστον κάθε μήνα',
      :requirement => ['pilot_12']
    a_weekly 'μέσα σε μια εβδομάδα από οποιαδήποτε αλλαγή',
      :text_as_statement => 'μέσα σε μια εβδομάδα από οποιαδήποτε αλλαγή',
      :requirement => ['standard_20']
    a_daily 'μέσα σε μια ημέρα από οποιαδήποτε αλλαγή',
      :text_as_statement => 'μέσα σε μια ημέρα από οποιαδήποτε αλλαγή',
      :requirement => ['exemplar_9']

    label_pilot_12 'Θα πρέπει να <strong>δημιουργείτε ένα νέο τμήμα της βάσης δεδομένων κάθε μήνα </strong> έτσι ώστε οι άλλοι να έχουν τα πιο πρόσφατα δεδομένα.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_12'
    dependency :rule => 'A and B and C and (D and E and F)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_monthly
    condition_E :q_dumpFrequency, '!=', :a_weekly
    condition_F :q_dumpFrequency, '!=', :a_daily

    label_standard_20 'Θα πρέπει να <strong>δημιουργείτε ένα νέο τμήμα της βάσης δεδομένων εντός μιας εβδομάδας από οποιαδήποτε αλλαγή </strong> έτσι ώστε οι υπόλοιποι να έχουν λιγότερο χρόνο να περιμένουν για τα τελευταία δεδομένα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_20'
    dependency :rule => 'A and B and C and (D and E)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_weekly
    condition_E :q_dumpFrequency, '!=', :a_daily

    label_exemplar_9 'Θα πρέπει να <strong>δημιουργείτε ένα νέο τμήμα της βάσης δεδομένων μέσα σε μια ημέρα από οποιαδήποτε αλλαγή </strong> έτσι ώστε να είναι ευκολότερο για τους υπόλοιπους να αποκτήσουν τα πιο πρόσφατα δεδομένα.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_9'
    dependency :rule => 'A and B and C and (D)'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_serviceType, '==', :a_changing
    condition_C :q_provideDumps, '==', :a_true
    condition_D :q_dumpFrequency, '!=', :a_daily

    q_corrected 'Θα διορθωθούν τα δεδομένα σας αν έχουν λάθη;',
      :discussion_topic => :corrected,
      :display_on_certificate => true,
      :text_as_statement => 'Τυχόν λάθη σε αυτά τα δεδομένα είναι',
      :help_text => 'Είναι καλή πρακτική να διορθώνετε τα σφάλματα στα δεδομένα σας, ειδικά αν τα χρησιμοποιείτε οι ίδιοι. Όταν κάνετε διορθώσεις, οι υπόλοιποι πρέπει να ενημερώνονται.',
      :pick => :one
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'διορθωμένα',
      :requirement => ['standard_21']

    label_standard_21 'Θα πρέπει να <strong>να διορθώνετε τα δεδομένα όταν οι άλλοι σας αναφέρουν σφάλματα </strong> έτσι ώστε όλοι να επωφελούνται από τις βελτιώσεις στην ακρίβεια.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_21'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_timeSensitive, '!=', :a_true
    condition_C :q_corrected, '==', :a_false

    label_group_8 'Ποιότητα',
      :help_text => 'πόσο πολύ οι άλλοι μπορούν να βασίζονται στα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_qualityUrl 'Πού τεκμηριώνετε προβλήματα με την ποιότητα των δεδομένων;',
      :discussion_topic => :qualityUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Η ποιότητα των δεδομένων τεκμηριώνετε στο',
      :help_text => 'Δώστε μια διεύθυνση URL, όπου οι άλλοι μπορούν να μάθουν για την ποιότητα των δεδομένων σας. Είναι δεκτό ότι τα λάθη είναι αναπόφευκτα, από δυσλειτουργίες του εξοπλισμού ή από λάθη που συμβαίνουν κατά τη "μετανάστευση" του συστήματος. Θα πρέπει να είστε ανοιχτοί σχετικά με την ποιότητα, ώστε οι υπόλοιποι να μπορούν να κρίνουν κατα πόσο μπορούν να στηριχθούν σε αυτά τα δεδομένα.'
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης Ποιότητας Δεδομένων',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης Ποιότητας Δεδομένων',
      :requirement => ['standard_22']

    label_standard_22 'Θα πρέπει να <strong>τεκμηριώνονται γνωστά ζητήματα με την ποιότητα των δεδομένων σας </strong> έτσι ώστε οι άλλοι να μπορούν να αποφασίζουν πόσο να εμπιστεύονται τα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_22'
    dependency :rule => 'A'
    condition_A :q_qualityUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_qualityControlUrl 'Πού περιγράφεται η διαδικασία ποιοτικού ελέγχου σας;',
      :discussion_topic => :qualityControlUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Οι διαδικασίες ποιοτικού ελέγχου περιγράφονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL ώστε οσοι επιθυμούν να μάθουν για τους συνεχείς ελέγχους στα δεδομένα σας, είτε αυτόματα είτε χειροκίνητα. Αυτό τους διαβεβαιώνει ότι λαμβάνετε σοβαρά υπόψη την ποιότητα και ενθαρρύνει τις βελτιώσεις που ωφελούν όλους.'
    a_1 'Σύνδεσμος(URL) Περιγραφής της Διαδικασίας Ποιοτικού Ελέγχου',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Περιγραφής της Διαδικασίας Ποιοτικού Ελέγχου',
      :requirement => ['exemplar_10']

    label_exemplar_10 'Θα πρέπει να <strong>τεκμηριώνετε τη διαδικασία ποιοτικού ελέγχου σας </strong> έτσι ώστε οι άλλοι να μπορούν να αποφασίζουν πόσο να εμπιστεύονται τα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_10'
    dependency :rule => 'A'
    condition_A :q_qualityControlUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_9 'Εγγυήσεις',
      :help_text => 'πόσο πολύ οι άλλοι μπορούν να βασίζονται στη διαθεσιμότητα των δεδομένων σας',
      :customer_renderer => '/partials/fieldset'

    q_backups 'Κάνετε εφεδρικά αντίγραφα εκτός του site;',
      :discussion_topic => :backups,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δεδομένα έχουν',
      :help_text => 'Κάνοντας μια τακτική offsite(εκτός του site) δημιουργία αντιγράφων ασφαλείας βοηθά στο να διασφαλιστεί ότι τα δεδομένα δεν θα χαθούν σε περίπτωση ατυχήματος.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'ασφαλή εφεδρικά αντίγραφα εκτός του site.',
      :requirement => ['standard_23']

    label_standard_23 'Θα πρέπει να <strong>να δημιοργείτε ακόλουθα αντίγραφα ασφαλείας offsite </strong> έτσι ώστε να μην χαθούν τα δεδομένα αν συμβεί κάποιο ατύχημα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_23'
    dependency :rule => 'A'
    condition_A :q_backups, '==', :a_false

    q_slaUrl 'Πού περιγράφετε τις εγγυήσεις σχετικά με τη διαθεσιμότητα της υπηρεσίας;',
      :discussion_topic => :slaUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Η διαθεσιμότητα της υπηρεσίας περιγράφεται στο',
      :help_text => 'Δώστε μια διεύθυνση URL για μια σελίδα που περιγράφει τι εγγυήσεις έχετε σχετικά με την βοήθεια που είναι διαθέσιμη. Για παράδειγμα, μπορεί να έχετε ένα εγγυημένο χρόνο λειτουργίας 99,5%, ή μπορεί να μη παρέχετε καμία εγγύηση.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης Διαθεσιμότητας Υπηρεσίας',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης Διαθεσιμότητας Υπηρεσίας',
      :requirement => ['standard_24']

    label_standard_24 'Θα πρέπει να <strong>περιγράψετε τι εγγυήσεις έχετε γύρω από τη διαθεσιμότητα της υπηρεσίας </strong>, έτσι ώστε οι άλλοι να ξέρουν πόσο μπορούν να βασίζονται σε αυτό.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_24'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_slaUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_statusUrl 'Πού παρέχονται πληροφορίες σχετικά με την τρέχουσα κατάσταση της υπηρεσίας;',
      :discussion_topic => :statusUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Κατάσταση υπηρεσίας δίνεται στο',
      :help_text => 'Δώστε μια διεύθυνση URL για μια σελίδα που ενημερώνει τους άλλους σχετικά με την τρέχουσα κατάσταση της υπηρεσίας σας, συμπεριλαμβανομένων τυχόν ελαττώματων που γνωρίζετε.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Σύνδεσμος(URL) Κατάστασης Υπηρεσίας',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Κατάστασης Υπηρεσίας',
      :requirement => ['exemplar_11']

    label_exemplar_11 'Θα πρέπει να <strong>έχει μια σελίδα κατάστασης υπηρεσίας </strong> που να αναφέρεται στην τρέχουσα κατάσταση της υπηρεσίας σας.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_11'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_statusUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_onGoingAvailability 'Για πόσο καιρό θα είναι διαθέσιμα αυτά τα δεδομένα;',
      :discussion_topic => :onGoingAvailability,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δεδομένα είναι διαθέσιμα',
      :pick => :one
    a_experimental 'μπορεί να εξαφανιστούν οποιαδήποτε στιγμή',
      :text_as_statement => 'δοκιμαστικά και ενδέχεται να εξαφανιστούν οποιαδήποτε στιγμή'
    a_short 'είναι διαθέσιμα δοκιμαστικά, αλλά θα παραμείνουν για άλλο ένα έτος περίπου',
      :text_as_statement => 'δοκιμαστικά για άλλο ένα έτος περίπου',
      :requirement => ['pilot_13']
    a_medium 'είναι στα μέσοπρόθεσμα σχέδια σας, έτσι θα πρέπει να είναι διαθέσιμα για ένα-δύο χρόνια',
      :text_as_statement => 'για τουλάχιστον δύο χρόνια',
      :requirement => ['standard_25']
    a_long 'είναι μέρος των καθημερινών σας εργασιών έτσι θα μείνουν δημοσιευμένα για μεγάλο χρονικό διάστημα',
      :text_as_statement => 'για μεγάλο χρονικό διάστημα',
      :requirement => ['exemplar_12']

    label_pilot_13 'Θα πρέπει να <strong>εγγυηθείτε ότι τα δεδομένα σας θα είναι διαθέσιμα σε αυτή τη μορφή για τουλάχιστον ένα χρόνο </strong> έτσι ώστε οι άλλοι να μπορούν να αποφασίζουν πόσο να βασίζονται στα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_13'
    dependency :rule => 'A and B and C'
    condition_A :q_onGoingAvailability, '!=', :a_short
    condition_B :q_onGoingAvailability, '!=', :a_medium
    condition_C :q_onGoingAvailability, '!=', :a_long

    label_standard_25 'Θα πρέπει να <strong>εγγυάστε ότι τα δεδομένα σας θα είναι διαθέσιμα σε αυτή τη μορφή μεσοπρόθεσμα </strong> έτσι ώστε οι άλλοι να μπορούν να αποφασίζουν πόσο να τα εμπιστεύονται.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_25'
    dependency :rule => 'A and B'
    condition_A :q_onGoingAvailability, '!=', :a_medium
    condition_B :q_onGoingAvailability, '!=', :a_long

    label_exemplar_12 'Θα πρέπει να <strong>εγγυάστε ότι τα δεδομένα σας θα είναι διαθέσιμα σε αυτήν την μορφή μακροπρόθεσμα </strong> έτσι ώστε οι άλλοι να μπορούν να αποφασίζουν πόσο να τα εμπιστεύονται.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_12'
    dependency :rule => 'A'
    condition_A :q_onGoingAvailability, '!=', :a_long

  end

  section_technical 'Τεχνικές Πληροφορίες',
    :description => 'Τοποθεσίες, μορφές και εμπιστοσύνη' do

    label_group_11 'Τοποθεσίες',
      :help_text => 'πώς οι άνθρωποι μπορούν να έχουν πρόσβαση στα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_datasetUrl 'Πού είναι το σύνολο δεδομένων σας;',
      :discussion_topic => :datasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα δημοσιεύονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL για το ίδιο το σύνολο δεδομένων. Τα ανοιχτά δεδομένα θα πρέπει να διασυνδέονται απ \'ευθείας στο διαδίκτυο, ώστε οι άλλοι να μπορούν εύκολα να τα βρουν και να τα επαναχρησιμοποιήσουν.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_oneoff
    a_1 'Σύνδεσμος(URL) Συνόλου Δεδομένων(Dataset)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Συνόλου Δεδομένων(Dataset)',
      :requirement => ['basic_9', 'pilot_14']

    label_basic_9 'Θα πρέπει να <strong>παρέχετε μια διεύθυνση URL για τα δεδομένα σας ή μια διεύθυνση URL για να τα τεκμηρίωνετε </strong> , έτσι ώστε οι άλλοι να μπορούν να τα βρουν.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_9'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_pilot_14 'Θα πρέπει να <strong>έχετει μια διεύθυνση URL που να είναι σε άμεση σύνδεση με τα ίδια τα δεδομένα </strong> έτσι ώστε οι άνθρωποι μπορούν να έχουν εύκολη πρόσβαση.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_oneoff
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_datasetUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_versionManagement 'Πώς δημοσιεύετε μια σειρά/ακολουθία του ίδιου συνόλου δεδομένων;',
      :discussion_topic => :versionManagement,
      :requirement => ['basic_10'],
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_series
    a_current 'ως ένα ξεχωριστό URL που ενημερώνεται τακτικά',
      :help_text => 'Επιλέξτε αυτό αν υπάρχει ένα URL για κατέβασμα των πιο πρόσφατων εκδόσεων του τρέχοντος συνόλου δεδομένων.',
      :requirement => ['standard_26']
    a_template 'ως συνεπείς διευθύνσεις URL για κάθε έκδοση',
      :help_text => 'Επιλέξτε αυτό αν οι διευθύνσεις URL του συνόλου δεδομένων σας ακολουθούν το ίδιο πρότυπο που περιλαμβάνει την ημερομηνία της δημοσίευσης, για παράδειγμα, μια διεύθυνση URL που ξεκινά \'2013-04\'. Αυτό βοηθά τους άλλους να κατανοήσουν το πόσο συχνά κυκλοφορείτε δεδομένα, και να γράψουν πρότυπα κειμένου(scripts), που προσκομίζουν νέα στοιχεία κάθε φορά που κυκλοφορούν.',
      :requirement => ['pilot_15']
    a_list 'ως μια λίστα εκδόσεων',
      :help_text => 'Επιλέξτε αυτό αν έχετε μια λίστα του συνόλου δεδομένων σε μια ιστοσελίδα ή μια τροφοδοσία (όπως Atom ή RSS) με συνδέσμους προς κάθε επιμέρους έκδοση και οι λεπτομέρειες της. Αυτό βοηθά τους άλλους να κατανοήσουν πόσο συχνά ανακοινώνονται/δίνονται στη κυκλοφορία δεδομένα, και να γράψουν πρότυπα κειμένου(scripts), που προσκομίζουν νέα στοιχεία κάθε φορά που κυκλοφορούν.',
      :requirement => ['standard_27']

    label_standard_26 'Θα πρέπει να <strong>έχετε μια ξεχωριστή μόνιμη διεύθυνση URL που θα κατεβαίνει η τρέχουσα έκδοση των δεδομένων σας </strong> έτσι ώστε οι άλλοι να έχουν εύκολη πρόσβαση.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_26'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_current

    label_pilot_15 'Θα πρέπει να <strong>χρησιμοποιείτε ένα συνεπές πρότυπο για τις διευθύνσεις URL διαφορετικών εκδόσεων </strong>, έτσι ώστε οι άλλοι να μπορούν να κατεβάσετε το καθένα αυτόματα.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_15'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_template

    label_standard_27 'Θα πρέπει να <strong>να έχετε ένα έγγραφο ή μια τροφοδοσία με μια λίστα των διαθέσιμων εκδόσεων </strong> έτσι ώστε οι άλλοι να μπορούν να δημιουργήσουν πρότυπα κειμένου(scripts) για να τα κατεβάζουν όλα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_27'
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '!=', :a_list

    label_basic_10 'Θα πρέπει να <strong>παρέχετε πρόσβαση στις εκδόσεις των δεδομένων σας μέσω μιας URL </strong> που να δίνεται η τρέχουσα έκδοση, μια ανιχνεύσιμη σειρά από διευθύνσεις URL ή σε μια σελίδα τεκμηρίωσης, έτσι ώστε οι άνθρωποι μπορούν να τη βρουν.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_10'
    dependency :rule => 'A and (B and C and D and E)'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_versionManagement, '!=', :a_current
    condition_D :q_versionManagement, '!=', :a_template
    condition_E :q_versionManagement, '!=', :a_list

    q_currentDatasetUrl 'Πού είναι το τρέχον σύνολο δεδομένων σας;',
      :discussion_topic => :currentDatasetUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Το τρέχον σύνολο δεδομένων είναι διαθέσιμο στο',
      :help_text => 'Δώστε μια απλή διεύθυνση URL με την πιο πρόσφατη έκδοση του συνόλου δεδομένων. Το περιεχόμενο σε αυτήν τη διεύθυνση URL θα πρέπει να αλλάζει κάθε φορά που μια νέα έκδοση είναι διαθέσιμη.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_current
    a_1 'Σύνδεσμος(URL) Τρέχουσας διεύθυνσης συνόλου δεδομένων (Current Dataset)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τρέχουσας διεύθυνσης συνόλου δεδομένων (Current Dataset)',
      :required => :required

    q_versionsTemplateUrl 'Τι μορφή έχουν οι διευθύνσεις URL του συνόλου δεδομένων;',
      :discussion_topic => :versionsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Οι εκδόσεις ακολουθούν αυτό το σταθερό μοτίβο URL',
      :help_text => 'Αυτή είναι η δομή των διευθύνσεων URL όταν δημοσιεύετε διαφορετικές εκδόσεις. Χρησιμοποιήστε το `{variable}` για να υποδείξετε τα τμήματα του URL προτύπου που αλλάζουν, για παράδειγμα, `http://example.com/data/monthly/mydata- {ΥΥ} {MM} .csv`',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_template
    a_1 'Σύνδεσμος(URL) Προτύπου Έκδοσης',
      :string,
      :input_type => :text,
      :placeholder => 'Σύνδεσμος(URL) Προτύπου Έκδοσης',
      :required => :required

    q_versionsUrl 'Πού είναι η λίστα με τις κυκλοφορίες του συνόλου δεδομένων;',
      :discussion_topic => :versionsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Οι εκδόσεις αυτών των δεδομένων αναφέρονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL σε μια σελίδα ή τροφοδοσία με μια αναγνώσιμη από τη μηχανή, λίστα του συνόλου δεδομένων. Χρησιμοποιήστε το URL της πρώτης σελίδας που θα πρέπει να συνδέετε με τις υπόλοιπες σελίδες.',
      :required => :required
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_series
    condition_B :q_versionManagement, '==', :a_list
    a_1 'Σύνδεσμος(URL) Λίστας Εκδόσεων',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Λίστας Εκδόσεων',
      :required => :required

    q_endpointUrl 'Πού είναι το endpoint για το API σας;',
      :discussion_topic => :endpointUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Το endpoint της υπηρεσίας API είναι',
      :help_text => 'Δώστε μια διεύθυνση URL που είναι ένα σημείο εκκίνησης για τα πρότυπα κειμένων(scripts) των ενδιαφερόμενων ώστε να έχουν πρόσβαση στο API σας. Αυτό πρέπει να είναι ένα έγγραφο περιγραφής της υπηρεσία που να βοηθά το πρότυπο κειμένου(script) να συμπεράνει ποιες υπηρεσίες υπάρχουν.'
    dependency :rule => 'A'
    condition_A :q_releaseType, '==', :a_service
    a_1 'Σύνδεσμος(URL) του Endpoint',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) του Endpoint',
      :requirement => ['basic_11', 'standard_28']

    label_basic_11 'Θα πρέπει να <strong>παρέχετε είτε μια API endpoint URL ή μια διεύθυνση URL προς την τεκμηρίωση του </strong> έτσι ώστε οποισδήποτε να μπορεί να το βρει.',
      :custom_renderer => '/partials/requirement_basic',
      :requirement => 'basic_11'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '==', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_standard_28 'Θα πρέπει να <strong>έχουν ένα έγγραφο περιγραφής υπηρεσίας ή ένα μοναδικό σημείο εισόδου για το API σας </strong> έτσι ώστε οι άνθρωποι μπορούν να έχουν πρόσβαση.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_28'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_C :q_endpointUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_dumpManagement 'Πώς δημοσιεύετε τμήματα(dumps) βάσεων δεδομένων;',
      :discussion_topic => :dumpManagement,
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    a_current 'ως ένα URL που ενημερώνεται τακτικά',
      :help_text => 'Επιλέξτε αυτό αν υπάρχει ένα URL για τους άλλους ώστε να κατεβάζουν την πιο πρόσφατη έκδοση του τρέχοντος τμήματος(dump) της βάσης δεδομένων.',
      :requirement => ['standard_29']
    a_template 'ως συνεπής διευθύνσεις URL για κάθε έκδοση',
      :help_text => 'Επιλέξτε αυτό αν οι διευθύνσεις URL τμημάτων(dumps) της βάσης δεδομένων σας ακολουθούν το ίδιο πρότυπο που περιλαμβάνει την ημερομηνία της δημοσίευσης, για παράδειγμα, μια διεύθυνση URL που ξεκινά \'2013-04\'. Αυτό βοηθά τους άλλους να κατανοήσουν πόσο συχνά ανακοινώνονται/δίνονται στη κυκλοφορία δεδομένα, και να γράψουν πρότυπα κειμένου(scripts) , που προσκομίζουν νέα στοιχεία κάθε φορά που κυκλοφορούν.',
      :requirement => ['exemplar_13']
    a_list 'ως μια λίστα κυκλοφοριών',
      :help_text => 'Επιλέξτε αυτό αν έχετε μια λίστα τμημάτων(dumps) βάσης δεδομένων σε μια ιστοσελίδα ή μια τροφοδοσία (όπως Atom ή RSS) με συνδέσμους προς κάθε επιμέρους έκδοσης και τις λεπτομέρειες της. Αυτό βοηθά τους άλλους να κατανοήσουν πόσο συχνά δίνονται στη κυκλοφορία δεδομένα, και να γράψουν πρότυπα κειμένου(scripts), που προσκομίζουν νέα στοιχεία κάθε φορά που κυκλοφορούν.',
      :requirement => ['exemplar_14']

    label_standard_29 'Θα πρέπει να <strong>έχετε ένα μοναδικό μόνιμο URL για να κατέβασμα του τρέχοντος τμήματος(dump) της βάσης δεδομένων σας </strong> έτσι ώστε οποισδήποτε να μπορει να το βρει.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_29'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_current

    label_exemplar_13 'Θα πρέπει να <strong>χρησιμοποιήσετε ένα συνεπές πρότυπο για τις διευθύνσεις τμημάτων(dumps) της βάσης δεδομένων </strong> έτσι ώστε οι άλλοι να μπορούν να τα κατεβάζουν αυτόματα.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_13'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_template

    label_exemplar_14 'Θα πρέπει να <strong>έχετε ένα έγγραφο ή τροφοδοσία με μια λίστα των διαθέσιμων τμημάτων(dumps) της βάσης δεδομένων </strong> έτσι ώστε οι άλλοι να μπορούν να δημιουργήσουν πρότυπα κειμένου(scripts) για να τα κατεβάζουν όλα',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_14'
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '!=', :a_list

    q_currentDumpUrl 'Πού είναι το τρέχων τμήμα(dump) της βάσης δεδομένων ;',
      :discussion_topic => :currentDumpUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Το πιο πρόσφατο τμήμα(dump) της βάσης δεδομένων είναι πάντα διαθέσιμο στο',
      :help_text => 'Δώστε μια διεύθυνση URL για το πιο πρόσφατο τμήμα(dump) της βάσης δεδομένων. Το περιεχόμενο σε αυτήν τη διεύθυνση URL θα πρέπει να αλλάζει κάθε φορά που ένα νέο τμήμα(dump) της βάσης δεδομένων δημιουργείται.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_current
    a_1 'Σύνδεσμος(URL) Τρέχοντος Τμήματος(dump)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τρέχοντος Τμήματος(dump)',
      :required => :required

    q_dumpsTemplateUrl 'Τι μορφή έχουν οι διευθύνσεις URL τμήματος(dump) της βάσης δεδομένων ;',
      :discussion_topic => :dumpsTemplateUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Τμήματα(dumps) της βάσης δεδομένων ακολουθούν το σύνηθες μοτίβο διεύθυνσης URL',
      :help_text => 'Αυτή είναι η δομή των διευθύνσεων URL όταν δημοσιεύετε διαφορετικές εκδόσεις. Χρησιμοποιήστε το `{variable}` για να υποδείξετε τα τμήματα του URL προτύπου που αλλάζουν, για παράδειγμα, `http://example.com/data/monthly/mydata- {ΥΥ} {MM} .csv`',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_template
    a_1 'Σύνδεσμος(URL) Προτύπου Τμήματος(Dump Template)',
      :string,
      :input_type => :text,
      :placeholder => 'Σύνδεσμος(URL) Προτύπου Τμήματος(Dump Template)',
      :required => :required

    q_dumpsUrl 'Πού είναι η λίστα με τα διαθέσιμα τμήματα(dumps) της βάσης δεδομένων;',
      :discussion_topic => :dumpsUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Ο κατάλογος των τμημάτων(dumps) της βάσης δεδομένων είναι στο',
      :help_text => 'Δώστε μια διεύθυνση URL σε μια σελίδα ή τροφοδοσία με έναν αναγνώσιμο από μηχανή κατάλογο των dump βάσεων δεδομένων. Χρησιμοποιήστε το URL της πρώτης σελίδας που πρέπει να συνδέεται με τις υπόλοιπες σελίδες.',
      :required => :required
    dependency :rule => 'A and B and C'
    condition_A :q_releaseType, '==', :a_service
    condition_B :q_provideDumps, '==', :a_true
    condition_C :q_dumpManagement, '==', :a_list
    a_1 'Σύνδεσμος(URL) Λίστας Τμημάτων(Dump List)',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Λίστας Τμημάτων(Dump List)',
      :required => :required

    q_changeFeedUrl 'Πού είναι η τροφοδοσία μεταβολών σας;',
      :discussion_topic => :changeFeedUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Μια τροφοδοσία μεταβολών σε αυτά τα δεδομένα είναι',
      :help_text => 'Δώστε μια διεύθυνση URL σε μια σελίδα ή τροφοδοσία που παρέχει μια αναγνώσιμη από μηχανή λίστα των προηγούμενων εκδόσεων τμηάτων(dumps) της βάσης δεδομένων. Χρησιμοποιήστε το URL της πρώτης σελίδας που πρέπει να συνδέεται με τις υπόλοιπες σελίδες.',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_changeFeed, '==', :a_true
    a_1 'Σύνδεσμος(URL) Τροφοδοσίας Μεταβολών',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τροφοδοσίας Μεταβολών',
      :required => :required

    label_group_12 'Μορφές',
      :help_text => 'πώς οι άλλοι μπορούν να εργαστούν με τα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_machineReadable 'Είναι αυτά τα δεδομένα αναγνώσιμα από τη μηχανή;',
      :discussion_topic => :machineReadable,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα είναι',
      :help_text => 'Οι άνθρωποι προτιμούν μορφές δεδομένων που είναι εύκολα για επεξεργασία από τον υπολογιστή, για ταχύτητα και ακρίβεια. Για παράδειγμα, μια σαρωμένη φωτοτυπία ενός υπολογιστικού φύλλου δεν θα είναι αναγνώσιμη από τη μηχανή, αλλά ένα αρχείο CSV θα είναι.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'αναγνώσιμα από τη μηχανή',
      :requirement => ['pilot_16']

    label_pilot_16 'Θα πρέπει να <strong>παρέχονται τα δεδομένα σας σε μορφή αναγνώσιμη από μηχανή </strong> έτσι ώστε να είναι εύκολο να επεξεργαστούν.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_16'
    dependency :rule => 'A'
    condition_A :q_machineReadable, '==', :a_false

    q_openStandard 'Έχουν αυτά τα δεδομένα την τυπική ανοιχτή μορφή;',
      :discussion_topic => :openStandard,
      :display_on_certificate => true,
      :text_as_statement => 'Η μορφή των δεδομένων είναι',
      :help_text => 'Τα ανοικτά πρότυπα δημιουργούνται μέσα από μια δίκαιη, διαφανή και συνεργατική διαδικασία. Ο καθένας μπορεί να τα εφαρμόσει και υπάρχει μεγάλη υποστήριξη, οπότε είναι πιο εύκολο για σας να μοιράζεστε δεδομένα με περισσότερους ανθρώπους. Για παράδειγμα, τα XML, CSV και JSON είναι ανοιχτά πρότυπα.',
      :help_text_more_url => 'https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/183962/Open-Standards-Principles-FINAL.pdf',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'μια τυπική ανοικτή μορφή',
      :requirement => ['standard_30']

    label_standard_30 'Θα πρέπει να <strong>παρέχετε τα δεδομένα σας σε ένα τυπικό ανοιχτό πρότυπο </strong> έτσι ώστε οι άλλοι να μπορούν να χρησιμοποιούν ευρέως διαθέσιμα εργαλεία για να τα επεξεργάζονται πιο εύκολα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_30'
    dependency :rule => 'A'
    condition_A :q_openStandard, '==', :a_false

    q_dataType 'Τι είδους δεδομένα δημοσιεύετε;',
      :discussion_topic => :dataType,
      :pick => :any
    a_documents 'έγγραφα αναγνώσιμα από τον άνθρωπο',
      :help_text => 'Επιλέξτε αυτό αν τα δεδομένα προορίζονται να χρησιμοποιούνται από τον άνθρωπο. Για παράδειγμα; έγγραφα πολιτικής, κυβερνητικά έγγραφα, οι εκθέσεις και τα πρακτικά συνεδρίασης. Αυτά έχουν συνήθως κάποια δομή , αλλά κυρίως αποτελούνται από κείμενο.'
    a_statistical 'στατιστικά στοιχεία, όπως εκτιμήσεις, μέσοι όροι και τα ποσοστά',
      :help_text => 'Επιλέξτε αυτό αν τα στοιχεία σας είναι στατιστικά ή αριθμητικά δεδομένα, όπως μετρήσεις, μέσους όρους ή ποσοστά. Όπως και τα αποτελέσματα της απογραφής, πληροφορίες ροής της κυκλοφορίας ή στατιστικές για την εγκληματικότητα για παράδειγμα.'
    a_geographic 'γεωγραφικές πληροφορίες, όπως σημεία και σύνορα',
      :help_text => 'Επιλέξτε αυτό αν τα δεδομένα σας μπορούν να απεικονίζονται σε χάρτη ως σημεία, σύνορα ή γραμμές.'
    a_structured 'άλλα είδη δομημένων δεδομένων',
      :help_text => 'Επιλέξτε αυτό αν τα δεδομένα σας είναι δομημένα με άλλους τρόπους. Όπως τις λεπτομέρειες ενός γεγονότος, τα σιδηροδρομικά δρομολόγια, τα στοιχεία επικοινωνίας ή οτιδήποτε που μπορεί να ερμηνευθεί σαν δεδομένο, και να αναλύθει και παρουσιαστεί με πολλούς τρόπους.'

    q_documentFormat 'Περιλαμβάνουν τα αναγνώσιμα από τον άνθρωπο έγγραφα σας μορφές που',
      :discussion_topic => :documentFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Τα έγγραφα δημοσιεύονται',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_documents
    a_semantic 'περιγράφουν σημασιολογική δομή όπως HTML, Docbook ή Markdown',
      :text_as_statement => 'σε μια σημασιολογική μορφή',
      :help_text => 'Αυτές οι μορφές/δομές μαρκάρουν δομές όπως κεφάλαια, επικεφαλίδες και πίνακες που το καθιστούν εύκολο να δημιουργούνται αυτόματα περιλήψεις όπως πίνακες περιεχομένων και γλωσσάρια. Επίσης διευκολύνουν την εφαρμογή διαφορετικών στυλ στο έγγραφο και έτσι αλλάζει η εμφάνιση του.',
      :requirement => ['standard_31']
    a_format 'περιγράφουν πληροφορίες σχετικά με τη διαμόρφωση, όπως OOXML ή PDF',
      :text_as_statement => 'σε μορφή εμφάνισης',
      :help_text => 'Αυτές οι μορφές δίνουν έμφαση στην εμφάνιση, όπως γραμματοσειρές, χρώματα και την τοποθέτηση των διαφόρων στοιχείων μέσα στη σελίδα. Είναι καλά για χρήση από τον άνθρωπο, αλλά δεν είναι τόσο εύκολο να επεξεργάζονται αυτόματα και να αλλάζουν στυλ.',
      :requirement => ['pilot_17']
    a_unsuitable 'δεν προορίζονται για έγγραφα, όπως το Excel, JSON ή CSV',
      :text_as_statement => 'σε μορφή ακατάλληλη για έγγραφα',
      :help_text => 'Αυτές οι μορφές καλύτερα εξυπηρετούν δομημένα δεδομένα ή σε μορφή πίνακα.'

    label_standard_31 'Θα πρέπει να <strong>δημοσιεύετε έγγραφα σε μορφή που εκθέτει τησημασιολογική δομή </strong> έτσι ώστε οι άλλοι να μπορούν να τα εμφανίζουν σε διαφορετικά στυλ.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_31'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic

    label_pilot_17 'Θα πρέπει να <strong>δημοσιεύετε έγγραφα σε μορφή ειδικά σχεδιασμένη ειδικά για αυτά </strong>, ώστε να είναι εύκολο να επεξεργαστούν.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_17'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_documents
    condition_B :q_documentFormat, '!=', :a_semantic
    condition_C :q_documentFormat, '!=', :a_format

    q_statisticalFormat 'Τα στατιστικά στοιχεία σας περιλαμβάνουν μορφές που',
      :discussion_topic => :statisticalFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Στατιστικά στοιχεία δημοσιεύονται',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_statistical
    a_statistical 'εκθέτουν τη δομή των στατιστικών hypercube δεδομένων, όπως <a href="http://sdmx.org/">SDMX </a> ή <a href="">Data Cube </a>
                     ',
      :text_as_statement => 'σε μια στατιστική μορφή δεδομένων',
      :help_text => 'Ατομικές παρατηρήσεις σε hypercubes αφορούν ένα συγκεκριμένο μέτρο και σύνολο από διαστάσεις. Κάθε παρατήρηση μπορεί επίσης να σχετίζεται με σχολιασμούς που δίνουν επιπλέον πλαίσιο. Μορφές όπως <a href="http://sdmx.org/">SDMX </a> και <a href="http://www.w3.org/TR/vocab-δεδομένα-cube/">Cube Δεδομένων </a> έχουν σχεδιαστεί για να εκφράσουν αυτή την υποκείμενη δομή.',
      :requirement => ['exemplar_15']
    a_tabular 'αντιμετωπίστε τα στατιστικά δεδομένα σαν έναν πίνακα, όπως CSV',
      :text_as_statement => 'σε μορφή πίνακα δεδομένων',
      :help_text => 'Αυτές οι μορφές τοποθετούν τα στατιστικά δεδομένα σε έναν πίνακα γραμμών και στηλών. Αυτό στερείται επιπλέον πλαισίου σχετικά με τον υποκείμενο υπερκύβο, αλλά είναι εύκολο να επεξεργαστεί.',
      :requirement => ['standard_32']
    a_format 'εστιάστε στο μορφότυπο του πίνακα δεδομένων, όπως το Excel',
      :text_as_statement => 'σε μορφή παρουσίασης',
      :help_text => 'Τα υπολογιστικά φύλλα χρησιμοποιούν μορφοποίηση, όπως πλάγια γραφή ή έντονο κείμενο, και ενδοπαραγραφοποίηση(indentation) μέσα στα πεδία για να περιγράψουν την εμφάνισή τους και την υποκείμενη δομή. Αυτό το στυλ βοηθά τους άλλους να κατανοήσουν την έννοια των δεδομένων σας, αλλά τα καθιστά λιγότερο κατάλληλο για επεξεργασία από υπολογιστές.',
      :requirement => ['pilot_18']
    a_unsuitable 'δεν προορίζονται για στατιστικά ή πίνακες δεδομένων, όπως το Word ή PDF.',
      :text_as_statement => 'σε μορφή ακατάλληλη για τα στατιστικά δεδομένα',
      :help_text => 'Αυτές οι μορφές δεν ταιριάζουν σε στατιστικά στοιχεία, διότι επισκιάζουν την υποκείμενη δομή των δεδομένων.'

    label_exemplar_15 'Θα πρέπει να <strong>δημοσιεύετε στατιστικά δεδομένα σε μορφή που εκθέτει τις διαστάσεις και τα μέτρα </strong> έτσι ώστε να είναι εύκολο να αναλυθούν.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_15'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical

    label_standard_32 'Θα πρέπει να <strong>δημοσιεύετε τα στοιχεία πίνακα σε μορφή που εκθέτει πίνακες δεδομένων </strong> έτσι ώστε να είναι εύκολο να αναλυθούν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_32'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular

    label_pilot_18 'Θα πρέπει να <strong>δημοσιεύετε τα στοιχεία πίνακα σε μορφή ειδικά σχεδιασμένη για το σκοπό αυτό </strong> έτσι ώστε να είναι εύκολο να επεξεργαστεί.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_18'
    dependency :rule => 'A and (B and C and D)'
    condition_A :q_dataType, '==', :a_statistical
    condition_B :q_statisticalFormat, '!=', :a_statistical
    condition_C :q_statisticalFormat, '!=', :a_tabular
    condition_D :q_statisticalFormat, '!=', :a_format

    q_geographicFormat 'Μήπως γεωγραφικά δεδομένα σας περιλαμβάνουν μορφές που',
      :discussion_topic => :geographicFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Τα γεωγραφικά δεδομένα είναι δημοσιευμένα',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_geographic
    a_specific 'έχουν σχεδιαστεί για γεωγραφικά δεδομένα όπως <a href="http://www.opengeospatial.org/standards/kml/">KML </a> ή <a href="http://www.geojson.org/">GeoJSON </a>
                     ',
      :text_as_statement => 'σε μια μορφή γεωγραφικών δεδομένων',
      :help_text => 'Αυτές οι μορφές περιγράφουν σημεία, γραμμές και σύνορα, και εκθέτουν τις δομές στα δεδομένα που καθιστούν ευκολότερη την αυτόματη διαδικασία.',
      :requirement => ['exemplar_16']
    a_generic 'διατηρεί τα δεδομένα δομημένα όπως τα JSON, XML και CSV',
      :text_as_statement => 'σε μια γενική μορφή δεδομένων',
      :help_text => 'Οποιαδήποτε μορφή που αποθηκεύει κανονικά δομημένα δεδομένα, μπορεί επίσης να εκφράσει γεωγραφικά δεδομένα, ιδιαίτερα εάν διαθέτει μόνο δεδομένα σχετικά με τα σημεία.',
      :requirement => ['pilot_19']
    a_unsuitable 'δεν έχουν σχεδιαστεί για γεωγραφικά δεδομένα, όπως το Word ή PDF',
      :text_as_statement => 'σε μορφή ακατάλληλη για γεωγραφικά δεδομένα',
      :help_text => 'Σε αυτές τις μορφές δεν ταιριάζουν γεωγραφικά δεδομένα, επειδή αποκρύπτουν την υποκείμενη δομή των δεδομένων.'

    label_exemplar_16 'Θα πρέπει να <strong>δημοσιεύετε γεωγραφικά δεδομένα σε μορφή ειδικά σχεδιασμένη για αυτό το σκοπό </strong> έτσι ώστε οι άλλοι να μπορούν να χρησιμοποιήσουν ευρέως διαθέσιμα εργαλεία για την επεξεργασία τους.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_16'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific

    label_pilot_19 'Θα πρέπει να <strong>δημοσιεύετε γεωγραφικά δεδομένα ως δομημένα δεδομένα </strong> έτσι ώστε να είναι εύκολα στην επεξεργασία.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_19'
    dependency :rule => 'A and (B and C)'
    condition_A :q_dataType, '==', :a_geographic
    condition_B :q_geographicFormat, '!=', :a_specific
    condition_C :q_geographicFormat, '!=', :a_generic

    q_structuredFormat 'Μήπως τα δομημένα δεδομένα σας περιλαμβάνουν μορφές που',
      :discussion_topic => :structuredFormat,
      :display_on_certificate => true,
      :text_as_statement => 'Δομημένα δεδομένα είναι δημοσιευμένα',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_dataType, '==', :a_structured
    a_suitable 'έχουν σχεδιαστεί για δομημένα δεδομένα όπως τα JSON, XML, Turtle ή CSV',
      :text_as_statement => 'σε μια μορφή δομημένων δεδομένων',
      :help_text => 'Αυτές οι μορφές οργανώνουν τα δεδομένα σε μια βασική δομή πραγμάτων που έχουν τιμές σε ένα γνωστό σύνολο ιδιοτήτων. Αυτές οι μορφές είναι εύκολο για τους υπολογιστές να τις επεξεργάζονται αυτόματα.',
      :requirement => ['pilot_20']
    a_unsuitable 'δεν έχουν σχεδιαστεί για δομημένα δεδομένα όπως το Word ή PDF',
      :text_as_statement => 'σε μια μορφή ακατάλληλη για δομημένα δεδομένα',
      :help_text => 'Αυτές οι μορφές δεν ταιριάζουν σε αυτό το είδος των δεδομένων, διότι αποκρύπτουν υποκείμενη δομή τους.'

    label_pilot_20 'Θα πρέπει να <strong>δημοσιεύετε δομημένα δεδομένα σε μορφή ειδικά σχεδιασμένη για αυτο το σκοπό </strong> έτσι ώστε να είναι εύκολη η επεξεργασία τους.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_20'
    dependency :rule => 'A and (B)'
    condition_A :q_dataType, '==', :a_structured
    condition_B :q_structuredFormat, '!=', :a_suitable

    q_identifiers 'Μήπως τα δεδομένα σας χρησιμοποιούν μόνιμα αναγνωριστικά;',
      :discussion_topic => :identifiers,
      :display_on_certificate => true,
      :text_as_statement => 'Τα δεδομένα περιλαμβάνουν',
      :help_text => 'Τα στοιχεία συνήθως αναφέρονται σε πραγματικά πράγματα όπως τα σχολεία, τους δρόμους ή τις χρήσεις συστημάτων κωδικοποίησης. Εάν τα δεδομένα από διαφορετικές πηγές χρησιμοποιούν το ίδιο μόνιμο και μοναδικό αναγνωριστικό για να αναφερθούν σε ίδια πράγματα, τότε οι άλλοι θα μπορούν να συνδυάσουν τις πηγές εύκολα δημιουργώντας πιο χρήσιμα δεδομένα. Αναγνωριστικά μπορούν να είναι τα GUID, DOIs ή διευθύνσεις URL.',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'μόνιμα αναγνωριστικά',
      :requirement => ['standard_33']

    label_standard_33 'Θα πρέπει να <strong>χρησιμοποιείτε αναγνωριστικά για πράγματα στα δεδομένα σας </strong> έτσι ώστε να μπορούν εύκολα να σχετίζονται με άλλα δεδομένα σχετικά με αυτά τα πράγματα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_33'
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_false

    q_resolvingIds 'Μπορούν τα αναγνωριστικά στα δεδομένα σας να χρησιμοποιηθούν για να βρεθούν επιπλέον πληροφορίες;',
      :discussion_topic => :resolvingIds,
      :display_on_certificate => true,
      :text_as_statement => 'Τα μόνιμα αναγνωριστικά',
      :pick => :one
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'όχι, τα αναγνωριστικά δεν μπορούν να χρησιμοποιηθούν για να βρεθούν πρόσθετες πληροφορίες',
      :text_as_statement => ''
    a_service 'ναι, υπάρχει μια υπηρεσία που οι άνθρωποι μπορούν να χρησιμοποιήσουν για να προσδιορίσουν τα αναγνωριστικά.',
      :text_as_statement => 'προσδιορίζονται χρησιμοποιώντας μια υπηρεσία',
      :help_text => 'Online υπηρεσίες μπορούν να χρησιμοποιηθούν για να πληροφορήσουν τον κόσμο σχετικά με τα αναγνωριστικά, όπως τα αναγνωριστικά GUID ή DOIs στα οποία δεν υπάρχει άμεση πρόσβαση όπως σε μια σελίδα URL.',
      :requirement => ['standard_34']
    a_resolvable 'ναι, τα αναγνωριστικά είναι διευθύνσεις(URLs) σελίδων που προσδιορίζονται οτι δίνουν πληροφορίες',
      :text_as_statement => 'προσδιορίζονται επειδή είναι διευθύνσεις(URLs) σελίδων',
      :help_text => 'Οι διευθύνσεις(URLs) σελίδων είναι χρήσιμες τόσο για τους ανθρώπους όσο και για τους υπολογιστές. Οι άνθρωποι μπορούν να βάλουν μια διεύθυνση(URL) στον browser τους και να διαβάσουν περισσότερες πληροφορίες, όπως <a href="http://opencorporates.com/companies/gb/08030289">εταιρείες </a> και <a href="">ταχυδρομικούς κώδικες </a>. Οι υπολογιστές μπορούν επίσης να επεξεργαστούν αυτές τις επιπλέον πληροφορίες, χρησιμοποιώντας δέσμες ενεργειών(scripts) να έχουν πρόσβαση στα υποκείμενα δεδομένα.',
      :requirement => ['exemplar_17']

    label_standard_34 'Θα πρέπει να <strong>παρέχετε μια υπηρεσία για τον προσδιορισμό των αναγνωριστικών που χρησιμοποιείτε </strong> έτσι ώστε άλλοι να μπορούν να βρουν επιπλέον πληροφορίες σχετικά με αυτά.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_34'
    dependency :rule => 'A and (B and C)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_service
    condition_C :q_resolvingIds, '!=', :a_resolvable

    label_exemplar_17 'Θα πρέπει να <strong>συνδέεται το κάθε ένα από τα πράγματα στα δεδομένα σας με μια ιστοσελίδα με πληροφορίες </strong> έτσι ώστε οι άνθρωποι μπορούν εύκολα να βρουν και να μοιραστούν αυτές τις πληροφορίες.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_17'
    dependency :rule => 'A and (B)'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '!=', :a_resolvable

    q_resolutionServiceURL 'Πού είναι η υπηρεσία που χρησιμοποιείται για να προσδιορίσει τα αναγνωριστικά;',
      :discussion_topic => :resolutionServiceURL,
      :display_on_certificate => true,
      :text_as_statement => 'Η υπηρεσία προσδιορισμού αναγνωριστικού είναι στο',
      :help_text => 'Η υπηρεσία προσδιορισμού θα μπορεί να λάβει ένα αναγνωριστικό ως παράμετρο ερωτήματος και να δώσει πίσω κάποια πληροφορία σχετικά με το πράγμα που προσδιορίζει.'
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    a_1 'Σύνδεσμος(URL) Υπηρεσίας Προσδιορισμού Αναγνωριστικών',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Υπηρεσίας Προσδιορισμού Αναγνωριστικών',
      :requirement => ['standard_35']

    label_standard_35 'Θα πρέπει να <strong>έχετε μια διεύθυνση(URL) μέσω της οποίας θα μπορούν να προσδιοριστούν τα αναγνωριστικά </strong> έτσι ώστε περισσότερες πληροφορίες σχετικά με αυτά να μπορούν να βρεθούν από έναν υπολογιστή.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_35'
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_resolvingIds, '==', :a_service
    condition_C :q_resolutionServiceURL, '==', {:string_value => '', :answer_reference => '1'}

    q_existingExternalUrls 'Υπάρχουν οι πληροφορίες τρίτων σχετικά με τα πράγματα στα δεδομένα σας στο διαδίκτυο;',
      :discussion_topic => :existingExternalUrls,
      :help_text => 'Μερικές φορές άλλοι άνθρωποι έξω από τον έλεγχό σας παρέχουν διευθύνσεις URL για πράγματα στα δεδομένα σας. Για παράδειγμα, τα δεδομένα σας θα μπορούσαν να περιέχουν ταχυδρομικούς κώδικες που συνδέονται με την ιστοσελίδα της Ordnance Survey.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A'
    condition_A :q_identifiers, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_reliableExternalUrls 'Είναι αυτές οι πληροφορίες τρίτων αξιόπιστες;',
      :discussion_topic => :reliableExternalUrls,
      :help_text => 'Εάν σε ένα τρίτο μέρος παρέχει δημόσιες διευθύνσεις URL για τα πράγματα στα δεδομένα σας, πιθανότατα να λαμβάνει μέτρα για να εξασφαλίσει την ποιότητα και την αξιοπιστία των δεδομένων. Αυτό είναι ένα μέτρο του κατά πόσο εμπιστεύεστε τις διαδικασίες τους πραγματοποιώντας το. Ψάξτε για το ανοιχτό πιστοποιητικό δεδομένων τους ή παρόμοια χαρακτηριστικά που θα βοηθήσουν στην απόφασή σας.',
      :pick => :one,
      :required => :exemplar
    dependency :rule => 'A and B'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    a_false 'no'
    a_true 'yes'

    q_externalUrls 'Μήπως τα δεδομένα σας χρησιμοποιούν αυτές τις διευθύνσεις URL από τρίτους;',
      :discussion_topic => :externalUrls,
      :display_on_certificate => true,
      :text_as_statement => 'Σύνδεσμοι(URLs) Τρίτων-μερών',
      :help_text => 'Θα πρέπει να χρησιμοποιείτε τις διευθύνσεις URL τρίτων που προσδιορίζουν πληροφορίες σχετικά με τα πράγματα που περιγράφονται στα δεδομένα σας. Αυτό μειώνει τις επικαλύψεις, και βοηθά τους ανθρώπους να συνδυάζουν δεδομένα από διαφορετικές πηγές για να γίνουν πιο χρήσιμα.',
      :pick => :one
    dependency :rule => 'A and B and C'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'αναφέρονται σε αυτά τα δεδομένα',
      :requirement => ['exemplar_18']

    label_exemplar_18 'Θα πρέπει να <strong>χρησιμοποιείτε URLs πληροφοριών τρίτων μερών στα δεδομένα σας </strong> έτσι ώστε να είναι εύκολο να συνδυαστούν με άλλα δεδομένα που χρησιμοποιούν αυτές τις διευθύνσεις URL.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_18'
    dependency :rule => 'A and B and C and D'
    condition_A :q_identifiers, '==', :a_true
    condition_B :q_existingExternalUrls, '==', :a_true
    condition_C :q_reliableExternalUrls, '==', :a_true
    condition_D :q_externalUrls, '==', :a_false

    label_group_13 'Εμπιστοσύνη',
      :help_text => 'πόση εμπιστοσύνη μπορούν οι άλλοι να έχουν στα δεδομένα τους',
      :customer_renderer => '/partials/fieldset'

    q_provenance 'Παρέχετε αναγνώσιμη από τη μηχανή προέλευση για τα δεδομένα σας;',
      :discussion_topic => :provenance,
      :display_on_certificate => true,
      :text_as_statement => 'Η προέλευση αυτών των δεδομένων είναι',
      :help_text => 'Αυτό έχει να κάνει με την προέλευση του πώς δημιουργήθηκαν τα δεδομένα σας και υπέστησαν επεξεργασία πριν από τη δημοσίευσή τους. Χτίζεται εμπιστοσύνη για τα δεδομένα που δημοσιεύετε επειδή ο οποιοσδήποτε θα μπορεί να εντοπίζει το πώς έχουν αντιμετωπιστεί.',
      :help_text_more_url => 'http://www.w3.org/TR/prov-primer/',
      :pick => :one
    a_false 'no',
      :text_as_statement => ''
    a_true 'yes',
      :text_as_statement => 'αναγνώσιμη απο τη μηχανή',
      :requirement => ['exemplar_19']

    label_exemplar_19 'Θα πρέπει να <strong>παρέχετε ένα αναγνώσιμο από τη μηχανή μονοπάτι προέλευσης </strong> για τα δεδομένα σας έτσι ώστε οι άλλοι να μπορούν να εντοπίζουν το πώς έγινε η επεξεργασία.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_19'
    dependency :rule => 'A'
    condition_A :q_provenance, '==', :a_false

    q_digitalCertificate 'Πού μας περιγράφετε το πώς αυτοί που λαμβάνουν τα δεδομένα μπορούν να ελέγξουν ότι προέρχονται από εσάς;',
      :discussion_topic => :digitalCertificate,
      :display_on_certificate => true,
      :text_as_statement => 'Αυτά τα δεδομένα μπορούν να επαληθευτούν χρησιμοποιώντας το',
      :help_text => 'Αν παραδινετε σημαντικά στοιχεία σε άλλους θα πρέπει να είναι σε θέση να μπορούν να ελέγχουν ότι αυτό που λαμβάνουν είναι το ίδιο με αυτό που δημοσιεύσατε. Για παράδειγμα, μπορείτε να υπογράφετε ψηφιακά(digitally sign) τα δεδομένα που δημοσιεύετε, έτσι ώστε κάποιος να μπορεί να πει αν έχουν αλλοιωθεί.'
    a_1 'Σύνδεσμος(URL) Διαδικασίας Επαλήθευσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Διαδικασίας Επαλήθευσης',
      :requirement => ['exemplar_20']

    label_exemplar_20 'Θα πρέπει να <strong>περιγράφετε το πώς οι άλλοι θα μπορούν να ελέγξουν ότι τα δεδομένα που παρέλαβαν είναι τα ίδιο με αυτά που δημοσιεύσατε </strong> έτσι ώστε να μπορούν να τα εμπιστεύονται.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_20'
    dependency :rule => 'A'
    condition_A :q_digitalCertificate, '==', {:string_value => '', :answer_reference => '1'}

  end

  section_social 'Κοινωνικές Πληροφορίες',
    :description => 'Τεκμηρίωση, υποστήριξη και υπηρεσίες' do

    label_group_15 'Τεκμηρίωση',
      :help_text => 'το πώς βοηθάτε τους άλλους να κατανοήσουν το πλαίσιο και το περιεχόμενο των δεδομένων σας',
      :customer_renderer => '/partials/fieldset'

    q_documentationMetadata 'Μήπως τεκμηρίωση των δεδομένων σας περιλαμβάνει δεδομένα αναγνώσιμα από τη μηχανή για',
      :discussion_topic => :documentationMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Η τεκμηρίωση περιλαμβάνει στοιχεία αναγνώσιμα από τη μηχανή για',
      :pick => :any
    dependency :rule => 'A'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    a_title 'τον τίτλο',
      :text_as_statement => 'τον τίτλο',
      :requirement => ['standard_36']
    a_description 'την περιγραφή',
      :text_as_statement => 'την περιγραφή',
      :requirement => ['standard_37']
    a_issued 'την ημερομηνία κυκλοφορίας',
      :text_as_statement => 'την ημερομηνία κυκλοφορίας',
      :requirement => ['standard_38']
    a_modified 'την ημερομηνία τροποποίησης',
      :text_as_statement => 'την ημερομηνία τροποποίησης',
      :requirement => ['standard_39']
    a_accrualPeriodicity 'την συχνότητα των κυκλοφοριών',
      :text_as_statement => 'την συχνότητα κυκλοφορίας',
      :requirement => ['standard_40']
    a_identifier 'το αναγνωριστικό',
      :text_as_statement => 'το αναγνωριστικό',
      :requirement => ['standard_41']
    a_landingPage 'τη σελίδα προορισμού',
      :text_as_statement => 'τη σελίδα προορισμού',
      :requirement => ['standard_42']
    a_language 'τη γλώσσα',
      :text_as_statement => 'τη γλώσσα',
      :requirement => ['standard_43']
    a_publisher 'τον εκδότη',
      :text_as_statement => 'τον εκδότη',
      :requirement => ['standard_44']
    a_spatial 'τη χωρική / γεωγραφική κάλυψη',
      :text_as_statement => 'τη χωρική / γεωγραφική κάλυψη',
      :requirement => ['standard_45']
    a_temporal 'τη χρονική κάλυψη',
      :text_as_statement => 'τη χρονική κάλυψη',
      :requirement => ['standard_46']
    a_theme 'το(-α) Θέμα(-τα)',
      :text_as_statement => 'το(-α) Θέμα(-τα)',
      :requirement => ['standard_47']
    a_keyword 'το(-α) κλειδί (α) ή ετικέτα (-ες)',
      :text_as_statement => 'το(-α) κλειδί (α) ή ετικέτα (-ες)',
      :requirement => ['standard_48']
    a_distribution 'τη(-ις) διανομή (-ες)',
      :text_as_statement => 'τη(-ις) διανομή (-ες)'

    label_standard_36 'Θα πρέπει να <strong>συμπεριλάβετε έναν αναγνώσιμο από τη μηχανή τίτλο στοιχείων στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να ξέρει πώς να αναφερθεί σε αυτό.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_36'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_title

    label_standard_37 'Θα πρέπει να <strong>συμπεριλάβετε περιγραφή των δεδομένων αναγνώσιμη από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γωρίζει τι περιέχει.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_37'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_description

    label_standard_38 'Θα πρέπει να <strong>συμπεριλάβετε μια αναγνώσιμη από τη μηχανή ημερομηνία κυκλοφορίας δεδομένων στην τεκμηρίωση σας </strong> έτσι ώστε κάποιος να γνωρίζει πώς είναι έγκαιρη.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_38'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_issued

    label_standard_39 'Θα πρέπει να <strong>περιλαμβάνεται η ημερομηνία τελευταίας τροποποίησης αναγνώσιμη από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει αν έχει τα πιο πρόσφατα δεδομένα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_39'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_modified

    label_standard_40 'Θα πρέπει να <strong>παρέχετε μεταδεδομένα αναγνώσιμα από τη μηχανή σχετικά με το πόσο συχνά κυκλοφορείτε νέες εκδόσεις των δεδομένων σας </strong>έτσι ώστε κάποιος να γνωρίζει πόσο συχνά τα ενημερώνετε.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_40'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_accrualPeriodicity

    label_standard_41 'Θα πρέπει να <strong>συμπεριλάβετε μια κανονική διεύθυνση URL για τα δεδομένα στην αναγνώσιμη από τη μηχανή τεκμηρίωσή σας </strong> έτσι ώστε κάποιος να γνωρίζει πώς να έχει συνεπή πρόσβαση.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_41'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_identifier

    label_standard_42 'Θα πρέπει να <strong>συμπεριλάβετε μια κανονική διεύθυνση URL στην ίδια την αναγνώσιμη από τη μηχανή τεκμηρίωση </strong>έτσι ώστε κάποιος να γνωρίζει πώς να έχει συνεπή πρόσβαση σε αυτή.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_42'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_landingPage

    label_standard_43 'Θα πρέπει να <strong>συμπεριλάβετε τη γλώσσα των δεδομένων στην αναγνώσιμη από τη μηχανή τεκμηρίωση σας </strong>έτσι ώστε αν κάποιος ψάχνει για αυτό να γνωρίζει αν θα μπορεί να το καταλάβει.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_43'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_language

    label_standard_44 'Θα πρέπει να <strong>υποδεικνύετε τον εκδότη των δεδομένων στην αναγνώσιμη από τη μηχανή τεκμηρίωσή σας </strong> έτσι ώστε κάποιος να μπορεί να αποφασίσει πόσο να εμπιστευτεί τα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_44'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_publisher

    label_standard_45 'Θα πρέπει να <strong>συμπεριλάβετε τη γεωγραφική κάλυψη στην αναγνώσιμη από τη μηχανή τεκμηρίωση σας </strong>έτσι ώστε κάποιος να καταλαβαίνει πού τα δεδομένα σας να ισχύουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_45'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_spatial

    label_standard_46 'Θα πρέπει να <strong>συμπεριλάβετε τη χρονική κάλυψη στην αναγνώσιμη από τη μηχανή τεκμηρίωση σας </strong>έτσι ώστε κάποιος να καταλαβαίνει πότε τα δεδομένα σας να ισχύουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_46'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_temporal

    label_standard_47 'Θα πρέπει να <strong>συμπεριλάβετε το θέμα στην αναγνώσιμη από τη μηχανή τεκμηρίωση σας </strong>έτσι ώστε κάποιος να καταλαβαίνει για το τι περίπου πρόκειται.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_47'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_theme

    label_standard_48 'Θα πρέπει να <strong>συμπεριλάβετε αναγνώσιμα από τη μηχανή κλειδιά ή ετικέτες στην τεκμηρίωση σας </strong>έτσι ώστε να βοηθήσετε τους άλλους να ψάξουν μέσα στα δεδομένα πιο αποτελεσματικά.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_48'
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '!=', :a_keyword

    q_distributionMetadata 'Μήπως η τεκμηρίωση περιλαμβάνει αναγνώσιμα από τη μηχανή μεταδεδομένα σε κάθε διανομή για',
      :discussion_topic => :distributionMetadata,
      :display_on_certificate => true,
      :text_as_statement => 'Η τεκμηρίωση για κάθε διανομή περιλαμβάνει δεδομένα αναγνώσιμα από τη μηχανή για',
      :pick => :any
    dependency :rule => 'A and B'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    a_title 'τον τίτλο',
      :text_as_statement => 'τον τίτλο',
      :requirement => ['standard_49']
    a_description 'την περιγραφή',
      :text_as_statement => 'την περιγραφή',
      :requirement => ['standard_50']
    a_issued 'την ημερομηνία κυκλοφορίας',
      :text_as_statement => 'την ημερομηνία κυκλοφορίας',
      :requirement => ['standard_51']
    a_modified 'την ημερομηνία τροποποίησης',
      :text_as_statement => 'την ημερομηνία τροποποίησης',
      :requirement => ['standard_52']
    a_rights 'τη δήλωση δικαιωμάτων',
      :text_as_statement => 'τη δήλωση δικαιωμάτων',
      :requirement => ['standard_53']
    a_accessURL 'Σύνδεσμος(URL) για πρόσβαση στα δεδομένα.',
      :text_as_statement => 'μια διεύθυνση URL για πρόσβαση στα δεδομένα',
      :help_text => 'Αυτά τα μεταδεδομένα θα πρέπει να χρησιμοποιούνται όταν τα δεδομένα σας δεν είναι διαθέσιμα για λήψη από το διαδίκτυο, σαν ένα API για παράδειγμα.'
    a_downloadURL 'Σύνδεσμος(URL) για να κατεβάσετε το σύνολο των δεδομένων',
      :text_as_statement => 'μια διεύθυνση URL για να κατεβάσετε το σύνολο δεδομένων'
    a_byteSize 'μέγεθος σε bytes',
      :text_as_statement => 'μέγεθος σε bytes'
    a_mediaType 'το είδος της λήψης μέσου',
      :text_as_statement => 'το είδος της λήψης μέσου'

    label_standard_49 'Θα πρέπει να <strong>συμπεριλάβετε τους αναγνώσιμους από τη μηχανή τίτλους στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει πώς να αναφερθεί σε κάθε κατανομή των δεδομένων.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_49'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_title

    label_standard_50 'Θα πρέπει να <strong>συμπεριλάβετε περιγραφές αναγνώσιμες από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει τι περιέχει κάθε κατανομή των δεδομένων.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_50'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_description

    label_standard_51 'Θα πρέπει να <strong>συμπεριλάβετε ημερομηνίες κυκλοφορίας αναγνώσιμες από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει το πόσο πρόσφατη είναι η κάθε διανομή.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_51'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_issued

    label_standard_52 'Θα πρέπει να <strong>συμπεριλάβετε ημερομηνίες τελευταίας τροποποίησης αναγνώσιμες από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει αν το αντίγραφο των δεδομένων που έχει είναι ενημερωμένο.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_52'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_modified

    label_standard_53 'Θα πρέπει να <strong>συμπεριλάβετε ένα σύνδεσμο για την ισχύουσα κατάσταση των δικαιωμάτων αναγνώσιμη από τη μηχανή στην τεκμηρίωση σας </strong>έτσι ώστε κάποιος να γνωρίζει τιμπορεί να κάνει με την διανομή των δεδομένων.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_53'
    dependency :rule => 'A and B and C'
    condition_A :q_documentationUrl, '!=', {:string_value => '', :answer_reference => '1'}
    condition_B :q_documentationMetadata, '==', :a_distribution
    condition_C :q_distributionMetadata, '!=', :a_rights

    q_technicalDocumentation 'Πού είναι η τεχνική τεκμηρίωση για τα δεδομένα;',
      :discussion_topic => :technicalDocumentation,
      :display_on_certificate => true,
      :text_as_statement => 'Η τεχνική τεκμηρίωση για τα στοιχεία είναι στο'
    a_1 'Σύνδεσμος(URL) Τεχνικής Τεκμηρίωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεχνικής Τεκμηρίωσης',
      :requirement => ['pilot_21']

    label_pilot_21 'Θα πρέπει να <strong>παρέχετε τεχνική τεκμηρίωση για τα στοιχεία </strong> έτσι ώστε οι άνθρωποι να καταλάβουν πώς να το χρησιμοποιήσουν.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_21'
    dependency :rule => 'A'
    condition_A :q_technicalDocumentation, '==', {:string_value => '', :answer_reference => '1'}

    q_vocabulary 'Μήπως οι τύποι δεδομένων χρησιμοποιούν λεξιλόγιο ή σχήματα;',
      :discussion_topic => :vocabulary,
      :help_text => 'Μορφές όπως CSV, JSON, XML ή Turtle χρησιμοποιούν λεξιλόγια ή σχήματα που πληροφορούν για το τι στήλες ή ιδιότητες περιέχουν τα δεδομένα.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_schemaDocumentationUrl 'Πού είναι τεκμηρίωση σχετικά με τα λεξιλόγια των δεδομένων σας;',
      :discussion_topic => :schemaDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Τα λεξιλόγια που χρησιμοποιούνται από αυτά τα δεδομένα τεκμηριώνονται στο'
    dependency :rule => 'A'
    condition_A :q_vocabulary, '==', :a_true
    a_1 'Σύνδεσμος(URL) Σχήματος Τεκμηρίωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Σχήματος Τεκμηρίωσης',
      :requirement => ['standard_54']

    label_standard_54 'Θα πρέπει να <strong>τεκμηριώνετε κάθε λεξιλόγιο που χρησιμοποιούν μέσα τα δεδομένα σας </strong>έτσι ώστε οι άλλοι να ξέρουν πώς να το ερμηνεύσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_54'
    dependency :rule => 'A and B'
    condition_A :q_vocabulary, '==', :a_true
    condition_B :q_schemaDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_codelists 'Υπάρχουν κωδικοί που χρησιμοποιούνται σε αυτά τα δεδομένα;',
      :discussion_topic => :codelists,
      :help_text => 'Εάν τα δεδομένα σας χρησιμοποιούν τους κωδικούς για να αναφερθούν σε πράγματα όπως γεωγραφικές περιοχές, κατηγορίες δαπανών ή ασθένειες για παράδειγμα, αυτά θα πρέπει να εξηγηθούν.',
      :pick => :one,
      :required => :standard
    a_false 'no'
    a_true 'yes'

    q_codelistDocumentationUrl 'Που είναι τεκμηριωμένοι οι τυχόν κώδικες στα δεδομένα σας;',
      :discussion_topic => :codelistDocumentationUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Οι κωδικοί σε αυτά τα δεδομένα τεκμηριώνονται στο'
    dependency :rule => 'A'
    condition_A :q_codelists, '==', :a_true
    a_1 'Σύνδεσμος(URL) Τεκμηρίωσης Καταλόγου Κωδικών',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Τεκμηρίωσης Καταλόγου Κωδικών',
      :requirement => ['standard_55']

    label_standard_55 'Θα πρέπει να <strong>τεκνηριώνετε τους κωδικούς που χρησιμοποιούνται στα δεδομένα σας </strong>, έτσι ώστε οι άλλοι να ξέρουν πώς να τα ερμηνεύσουν.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_55'
    dependency :rule => 'A and B'
    condition_A :q_codelists, '==', :a_true
    condition_B :q_codelistDocumentationUrl, '==', {:string_value => '', :answer_reference => '1'}

    label_group_16 'Υποστήριξη',
      :help_text => 'πώς επικοινωνείτε με τους ανθρώπους που χρησιμοποιούν τα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_contactUrl 'Πού μπορεί κάποιος να μάθει πώς να επικοινωνήσει με κάποιον άλλο κάνοντας ερωτήσεις σχετικά με αυτά τα δεδομένα;',
      :discussion_topic => :contactUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Μάθετε πώς μπορείτε να επικοινωνήσετε με κάποιον σχετικά με αυτά τα δεδομένα στο',
      :help_text => 'Δώστε μια διεύθυνση URL για μια σελίδα που περιγράφει το πώς οι άνθρωποι μπορούν να επικοινωνήσουν με κάποιον, αν έχουν ερωτήσεις σχετικά με τα δεδομένα.'
    a_1 'Τεκμηρίωση Επικοινωνίας',
      :string,
      :input_type => :url,
      :placeholder => 'Τεκμηρίωση Επικοινωνίας',
      :requirement => ['pilot_22']

    label_pilot_22 'Θα πρέπει να <strong>παρέχετε πληροφορίες επικοινωνίας στους άλλους ώστε να μπορούν να στέλνουν ερωτήσεις </strong>για τα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_22'
    dependency :rule => 'A'
    condition_A :q_contactUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_improvementsContact 'Πού μπορούν οι άνθρωποι να μάθουν πώς να βελτιώσουν τον τρόπο που τα δεδομένα σας έχουν δημοσιευτεί;',
      :discussion_topic => :improvementsContact,
      :display_on_certificate => true,
      :text_as_statement => 'Μάθετε πώς γίνονται οι προτάσεις βελτίωσης για τη δημοσίευση στο'
    a_1 'Σύνδεσμος(URL) Προτάσεων Βελτίωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Προτάσεων Βελτίωσης',
      :requirement => ['pilot_23']

    label_pilot_23 'Θα πρέπει να <strong>παρέχετε οδηγίες σχετικά με το πώς θα γίνονται οι προτάσεις βελτιωσης </strong>όσον αφορά τον τρόπο που δημοσιεύονται τα δεδομένα έτσι ώστε να μπορείτε να ανακαλύψετε το τι χρειάζονται οι άλλοι.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_23'
    dependency :rule => 'A'
    condition_A :q_improvementsContact, '==', {:string_value => '', :answer_reference => '1'}

    q_dataProtectionUrl 'Πού μπορεί κάποιος να μάθει πώς να επικοινωνήσει με κάποιον σχετικά με ερωτήσεις για την ιδιωτικότητα και προστασία δεδομένων προσωπικού χαρακτήρα;',
      :discussion_topic => :dataProtectionUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Μάθετε πού να στέλνετε ερωτήσεις σχετικά με την ιδιωτικότητα και προστασία δεδομένων προσωπικού χαρακτήρα στο'
    a_1 'Τεκμηρίωση Εμπιστευτικής Επικοινωνίας',
      :string,
      :input_type => :url,
      :placeholder => 'Τεκμηρίωση Εμπιστευτικής Επικοινωνίας',
      :requirement => ['pilot_24']

    label_pilot_24 'Θα πρέπει να <strong>παρέχετε πληροφορίες επικοινωνίας έτσι ώστε κάποιος να μπορεί να στείλει ερωτήσεις σχετικά με την ιδιωτικότητα και προστασία δεδομένων προσωπικού χαρακτήρα </strong>αλλά και την κοινοποίηση των προσωπικών στοιχείων.',
      :custom_renderer => '/partials/requirement_pilot',
      :requirement => 'pilot_24'
    dependency :rule => 'A'
    condition_A :q_dataProtectionUrl, '==', {:string_value => '', :answer_reference => '1'}

    q_socialMedia 'Χρησιμοποιείτε τα μέσα κοινωνικής δικτύωσης για να είστε σε επαφή με τους ανθρώπους που χρησιμοποιούν τα δεδομένα σας;',
      :discussion_topic => :socialMedia,
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['standard_56']

    label_standard_56 'Θα πρέπει να <strong>χρησιμοποιείτε τα μέσα κοινωνικής δικτύωσης για να αναζητήσετε τους ανθρώπους που χρησιμοποιούν τα δεδομένα σας </strong> και να μάθετε πώς χρησιμοποιούνται.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_56'
    dependency :rule => 'A'
    condition_A :q_socialMedia, '==', :a_false

    repeater 'Λογαριασμός' do

      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      q_account 'Σε ποια μέσα κοινωνικής δικτύωσης έχεις λογαριασμό και μπορεί κάποιος να σε βρει;',
        :discussion_topic => :account,
        :display_on_certificate => true,
        :text_as_statement => 'Επικοινωνήστε με τον επιμελητή μέσω των λογαριασμών του στα μέσα κοινωνικής δικτύωσης.',
        :help_text => 'Δώστε τις διευθύνσεις URL για τους λογαριασμούς των μέσων κοινωνικής δικτύωσής σας, όπως στο Twitter ή στο Facebook.',
        :required => :required
      dependency :rule => 'A'
      condition_A :q_socialMedia, '==', :a_true
      a_1 'Σύνδεσμος(URL) Μέσου Κοινωνικής Δικτύωσης',
        :string,
        :input_type => :url,
        :required => :required,
        :placeholder => 'Σύνδεσμος(URL) Μέσου Κοινωνικής Δικτύωσης'

    end

    q_forum 'Που θα γίνονται οι συζητήσες για αυτό το σύνολο των δεδομένων;',
      :discussion_topic => :forum,
      :display_on_certificate => true,
      :text_as_statement => 'Συζητήστε αυτά τα δεδομένα στο',
      :help_text => 'Δώστε μια διεύθυνση URL στο φόρουμ σας ή στη λίστα αλληλογραφίας σας, όπου οι άλλοι μπορούν να μιλήσουν για τα δεδομένα σας.'
    a_1 'Σύνδεσμος(URL) Φόρουμ ή Λίστας αλληλογραφίας',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Φόρουμ ή Λίστας αλληλογραφίας',
      :requirement => ['standard_57']

    label_standard_57 'Θα πρέπει να <strong>πείτε στους άλλους που μπορούν να συζητηθούν τα δεδομένα σας </strong> και να υπάρξει αλληλοϋποστήριξη.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_57'
    dependency :rule => 'A'
    condition_A :q_forum, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionReporting 'Πού μπορούν οι άλλοι να μάθουν πώς να ζητούν διορθώσεις στα στοιχεία σας;',
      :discussion_topic => :correctionReporting,
      :display_on_certificate => true,
      :text_as_statement => 'Μάθετε πώς μπορείτε να ζητήσετε διορθώσεις δεδομένων στο',
      :help_text => 'Δώστε μια διεύθυνση URL, όπου κάποιος θα μπορεί να αναφέρει τα λάθη που εντόπισε στα δεδομένα σας.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Σύνδεσμος(URL) Οδηγιών Διόρθωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Οδηγιών Διόρθωσης',
      :requirement => ['standard_58']

    label_standard_58 'Θα πρέπει να <strong>παρέχετε οδηγίες σχετικά με το πώς κάποιος θα μπορεί να αναφέρει λάθη </strong> στα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_58'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionReporting, '==', {:string_value => '', :answer_reference => '1'}

    q_correctionDiscovery 'Πού μπορεί κάποιος να μάθει πώς να λαμβάνει ειδοποιήσεις για διορθώσεις στα δεδομένα σας;',
      :discussion_topic => :correctionDiscovery,
      :display_on_certificate => true,
      :text_as_statement => 'Μάθετε πώς για να λαμβάνετε ειδοποιήσεις σχετικά με τις διορθώσεις των δεδομένων σας στο',
      :help_text => 'Δώστε μια διεύθυνση URL όπου περιγράφετε πώς οι ειδοποιήσεις σχετικά με τις διορθώσεις κοινοποιούνται μεταξύ των ανθρώπων.'
    dependency :rule => 'A'
    condition_A :q_corrected, '==', :a_true
    a_1 'Σύνδεσμος(URL) Κοινοποίησης Διόρθωσης',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Κοινοποίησης Διόρθωσης',
      :requirement => ['standard_59']

    label_standard_59 'Θα πρέπει να <strong>παρέχετε μια λίστα αλληλογραφίας ή τροφοδότηση(feed) με ενημερώσεις </strong>, έτσι ώστε κάποιος να μπορεί να διατηρεί τα αντίγραφα των δεδομένων του ενημερωμένα.',
      :custom_renderer => '/partials/requirement_standard',
      :requirement => 'standard_59'
    dependency :rule => 'A and B'
    condition_A :q_corrected, '==', :a_true
    condition_B :q_correctionDiscovery, '==', {:string_value => '', :answer_reference => '1'}

    q_engagementTeam 'Έχετε κάποιον που να χτίζει ενεργά μια κοινότητα γύρω από αυτά τα δεδομένα;',
      :discussion_topic => :engagementTeam,
      :help_text => 'Μια εμπλεκόμενη ομάδα της κοινότητας θα αναλάβει μέσω των μέσων κοινωνικής δικτύωσης, το blogging, τη διοργάνωση hackdays ή διαγωνισμών να ενθαρρύνει τον κόσμο να χρησιμοποιεί τα δεδομένα.',
      :help_text_more_url => 'http://theodi.org/guide/engaging-reusers',
      :pick => :one
    a_false 'no'
    a_true 'yes',
      :requirement => ['exemplar_21']

    label_exemplar_21 'Θα πρέπει να <strong>δημιουργήσετε μια κοινότητα ανθρώπων γύρω από τα δεδομένα σας </strong> για να ενθαρρύνετε την ευρύτερη χρήση των δεδομένων σας.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_21'
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_false

    q_engagementTeamUrl 'Που είναι η αρχική τους σελίδα;',
      :discussion_topic => :engagementTeamUrl,
      :display_on_certificate => true,
      :text_as_statement => 'Η συμμετοχή της κοινότητας γίνεται μέσω',
      :required => :required
    dependency :rule => 'A'
    condition_A :q_engagementTeam, '==', :a_true
    a_1 'Σύνδεσμος(URL) Αρχικής σελίδας Εμπλεκόμενης Ομάδας της Κοινότητας',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Αρχικής σελίδας Εμπλεκόμενης Ομάδας της Κοινότητας',
      :required => :required

    label_group_17 'Υπηρεσίες',
      :help_text => 'πώς θα δώσουμε στους άλλους την πρόσβαση σε εργαλεία που χρειάζονται για να εργαστούν με τα δεδομένα σας',
      :customer_renderer => '/partials/fieldset'

    q_libraries 'Πού αναφέρετε εργαλεία για χρήση στα δεδομένα σας;',
      :discussion_topic => :libraries,
      :display_on_certificate => true,
      :text_as_statement => 'Εργαλεία που βοηθούν στην χρήση των δεδομένων αυτών αναφέρονται στο',
      :help_text => 'Δώστε μια διεύθυνση URL που περιλαμβάνει τα εργαλεία που γνωρίζετε ή που προτείνουν άλλοι και μπορούν να χρησιμοποιηθούν όταν κάποιος εργάζεται με τα δεδομένα σας.'
    a_1 'Σύνδεσμος(URL) Εργαλείου',
      :string,
      :input_type => :url,
      :placeholder => 'Σύνδεσμος(URL) Εργαλείου',
      :requirement => ['exemplar_22']

    label_exemplar_22 'Θα πρέπει να <strong>παρέχετε μια λίστα με βιβλιοθήκες λογισμικού και άλλα άμεσα διαθέσιμα εργαλεία </strong> έτσι ώστε οι άνθρωποι μπορούν να πάρουν γρήγορα να εργαστούν με τα δεδομένα σας.',
      :custom_renderer => '/partials/requirement_exemplar',
      :requirement => 'exemplar_22'
    dependency :rule => 'A'
    condition_A :q_libraries, '==', {:string_value => '', :answer_reference => '1'}

  end

end
