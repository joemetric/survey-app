class Survey < ActiveRecord::Base
  
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
      if unsaved # This block was added for #767
        survey_package = Package.find(package_id)
        total_questions = question_attributes.nil? ? 0 : question_attributes.send("total_#{key}")
        concerned_question_type = survey_package.pricing_info.send(key.singularize)
      else
        survey_package = package
        total_questions = send(key).size
        concerned_question_type = package_pricings.send(key.singularize)
      end
      standard_cost, cost, extra_questions, extra_questions_cost = 0.00, 0.00, 0, 0.00
      extra_responses, extra_responses_cost, extra_responses_questions_cost = 0, 0.00, 0.00
      extra_responses += responses - survey_package.total_responses if responses > survey_package.total_responses
      if concerned_question_type
        if total_questions > concerned_question_type.total_questions
          extra_questions = total_questions - concerned_question_type.total_questions
        end
        standard_cost += concerned_question_type.standard_price * (total_questions - extra_questions) * (responses - extra_responses) 
        cost += standard_cost
        if extra_questions > 0
          extra_questions_cost += concerned_question_type.normal_price * extra_questions * (responses - extra_responses) 
          cost += extra_questions_cost
        end
        if extra_responses > 0
          extra_responses_cost += concerned_question_type.normal_price * (total_questions - extra_questions) * extra_responses
          cost += extra_responses_cost
          extra_responses_questions_cost += concerned_question_type.normal_price * extra_questions * extra_responses
          cost += extra_responses_questions_cost
        end
      end    
      discounted_questions = total_questions - extra_questions
      if unsaved
        {
         :normal => concerned_question_type.name.plural_form(extra_questions), 
         :standard => concerned_question_type.name.plural_form(discounted_questions),
         :discounted_questions => discounted_questions,
         :extra_questions => extra_questions,
         :standard_price => concerned_question_type.standard_price.us_dollar,
         :normal_price =>  concerned_question_type.normal_price.us_dollar,
         :extra_questions_cost => extra_questions_cost.us_dollar,
         :extra_responses_cost => extra_responses_cost.us_dollar,
         :extra_responses_questions_cost => (responses * extra_questions * concerned_question_type.normal_price).us_dollar,
         :cost_with_discount => standard_cost.us_dollar,
         :total_cost => cost, 
         :responses => responses,
         :discounted_responses => responses - extra_responses,
         :extra_responses => extra_responses
        }
      else
        cost
      end
    end
    
    define_method("refund_for_#{key}") do
      extra_questions, refund_cost = 0, 0.0
      total_questions = send(key).size
      concerned_question_type = package_pricings.send(key.singularize)
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
    
    define_method("payout_for_#{key}") do
      concerned_question_type = payouts.send(key.singularize)
      payout = 0.0
      payout += send(key).size * concerned_question_type.amount if concerned_question_type 
    end
    
  }
  
  def cost_in_cents; chargeable_amount * 100 end
  
  def self.pricing_details(params)
    survey = Survey.new(params[:survey])
    survey.responses = 0 if survey.responses.nil?
    survey.unsaved = true
    survey.question_attributes = params[:survey][:questions_attributes]
    survey.package_id = params[:survey][:package_id]
    survey_package = Package.find(survey.package_id)
    survey_configuration = {}
    survey_configuration[:total_cost] = survey_package.base_cost
    QUESTION_TYPES.keys.each {|k| 
      survey_configuration[k.to_sym] = survey.send("#{k}_cost")
      survey_configuration[:total_cost] += survey_configuration[k.to_sym][:total_cost]
      survey_configuration[k.to_sym][:total_cost] = survey_configuration[k.to_sym][:total_cost].us_dollar 
    }
    survey_configuration[:total_cost] = survey_configuration[:total_cost].us_dollar
    survey_configuration
  end
  
  def total_cost
    if package
      total_payable = package.base_cost
      QUESTION_TYPES.keys.each {|k| total_payable += send("#{k}_cost") }
      connection.execute("UPDATE surveys SET chargeable_amount = #{total_payable} WHERE id = #{id};") if id
      return total_payable
    end
  end
  
  def refundable_amount
    total_refundable = 0.0
    QUESTION_TYPES.keys.each {|k| total_refundable += send("refund_for_#{k}")} if unreceived_responses > 0
    total_refundable 
  end
  
  def total_payout
    rewarded_amount = 0.0
    QUESTION_TYPES.keys.each {|k| rewarded_amount += send("payout_for_#{k}")}
    rewarded_amount
  end
   
end