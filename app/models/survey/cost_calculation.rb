class Survey < ActiveRecord::Base
  
  # This file includes methods used in calculating total cost of survey according to the following data:
  # 1. Survey Package Configuration
  # 2. Total Responses to be collected
  # 3. Total Questions set for each category
  
  QUESTION_TYPES  = {'standard_questions' => 1,
                     'premium_questions' => 2,
                     'standard_demographic' => 3,
                     'premium_demographic' => 4
                     }
  
  QUESTION_TYPES.each_pair { |key, value|
    
    define_method(key) do
      questions.find(:all,
      :conditions => ['package_question_types.id = ?', value],
      :joins => ['RIGHT JOIN question_types ON questions.question_type_id = question_types.id ' +
      'RIGHT JOIN package_question_types ON question_types.package_question_type_id = package_question_types.id'])
    end
    
    define_method("#{key}_cost") do
      survey_package = package
      total_questions = send(key).size # Total Questions added by User in a Survey
      extra_questions, extra_responses, cost = 0, 0, 0.0
      concerned_question_type = survey_package.pricing_info.send(key.singularize)
      extra_responses = responses - survey_package.total_responses if responses > survey_package.total_responses
      if concerned_question_type
        if total_questions > concerned_question_type.total_questions
          extra_questions = total_questions - concerned_question_type.total_questions
        end
        cost = concerned_question_type.standard_price * (total_questions - extra_questions) * (responses - extra_responses) 
        cost += concerned_question_type.normal_price * extra_questions * (responses - extra_responses) if extra_questions > 0
        if extra_responses > 0
          cost += concerned_question_type.normal_price * (total_questions - extra_questions) * extra_responses
          cost += concerned_question_type.normal_price * extra_questions * extra_responses
        end
      end
      cost
    end
    
    define_method("refund_for_#{key}") do
      extra_questions, refund_cost = 0, 0.0
      total_questions = send(key).size
      concerned_question_type = package.pricing_info.send(key.singularize)
      if concerned_question_type
        if total_questions > concerned_question_type.total_questions
          extra_questions = total_questions - concerned_question_type.total_questions
        end
        refund_cost += unreceived_responses * (total_questions - extra_questions) * concerned_question_type.standard_price
        if extra_questions > 0
          refund_cost += unreceived_responses * extra_questions * concerned_question_type.normal_price
        end
      end
      return refund_cost
    end
  }
  
  def cost_in_cents; chargeable_amount * 100 end
  
  def total_cost
    if package
      total_payable = package.base_cost
      QUESTION_TYPES.keys.each {|k| total_payable += send("#{k}_cost") }
      connection.execute("UPDATE surveys SET chargeable_amount = #{total_payable} WHERE id = #{id};");
      return total_payable
    end
  end
  
  def refundable_amount
    total_refundable = 0.0
    QUESTION_TYPES.keys.each {|k| total_refundable += send("refund_for_#{k}")} if unreceived_responses > 0
    total_refundable 
  end
   
end