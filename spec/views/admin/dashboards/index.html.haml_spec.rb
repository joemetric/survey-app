require 'spec/spec_helper'

# spec spec/views/admin/dashboards/index.html.haml_spec.rb

describe "/admin/dashboards/index" do

  fixtures :surveys, :users
  
  before(:each) do
    Authlogic::Session::Base.controller = template.controller
    assigns[:current_admin] = users(:admin)
  end
  
  describe "Demographic Distribution" do 
    it "should display options for show as Age, Gender, Income, Martial Status, Race, Education, Occupation" do
      do_render 
      response.should have_tag("select[id=?]", "filter_by") do |select|
        select.should have_tag("option[value=?]", 'age', :text => "Age")
        select.should have_tag("option[value=?]", 'gender', :text => "Gender")
        select.should have_tag("option[value=?]", 'income', :text => "Income")
        select.should have_tag("option[value=?]", 'martial_status', :text => "Martial Status")
        select.should have_tag("option[value=?]", 'race', :text => "Race")
        select.should have_tag("option[value=?]", 'education', :text => "Education")
        select.should have_tag("option[value=?]", 'occupation', :text => "Occupation")
      end
    end
    
    it "should display user count based on show list option and no segment" do
      assigns[:filters] = User.user_age_list
      assigns[:filter_by] = 'Age'
      render :partial => "admin/dashboards/results/filter_by"
      response.should have_tag('tr') do |row|
        row.should have_tag('th') do |cell|
          cell.should have_tag('h3', :text => 'Age')
        end
        row.should have_tag('th') do |cell|
          cell.should have_tag('h3', :text => '# of Users')
        end
      end
      if assigns[:filters].size > 0
        assigns[:filters].each do |filter|
          response.should have_tag('tr') do |row|
            row.should have_tag('td', :text => filter[0])
            row.should have_tag('td', :text => filter[1])
          end
        end
      end
    end
    
    it "should display demographic destribution based on show list option and segment" do
      assigns[:results] = User.consumers.all
      assigns[:filter_by] = 'Race'
      assigns[:segment_by] = 'Gender'
      assigns[:filters] =  eval "User::#{assigns[:filter_by]}"
      assigns[:segments] = eval "User::#{assigns[:segment_by]}"
      assigns[:filter_column]= 'race'
      render :partial => "admin/dashboards/results/filter_by_with_segment_by"
      response.should have_tag('tr') do |row|
        row.should have_tag('th') do |cell|
          cell.should have_tag('h3', :text => assigns[:filter_by])
        end
        assigns[:segments].keys.sort.each do |s|
          row.should have_tag('th') do |cell|
            cell.should have_tag('h3', :text => assigns[:segments][s])
          end
        end
      end
      assigns[:filters].keys.sort.each do |f|
        response.should have_tag('tr') do |row|
          row.should have_tag('td', :text => assigns[:filters][f])
          assigns[:segments].keys.sort.each do |s|
            row.should have_tag('td', :text => (assigns[:results].count {|u| u.send(assigns[:filter_column]) == f && u.send(:gendeer) == s}) )
          end
        end
      end
    end
  end
  
  describe "Survey Distribution" do
    
    it "should have show and segment by select " do
      do_render
      response.should have_tag("select[id=?]", 'survey') do |select|
        select.should have_tag("option[value=?]", 'completed_surveys', :text => "# Completed Surveys" )  
        select.should have_tag("option[value=?]", 'registered_respondents', :text => "# Registered Respondents" )  
        select.should have_tag("option[value=?]", 'submitted_surveys', :text => "# Company Submitted Surveys" )  
        select.should have_tag("option[value=?]", 'registered_companies', :text => "# Registered Companies" )        
      end
      response.should have_tag("select[id=?]", 'survey_range')
    end
    
    it "should display survey distrubution based on segment and show option" do
      param_survey = "completed_surveys"
      param_survey_range = "week_by_hours"
      assigns[:results] = eval "Survey.#{param_survey}"
      assigns[:segmented_data] =  eval "Survey.#{param_survey_range}"
      assigns[:header] = param_survey
      assigns[:results_class] = Survey::SurveyOptionClass[param_survey]
      render :partial => "admin/dashboards/survey_distribution/results"
      response.should have_tag('table') do |table|
        table.should have_tag('tr') do |row|
          row.should have_tag('th') do |cell|
            cell.should have_tag('h3', :text => assigns[:segmented_data][:header])
          end
          row.should have_tag('th') do |cell|
            cell.should have_tag('h3', :text => assigns[:header].humanize)
          end
        end
      end
    end
  end
  
  def do_render
    render "admin/dashboards/index.html.haml"
  end
end 