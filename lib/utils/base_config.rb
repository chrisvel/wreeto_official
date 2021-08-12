module Utils 
  module BaseConfig 

    def base_url
      return 'https://wreeto.com' if Rails.env.production?
      host = ENV["WREETO_HOST"] || 'localhost'
      port = ENV["WREETO_PORT"] || 8383
      "http://#{host}:#{port}"
    end
  end 
end