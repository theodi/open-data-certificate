# encoding: UTF-8
# Question#is_mandatory is now false by default. The default_mandatory option allows you to set
#   is_mandatory for all questions in a survey.
survey 'ODI Questionnaire German', :default_mandatory => false do

  section 'Rights' do
    label 'ensuring that you have the right to publish the data'

    q_do_you_have_rights 'Do you have the rights to publish the data as open data?', :pick => :one, :is_mandatory => true
    a_yes 'yes, you have the right to publish the data as open data'
    a_no "no, you don't have the right to publish the data as open data"
    a_dont_know "you don't know whether you have the right to publish the data as open data"

    label 'You must have the right to publish data that you publish.'
    dependency :rule => 'A'
    condition_A :q_do_you_have_rights, '==', :a_no

    q_gathered_by_you 'Was all this data originally created or gathered by you?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A or B'
    condition_A :q_do_you_have_rights, '==', :a_yes
    condition_B :q_do_you_have_rights, '==', :a_dont_know

    q_extracted_and_calculated 'Was some of this data extracted or calculated from other data?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A and B'
    condition_A :q_do_you_have_rights, '==', :a_dont_know
    condition_B :q_gathered_by_you, '==', :a_no

    label "You have said that the data wasn't originally created or gathered by you, and wasn't crowd-sourced, so it must have been extracted or calculated from other data sources."
    dependency :rule => 'A and B and C'
    condition_A :q_gathered_by_you, '==', :a_no
    condition_B :q_extracted_and_calculated, '==', :a_no
    condition_C :q_crowd_sourced, '!=', :a_yes

    q_other_data_sources_open 'Are all the other data sources published as open data by their owners?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_extracted_and_calculated, '==', :a_yes

    label 'You should get legal advice to ensure that you have the right to republish this data.'
    dependency :rule => 'A'
    condition_A :q_other_data_sources_open, '==', :a_no

    q_crowd_sourced 'Was some of this data crowd-sourced?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A and B'
    condition_A :q_do_you_have_rights, '==', :a_dont_know
    condition_B :q_gathered_by_you, '==', :a_no

    label "You have said that the data wasn't originally created or gathered by you, and wasn't extracted or calculated from other data, so it must have been crowd-sourced."
    dependency :rule => 'A and B'
    condition_A :q_gathered_by_you, '==', :a_no
    condition_B :q_crowd_sourced, '==', :a_no
    condition_C :q_extracted_and_calculated, '!=', :a_yes

    q_require_judgement 'Did contributions require judgement?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_crowd_sourced, '==', :a_yes

    q_cla_location 'Where is the Contributor Licence Agreement (CLA)?', :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_require_judgement, '==', :a_yes

    q_cla_agreed_by_all 'Have all contributors agreed to the CLA?', :pick => :one, :is_mandatory => true
    a_yes 'yes'
    a_no 'no'
    dependency :rule => 'A'
    condition_A :q_require_judgement, '==', :a_yes

    label 'You should get legal advice to ensure that you have the right to republish this data.'
    dependency :rule => 'A'
    condition_A :q_cla_agreed_by_all, '==', :a_no

    q_sources_of_data 'Where do you describe the sources of the data?', :is_mandatory => true
    a_1 :string
    dependency :rule => 'A'
    condition_A :q_gathered_by_you, '==', :a_no

  end
end
