class ImageZip
  require 'zip/zip'
  require 'zip/zipfilesystem'
  require 'ftools'
  require 'net/http'
  
  def self.bundle(survey)
     base_directory = "#{RAILS_ROOT}/tmp/image_archives"
     File.makedirs(base_directory) unless File.file?(base_directory)
     bundle_filename = "#{base_directory}/#{Date.today}_#{survey.name}.zip"
     File.delete(bundle_filename) if File.file?(bundle_filename)
     all_questions = survey.questions
     image_answers = []
     Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
       |zipfile|
       all_questions.each_with_index { |q, i| 
        if q.question_type_id.eql?(3)
          q.answers.each { |a|
             unless a.image_file_name.blank?
               image_file = get_file(a)
               zipfile.add("Question_#{i + 1}/#{a.image_file_name}", image_file)
               image_answers << image_file
             end
           }
         end
       }
     }
     delete_temp_images(image_answers)
     File.chmod(777, bundle_filename)
     return bundle_filename
  end
  
  def self.get_file(answer)
     Net::HTTP.start( 's3.amazonaws.com' ) { |http|
     image_url = answer.image_url.split('s3.amazonaws.com').last
     resp = http.get(image_url) 
     make_temp_image(resp.body, answer)
    }
  end
  
  def self.make_temp_image(response, answer)
     temp_image_path = "#{RAILS_ROOT}/tmp/ans/#{answer.id}" 
     File.makedirs(temp_image_path) unless File.file?(temp_image_path)
     file_path = "#{temp_image_path}/#{answer.image_file_name}"
     f = File.open( file_path, "wb+")
     f << response
     f.close
     return file_path
  end
  
  def self.delete_temp_images(answers)
     answers.each { |a| File.delete(a)}
  end

end