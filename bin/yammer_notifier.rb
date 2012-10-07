$: << File.join(File.dirname(__FILE__), '..','lib')
require "bundler"
Bundler.require(:default, :notifier)
require 'message_stream'
require 'store'
require 'logger'
Store.path = File.join(File.dirname(__FILE__),'..')

class Main
  def initialize(token)
    @logger = Logger.new('/tmp/yammer-notifier.log')
    loop do
      begin
        load_messages(token)
        sleep(300)
      rescue => e
        @logger.error e.message
      end
    end
  end

  def load_messages(token)
    total = MessageStream.new(token).load_messages
    @logger.info "#{total} Messages loaded #{Time.now}"
  end
end

Main.new(ARGV.first||ENV['TOKEN']||Store.options[:token])
