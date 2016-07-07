require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

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
  end
end

class ApplicationController < ActionController::Base
  attr_accessor :current_user
  impersonates :user
end
