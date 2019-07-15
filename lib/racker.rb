require 'erb'

class Racker
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/' then Rack::Response.new('Hello word!', 200)
    else Rack::Response.new('Not Found', 404)
    end
  end
end