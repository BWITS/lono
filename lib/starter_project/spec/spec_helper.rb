ENV['TEST'] = '1'

require "pp"
 
root = File.expand_path('../../', __FILE__)
require "#{root}/../lono" # TODO change this to lono after release

module Helpers
  def execute(cmd)
    puts "Running: #{cmd}" if ENV['DEBUG']
    out = `#{cmd}`
    puts out if ENV['DEBUG']
    out
  end

  def helper
    return @helper if @helper
    options = {:project_root => ".", :quiet => true}
    Lono::DSL.new(options).helpers
    @helper = Lono::Template.new("test", {}, options)
  end

end

RSpec.configure do |c|
  c.include Helpers
end