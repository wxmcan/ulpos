module Ulpos
  class << self
    attr_accessor :app_key, :app_secret, :endpoint

    def configure
      yield self
      true
    end
  end

  autoload :Client, "ulpos/client"
end
