ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'byebug'

# Default .env setup after migration
env_params = {}
File.open('.env').readlines.each do |s| 
	data = s.split('=')
	env_params[data[0]] = data[1]
end

rails_master_key_enabled = env_params.has_key? 'RAILS_MASTER_KEY'

env_default_params = {}
unless rails_master_key_enabled
	File.open('.env.development.local').readlines.each do |s| 
		data = s.split('=')
		env_default_params[data[0]] = data[1]
	end
	
	env_params['RAILS_MASTER_KEY'] = env_default_params['RAILS_MASTER_KEY']

	File.open('.env', 'w') do |file|
		env_params.sort.each do |param, value|
			file.write "#{param}=#{value}"
		end
	end
end

