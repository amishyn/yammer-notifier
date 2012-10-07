$: << File.dirname(__FILE__)

require 'faraday'
require 'multi_json'
require 'oj'
require 'store'
require 'terminal-notifier'

class MessageStream

  def initialize(token)
    @token = token
  end

  def load_messages
    url =  "/api/v1/messages/following.json?access_token=#{@token}"
    url += "&newer_than=#{last_message_id}" if last_message_id
    response = conn.get url
    return if response.body.strip.empty?
    json = MultiJson.load(response.body)

    json['messages'].reverse.each do |m|
      author = json["references"].select{|e| e["id"] == m["sender_id"]}.first['full_name']
      message = m["body"]["plain"]
      body = "#{author}: #{message}"
      TerminalNotifier.notify(body, :open => m["web_url"])
    end
    if json['messages'].first
      Store.update(:last_message_id => json['messages'].first["id"])
    end
    json['messages'].count
  end

  def last_message_id
    Store.options[:last_message_id]
  end

  def conn
    @conn ||= Faraday.new(:url => "https://www.yammer.com") do |c|
      c.adapter :patron
    end
  end

end
