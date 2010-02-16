Factory.define :survey do |s|
  s.name 'Comparison of IPhone and Android Phones'
  s.owner_id 1
  s.responses 1
  s.payment_status 'incomplete'
  s.package_id 1
  s.association :payment, :factory => :payment
  s.end_at "#{Date.today}"
end


Factory.define :survey_with_question do |s|
  s.name 'Comparison of IPhone and Android Phones'
  s.owner_id 1
  s.responses 1
  s.payment_status 'incomplete'
  s.package_id 1
  s.association :payment, :factory => :payment
  s.end_at "#{Date.today}"
  s.questions {|question| question.association(:question, :name => "Question Name")}
end
