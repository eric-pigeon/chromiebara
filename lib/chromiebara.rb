require 'capybara'
require 'rammus'

module Chromiebara
  require "chromiebara/version"
  require "chromiebara/driver"
  require "chromiebara/node"
  class Error < StandardError; end
end

Capybara.register_driver :chromiebara do |app|
  Chromiebara::Driver.new(app, headless: true)
end
