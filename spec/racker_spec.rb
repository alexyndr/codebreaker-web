# frozen_string_literal: true

require 'spec_helper'

# require_relative '../lib/racker.rb'

describe Racker do
  let(:app) { Rack::Builder.parse_file('config.ru').first }

  context 'with statuses' do
    it 'returns status not found' do
      get '/unknown'
      expect(last_response).to be_not_found
    end

    # it 'returns status ok' do
    #   get '/'
    #   expect(last_response).to be_ok
    # end

  end
end
