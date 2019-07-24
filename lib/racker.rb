# frozen_string_literal: true

require 'pry'
require 'erb'
require 'codebreaker'
require 'yaml'

# Best class ever made, from people by people
class Racker
  attr_reader :request

  current_path = File.dirname(__FILE__)
  FILE_PATH = current_path + '/../data/data.yml'

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @game = request.session[:game] ||= Codebreaker::Game.new
  end

  def response
    case request.path
    when '/' then menu
    when '/change' then registr_user
    when '/game' then show_game
    when '/submit_answer' then submit_answer
    when '/show_hint' then show_hint
    when '/statistics' then statistics
    when '/rule' then Rack::Response.new(render('rule.html'))
    when '/win' then win_player
    when '/clear_session' then clear
    when '/lose' then Rack::Response.new(render('lose.html'))
    else Rack::Response.new(render('not_found.html'), 404)
    end
  end

  def menu
    return render_page('menu.html') unless curent_session?

    redirect_to('/game')
  end

  def statistics
    load_stat
    render_page('statistics.html')
  end

  def clear
    request.session.clear
    redirect_to('/')
  end

  def registr_user
    request.session[:game].user = request.params['player_name']
    request.session[:name] = request.params['player_name']
    request.session[:game].choose_difficulty(request.params['level'])
    redirect_to('/game')
  end

  def show_game
    return redirect_to('/') unless curent_session?

    @result = request.session[:result]
    render_page('game.html')
  end

  def submit_answer
    unless request.params['number'].empty?
      request.session[:numbers] = request.params['number']
      request.session[:result] = @game.compare_code(request.params['number']).split('')
    end
    win_or_lose
  end

  def win_or_lose
    if request.session[:result].join.match(/[+]{4}/)
      redirect_to('/win')
    elsif !request.session[:game].atempts.positive?
      redirect_to('/lose')
    else
      redirect_to('/game')
    end
  end

  def show_hint
    @game.creepted_code.push(@game.hint)
    redirect_to('/game')
  end

  def win_player
    return redirect_to('/') unless curent_session? && request.session[:result]

    add_stat
    save(@game.stat)
    render_page('win.html')
  end

  def add_stat
    @game.stat[:atmp_left] = @game.atempts
    @game.stat[:hint_left] = @game.hints
    @game.stat[:name] = @game.user
    @game.stat[:time] = Time.now.strftime('%H:%M, %d %B %Y')
  end

  def render(template)
    path = File.expand_path("../views/#{template}.erb", __FILE__)

    render_layout do
      ERB.new(File.read(path)).result(binding)
    end
  end

  def render_layout
    layout = File.expand_path('views/layout.html.erb', __dir__)
    ERB.new(File.read(layout)).result(binding)
  end

  def render_page(page)
    Rack::Response.new(render(page))
  end

  def redirect_to(page)
    Rack::Response.new { |response| response.redirect(page) }
  end

  def curent_session?
    request.session.key?(:name)
  end

  def save(game_stat)
    File.open(FILE_PATH, 'a') { |f| f.write game_stat.to_yaml }
  end

  def load_stat
    @game_data = YAML.load_stream(File.open(FILE_PATH)) if File.exist?(FILE_PATH)
  end
end
