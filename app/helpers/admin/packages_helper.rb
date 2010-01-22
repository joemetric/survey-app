module Admin::PackagesHelper  

  def package_info(package)
    returning info = [] do 
      info << "Includes #{package.total_responses} responses to"
      info << package.questions_info    
    end
  end
  
end
