# encoding: UTF-8
survey "One language is never enough" do
  translations :en =>:default, :es => "translations/languages.es.yml", :he => "translations/languages.he.yml", :ko => "translations/languages.ko.yml"
  section_one "One" do
    g_hello "Hello" do
      q_name "What is your name?"
      a_name :string, :help_text => "My name is..."
    end
  end
  section_two "Two" do
    q_color "What is your favorite color?"
    a_name :string

    label_translate_me "does this translate"

    q_pavlingMgp 'am I mandatory', :required => :exemplar
    a_nameMgp :string, :help_text => "required..."
    dependency :rule => 'A'
    condition_A :q_color, "==", {:string_value => "red", :answer_reference => "name"}

  end
end
