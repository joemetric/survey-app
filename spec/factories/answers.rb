Factory.define :answer do |q|
  q.answer 'Some Answer'
  #q.reply {|reply| reply.association(:reply)}
  #q.survey_id self.question.survey.id
end

Factory.define :reply do |r|
#r.survey_id 
end