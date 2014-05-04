module Lono
  class DSL
    def initialize(options={})
      @options = options
      @options[:project_root] ||= '.'
      @templates = []
      @results = {}
    end

    def evaluate
      load_stacks
    end

    def load_stacks
      Dir.glob("#{@options[:project_root]}/app/stacks/**/*").each do |path|
        instance_eval(File.read(path), path)
      end
    end

    def template(name, &block)
      @templates << {:name => name, :block => block}
    end

    def build
      @templates.each do |t|
        @results[t[:name]] = Template.new(t[:name], t[:block], @options).build
      end
    end

    def output
      output_path = "#{@options[:project_root]}/output"
      FileUtils.rm_rf(output_path) if @options[:clean]
      FileUtils.mkdir(output_path) unless File.exist?(output_path)
      puts "Generating Cloud Formation templates:" unless @options[:quiet]
      @results.each do |name,json|
        path = "#{output_path}/#{name}"
        puts "  #{path}" unless @options[:quiet]
        validate(json, path)
        File.open(path, 'w') {|f| f.write(output_json(json)) }
      end
    end

    def validate(json, path)
      begin
        JSON.parse(json)
      rescue JSON::ParserError => e
        puts "Invalid json.  Output written to #{path} for debugging".colorize(:red)
        File.open(path, 'w') {|f| f.write(json) }
        exit 1
      end
    end

    def output_json(json)
      @options[:pretty] ? JSON.pretty_generate(JSON.parse(json)) : json
    end

    def helpers
      Dir.glob("#{@options[:project_root]}/app/helpers/**/*.rb").each do |path|
        require path
        klass_name = camelize(File.basename(path).sub(/.rb$/,''))
        klass = Kernel.const_get(klass_name)
        Template.send(:include, klass)
      end
    end

    def camelize(str)
      str.split('_').map {|w| w.capitalize}.join
    end

    def run(options={})
      helpers
      evaluate
      build
      output
    end
  end
end