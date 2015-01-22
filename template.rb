
# To use this app template:
# rails-api new <app_name> --database=postgresql -T -m path/to/this/file/template.rb

def source_paths
  Array(super) +
    [File.join(File.expand_path(File.dirname(__FILE__)),'files')]
end

insert_into_file 'Gemfile', "\nruby '2.2.0'", after: "source 'https://rubygems.org'\n"
gem 'newrelic_rpm'
gem 'rack-cors'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'
gem 'nokogiri'

# add gems for dev & test env
gem_group :development, :test do
  gem "rspec-rails", "~> 3.1.0"
  gem "pry-byebug"
  gem "pry-rails"
  gem "factory_girl_rails", "~> 4.0"
  gem "faker"
  gem "codeclimate-test-reporter", require: nil
end

# add gems for production env
gem_group :production do
  gem "unicorn"
  gem "rails_12factor"
  gem "rails_stdout_logging"
  gem "rails_serve_static_assets"
end

gsub_file "Gemfile", /[#].*/,''
gsub_file "Gemfile", /[\n]+/,"\n"

in_root do
  run "rspec --init"
  template '.travis.yml'
  template '.ruby-version'
  template 'LICENSE'
  template 'README.md'
  template 'Procfile'
  remove_file 'README.rdoc'
end

inside 'config' do
  template 'unicorn.rb'
end

inside 'app' do
  inside 'serializers' do
  end
end

after_bundle do
  run "rake db:create"
  run "rake db:migrate"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end

# you may need to make more specific changes to files that
# aren't supported directly by the API. Thor provides two
# methods to give you this control: insert_into_file and gsub_file.

=begin
gsub_file "Gemfile", /^gem\s+["']sqlite3["'].*$/,''
gsub_file "Gemfile", /^gem\s+["']turbolinks["'].*$/,''
insert_into_file 'Gemfile', "\nruby '2.1.0'",
 after: "source 'https://rubygems.org'\n"
inside 'config' do
  insert_into_file 'environment.rb', "$stdout.sync = true\n"
  before: "# Load the rails application"
end
=end











