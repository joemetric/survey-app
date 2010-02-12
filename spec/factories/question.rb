Factory.define :question do |q|
  q.name 'Hello World'
  q.question_type_id 1
  q.answers {|answers| answers.association(:answer)}
end