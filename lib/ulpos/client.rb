require 'json'
module Ulpos
  class Client
    attr_reader :app_key, :app_secret, :endpoint

    def initialize(app_key = Ulpos.app_key, app_secret = Ulpos.app_secret, endpoint = Ulpos.endpoint)
      @app_key = app_key
      @app_secret = app_secret
      @endpoint = endpoint 
    end

    def invoke(method = nil, options = {})
      params = {
        :appkey => @app_key,
        :timestamp => Time.now.to_i.to_s,
        :signature_method => 'md5',
        :method => method,
        :format => 'json'
      }
      params.merge!(options)
      str = params.sort.collect { |param| "#{param[0]}=#{param[1]}" }.join("&")
      sign_str = @app_key + params[:timestamp] + @app_secret + params[:signature_method]
      sign = Digest::MD5.hexdigest(sign_str)
      method = "/#{params[:method]}" if params[:method]
      url = "#{@endpoint}#{method}?#{str}&sign=#{sign}"
      response = Net::HTTP.get(URI.parse(url))

      if params[:format] == 'json'
        JSON.parse(response)
      elsif params[:format] == 'xml'
        response
      else
        response
      end
    end
  end
end
