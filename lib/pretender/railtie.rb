module Pretender
  class Railtie < Rails::Railtie
    initializer "pretender" do
      # ActiveSupport.on_load(:action_cable) runs too late with Unicorn
      ActionCable::Connection::Base.extend(Pretender::Methods) if defined?(ActionCable)
    end
  end
end
