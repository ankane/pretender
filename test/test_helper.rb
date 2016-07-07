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

    def initialize
      @session = {}
    end

    def self.helper_method(*)
    end
  end
end

require "pretender"

class ApplicationController < ActionController::Base
  attr_accessor :current_user
  impersonates :user
end
