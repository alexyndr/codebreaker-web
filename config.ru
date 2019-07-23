# frozen_string_literal: true

require './lib/racker'

use Rack::Reloader
use Rack::Static, urls: ['/assets'], root: './'
use Rack::Session::Cookie, key: 'rack.session', secret: 'change_me'
run Racker
