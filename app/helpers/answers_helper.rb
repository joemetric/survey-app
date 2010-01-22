module AnswersHelper
  
  def render_answers_for(question) 
    rows = String.new
    answers = Answer.by_question(question)
    if answers.blank?
      td = content_tag(:td)
      td += content_tag(:td, 'No answers submitted yet')
      rows += content_tag(:tr, td)
    else
      answers.each_with_index do |answer, index|
        td = content_tag(:td, index + 1)
        td += content_tag(:td, (answer.photo_response? ? link_to_photo_response(answer) : answer.answer), :class => 'left_text')
        rows += content_tag(:tr, td)
      end
    end
    rows
  end
  
  def link_to_photo_response(answer)
    link_to answer.image_url, answer.image_url, :class => 'simple_link', :target => '_blank'
  end
  
end
