module Utils 
  module BaseConfig 

    def base_url
      host = ENV["WREETO_HOST"] || 'localhost'
      port = ENV["WREETO_PORT"] || 8383
      behind_proxy = ENV["BEHIND_PROXY"] || 'no'
      protocol = ENV["PROTOCOL"] || 'http'
      if behind_proxy == 'yes'
        "#{protocol}://#{host}"
      else
        "#{protocol}://#{host}:#{port}"
      end
    end
  end 
end
