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

class RailsThor < Thor
  include RakeScriptQuick
end

class Rails < RailsThor
  # ========================
  # SCRIPT
  # ========================
  
  desc "console", "Starts a rails console"
  method_options 'e' => :optional, '--database' => :boolean
  def console
    environment = options['e'] || 'development'
    options['database'] ? script("dbconsole #{environment}") : script("console #{environment}")
  end
  
  desc "about", "Displays information about this application"
  def about
    script("about")
  end
  
  desc 'generate', 'Generates an item for the rails application'
  def generate(category, name, schema=nil)
    script("generate #{category} #{name} #{schema}")
  end
  
  def destroy(category, name)
    script("destroy #{category} #{name}")
  end
  
  # ========================
  # RAKE
  # ========================

  desc 'routes', "Print out all defined routes in match order, with names."
  def routes
    puts "Loading rails routes list..."
    rake(:routes)
  end
  
  class Db < RailsThor

    desc "create", "Create the database defined in config/database.yml"
    method_options '--all' => :boolean, 'e' => :optional
    def create
      environment = options['e'] || 'development'
      options[:all] ? rake('db:create:all') : rake("db:create RAILS_ENV=#{environment}")
    end
    
    desc "migrate", "Migrate the database through scripts in db/migrate."
    method_options '--up' => :boolean, '--down' => :boolean, '--redo' => :boolean, 'v' => :optional
    def migrate
      migrate_action = "db:migrate:up"   if options[:up]
      migrate_action = "db:migrate:down" if options[:down]
      migrate_action = "db:migrate:redo" if options[:redo]
      migrate_action ||= "db:migrate"
      options['v'] ? rake("#{migrate_action} VERSION=#{v}") :  rake(migrate_action)
    end
    
    class Fixtures < RailsThor
      desc "load", "Load fixtures into the current environment's database."   
      method_options 'e' => :optional   
      def load
        environment = options['e'] || 'test'
        puts "Loading fixtures into the #{environment} database..."
        rake("db:fixtures:load RAILS_ENV=#{environment}")
      end
    end

    class Test < RailsThor

      desc "prepare", "Prepares the test database"
      def prepare
        rake('db:test:prepare')
        rake('db:test:load')
        puts "Prepared the test database"
      end
      
      desc "clone", "Recreate the test database from the database schema"
      method_options '--structure' => :boolean
      def clone
        options[:structure] ? rake('db:test:clone:structure') : rake('db:test:clone')
      end
    end
  end
  
  class Schema < RailsThor
    desc "dump", "Create a db/schema.rb file that can be portably used"
    def dump
      rake('db:schema:dump')
    end
    
    desc "load", "Load a schema.rb file into the database"
    def load
      rake('db:schema:load')
    end
  end
  
  class Log < RailsThor
    desc "clear", "Truncates all *.log files in log/ to zero bytes"
    def clear
      rake('log:clear')
      puts "Successfully cleared all log files"
    end
  end

  desc "gems", "List the gems that this rails application depends on"
  method_options 'e' => :optional
  def gems
    environment = options['e'] || 'development'
    puts "Fetching gem configuration options..."
    rake("gems RAILS_ENV=#{environment}")
  end

  class Gems < RailsThor
    map "-y" => :include_dependencies
  
    desc 'build', 'Build any native extensions for unpacked gems'
    def build
      rake('gems:build')
    end
    
    desc 'install', 'Installs all required gems for this application'
    def install
      rake('gems:install')
    end
    
    desc 'unpack [NAME]', 'Unpacks the specified gem into vendor/gems'
    method_options '--include-dependencies' => :boolean
    def unpack(name=nil)
      puts "Unpacking gem(s) to vendor directory..."
      unpack_command = options['include-dependencies'] ? 'gems:unpack' : 'gems:unpack:dependencies'
      name ? rake("#{unpack_command} GEM=#{name}") : rake(unpack_command)
    end
    
  end
end
