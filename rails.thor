# module: rails

class Rails < Thor
  desc "gems", "lists the required gems for this application"
  method_options 'e' => :optional
  def gems
    environment = options['e'] || 'development'
    system("rake gems RAILS_ENV=#{environment}")
  end
  
  desc "console", "starts a rails console"
  method_options 'e' => :optional
  def console
    environment = options['e'] || 'development'
    system("script/console #{environment}")
  end
end