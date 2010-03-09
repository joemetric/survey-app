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
    
    # Since cost calculation logic for questions and restrictions 
    # is same it is done in the block below
    
    define_method("#{key}_cost") do
      if new_record? # This block was added for #767
        survey_package = Package.find(package_id)
        if key == 'standard_demographic'
          total_questions = standard_demographics
        else
          total_questions = question_attributes.nil? ? 0 : question_attributes.send("total_#{key}")
        end
        concerned_question_type = survey_package.pricing_info.send(key.singularize)
      else
        survey_package = package
        if key == 'standard_demographic'
          total_questions = restrictions.size
        else
          total_questions = send(key).size
        end
        concerned_question_type = pricing_data.send(key.singularize)
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
      if new_record? || return_hash
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
      if key == 'standard_demographic'
        total_questions = restrictions.size
      else
        total_questions = send(key).size
      end
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
      return payout
    end
    
  }
  
  def cost_in_cents; chargeable_amount * 100 end
  
  def self.pricing_details(params)
    if params[:survey][:id]
      survey = Survey.find(params[:survey][:id])  
      survey_package = survey.package
    else
      survey = Survey.new(params[:survey])
      survey.package_id = params[:survey][:package_id]
      survey_package = Package.find(survey.package_id)
    end
    survey.return_hash = true
    survey.standard_demographics =  params[:survey][:genders_attributes].size rescue 0
    survey.standard_demographics += params[:survey][:zipcodes_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:occupations_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:races_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:educations_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:incomes_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:ages_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:martial_statuses_attributes].size rescue survey.standard_demographics
    survey.standard_demographics += params[:survey][:geographic_locations_attributes].size rescue survey.standard_demographics
    survey.responses = 0 if survey.responses.nil?
    survey.question_attributes = params[:survey][:questions_attributes]
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
      self.chargeable_amount = total_payable
      return total_payable
    end
  end
  
  def calculate_reward
    connection.execute("UPDATE surveys SET reward_amount = #{total_payout} WHERE id = #{id};")
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
  
  def gross_margin # Returns gross_margin for survey
    percent_of((chargeable_amount.to_f - award_for_complete_replies.to_f), chargeable_amount.to_f)
  end
  
  def award_for_complete_replies # Returns total amount rewarded to users who completed the survey
    replies.paid_or_complete.size * total_payout
  end
   
end