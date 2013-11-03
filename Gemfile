source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '3.2.13'

gem 'jquery-rails'
gem 'devise'
gem 'figaro'
gem 'mongoid'
gem 'unicorn'

gem "actionmailer", "~> 3.2.6"
gem 'json'

# file uploader
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem "carrierwave-processing", "~> 0.0.1"
gem "rmagick", "~> 2.13.1"


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer', :platform=>:ruby
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'quiet_assets'
end
group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
end
group :test do
  gem 'capybara'
  gem 'cucumber-rails', :require=>false
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
  gem 'launchy'
  gem 'mongoid-rspec'
end

