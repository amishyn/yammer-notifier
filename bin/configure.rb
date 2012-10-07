require "rubygems"
require "bundler/setup"
require 'oauth2'
require 'json'
require 'launchy'
require File.join(File.expand_path(File.dirname(__FILE__)),'..', 'lib', 'store')
require 'sinatra/base'
Store.path = File.join(File.dirname(__FILE__),'..')

def client
  client = OAuth2::Client.new(CONSUMER_KEY, CONSUMER_SECRET, :site => 'https://www.yammer.com', :authorize_url => '/dialog/oauth', :token_url => '/oauth2/access_token.json')
end

class CallbackApp < Sinatra::Base
  set :port, 8080
  get '/oauth2_callback' do
    code = params[:code]

    token = client.auth_code.get_token code
    access_token = eval(token.token)['token']
    Store.update(:token => access_token)

    "Access granted<script>setTimeout('window.close()',1000);</script>"
  end
  #after do
    #exit!
  #end
end

threads = []
threads<<Thread.new{CallbackApp.run!}


CONSUMER_KEY = 'cJ9Em3LqfKPDOEu7bpS0Q'
CONSUMER_SECRET = 'oXFnQQ7hDoTeYl2SNfI6zflEEMCwzFn9KyJtCnuL6aE'

threads<< Thread.new do
  url = client.auth_code.authorize_url(:redirect_uri => 'http://localhost:8080/oauth2_callback')
  Launchy.open(url)
end

threads.map &:join


