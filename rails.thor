# module: rails

module RakeScriptQuick
  # rake(:gems) or rake('db:create:all')
  def rake(task_name)
    system("rake #{task_name}")
  end
  
  # script(:console) or script(:generate, 'model Post')
  def script(task_name, argument=nil)
    command = "script/#{task_name}"
    command << " #{argument}" if argument
    system(command) 
  end
end

class Rails < Thor
  include RakeScriptQuick 
  
  desc "gems", "lists the required gems for this application"
  method_options 'e' => :optional
  def gems
    environment = options['e'] || 'development'
    puts "Fetching gem configuration options"
    rake("gems RAILS_ENV=#{environment}")
  end
  
  desc "console", "starts a rails console"
  method_options 'e' => :optional
  def console
    environment = options['e'] || 'development'
    script("console #{environment}")
  end
  
  class Db < Thor
    include RakeScriptQuick
    
    desc "create", "creates databases for use in rails"
    method_options '--all' => :boolean, 'e' => :optional
    def create
      environment = options['e'] || 'development'
      options[:all] ? rake('db:create:all') : rake("db:create RAILS_ENV=#{environment}")
    end
    
    class Test < Thor
      include RakeScriptQuick

      desc "prepare", "prepares the test database"
      def prepare
        rake('db:test:prepare')
        puts "Prepared the test database"
      end
    end
  end
end

