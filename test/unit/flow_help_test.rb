foreach (question_hash, question_index in @questions)
foreach (answer_hash from question_hash) {
  partialMethod(answerhash_val, answerhash_key, question_hash, question_index)
  operations_on(partialMethod, [allPreviouslyPassedLocalVars])
}

partialMethod(){
  @dependencies
  @questions
  foreach(dependency_hash in @dependencies)
  dependency = findMatchingDependencyHash(where dependency_hash[:id] equal_to answerhash_val[:dependency])
  return dependency # a hash
}

operations_on(dependency, [ARGS]){

  if dependency[:answers]
    # if the :answers hash has content render some markdown
  else
    # if the :answers hash has no content
    if
      # do some things
    else
      # print the ending markdown statement
    end

  end

}

given test.legal.xml

@questions should equal 1
therefore running each with index is the same as @questions.first
@dependencies should equal 9

@questions.first[:answers].count should equal 3

@questions.first[:answers].each do |anshash|
  # this step skip only possible when working with a simple XMl with one question
  puts anshash
  # expect a hash of key->value hashes
end;

@questions.first[:answers].each do |k,v|
  if v[:dependency].eql?(nil)
    puts "no match"
  else
    puts v[:dependency]
  end
  # this will print the Strings which can be matched against dependencies
end;

@questions.first[:answers].each do |k,v|
  if !v[:dependency].eql?(nil)
    if @dependencies.find { |d| d[:id] == v[:dependency] }
      puts "a match"
    end
    # dependency = @dependencies.find { |d| d[:id] == v[:dependency] }
  end
  puts v
  # puts dependency
end;

@questions.first[:answers].each do |k,v|
  if !v[:dependency].eql?(nil)
    dependency = @dependencies.find { |d| d[:id] == v[:dependency] }
  end
  puts v
  puts dependency
end;

@questions.first[:answers].each do |k,v|
  if !v[:dependency].eql?(nil)
    dependency = @dependencies.find { |d| d[:id] == v[:dependency] }
  end
  if dependency.present?
    puts dependency[:prerequisites].count
    if dependency[:answers].nil?
      puts "base case"
    else
      puts "other case"
      dependency[:answers].each do |k,v|
        puts v
      end
    end
  end
end;


@questions.first[:answers].each do |k,v|
  if !v[:dependency].eql?(nil)
    dependency = @dependencies.find { |d| d[:id] == v[:dependency] }
    # returns the first entire hash where any element in entire dependencies array
    # matches the String extracted from answer key val hash passed to this function
  end
  if dependency.present?
    # puts "there is a dependency"
    if dependency[:answers].nil?
      puts "answers are empty"
    else
      puts "answer are not empty"
      if dependency[:prerequisites].count <= 1
        # puts "base case"
        dependency[:answers].each do |k,v|
          answer_logic_flow(dependency, 0, k, v)
        end
      else
        puts "other case"
      end
    end
  end
end;


def answer_logic_flow (question, index, key, answer)
  puts question[:label]
  # question: dependency, index: index, key: k, answer: v
  if answer[:dependency].nil? && @questions[index + 1] != nil
    puts "print something"
  elsif !answer[:dependency].nil?
    puts "render dependency partial"
  else
    puts "print ending box"
  end
end