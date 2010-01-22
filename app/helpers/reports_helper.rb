module ReportsHelper
  
  def count_responses_for(option, collection)
    counter = 0
    collection.each { |a| counter += 1 if a.answer == option }
    counter
  end
  
  def photo_responses(answers)
    return if answers.blank?
    html_text = '<tr>'
    answers.each_with_index do |a, i|
      i += 1
      html_text += content_tag(:td, link_to_photo(a), :style => "text-align:left; text-indent:5px")
      html_text += '</tr>' if i % 4 == 0 
    end
    return html_text
  end
  
  def link_to_photo(reponse)
    link_to image_tag(reponse.image_url, :width => 119, :height => 119, :border => 0), reponse.image_url, :title => reponse.answer
  end
  
end
