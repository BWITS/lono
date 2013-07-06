module Lono
  class Bashify
    def initialize(options={})
      @options = options
      @path = options[:path]
    end

    def user_data_paths(data,path="")
      paths = []
      paths << path
      data.each do |key,value|
        if value.is_a?(Hash)
          paths += user_data_paths(value,"#{path}/#{key}")
        else
          paths += ["#{path}/#{key}"]
        end
      end
      paths.select {|p| p =~ /UserData/ && p =~ /Fn::Join/ }
    end

    def find_user_data
      raw = IO.read(@path)
      json = JSON.load(raw)

      user_data = json['Resources']['server']['Properties']['UserData']['Fn::Base64']['Fn::Join']
      @delimiter, @data = user_data
    end

    def run
      raw = IO.read(@path)
      json = JSON.load(raw)
      paths = user_data_paths(json)
      paths.each do |path|
        puts "UserData script for #{path}:"
        key = path.sub('/','').split("/").map {|x| "['#{x}']"}.join('')
        user_data = eval("json#{key}")
        delimiter = user_data[0]
        script = user_data[1]
        puts script.join(delimiter)
      end
    end
  end
end