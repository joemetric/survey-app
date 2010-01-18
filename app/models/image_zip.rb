class ImageZip
  require 'zip/zip'
  require 'zip/zipfilesystem'
  require 'ftools'
  
  def self.bundle(survey)
     base_directory = "#{RAILS_ROOT}/public/image_archives"
     File.makedirs(base_directory) unless File.file?(base_directory)
     bundle_filename = "#{base_directory}/#{Date.today}_#{survey.name}.zip"
     File.delete(bundle_filename) if File.file?(bundle_filename)
     all_questions = survey.questions
     Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
       |zipfile|
       all_questions.each_with_index { |q, i| 
        if q.question_type_id.eql?(3)
          q.answers.each { |a|
             unless a.image_file_name.blank?
               zipfile.add("Question_#{i + 1}/#{a.image_file_name}", "#{RAILS_ROOT}/public#{a.image.to_s.split('?').first}")
             end
           }
         end
       }
     }
     File.chmod(777, bundle_filename)
     return bundle_filename
  end
  

end