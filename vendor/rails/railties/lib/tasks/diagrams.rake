#Generates ER diagram for the database

namespace :doc do
  namespace :diagram do
    
    desc "Generate ER diagram for the database"
    task :models do
      sh "railroad -i -l -a -m -M | dot -Tpng > doc/models.png"
    end
  end

  task :diagrams => "diagram:models"

end