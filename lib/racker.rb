require 'erb'

class Racker
  def call(env)
    request = Rack::Request.new(env)
    case request.path
    when '/' then Rack::Response.new(render('menu.html'))
    when '/game' then Rack::Response.new(render('game.html'))
    when '/lose' then Rack::Response.new(render('lose.html'))
    when '/statistics' then Rack::Response.new(render('statistics.html'))
    when '/win' then Rack::Response.new(render('win.html'))
    else Rack::Response.new('Not Found', 404)
    end
  end

  private

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end