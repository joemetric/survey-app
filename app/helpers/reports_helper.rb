module ReportsHelper
  
  def count_responses_for(option, collection)
    counter = 0
    collection.each { |a| counter += 1 if a.answer == option }
    counter
  end
  
end
