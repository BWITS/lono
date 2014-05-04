module TemplateHelper
  def partial_if_exist(path)
    partial_path = File.expand_path('../../templates/partial', __FILE__)
    full_path = "#{partial_path}/#{path}"
    partial path if File.exist?(full_path)
  end
end