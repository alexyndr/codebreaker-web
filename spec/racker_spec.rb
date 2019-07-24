# frozen_string_literal: true

require 'spec_helper'

describe Racker do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  let(:game) { Codebreaker::Game.new }
  let(:name) { 'Alex' }
  let(:difficult) { 'easy' }
  let(:secret_code) { [1, 1, 1, 1] }
  let(:response_registr) { post '/change', player_name: name, level: difficult }
  let(:response) { post '/submit_answer', number: guess_code }

  context 'with statuses' do
    it 'returns status 404' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    it 'returns status 200' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'when_show_rules' do
    let(:response) { get '/rule' }

    it 'show rules' do
      expect(response.body).to include('Rules')
    end
  end

  describe 'when_show_stats' do
    let(:response) { get '/statistics' }

    it 'show stats' do
      expect(response).to be_ok
    end
  end

  describe 'when_user_registr' do
    before do
      response_registr
      follow_redirect!
    end

    it 'succes' do
      expect(last_response.body).to include(name)
    end
  end

  describe 'when_user_win' do
    let(:guess_code) { '1111' }

    before do
      response_registr
      env 'rack.session', game: game
      game.instance_variable_set(:@secrete_code, secret_code)
      response
      follow_redirect!
    end

    it 'win' do
      expect(last_response.body).to include('Congratulations')
    end
  end

  describe 'when_user_lose' do
    let(:guess_code) { '2111' }

    before do
      response_registr
      env 'rack.session', game: game
      game.instance_variable_set(:@secrete_code, secret_code)
      game.instance_variable_set(:@atempts, 1)
      response
      follow_redirect!
    end

    it 'lose' do
      expect(last_response.body).to include('Oops')
    end
  end
end
