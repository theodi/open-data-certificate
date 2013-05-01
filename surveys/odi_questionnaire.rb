# encoding: UTF-8
# Question#is_mandatory is now false by default. The default_mandatory option allows you to set
#   is_mandatory for all questions in a survey.
survey 'ODI Questionnaire', :default_mandatory => false do

  section 'Rights' do
    label 'ensuring that you have the right to publish the data'

    q_do_you_have_rights 'Do you have the rights to publish the data as open data?', :pick => :one, :is_mandatory => true,
                         :help_text => "Unless all the data was originally created or gathered by your organisation, you might not have the right to republish it. We ask this question to check that you have considered the ownership of the data. If you aren't sure, we will ask further questions about the source of the data you're publishing to find out."
    a_yes 'yes, you have the right to publish the data as open data'
    a_no "no, you don't have the right to publish the data as open data"
    a_dont_know "you don't know whether you have the right to publish the data as open data"

    label 'You must have the right to publish data that you publish.', :class => 'requirement'
    dependency :rule => 'A'
    condition_A :q_do_you_have_rights, '==', :a_no

    q_gathered_by_you 'Was all this data originally created or gathered by you?', :pick => :one, :is_mandatory => true,
                      :help_text => "If not all the data was originally created or gathered by you then you might not have the right to republish it. Answer 'no' to this question if the data includes information that was sourced from outside your organisation, or if it includes data that other individuals or organisations have contributed. We ask this question to work out whether we have to ask about other organisations or people who might own some of the data."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A or B'
    condition_A :q_do_you_have_rights, '==', :a_yes
    condition_B :q_do_you_have_rights, '==', :a_dont_know

    q_extracted_and_calculated 'Was some of this data extracted or calculated from other data?', :pick => :one, :is_mandatory => true,
                               :help_text => "You might have extracted data from another dataset, for example through an online service. Or you might have downloaded someone else's dataset and analysed it to create the data. In both these cases, we need to check that there are no legal barriers to you republishing the results of this data."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A and B'
    condition_A :q_do_you_have_rights, '==', :a_dont_know
    condition_B :q_gathered_by_you, '==', :a_no

    label "You have said that the data wasn't originally created or gathered by you, and wasn't crowd-sourced, so it must have been extracted or calculated from other data sources.", :class => 'requirement'
    dependency :rule => 'A and B and C'
    condition_A :q_gathered_by_you, '==', :a_no
    condition_B :q_extracted_and_calculated, '==', :a_no
    condition_C :q_crowd_sourced, '!=', :a_yes

    q_other_data_sources_open 'Are all the other data sources published as open data by their owners?', :pick => :one, :is_mandatory => true,
                              :help_text => "Open data is data that has been published under an open data licence or where the rights over that data have expired or been waived. If your data is created based on other data that is published as open data, then you can republish it. If your data incorporates data that is not published as open data, you will need to get legal advice to ensure that you can reuse that data and republish the results."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_extracted_and_calculated, '==', :a_yes

    label 'You should get legal advice to ensure that you have the right to republish this data.', :class => 'requirement'
    dependency :rule => 'A'
    condition_A :q_other_data_sources_open, '==', :a_no

    q_crowd_sourced 'Was some of this data crowd-sourced?', :pick => :one, :is_mandatory => true,
                    :help_text => "Crowd-sourcing involves collating data that is contributed by people operating outside your organisation. We ask about crowd-sourcing because if the data includes information that was contributed by others, you need to ensure that they granted their permission to publish their contributions as open data."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A and B'
    condition_A :q_do_you_have_rights, '==', :a_dont_know
    condition_B :q_gathered_by_you, '==', :a_no

    label "You have said that the data wasn't originally created or gathered by you, and wasn't extracted or calculated from other data, so it must have been crowd-sourced."
    dependency :rule => 'A and B and C'
    condition_A :q_gathered_by_you, '==', :a_no
    condition_B :q_crowd_sourced, '==', :a_no
    condition_C :q_extracted_and_calculated, '!=', :a_yes

    q_require_judgement 'Did contributions require judgement?', :pick => :one, :is_mandatory => true,
                        :help_text => "The individuals who contributed to your data may have needed to employ their creativity or judgement to make their contributions. For example, writing a description or choosing whether or not to include some data in a dataset would require judgement. If judgement is involved, the contributors will have copyright over their contributions, so we will then need to check that they have transferred or waived their rights, or licensed the data, to you."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_crowd_sourced, '==', :a_yes

    q_cla_location 'Where is the Contributor Licence Agreement (CLA)?', :is_mandatory => true,
                   :help_text => "A Contributor Licence Agreement is an agreement with contributors that ensures that you can reuse the data that they contribute. It will either transfer the rights in the contributions to you, waive their rights, or license the data to you such that you can republish it."
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_require_judgement, '==', :a_yes

    q_cla_agreed_by_all 'Have all contributors agreed to the CLA?', :pick => :one, :is_mandatory => true,
                        :help_text => "All contributors need to agree to a Contributor Licence Agreement (CLA) so that you can reuse or republish their contributions. You should keep a record of who has provided contributions and whether or not they have agreed to the CLA."
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_require_judgement, '==', :a_yes

    label 'You should get legal advice to ensure that you have the right to republish this data.'
    dependency :rule => 'A'
    condition_A :q_cla_agreed_by_all, '==', :a_no

    q_sources_of_data 'Where do you describe the sources of the data?', :is_mandatory => true,
                      :help_text => "If not all the data was originally created or gathered by you then even if you have the rights to publish it, it is good practice to document where the data was sourced from (its provenance) and the rights under which you are publishing the data."
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_gathered_by_you, '==', :a_no

  end

  section 'Licensing' do
    label 'giving other people permission to reuse the data'

    q_copyright_url 'Where is your copyright statement?', :is_mandatory => true, :requirement => :pilot_1
    a_1 :string

    q_copyright_statement_meta_data 'Does your copyright statement include machine-readable data for:', :pick => :any
    a_1 'licenses'
    a_2 'attribution'
    a_3 'attribution URL'
    a_4 'additional permissions or alternative licences'
    a_5 'non-binding use guidelines'

    q_which_database_license 'Under which licence can others reuse the data?', :pick => :one, :display_type => :dropdown
    a_0 'choose one...'
    a_1 'Open Data Commons Attribution License'
    a_2 'Open Data Commons Open Database License (ODbL)'
    a_3 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_4 'Creative Commons CCZero'
    a_5 'UK Open Government Licence'
    a_not_applicable 'Not applicable'
    a_other 'Other...'

    q_database_license_why_not_applicable 'Why is a licence not applicable for this data?', :pick => :one, :is_mandatory => true
    a_1 'there is no database right in this data'
    a_2 'the applicable database rights have expired'
    a_waived 'the applicable database rights have been waived'
    dependency :rule => 'A'
    condition_A :q_which_database_license, '==', :a_not_applicable

    q_which_database_licence_waiver 'Which waiver are you using to waive database rights?', :pick => :one, :display_type => :dropdown
    a_0 'choose one...'
    a_1 'Open Data Commons Public Domain Dedication and Licence (PDDL)'
    a_2 'Creative Commons CCZero'
    a_other 'Other...'
    dependency :rule => 'A'
    condition_A :q_database_license_why_not_applicable, '==', :a_waived

    q_database_waiver_location 'Where is the waiver for the database rights?', :pick => :one, :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_database_licence_waiver, '==', :a_other

    q_database_license_name "What's the name of the licence?", :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_database_license, '==', :a_other

    q_database_license_location "What's the location of the licence?", :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_database_license, '==', :a_other

    q_is_database_license_open 'Is the licence an open licence?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_which_database_license, '==', :a_other

    label 'You must publish open data under an open licence so that others can reuse it'
    dependency :rule => 'A'
    condition_A :q_is_database_license_open, '==', :a_no


    q_which_content_license 'Under which licence can others reuse the content?', :pick => :one, :display_type => :dropdown
    a_0 'choose one...'
    a_1 'Creative Commons Attribution'
    a_2 'Creative Commons Attribution Share-Alike'
    a_3 'Creative Commons CCZero'
    a_4 'UK Open Government Licence'
    a_not_applicable 'Not applicable'
    a_other 'Other...'

    q_content_license_why_not_applicable 'Why is a licence not applicable for this data?', :pick => :one, :is_mandatory => true
    a_1 'there is no copyright in this data'
    a_2 'the applicable copyright has expired'
    a_waived 'the applicable copyright has been waived'
    dependency :rule => 'A'
    condition_A :q_which_content_license, '==', :a_not_applicable

    q_which_content_licence_waiver 'Which waiver are you using to waive copyright?', :pick => :one, :display_type => :dropdown
    a_0 'choose one...'
    a_1 'Creative Commons CCZero'
    a_other 'Other...'
    dependency :rule => 'A'
    condition_A :q_content_license_why_not_applicable, '==', :a_waived

    q_content_waiver_location 'Where is the waiver for the copyright?', :pick => :one, :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_content_licence_waiver, '==', :a_other

    q_content_license_name "What's the name of the licence?", :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_content_license, '==', :a_other

    q_content_license_location "What's the location of the licence?", :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_which_content_license, '==', :a_other

    q_is_content_license_open 'Is the licence an open licence?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_which_content_license, '==', :a_other

    label 'You must publish open data under an open licence so that others can reuse it'
    dependency :rule => 'A'
    condition_A :q_is_content_license_open, '==', :a_no
  end

  section 'Privacy' do
    label "ensuring that you protect people's privacy"

    q_dataPersonal 'Could the source of this data be personal data under the Data Protection Act?', :pick => :one, :is_mandatory => true
    a_not_personal 'no, the data could never be personal data as it is not about people or their activity',
                   :help_text => "Data that is about the activity of people can be personal data if there's the potential for it to be combined with other data to identify individuals. For example, data about road traffic flows is about people's activity and could be combined with other information (about an individual's commuting patterns) to reveal information about that individual."
    a_personal 'yes, the source of this data is classified as personal data within your organisation',
               :help_text => 'Personal data is data that relates to a living individual who can be identified from the data or from the data in combination with other information. If your organisation has other information that can be used to identify the individuals in the source of this data, then it must be classified as personal data within your organisation.'
    a_possibly 'yes, the source of this data could be classified as personal data if held by other people who have access to additional information',
               :help_text => "Personal data is data that relates to a living individual who can be identified from the data or from the data in combination with other information. Even if your organisation doesn't have other information that could be used to identify the individuals in the source of this data, it may be that other people do have access to such information."


    q_consentExempt 'Is this data exempt from the non-disclosure provisions of the Data Protection Act?', :pick => :one, :is_mandatory => true,
                    :help_text => 'There are exemptions from the non-disclosure provisions of the Data Protection Act, which mean that organisations do not have to comply with the normal non-disclosure provisions.'
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A or B'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly

    q_privacyImpactAssessmentUrl 'Where is your privacy impact assessment published?', :is_mandatory => true,
                                 :help_text => 'A <a href="http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx">Privacy Impact Assessment</a> is a process for identifying privacy risks to individuals in the collection, use and disclosure of information. We ask where it is published because this enables us to check that it exists.'
    a_1 :string
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_no

    q_piaAudited 'Has your Privacy Impact Assessment been independently audited?', :pick => :one, :is_mandatory => true,
                 :help_text => 'An independent audit of a privacy impact assessment will check that the assessment has been carried out correctly. We ask if it has been independently audited to assess the rigour of the privacy impact assessment.'
    a_yes 'yes'
    a_no 'no'
    dependency :rule => '(A or B) and C and D'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    #condition_C :q_privacyImpactAssessmentUrl, '!=', { :string_value => "", :answer_reference => '1' }
    condition_C :q_consentExempt, '==', :a_no
    condition_D :q_privacyImpactAssessmentUrl, '=~', :regexp => '^(?=\s*\S).*$'

    q_individualConsentURL 'Where is the privacy notice you provide to affected individuals published?', :is_mandatory => true,
                           :help_text => 'Unless you are exempt from the non-disclosure provisions of the Data Protection Act, you are required to give individuals privacy notices when collecting data about them, which should specify the purposes for which that data will be used. We ask where these are because reusers need to be able to look at them so that they can stick within the confines of the Data Protection Act when they are handling the data.'
    answer :string
    dependency :rule => 'A'
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_no

    q_personalDataAnonymisation 'Has your anonymisation approach been audited?', :pick => :one, :is_mandatory => true,
                                :help_text => 'An audit of your anonymisation approach will ensure that you have carried out the appropriate anonymisation technique for your data, and carried it out effectively. This can be done by a specialist within your organisation or an independent third party.'
    a_yes 'yes'
    a_no 'no'
    dependency :rule => '(A or B) and C'
    condition_A :q_dataPersonal, '==', :a_personal
    condition_B :q_dataPersonal, '==', :a_possibly
    condition_C :q_consentExempt, '==', :a_no

    q_privacyImpactAssessment 'Have you carried out a privacy impact assessment?', :pick => :one, :is_mandatory => true,
                              :help_text => 'A <a href="http://www.ico.gov.uk/for_organisations/data_protection/topic_guides/privacy_impact_assessment.aspx">Privacy Impact Assessment</a> is a process for identifying privacy risks to individuals in the collection, use and disclosure of information. Even if you are exempt from the non-disclosure provisions of the Data Protection Act, you should carry out a privacy impact assessment so that you are aware of the possible risks of making the data open. We do not expect you to publish this privacy impact assessment because it might contain sensitive information about the risks that you are prepared to take.'
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_consentExempt, '==', :a_yes
  end
end