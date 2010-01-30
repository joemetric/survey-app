module Admin::CharityorgsHelper
  
  def file_name(file_path)
    fileName = File.basename(file_path)
    return fileName 
  end
  
end
