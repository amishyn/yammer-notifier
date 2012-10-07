require 'rubygems'
require 'daemons'

ENV['BUNDLE_GEMFILE'] ||= File.join(File.expand_path(File.dirname(__FILE__)), '..', 'Gemfile')

options = {
    :backtrace  => true,
    :ontop      => false,
    :log_output => true,
    :log_dir    => File.join(File.expand_path(File.dirname(__FILE__)), '..', 'log'),
  }
Daemons.run(File.join(File.dirname(__FILE__), 'yammer_notifier.rb'), options)

