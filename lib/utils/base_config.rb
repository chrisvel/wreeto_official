module Utils 
  module BaseConfig 

    def base_url
      host = ENV["WREETO_HOST"] || 'localhost'
      port = ENV["WREETO_PORT"] || 8383
      "http://#{host}:#{port}"
    end
  end 
end