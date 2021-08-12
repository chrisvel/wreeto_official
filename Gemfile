source 'https://rubygems.org'

gem 'rails', '~> 6.1', '>= 6.1.2.1'
gem 'pg', '1.2.3'
gem 'puma'
gem 'jbuilder', '~> 2.7'
gem 'redcarpet', '3.5.1'
gem 'coderay', '1.1.3'
gem 'coderay_bash', '1.0.7'
gem 'kaminari', '~> 1.2'
gem 'mini_magick'
gem 'rack-attack'
gem 'rack-cors'
gem 'omniauth-google-oauth2'
gem "omniauth-rails_csrf_protection"
gem 'sidekiq', '6.1.3'
gem 'sidekiq-scheduler', '3.0.1'
gem 'sidekiq-status', '1.1.4'
gem 'foreman', '~> 0.87.2'
gem 'bcrypt', '3.1.16'
gem 'rails_admin'
gem 'recaptcha'
gem "valid_email2"
gem "active_link_to"
gem "image_processing"
gem "ancestry"

gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'

# Auth
# gem 'devise', '4.7.3'
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem 'pundit', '2.1.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem "minitest"
  gem "minitest-reporters"
  gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
end

group :development do
  gem 'web-console'
  gem 'listen', '3.4.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'letter_opener_web', '1.4.0'
  gem 'faker'
  gem 'rack-mini-profiler'
  gem 'bullet'

  # For memory profiling
  gem 'memory_profiler'

  # For call-stack profiling flamegraphs
  gem 'stackprof'
end

group :test do 
  gem 'mocha'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
