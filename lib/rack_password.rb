require 'rack_password/version'
require 'rack'

module RackPassword

  class Block

    def initialize app, options = {}
      @app = app
      @options = {
        :key => :staging_auth,
        :code_param => :code
        }.merge options
    end

    def call env
      request = Rack::Request.new env

      bv = BlockValidator.new(@options, request)
      return @app.call(env) if bv.valid?


      if request.post? and bv.valid_code?(request.params[@options[:code_param].to_s]) # If post method check :code_param value
        domain = @options[:cookie_domain]
        domain ||= request.host == 'localhost' ? '' : ".#{request.host}"
      [301, {'Location' => request.path, 'Set-Cookie' => "#{@options[:key]}=#{request.params[@options[:code_param].to_s]}; domain=#{domain}; expires=30-Dec-2039 23:59:59 GMT"}, ['']] # Redirect if code is valid
      else
        success_rack_response
      end
    end

    def success_rack_response
      [200, {'Content-Type' => 'text/html'}, [read_success_view]]
    end

    private

    def read_success_view
      @success_view ||= File.open(File.join(File.dirname(__FILE__), "views", "block_middleware.html")).read
      fill_in_application_name(@success_view)
    end

    def fill_in_application_name(view)
      app_name = defined?(Rails) ? Rails.application.class.parent_name : ""
      view.sub('__App_Name__', app_name)
    end
  end

  class BlockValidator
    attr_accessor :options, :request

    def initialize options, request
      @options = options
      @request = request
    end

    def valid?
      valid_path? || valid_code?(@request.cookies[@options[:key].to_s]) || valid_ip? || valid_custom_rule?
    end

    def valid_ip?
      return false if @options[:ip_whitelist].nil?
      @options[:ip_whitelist].include? @request.ip.to_s
    end

    def valid_path?
      !!(@request.path =~ @options[:path_whitelist])
    end

    def valid_code? code
      return false if @options[:auth_codes].nil?
      @options[:auth_codes].include? code
    end

    def valid_custom_rule?
      return false if @options[:custom_rule].nil?
      !!@options[:custom_rule].call(@request)
    end
  end

end
