require "minitest/autorun"
require "minitest/pride"
require "active_support/core_ext/string/inflections"

User = Struct.new(:id) do
  def self.where(id: nil)
    [new(id)]
  end
end

module ActionController
  class Base
    attr_reader :session
    attr_accessor :current_user

    def initialize
      @session = {}
    end

    def self.helper_method(*)
    end
  end
end

require_relative "../lib/pretender"

class ApplicationController < ActionController::Base
  impersonates :user
end
