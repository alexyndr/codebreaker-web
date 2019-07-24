# frozen_string_literal: true

require 'spec_helper'

# require_relative '../lib/racker.rb'

describe Racker do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  let(:game) { Codebreaker::Game.new }
  let(:name) { 'Alex' }
  let(:difficult) { 'easy' }

  context 'with statuses' do
    it 'returns status 404' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    it 'returns status ok' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'when_show_rules' do
    let(:response) { get '/rule' }

    it 'show rules' do
      expect(response).to be_ok
      expect(response.body).to include("Rules")
    end
  end

  describe 'when_show_stats' do
    let(:response) { get '/statistics' }

    it 'show stats' do
      expect(response).to be_ok
    end
  end

  describe 'when_user_registr' do
    let(:response) do
      post '/change', player_name: name, level: difficult
    end

    before do
      post '/change', player_name: name, level: difficult

      follow_redirect!
    end

    it 'succes' do
      expect(last_response).to be_ok
    end
  end

  describe 'user_win' do
    let(:guess_code) { '1111' }
    let(:secret_code) { [1,1,1,1] }
    let(:response_registr) do
      post '/change', player_name: name, level: difficult
    end
    let(:response) { post ''}
  end
end
