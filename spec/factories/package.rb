Factory.define :package do |p|
  p.name 'Default'
  p.base_cost 50
  p.code 'default'
  p.total_responses 20
  p.lifetime {|lifetime| lifetime.association(:lifetime)}
  p.payouts {|payouts| payouts.association(:payout)}
  p.pricings {|pricings| answers.association(:pricing)}
  p.package_question_types {|package_question_types| package_question_types.association(:package_question_type)}
end

Factory.define :lifetime do |l|
  l.validity_type_id 1
end
  
Factory.define :payouts do |p|
  p.amount 0.5
end
    
Factory.define :pricings do |p|
end      
      
Factory.define :package_question_types do |p|
  p.question_types {|question_types| question_types.association(:question_type)}
end