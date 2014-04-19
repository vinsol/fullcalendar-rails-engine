module FullcalendarEngine
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, type: :boolean, default: false

      ASSET_BASE_PATH = 'app/assets'
      JS_BASE_PATH    = "#{ASSET_BASE_PATH}/javascripts"
      CSS_BASE_PATH   = "#{ASSET_BASE_PATH}/stylesheets"

      def add_javascripts
        if File.exist?("#{JS_BASE_PATH}/application.js")
          append_file "#{JS_BASE_PATH}/application.js", "//= require fullcalendar_engine/application\n"
        elsif File.exist?("#{JS_BASE_PATH}/application.js.coffee")
          append_file "#{JS_BASE_PATH}/application.js.coffee", "//= require fullcalendar_engine/application\n"
        end
      end

      def add_stylesheets
        if File.exist?("#{CSS_BASE_PATH}/application.css")
          inject_into_file "#{CSS_BASE_PATH}/application.css", " *= require fullcalendar_engine/application\n", :before => /\*\//, :verbose => true
        elsif File.exist?("#{CSS_BASE_PATH}/application.css.scss")
          inject_into_file "#{CSS_BASE_PATH}/application.css.scss", " *= require fullcalendar_engine/application\n", :before => /\*\//, :verbose => true
        end
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=fullcalendar_engine'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end