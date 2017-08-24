### Modelling The Open Data Certificate xml files

##### 1: The ODC questionnaire exists in two sections, and accordingly as two files within prototypes directory

The general questionnaire (stored in prototype/translations/certificate.en.xml) containing the questions for General, Technical and Social sections and the legal portion (stored in prototype/jurisdictions/certificate.GB.xml) for questions relating to copyright and IP ownership that differ by country or legal jurisdiction

##### 2: prototype/surveyor.xsl transforms these two XML files into survey/odc_questionnaire.$country_code.rb

the mechanism by which specific country codes and their corresponding language is translated is being refactored at present  see [Surveyor/Translations](#translations) below

##### 3: the surveyor gem parses the odc_questionairre.$COUNTRY_CODE.rb file, and produces the following models

`Survey, SurveySection, Question, QuestionGroup,Answer, Dependency, DependencyCondition.`

which are stored in `app/models`

A `Question` will may have a `Dependency`
the `Dependency` will have_many `DependencyCondition`s which may belong to other `Question`s
the `DependencyCondition`s have one `Question` and one `Answer` and then an `operator` to compare test them against


##### 4: app/SurveysController starts a survey and updates it

##### 5: Test suites exist in

```
vendor/surveyor/gems/surveyor-1.4.0/spec/
test/unit/question_test.rb
test/unit/response_set_test.rb
```

##### Unknowns:

need to inspect surveys/development subdirectory [potential ticket)

#### Changing surveys

To change surveys, you'll need Saxon installed. On a Mac, this is as simple as running:

```bash
brew install saxon
```

You can then change the `prototype/survey.xsl` file and run:

```bash
saxon -s:prototype/jurisdictions/ -xsl:prototype/surveyor.xsl -o:prototype/temp/
```
