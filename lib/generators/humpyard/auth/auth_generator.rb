require 'generators/humpyard'
require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_model'
require 'active_record'

module Humpyard
  module Generators
    ####
    # == User Generator
    #
    #   rails humpyard:auth user_model [options]
    #
    # === Description
    # The humpyard user generator creates a basic auth
    #
    # === Options
    #
    # === Runtime options
    # <tt>-q, [--quiet]</tt>:: Supress status output
    # <tt>-p, [--pretend]</tt>:: Run but do not make any changes
    # <tt>-s, [--skip]</tt>:: Skip files that already exist
    # <tt>-f, [--force]</tt>:: Overwrite files that already exist
    #
    # === Examples
    #   rails generate humpyard:auth user
    
    class AuthGenerator < Base
      include Rails::Generators::Migration   
      
      argument :user_model, :type => :string, :required => true, :banner => 'UserModel'
      
      include Humpyard::Generators::ModelTemplate
      
	    class_option :users_framework, :desc => 'The user management framework used in humpyard application (options: simple/custom/fake/devise/authlogic)', :group => 'Users config', :type => :string, :default => Humpyard::config.users_framework
	    class_option :skip_models, :desc => 'Don\'t generate User realated models', :type => :boolean
      class_option :skip_haml, :desc => 'Don\'t generate HAML related files (the layout template)', :type => :boolean
      class_option :skip_injection, :desc => 'Don\'t inject anything to files like routes.rb or application_controller.rb', :type => :boolean
	
      def create_user # :nodoc:   
        template_path = "#{::File.dirname(__FILE__)}/templates/"
           
        #Dir.glob("#{template_path}#{options[:users_framework]}/**/*.*").each do |file|
        #  template file.gsub(template_path, ''), "app/#{file.gsub("#{template_path}#{options[:users_framework]}/", '')}"
        #end
        
        application_controller_injection = 
          "  helper_method :current_user\n\n" +
          "  # Handle AccessDenied exception of CanCan\n" +
          "  rescue_from CanCan::AccessDenied do |exception|\n" +
          "    flash[:error] = exception.message\n" +
          "    redirect_to root_url\n" +
          "  end\n\n"
          
        routes_injection = ""  
          
        class_collisions class_name
        
        template "#{options[:users_framework]}/models/ability.rb", "app/models/ability.rb"
        
        case options[:users_framework]
        when 'simple'
          template "simple/controllers/user_sessions_controller.rb", "app/controllers/#{singular_name}_sessions_controller.rb"
          template "simple/config/humpyard_users.yml", "config/humpyard_#{plural_name}.yml"
          template "simple/views/user_sessions/new.html.haml", "app/views/#{singular_name}_sessions/new.html.haml"
                    
          application_controller_injection +=
            "  private\n" +
            "  def current_user\n" +
            "    if not @current_user.nil?\n" +
            "      @current_user\n" +
            "    else\n" +
            "      session[:humpyard] ||= {}\n" +
            "      @current_user = session[:humpyard][:user] || false\n" +
            "    end\n" +
            "  end\n" +
            "\n" +
            "  private\n" +
            "  def humpyard_logout_path\n" +
            "    logout_path\n" +
            "  end\n\n"
            
          routes_injection += "scope \"/#"+"{Humpyard::config.admin_prefix}\" do\n" +
            "    get  'login' => '#{singular_name}_sessions#new', :as => :login\n" +
            "    post 'login' => '#{singular_name}_sessions#create', :as => :login\n" +
            "    get  'logout' => '#{singular_name}_sessions#destroy', :as => :logout\n" +
            "  end"  
        when 'authlogic'
          
          raise "Authlogic is not working, yet!"
          
          template "authlogic/models/ability.rb", "app/models/ability.rb"
          template "authlogic/models/user.rb", "app/models/#{singular_name}.rb"
          template "authlogic/models/user_session.rb", "app/models/#{singular_name}_session.rb"
                    
          unless true or options.skip_tests?
            case test_framework
            when :rspec
              template "authlogic/tests/rspec/model.rb", "spec/models/#{singular_name}_spec.rb"
              template "authlogic/fixtures.yml", "spec/fixtures/#{plural_name}.yml"
            else
              template "authlogic/tests/#{test_framework}/model.rb", "test/unit/#{singular_name}_test.rb"
              template "authlogic/fixtures.yml", "test/fixtures/#{plural_name}.yml"
            end
          end

          unless options.skip_migration?
            migration_template 'authlogic/migration.rb', "db/migrate/create_#{plural_name.gsub('/','_')}.rb"
          end
          
          template "authlogic/controllers/user_sessions_controller.rb", "app/controllers/#{singular_name}_sessions_controller.rb"
          
          routes_injection += "resources :#{singular_name}_sessions"
          
          unless options.skip_views?
            template 'authlogic/views/user_sessions/new.html.haml', "app/views/#{singular_name}_sessions/new.html.haml"
          end
          
          
          gem 'authlogic', :git => 'http://github.com/odorcicd/authlogic.git', :branch => 'rails3'
          
          
          application_controller_injection +=
            "  private\n" +
            "  def current_user_session\n" +
            "    return @current_user_session if defined?(@current_user_session)\n" +
            "    @current_user_session = UserSession.find\n" +
            "  end\n\n" +
            "  def current_user\n" +
            "    return @current_user if defined?(@current_user)\n" +
            "    @current_user = current_user_session && current_user_session.record\n" +
            "  end\n"  
        when 'devise'
          
          raise "Devise is not working, yet!"
          
          template "#{options[:users_framework]}/models/ability.rb", "app/models/ability.rb"
          gem 'devise', :git => 'http://github.com/plataformatec/devise.git' #,'>= 1.1.rc1'
          
          run "bundle install"
          
          generate :devise_install
          
          prepend_file "config/initializers/devise.rb", "require 'devise'\n\n"

          
          
          generate :devise, singular_name
          
        when 'fake'      
          application_controller_injection +=
            "  private\n" +
            "  def current_user\n" +  
            "    if not @current_user.nil?\n" +
            "      @current_user\n" +
            "    else\n" +
            "      session[:humpyard] ||= {}\n" +
            "      unless params[:user].nil?\n" +
            "        session[:humpyard][:user] = params[:user].blank? ? false : params[:user]\n" +
            "      end\n" +
            "      @current_user = session[:humpyard][:user] || false\n" +
            "    end\n" +
            "  end\n"          
        end

        unless options.skip_injection
          route routes_injection unless routes_injection.blank?
          inject_into_class "app/controllers/application_controller.rb", ApplicationController, application_controller_injection
        end
        
        begin
          File.open("#{template_path}#{options[:users_framework]}/README", "r") do |infile|
            puts ''
            while (line = infile.gets)
              puts "   #{line}"
            end
            puts ''
          end
        rescue
          # No README found, do nothing
        end
      end
    
      private
        def model_name
          "#{user_model.camelize}"
        end

    end
  end
end
