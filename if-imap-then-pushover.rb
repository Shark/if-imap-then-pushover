#!/usr/bin/env ruby
require 'yaml'
require 'rubygems'
require 'bundler/setup'

require_relative 'lib/imap_idler'
require_relative 'lib/pushover_sender'
require_relative 'lib/utils'

Thread::abort_on_exception = true

config_path = File.join(File.expand_path(File.dirname(__FILE__)), 'config', 'config.yml')
config = YAML.load_file(config_path)

pushover_sender = PushoverSender.new(config, Utils.make_logger)
imap_idler = ImapIdler.new(config, Utils.make_logger, pushover_sender.method(:send))
imap_idler.idle
