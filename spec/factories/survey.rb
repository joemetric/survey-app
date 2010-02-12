Factory.define :survey do |s|
  s.name 'Comparison of IPhone and Android Phones'
  s.owner_id 1
  s.responses 1
  s.payment_status 'incomplete'
  s.package_id 1
  s.association :payment, :factory => :payment
  s.end_at "#{Date.today}"
  #s.question {|question| question.association(:question, :name => "Question Name")}
end