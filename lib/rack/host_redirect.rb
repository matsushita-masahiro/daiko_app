module Rack
  class HostRedirect
    def initialize(app, redirect_map = {})
      @app = app
      @redirect_map = redirect_map
    end

    def call(env)
      request = Rack::Request.new(env)
      host = request.host

      if @redirect_map.key?(host)
        target_host = @redirect_map[host]
        target_url = "#{request.scheme}://#{target_host}#{request.fullpath}"
        
        [301, { 'Location' => target_url, 'Content-Type' => 'text/html' }, ['Moved Permanently']]
      else
        @app.call(env)
      end
    end
  end
end
