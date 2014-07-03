module Lono
  class Upgrade
    def run
      %w[
        app/stacks
        app/helpers
        app/templates
        app/helpers
      ]
      FileUtils.mkdir("")
      FileUtils.mv("config/lono/")
    end
  end
end