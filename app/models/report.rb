class Report
  
  require 'csv'
  
  def self.csv_for(survey)
    all_questions = survey.questions
    all_replies = survey.replies
    data = StringIO.new
    CSV::Writer.generate(data, ',') do |questions|
      questions << ['Response #'].push(all_questions.attribute_values(:name)).flatten
      all_replies.each_with_index do |r, i|
        answers = r.answers_with_question_type.each_with_index do |a, index| 
          a.answer = "Question_#{index + 1}/#{a.image_file_name}" if a.photo_response?
        end
        questions << [i + 1].push(answers.sort_by(&:question_id).to_array).flatten
      end
    end
    data.rewind
    data
  end
  
end
