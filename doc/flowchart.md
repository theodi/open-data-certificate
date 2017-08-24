#### Flowchart

http://localhost:3000/flowchart
files responsible:
```ruby
lib>flow.rb
app>controllers>flowcharts_controller.rb
app>views>flowcharts/.
```
you'll want to have open
prototype/translation/certificate.en.xml & prototype/jurisdictions/certificate.GB.xml

rendering flow =
```
show
^~> _question
___^~> _answer
______^~> _dependency
_________^~> _answer

// this effectively functions as a foreach loop

foreach(question_element in @questions hash)
    # passes a hash
    foreach(answer in answers hash*)
        #*where `answers` is extracted from question_element as a key=>value element
        PartialDependency(question_element, question_element_index, answer.key, answer.value)
           # A Hash is retrieved from @dependencies instance hash and assigned to dependency (local var)
           # answer[:dependency] and dependency[:label] are the values printed to screen in varying outputs

```

each of the partials render text in the markdown format which https://github.com/knsv/mermaid stipulates

Intern Suggestions:

Clearer explanation.
Make calls between dependency and answer clearer.
List of all possible answer dependencies.
Test for dependencies inside and outside answer

Flow pseudocode:

  -- Question

  if the question has no answers and there exists a next question
    convert question id and label into readable string ...
  else if the question has answers, for each answer

    -- Answer

    if there is no answer dependency and there is a next question
      convert question id and label into readable string ...
    else if there is an answer dependency

      -- Dependency

      dependency = returns more information about dependency of a given answer as a hash
      if there are no answers for that dependency
        convert question id and label into readable string ...
        if there is a next question
          render question/answer/dependency
        else render end block
      else
        render question/answer/dependency
        if dependency prerequisites are <= 1 or (dependency is one of ["timeSensitive","privacyImpactAssessmentExists"] & dependency has 2 prerequisites)
          for each dependency answer
            render answer
            add it to @deps
        else
          destroy first prerequisite of dependency

    else
      Render end block
