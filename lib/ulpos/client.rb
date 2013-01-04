require 'json'
module Ulpos
  class Client
    attr_reader :app_key, :app_secret, :endpoint

    def initialize(app_key = Ulpos.app_key, app_secret = Ulpos.app_secret, endpoint = Ulpos.endpoint)
      @app_key = app_key
      @app_secret = app_secret
      @endpoint = endpoint 
    end

    def invoke(method, options = {})
      params = {
        :timestamp => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        :format => 'json',
        :app_key => @app_key,
        :v => '2.0',
        :method => method,
        :sign_method => 'md5'
      }
      params.merge!(options)
      str = @app_secret + (params.sort.collect { |param| "#{param[0]}#{param[1]}" }).join("") + @app_secret
      params["sign"] = Digest::MD5.hexdigest(str).upcase!
      res = Net::HTTP.post_form(URI.parse(@endpoint), params)
      if params[:format] == 'json'
        JSON.parse(res.body)
      elsif params[:format] == 'xml'
        res.body
      else
        res.body
      end
    end
  end
end
