require 'spec_helper'

describe "Lono" do
  describe "TemplateHelper" do
    it "should output partial if it exists" do
      helper.partial_if_exist("exist.json.erb").should include("FakeParameter")
    end

    it "should output nothing if partial does not exists" do
      helper.partial_if_exist("does_not_exist.json.erb").should be_nil
    end
  end
end
